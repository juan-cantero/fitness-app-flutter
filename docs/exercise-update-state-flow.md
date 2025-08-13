# Exercise Update State Flow Documentation

## Overview

This document explains the complete state flow when updating an exercise in the fitness app, including all components involved, provider interactions, and the Riverpod pattern implementation.

## Architecture Overview

The exercise update system follows a clean architecture pattern with proper state management using Riverpod. The flow ensures that all UI components automatically refresh when exercise data changes.

## Components Involved

### 1. UI Layer
- **ExerciseEditScreen** - The form where users edit exercise details
- **ExerciseDetailScreen** - Shows exercise details and contains the edit button
- **ExercisesScreen** - Lists all exercises

### 2. State Management Layer (Riverpod Providers)
- **exerciseCreationProvider** - Manages form state and update operations
- **exerciseByIdProvider** - Provides individual exercise data by ID
- **exercisesProvider** - Manages the list of all exercises
- **popularExercisesProvider** - Manages popular exercises list
- **exerciseCategoriesProvider** - Manages exercise categories
- **similarExercisesProvider** - Provides related exercises

### 3. Repository Layer
- **IExerciseRepository** - Interface for exercise operations
- **LocalExerciseRepository** - SQLite implementation with retry logic
- **BaseRepository** - Base class with database operations

### 4. Database Layer
- **DatabaseManager** - SQLite connection management with WAL mode and timeouts
- **SQLite Database** - Persistent storage with proper locking mechanisms

## Complete State Flow

### Step 1: User Initiates Update

```dart
// ExerciseEditScreen - User clicks save button
onPressed: () async {
  final success = await ref
      .read(exerciseCreationProvider.notifier)
      .updateExercise();
  
  if (success) {
    Navigator.of(context).pop();
  }
}
```

**Files involved:**
- `lib/features/exercises/presentation/screens/exercise_edit_screen.dart`

### Step 2: Form Validation and State Update

```dart
// ExerciseCreationNotifier.updateExercise()
Future<bool> updateExercise() async {
  // 1. Validate form data
  final validationState = _validateForm(state.formData);
  if (!validationState.isValid) {
    state = state.copyWith(validationState: validationState);
    return false;
  }

  // 2. Set loading state
  state = state.copyWith(
    isSubmitting: true,
    submitError: null,
  );

  // 3. Create updated exercise model
  final updatedExercise = state.formData.toExercise(state.imageState.images).copyWith(
    id: _editingExerciseId!,
    updatedAt: DateTime.now(),
  );
  
  // ... continue to repository call
}
```

**Files involved:**
- `lib/features/exercises/providers/exercise_creation_providers.dart:505-548`

### Step 3: Repository Update with Retry Logic

```dart
// ExerciseCreationNotifier.updateExercise() - continued
try {
  // Repository update with built-in retry logic and proper transactions
  await _exerciseRepository.update(updatedExercise);
  
  // Success state
  state = state.copyWith(
    isSubmitting: false,
    isSubmitted: true,
  );
} catch (e) {
  // Error handling
  state = state.copyWith(
    isSubmitting: false,
    submitError: e.toString(),
  );
  return false;
}
```

**Files involved:**
- `lib/features/exercises/providers/exercise_creation_providers.dart:542-544`
- `lib/shared/repositories/local/local_exercise_repository.dart` (via interface)

### Step 4: Database Operation with Retry Logic

```dart
// BaseRepository.update() - Robust database update
Future<T> update(T model) async {
  // Prevent concurrent updates
  if (_isUpdating) {
    while (_isUpdating) {
      await Future.delayed(Duration(milliseconds: 100));
    }
  }
  _isUpdating = true;
  
  try {
    // Retry logic for database locks (ChatGPT's advice)
    for (int attempt = 1; attempt <= 5; attempt++) {
      try {
        final db = await database;
        
        // Use short transaction to minimize lock time
        final count = await db.transaction<int>((txn) async {
          return await txn.update(
            tableName,
            data,
            where: 'id = ?',
            whereArgs: [id],
          );
        });
        
        if (count == 0) {
          throw DatabaseException('$tableName with id $id not found');
        }
        
        return model; // Success!
        
      } catch (e) {
        final errorStr = e.toString().toLowerCase();
        
        // Check if this is a database lock error
        if (errorStr.contains('database is locked')) {
          if (attempt == 5) {
            throw DatabaseException('Database remained locked after 5 attempts: $e');
          }
          
          // Wait with exponential backoff
          final waitMs = 100 * attempt;
          await Future.delayed(Duration(milliseconds: waitMs));
          continue;
        } else {
          // Non-lock error, don't retry
          throw DatabaseException('Failed to update $tableName: $e');
        }
      }
    }
  } finally {
    _isUpdating = false;
  }
}
```

**Files involved:**
- `lib/shared/repositories/base_repository.dart:114-194`

### Step 5: Database Configuration (WAL Mode & Timeouts)

