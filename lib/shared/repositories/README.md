# Repository Abstraction Layer

A comprehensive repository abstraction layer for the Flutter fitness app that enables seamless switching between local SQLite and future remote Supabase implementations.

## Overview

This abstraction layer provides:

- **Abstract Repository Interfaces** - Common interfaces for all repository operations
- **Sync-Aware Repository Pattern** - Local-first operations with sync tracking and conflict resolution
- **Repository Provider System** - Riverpod-based dependency injection with automatic switching
- **Configuration Management** - Intelligent switching between local/remote based on connectivity and preferences
- **Future Remote Repository Support** - Placeholder implementations for Supabase integration
- **Comprehensive Error Handling** - Robust error management with retry policies
- **Mock Implementations** - Complete test doubles for unit testing

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Application Layer                        │
├─────────────────────────────────────────────────────────────┤
│                Repository Providers (Riverpod)             │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────────┐ │
│  │   Local     │ │   Remote    │ │       Hybrid            │ │
│  │ Repository  │ │ Repository  │ │     Repository          │ │
│  └─────────────┘ └─────────────┘ └─────────────────────────┘ │
├─────────────────────────────────────────────────────────────┤
│                Repository Interfaces                       │
│  IExerciseRepository │ IWorkoutRepository │ ISyncAware...   │
├─────────────────────────────────────────────────────────────┤
│           Configuration & Strategy Management               │
│  RepositoryConfig │ RepositoryStrategy │ ConnectivityMgr   │
├─────────────────────────────────────────────────────────────┤
│                    Data Sources                             │
│    SQLite Database        │        Supabase                │
└─────────────────────────────────────────────────────────────┘
```

## Quick Start

### 1. Basic Usage with Providers

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../shared/repositories/providers/repository_providers.dart';

class ExerciseService extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseRepo = ref.watch(exerciseRepositoryProvider);
    
    return FutureBuilder<List<Exercise>>(
      future: exerciseRepo.getAll(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ExerciseList(exercises: snapshot.data!);
        }
        return CircularProgressIndicator();
      },
    );
  }
}
```

### 2. Repository Configuration

```dart
import '../shared/repositories/config/repository_config.dart';

// Configure for development (local-first)
await RepositoryConfigBuilder()
  .setMode(RepositoryMode.localFirst)
  .setSyncEnabled(true)
  .setAutoSyncInterval(5)
  .apply();

// Configure for production (hybrid)
await RepositoryConfigBuilder()
  .setMode(RepositoryMode.hybrid)
  .setSyncEnabled(true)
  .setRemoteEnabled(true)
  .setConflictResolutionStrategy(ConflictResolutionStrategy.manual)
  .apply();
```

### 3. Working with Sync Operations

```dart
// Get pending sync operations
final syncOps = await exerciseRepo.getPendingSyncOperations();

// Handle sync conflicts
final conflicts = await exerciseRepo.getSyncConflicts();
for (final conflict in conflicts) {
  await exerciseRepo.handleSyncConflict(conflict, 'local_wins');
}

// Force sync a specific record
await exerciseRepo.forceSyncRecord('exercise_id_123');
```

## Repository Modes

### Local Only
- Uses only SQLite database
- No network operations
- Best for offline-first applications

```dart
final config = await RepositoryConfig.getInstance();
config.repositoryMode = RepositoryMode.localOnly;
```

### Remote Only
- Uses only Supabase (when implemented)
- Requires internet connection
- Real-time synchronization

```dart
config.repositoryMode = RepositoryMode.remoteOnly;
```

### Local First
- Prefers local operations
- Syncs to remote in background
- Offline-capable with eventual consistency

```dart
config.repositoryMode = RepositoryMode.localFirst;
```

### Remote First
- Prefers remote operations
- Falls back to local when offline
- Real-time with offline backup

```dart
config.repositoryMode = RepositoryMode.remoteFirst;
```

### Hybrid
- Intelligent switching based on context
- Reads from remote, writes to local first
- Optimal for production applications

```dart
config.repositoryMode = RepositoryMode.hybrid;
```

## Sync and Conflict Resolution

### Conflict Resolution Strategies

```dart
enum ConflictResolutionStrategy {
  localWins,     // Local changes take precedence
  serverWins,    // Server changes take precedence
  merge,         // Attempt intelligent merge
  manual,        // Require manual resolution
  lastWriteWins, // Timestamp-based resolution
}
```

### Handling Sync Conflicts

```dart
// Automatic resolution
await exerciseRepo.handleSyncConflict(conflict, 'local_wins');

// Manual resolution
final conflict = conflicts.first;
final localData = jsonDecode(conflict.localData);
final serverData = jsonDecode(conflict.serverData);

// User makes decision, then resolve
final resolvedData = await showConflictDialog(localData, serverData);
await exerciseRepo.handleSyncConflict(conflict, 'manual');
```

## Error Handling

### Repository Exceptions

```dart
try {
  final exercises = await exerciseRepo.getAll();
} on NetworkException catch (e) {
  if (e.isTimeout) {
    // Handle timeout
  } else if (e.isNoConnection) {
    // Handle offline state
  }
} on DatabaseException catch (e) {
  if (e.isCorrupted) {
    // Handle database corruption
  }
} on ValidationException catch (e) {
  // Handle validation errors
  final fieldErrors = e.fieldErrors;
} on SyncException catch (e) {
  if (e.isConflict) {
    // Handle sync conflict
  }
} on RepositoryException catch (e) {
  // Handle generic repository error
}
```

### Retry Policies

```dart
// Built-in retry policies
RetryPolicy.network      // 3 attempts, exponential backoff
RetryPolicy.aggressive   // 5 attempts, quick retries
RetryPolicy.conservative // 2 attempts, longer delays
RetryPolicy.none         // No retries

// Custom retry policy
final customPolicy = RetryPolicy(
  maxAttempts: 4,
  initialDelay: Duration(seconds: 2),
  backoffMultiplier: 1.5,
  shouldRetry: (exception) => exception is NetworkException,
);
```

## Testing

### Using Mock Repositories

```dart
import '../shared/repositories/mock/mock_repositories.dart';

void main() {
  testWidgets('Exercise list displays correctly', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          exerciseRepositoryProvider.overrideWith(
            (ref) => MockExerciseRepository(),
          ),
        ],
        child: MyApp(),
      ),
    );
    
    // Test with predictable mock data
    expect(find.text('Push-ups'), findsOneWidget);
    expect(find.text('Squats'), findsOneWidget);
  });
}
```

### Testing Sync Operations

```dart
test('handles sync conflicts correctly', () async {
  final mockRepo = MockExerciseRepository();
  
  // Create a sync conflict
  final conflict = SyncConflict(
    id: 'conflict_1',
    tableName: 'exercises',
    recordId: 'exercise_1',
    localData: '{"name": "Local Exercise"}',
    serverData: '{"name": "Server Exercise"}',
    conflictType: 'concurrent_modification',
    createdAt: DateTime.now(),
  );
  
  // Test conflict resolution
  await mockRepo.handleSyncConflict(conflict, 'local_wins');
  
  final conflicts = await mockRepo.getSyncConflicts();
  expect(conflicts.isEmpty, true);
});
```

## Advanced Usage

### Custom Repository Implementation

```dart
class CustomExerciseRepository extends SyncAwareRepository<Exercise> 
    implements IExerciseRepository {
  
  CustomExerciseRepository(DatabaseManager dbManager) 
      : super(dbManager, 'exercises');

  @override
  Exercise fromDatabase(Map<String, dynamic> map) => Exercise.fromDatabase(map);

  @override
  Map<String, dynamic> toDatabase(Exercise model) => model.toDatabase();

  @override
  String getId(Exercise model) => model.id;

  // Implement custom exercise-specific methods
  @override
  Future<List<Exercise>> searchExercises(String? query, {
    ExerciseFilter? filter,
    ExerciseSortBy sortBy = ExerciseSortBy.name,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    // Custom implementation
  }
}
```

### Custom Provider Override

```dart
final customExerciseRepositoryProvider = Provider<IExerciseRepository>((ref) {
  final dbManager = ref.watch(databaseManagerProvider);
  return CustomExerciseRepository(dbManager);
});

// Use in tests or specific contexts
ProviderScope(
  overrides: [
    exerciseRepositoryProvider.overrideWith(customExerciseRepositoryProvider),
  ],
  child: MyApp(),
)
```

### Monitoring Repository Health