```dart
// DatabaseManager._onConfigure() - Optimized for concurrency
Future<void> _onConfigure(Database db) async {
  try {
    // Enable WAL mode for better concurrency
    await db.execute('PRAGMA journal_mode = WAL');
    
    // Set synchronous mode to NORMAL for better performance
    await db.execute('PRAGMA synchronous = NORMAL');
    
    // Set busy timeout to handle locks gracefully (ChatGPT's advice)
    await db.execute('PRAGMA busy_timeout = 5000'); // 5 seconds
    
    // Enable query optimization
    await db.execute('PRAGMA optimize');
  } catch (e) {
    debugPrint('Database configuration warning: $e');
  }
}
```

**Files involved:**
- `lib/core/database/database_manager.dart:66-91`

### Step 6: Provider State Refresh

```dart
// ExerciseCreationNotifier.updateExercise() - after successful repository update
// Trigger automatic refresh of all exercise providers using proper Riverpod pattern
refreshExerciseProviders(_ref);
```

**Files involved:**
- `lib/features/exercises/providers/exercise_creation_providers.dart:547`

### Step 7: Targeted Provider Refresh Strategy (Updated)

```dart
// refreshExerciseProviders() - Uses targeted invalidation (more efficient)
void refreshExerciseProviders(Ref ref, Exercise updatedExercise) {
  // Targeted invalidation - only refresh what actually changed
  ref.invalidate(exerciseByIdProvider(updatedExercise.id));
  ref.invalidate(similarExercisesProvider(updatedExercise.id));
  ref.invalidate(exerciseProgressionsProvider(updatedExercise.id));
  ref.invalidate(exerciseRegressionsProvider(updatedExercise.id));
  
  // For lists and stats, invalidate entire provider  
  ref.invalidate(exercisesProvider);
  ref.invalidate(popularExercisesProvider);
  ref.invalidate(exerciseCategoriesProvider);
  ref.invalidate(exerciseStatsProvider);
}
```

**Files involved:**
- `lib/features/exercises/providers/exercises_providers.dart:418-428`

### Step 8: FutureProvider.family Cache Invalidation

```dart
// All FutureProvider.family instances watch the refresh trigger
final exerciseByIdProvider = FutureProvider.family<Exercise?, String>((ref, exerciseId) async {
  // Watch the refresh trigger so this provider invalidates its cache when data changes
  ref.watch(_repositoryRefreshTriggerProvider);
  final repository = ref.watch(simpleExerciseRepositoryProvider);
  return await repository.getById(exerciseId);
});

// Same pattern for:
// - similarExercisesProvider
// - exerciseProgressionsProvider  
// - exerciseRegressionsProvider
// - exerciseStatsProvider
```

**Files involved:**
- `lib/features/exercises/providers/exercises_providers.dart:548-577`

### Step 9: StateNotifierProvider Data Reload

```dart
// ExercisesNotifier.refresh() - Reloads exercise list
Future<void> refresh() async {
  _pagination = _pagination.copyWith(page: 0, hasMore: true, isLoading: true);
  _allExercises.clear();
  await _loadExercises(); // Fetches fresh data from repository
}
```

**Files involved:**
- `lib/features/exercises/providers/exercises_providers.dart:267-271`

### Step 10: UI Auto-Rebuild

```dart
// ExerciseDetailScreen - Automatically rebuilds when exerciseByIdProvider refreshes
@override
Widget build(BuildContext context) {
  final exerciseAsync = ref.watch(exerciseByIdProvider(widget.exerciseId));
  
  return Scaffold(
    body: exerciseAsync.when(
      data: (exercise) => _buildExerciseDetail(context, ref, exercise),
      loading: () => _buildLoading(),
      error: (error, stack) => _buildError(context, error),
    ),
  );
}

// ExercisesScreen - Automatically rebuilds when exercisesProvider refreshes  
final exercises = ref.watch(exercisesProvider);
```

**Files involved:**
- `lib/features/exercises/presentation/screens/exercise_detail_screen.dart:28-44`
- `lib/features/exercises/presentation/screens/exercises_screen.dart`

## Provider Types and Refresh Strategies

### FutureProvider.family (Cache-based)
- **Providers**: exerciseByIdProvider, similarExercisesProvider, etc.
- **Challenge**: Caches results by parameter (exerciseId)
- **Solution**: Watch `_repositoryRefreshTriggerProvider` to invalidate cache
- **Refresh Method**: Automatic when trigger increments

### StateNotifierProvider (State-based)
- **Providers**: exercisesProvider, popularExercisesProvider, etc.
- **Challenge**: Maintains own internal state
- **Solution**: Call `.refresh()` method directly
- **Refresh Method**: Manual via notifier method

### Provider (Simple)
- **Providers**: simpleExerciseRepositoryProvider, imageStorageServiceProvider
- **Challenge**: Static/singleton instances
- **Solution**: Watch refresh trigger for repository provider
- **Refresh Method**: Rebuilds when dependencies change