```dart
Consumer(
  builder: (context, ref, child) {
    final healthCheck = ref.watch(repositoryHealthProvider);
    
    return healthCheck.when(
      data: (health) {
        final allHealthy = health.values.every((isHealthy) => isHealthy);
        return StatusIndicator(
          color: allHealthy ? Colors.green : Colors.red,
          text: allHealthy ? 'All Systems Operational' : 'System Issues Detected',
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error),
    );
  },
)
```

## Migration Guide

### From Old Repository Pattern

```dart
// Old pattern
final exerciseRepo = RepositoryFactory(databaseManager).exerciseRepository;

// New pattern
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseRepo = ref.watch(exerciseRepositoryProvider);
    // Use exerciseRepo...
  }
}
```

### Enabling Remote Repositories

1. **Update Configuration**
```dart
final config = await RepositoryConfig.getInstance();
await config.enableRemoteRepositories();
```

2. **Implement Supabase Repositories**
```dart
// Replace stubs in remote/ directory with actual implementations
class RemoteExerciseRepository extends RemoteBaseRepository<Exercise> 
    implements IExerciseRepository {
  // Implement actual Supabase operations
}
```

3. **Update Providers**
```dart
// Providers automatically switch when remote is enabled
// No code changes needed in application layer
```

## Best Practices

### 1. Use Providers for Dependency Injection
```dart
// ✅ Good
final exerciseRepo = ref.watch(exerciseRepositoryProvider);

// ❌ Avoid
final exerciseRepo = ExerciseRepository(databaseManager);
```

### 2. Handle Errors Appropriately
```dart
// ✅ Good
try {
  await exerciseRepo.create(exercise);
} on ValidationException catch (e) {
  showValidationErrors(e.fieldErrors);
} on NetworkException catch (e) {
  showNetworkError(e);
}

// ❌ Avoid
try {
  await exerciseRepo.create(exercise);
} catch (e) {
  print('Error: $e'); // Too generic
}
```

### 3. Use Appropriate Repository Modes
```dart
// ✅ Development
config.repositoryMode = RepositoryMode.localFirst;

// ✅ Production with users
config.repositoryMode = RepositoryMode.hybrid;

// ✅ Testing
config.repositoryMode = RepositoryMode.mock; // via provider override
```

### 4. Monitor Sync Status
```dart
// ✅ Show sync status to users
Consumer(
  builder: (context, ref, child) {
    final pendingCount = ref.watch(pendingSyncCountProvider);
    return pendingCount.when(
      data: (count) => SyncStatusBadge(pendingOperations: count),
      loading: () => SyncingIndicator(),
      error: (error, stack) => SyncErrorIndicator(),
    );
  },
)
```

## Future Roadmap

### Phase 1: Local-First (Current)
- ✅ SQLite repositories
- ✅ Sync tracking
- ✅ Conflict detection
- ✅ Provider system

### Phase 2: Remote Integration
- 🔄 Implement Supabase repositories
- 🔄 Real-time subscriptions
- 🔄 Server-side conflict resolution
- 🔄 Optimistic updates

### Phase 3: Advanced Features
- 📋 Background sync service
- 📋 Selective sync by user preferences
- 📋 Compressed sync payloads
- 📋 Advanced conflict resolution UI

### Phase 4: Performance & Analytics
- 📋 Repository performance monitoring
- 📋 Sync analytics and optimization
- 📋 Intelligent caching strategies
- 📋 Predictive prefetching

## Contributing

When contributing to the repository layer:

1. **Follow Interface Contracts** - All implementations must satisfy the repository interfaces
2. **Add Comprehensive Tests** - Include unit tests for all repository methods
3. **Document Breaking Changes** - Update this README for any interface changes
4. **Consider Backward Compatibility** - Maintain compatibility with existing provider usage
5. **Test All Repository Modes** - Ensure changes work in local, remote, and hybrid modes

## Support

For questions or issues with the repository abstraction layer:

1. Check the interface documentation in `interfaces/repository_interfaces.dart`
2. Review error handling in `errors/repository_exceptions.dart`
3. Examine provider configuration in `providers/repository_providers.dart`
4. Look at test examples in the `mock/` directory

---

**Legend:**
- ✅ Completed
- 🔄 In Progress  
- 📋 Planned