## Error Handling and Recovery

### Database Lock Errors
1. **Retry Logic**: Up to 5 attempts with exponential backoff
2. **Timeout Handling**: 5-second busy timeout via PRAGMA
3. **Transaction Management**: Short-lived transactions to minimize locks
4. **WAL Mode**: Better concurrency for read/write operations

### Form Validation Errors
1. **Client-side validation** before repository call
2. **Error state management** in exerciseCreationProvider
3. **User feedback** via form error display

### Network/Repository Errors
1. **Error capture** in updateExercise() try-catch
2. **Error state** displayed to user
3. **Retry capability** built into repository layer

## Key Design Decisions

### 1. Targeted Provider Invalidation (Updated)
**Why**: More efficient than global trigger approach
- Uses `ref.invalidate()` for specific providers that changed
- Avoids unnecessary rebuilds of unrelated UI components
- More idiomatically correct for Riverpod 2.x

### 2. Proper Mutex Synchronization (Updated)
**Why**: Replaces spinlock with proper concurrency control
- Uses `Mutex.protect()` for clean synchronization
- Prevents busy-waiting and event loop blocking
- Guarantees exclusive access even with exceptions

### 3. Exponential Backoff with Jitter (Updated)
**Why**: More robust retry strategy for database locks
- Exponential: 100ms, 200ms, 400ms, 800ms (vs linear 100, 200, 300, 400)
- Jitter: +0-49ms randomization prevents thundering herd
- Better performance under high concurrency

### 4. Decoupled Navigation with ref.listen (Updated)
**Why**: Separates UI logic from business logic
- Navigation triggered automatically by state changes
- Proper `mounted` checks for safety
- Cleaner, more maintainable code structure

### 5. Repository Pattern with Robust Error Handling
**Why**: Handles SQLite concurrency issues gracefully
- Mutex protection for database operations
- Transaction scoping to minimize lock time
- Proper error mapping for UI feedback

## Testing the Flow

### Manual Testing Steps
1. Open exercise detail screen
2. Click Edit button
3. Modify exercise name
4. Click Save
5. Verify: Detail screen shows new name immediately
6. Navigate to exercise list
7. Verify: List shows updated name without manual refresh

### Expected Log Output
```
=== UPDATE EXERCISE DEBUG ===
Is submitting: false
Editing exercise ID: [exercise-id]
Validation valid: true
Creating updated exercise...
Calling repository update...
Starting update operation for exercises with id: [exercise-id]
Update attempt 1/5
Update completed, affected rows: 1
Update successful on attempt 1
Triggering provider refresh...
Repository update completed
```

## Performance Considerations

### Database Optimizations
- WAL mode for better concurrency
- Proper indexing on frequently queried fields
- Transaction scoping to minimize lock time
- Busy timeout for graceful lock handling

### Memory Management
- Provider caching with proper invalidation
- Image metadata caching in ImageStorageService
- Pagination for large exercise lists

### UI Responsiveness
- Immediate loading states
- Debounced search operations  
- Lazy loading of exercise details
- Optimized list rendering

## Future Improvements

### 1. Real-time Sync
- WebSocket connections for real-time updates
- Conflict resolution strategies
- Offline-first architecture enhancements

### 2. Optimistic Updates
- Update UI immediately, rollback on failure
- Local cache management
- Background sync operations

### 3. Advanced Caching
- Time-based cache invalidation
- Selective provider refreshing
- Cache warming strategies

## Troubleshooting Common Issues

### Issue: Exercise list doesn't update
**Cause**: StateNotifierProvider not refreshed
**Solution**: Ensure `exercisesProvider.notifier.refresh()` is called

### Issue: Detail screen shows old data
**Cause**: FutureProvider.family cache not invalidated  
**Solution**: Ensure provider watches `_repositoryRefreshTriggerProvider`

### Issue: Database lock timeout
**Cause**: Concurrent database operations
**Solution**: Check retry logic and transaction scoping in BaseRepository

### Issue: Form validation errors
**Cause**: Client-side validation failing
**Solution**: Check `_validateForm()` method in ExerciseCreationNotifier

## Code References

### Key Files
- `lib/features/exercises/providers/exercise_creation_providers.dart` - Form state management
- `lib/features/exercises/providers/exercises_providers.dart` - Exercise providers and refresh logic
- `lib/shared/repositories/base_repository.dart` - Database operations with retry logic
- `lib/core/database/database_manager.dart` - SQLite configuration and connection management

### Provider Relationships
```
exerciseCreationProvider
├── simpleExerciseRepositoryProvider
│   └── DatabaseManager (singleton)
├── imageStorageServiceProvider
└── _repositoryRefreshTriggerProvider
    ├── exerciseByIdProvider (family)
    ├── similarExercisesProvider (family)
    └── exercisesProvider (notifier)
```

This documentation provides a complete understanding of how exercise updates flow through the entire application architecture, ensuring maintainability and debuggability for future developers.