# State Management with Riverpod

This guide explains how we use Riverpod for state management in the Fitness App. You'll learn the different types of providers, how they integrate with our repository pattern, and how to build reactive UIs that respond to data changes.

## Table of Contents
1. [Why Riverpod?](#why-riverpod)
2. [Provider Types Overview](#provider-types-overview)
3. [Basic Provider Patterns](#basic-provider-patterns)
4. [StateNotifier for Complex State](#statenotifier-for-complex-state)
5. [AsyncValue Handling](#asyncvalue-handling)
6. [Repository Integration](#repository-integration)
7. [UI Integration Patterns](#ui-integration-patterns)
8. [Error Handling](#error-handling)
9. [Testing with Riverpod](#testing-with-riverpod)
10. [Performance Optimization](#performance-optimization)

## Why Riverpod?

### Problems with Traditional State Management

**setState() Issues:**
```dart
class ExercisesList extends StatefulWidget {
  @override
  _ExercisesListState createState() => _ExercisesListState();
}

class _ExercisesListState extends State<ExercisesList> {
  List<Exercise>? exercises;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    try {
      setState(() => isLoading = true);
      final result = await exerciseRepository.getAll();
      setState(() {
        exercises = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return CircularProgressIndicator();
    if (error != null) return Text('Error: $error');
    return ListView.builder(
      itemCount: exercises?.length ?? 0,
      itemBuilder: (context, index) => ExerciseTile(exercises![index]),
    );
  }
}
```

**Problems:**
- 🔄 **Boilerplate**: Lots of repetitive loading/error state management
- 🐛 **Error-Prone**: Easy to forget setState(), causing stale UI
- 🧪 **Hard to Test**: Difficult to test business logic separately from UI
- 📊 **No Caching**: Data fetched every time widget rebuilds
- 🔗 **Tight Coupling**: Repository dependencies mixed with UI code

### Riverpod Solution

```dart
// 1. Define data provider
final exercisesProvider = FutureProvider<List<Exercise>>((ref) async {
  final repository = ref.watch(exerciseRepositoryProvider);
  return repository.getAll();
});

// 2. Use in widget
class ExercisesList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(exercisesProvider);
    
    return exercisesAsync.when(
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
      data: (exercises) => ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) => ExerciseTile(exercises[index]),
      ),
    );
  }
}
```

**Benefits:**
- ✅ **Automatic State Management**: Loading, error, and data states handled automatically
- ✅ **Caching**: Data cached automatically, shared between widgets
- ✅ **Reactivity**: UI automatically rebuilds when data changes
- ✅ **Testability**: Business logic separate from UI, easy to test
- ✅ **Type Safety**: Compile-time checking prevents runtime errors
- ✅ **Dependency Injection**: Clean separation of concerns

## Provider Types Overview

Riverpod provides different provider types for different use cases:

### Provider Hierarchy

```
Provider (Immutable)
    ↓
StateProvider (Mutable Simple State)
    ↓
FutureProvider (Async Operations)
    ↓
StreamProvider (Real-time Data)
    ↓
StateNotifierProvider (Complex State Management)
    ↓
ChangeNotifierProvider (Legacy Support)
```

### When to Use Each Type

| Provider Type | Use Case | Example |
|---------------|----------|---------|
| `Provider` | Immutable values, dependency injection | Repository instances, configuration |
| `StateProvider` | Simple mutable state | Selected tab, theme mode, filters |
| `FutureProvider` | Async data fetching | Exercise list, user profile |
| `StreamProvider` | Real-time updates | Workout timer, sync status |
| `StateNotifierProvider` | Complex state with business logic | Workout creation, exercise search |

## Basic Provider Patterns

### Provider for Dependency Injection

```dart
// Database manager
final databaseManagerProvider = Provider<DatabaseManager>((ref) {
  return DatabaseManager();
});

// Repository (depends on database)
final exerciseRepositoryProvider = Provider<IExerciseRepository>((ref) {
  final dbManager = ref.watch(databaseManagerProvider);
  return LocalExerciseRepository(dbManager);
});

// Configuration
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig(
    apiUrl: 'https://api.fitness-app.com',
    enableAnalytics: true,
  );
});
```

### StateProvider for Simple State

```dart
// Selected tab in bottom navigation
final selectedTabProvider = StateProvider<int>((ref) => 0);

// Theme mode
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

// Search query
final exerciseSearchQueryProvider = StateProvider<String>((ref) => '');

// Filter settings
final exerciseFilterProvider = StateProvider<ExerciseFilter?>((ref) => null);

// Usage in widget
class MainNavigation extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);
    
    return BottomNavigationBar(
      currentIndex: selectedTab,
      onTap: (index) {
        // Update state
        ref.read(selectedTabProvider.notifier).state = index;
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workouts'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Exercises'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
```

### FutureProvider for Async Data

```dart
// Basic async data fetching
final exercisesProvider = FutureProvider<List<Exercise>>((ref) async {
  final repository = ref.watch(exerciseRepositoryProvider);
  return repository.getAll();
});

// Parameterized providers
final exerciseProvider = FutureProvider.family<Exercise?, String>((ref, exerciseId) async {
  final repository = ref.watch(exerciseRepositoryProvider);
  return repository.getById(exerciseId);
});

// Dependent providers
final userWorkoutsProvider = FutureProvider<List<Workout>>((ref) async {
  // Get current user
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  
  // Get user's workouts
  final repository = ref.watch(workoutRepositoryProvider);
  return repository.findByUser(user.id);
});

// Usage with error handling
class ExerciseDetailScreen extends ConsumerWidget {
  final String exerciseId;
  
  const ExerciseDetailScreen({required this.exerciseId});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseAsync = ref.watch(exerciseProvider(exerciseId));
    
    return Scaffold(
      appBar: AppBar(
        title: exerciseAsync.when(
          data: (exercise) => Text(exercise?.name ?? 'Not Found'),
          loading: () => Text('Loading...'),
          error: (_, __) => Text('Error'),
        ),
      ),
      body: exerciseAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorWidget(
          error: error,
          onRetry: () => ref.refresh(exerciseProvider(exerciseId)),
        ),
        data: (exercise) {
          if (exercise == null) {
            return Center(child: Text('Exercise not found'));
          }
          return ExerciseDetailView(exercise: exercise);
        },
      ),
    );
  }
}
```

### StreamProvider for Real-time Data

```dart
// Real-time sync status
final syncStatusProvider = StreamProvider<SyncStatus>((ref) {
  final syncService = ref.watch(syncServiceProvider);
  return syncService.statusStream;
});

// Workout timer
final workoutTimerProvider = StreamProvider<Duration>((ref) {
  return Stream.periodic(Duration(seconds: 1), (count) => Duration(seconds: count));
});

// Database changes (using SQLite triggers or custom events)
final exerciseUpdatesProvider = StreamProvider<List<Exercise>>((ref) {
  final repository = ref.watch(exerciseRepositoryProvider);
  return repository.watchAll(); // Custom stream method
});

// Usage
class SyncStatusWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStatusAsync = ref.watch(syncStatusProvider);
    
    return syncStatusAsync.when(
      loading: () => SizedBox.shrink(),
      error: (error, stack) => Icon(Icons.sync_problem, color: Colors.red),
      data: (status) {
        return Row(
          children: [
            Icon(
              status.isPending ? Icons.sync : Icons.sync_disabled,
              color: status.isPending ? Colors.orange : Colors.green,
            ),
            Text('${status.pendingCount} pending'),
          ],
        );
      },
    );
  }
}
```

## StateNotifier for Complex State

For complex state management with business logic, we use StateNotifier:

### Exercise Search State Management

```dart
// State class
@freezed
class ExerciseSearchState with _$ExerciseSearchState {
  const factory ExerciseSearchState({
    @Default([]) List<Exercise> exercises,
    @Default([]) List<Exercise> filteredExercises,
    @Default('') String query,
    ExerciseFilter? filter,
    @Default(ExerciseSortBy.name) ExerciseSortBy sortBy,
    @Default(true) bool ascending,
    @Default(false) bool isLoading,
    String? error,
  }) = _ExerciseSearchState;
}

// StateNotifier
class ExerciseSearchNotifier extends StateNotifier<ExerciseSearchState> {
  final IExerciseRepository _repository;
  
  ExerciseSearchNotifier(this._repository) : super(const ExerciseSearchState()) {
    loadExercises();
  }
  
  Future<void> loadExercises() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final exercises = await _repository.getAll();
      state = state.copyWith(
        exercises: exercises,
        filteredExercises: exercises,
        isLoading: false,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
    }
  }
  
  void setQuery(String query) {
    state = state.copyWith(query: query);
    _applyFilters();
  }
  
  void setFilter(ExerciseFilter? filter) {
    state = state.copyWith(filter: filter);
    _applyFilters();
  }
  
  void setSorting(ExerciseSortBy sortBy, bool ascending) {
    state = state.copyWith(sortBy: sortBy, ascending: ascending);
    _applyFilters();
  }
  
  void _applyFilters() {
    var filtered = List<Exercise>.from(state.exercises);
    
    // Apply text search
    if (state.query.isNotEmpty) {
      final queryLower = state.query.toLowerCase();
      filtered = filtered.where((exercise) {
        return exercise.name.toLowerCase().contains(queryLower) ||
               (exercise.description?.toLowerCase().contains(queryLower) ?? false);
      }).toList();
    }
    
    // Apply muscle group filter
    if (state.filter?.muscleGroups != null && state.filter!.muscleGroups!.isNotEmpty) {
      filtered = filtered.where((exercise) {
        return state.filter!.muscleGroups!.any(
          (mg) => exercise.primaryMuscleGroups.contains(mg)
        );
      }).toList();
    }
    
    // Apply difficulty filter
    if (state.filter?.difficultyLevel != null) {
      filtered = filtered.where((exercise) {
        return exercise.difficultyLevel == state.filter!.difficultyLevel;
      }).toList();
    }
    
    // Apply sorting
    filtered.sort((a, b) {
      int comparison;
      switch (state.sortBy) {
        case ExerciseSortBy.name:
          comparison = a.name.compareTo(b.name);
          break;
        case ExerciseSortBy.difficulty:
          final aDiff = _difficultyToInt(a.difficultyLevel);
          final bDiff = _difficultyToInt(b.difficultyLevel);
          comparison = aDiff.compareTo(bDiff);
          break;
        case ExerciseSortBy.createdAt:
          comparison = (a.createdAt ?? DateTime(0)).compareTo(b.createdAt ?? DateTime(0));
          break;
        default:
          comparison = a.name.compareTo(b.name);
      }
      return state.ascending ? comparison : -comparison;
    });
    
    state = state.copyWith(filteredExercises: filtered);
  }
  
  int _difficultyToInt(String difficulty) {
    switch (difficulty) {
      case 'beginner': return 1;
      case 'intermediate': return 2;
      case 'advanced': return 3;
      default: return 0;
    }
  }
  
  Future<void> refresh() async {
    await loadExercises();
  }
}

// Provider
final exerciseSearchProvider = StateNotifierProvider<ExerciseSearchNotifier, ExerciseSearchState>((ref) {
  final repository = ref.watch(exerciseRepositoryProvider);
  return ExerciseSearchNotifier(repository);
});
```

### Workout Creation State Management

```dart
@freezed
class WorkoutCreationState with _$WorkoutCreationState {
  const factory WorkoutCreationState({
    @Default('') String name,
    @Default('') String description,
    @Default('beginner') String difficultyLevel,
    @Default('strength') String workoutType,
    @Default([]) List<WorkoutExercise> exercises,
    @Default(false) bool isSaving,
    String? error,
    String? validationError,
  }) = _WorkoutCreationState;
  
  // Computed properties
  bool get isValid => name.trim().isNotEmpty && exercises.isNotEmpty;
  int get estimatedDuration => exercises.fold(0, (sum, ex) => sum + (ex.sets * 3)); // 3 min per set estimate
}

class WorkoutCreationNotifier extends StateNotifier<WorkoutCreationState> {
  final IWorkoutRepository _workoutRepository;
  final IExerciseRepository _exerciseRepository;
  
  WorkoutCreationNotifier(this._workoutRepository, this._exerciseRepository) 
      : super(const WorkoutCreationState());
  
  void setName(String name) {
    state = state.copyWith(name: name, validationError: null);
  }
  
  void setDescription(String description) {
    state = state.copyWith(description: description);
  }
  
  void setDifficultyLevel(String level) {
    state = state.copyWith(difficultyLevel: level);
  }
  
  void setWorkoutType(String type) {
    state = state.copyWith(workoutType: type);
  }
  
  Future<void> addExercise(String exerciseId) async {
    try {
      final exercise = await _exerciseRepository.getById(exerciseId);
      if (exercise == null) return;
      
      final workoutExercise = WorkoutExercise(
        id: generateId(),
        exerciseId: exerciseId,
        exercise: exercise,
        sets: 3,
        reps: 10,
        orderIndex: state.exercises.length,
      );
      
      state = state.copyWith(
        exercises: [...state.exercises, workoutExercise],
      );
    } catch (error) {
      state = state.copyWith(error: 'Failed to add exercise: $error');
    }
  }
  
  void updateExercise(int index, WorkoutExercise updatedExercise) {
    if (index < 0 || index >= state.exercises.length) return;
    
    final exercises = [...state.exercises];
    exercises[index] = updatedExercise;
    state = state.copyWith(exercises: exercises);
  }
  
  void removeExercise(int index) {
    if (index < 0 || index >= state.exercises.length) return;
    
    final exercises = [...state.exercises];
    exercises.removeAt(index);
    
    // Update order indexes
    for (int i = 0; i < exercises.length; i++) {
      exercises[i] = exercises[i].copyWith(orderIndex: i);
    }
    
    state = state.copyWith(exercises: exercises);
  }
  
  void reorderExercises(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;
    
    final exercises = [...state.exercises];
    final exercise = exercises.removeAt(oldIndex);
    exercises.insert(newIndex, exercise);
    
    // Update order indexes
    for (int i = 0; i < exercises.length; i++) {
      exercises[i] = exercises[i].copyWith(orderIndex: i);
    }
    
    state = state.copyWith(exercises: exercises);
  }
  
  Future<Workout?> saveWorkout() async {
    if (!state.isValid) {
      state = state.copyWith(
        validationError: 'Please provide a name and add at least one exercise',
      );
      return null;
    }
    
    state = state.copyWith(isSaving: true, error: null);
    
    try {
      final workout = Workout(
        id: generateId(),
        name: state.name.trim(),
        description: state.description.trim().isEmpty ? null : state.description.trim(),
        difficultyLevel: state.difficultyLevel,
        workoutType: state.workoutType,
        estimatedDurationMinutes: state.estimatedDuration,
        createdAt: DateTime.now(),
      );
      
      final savedWorkout = await _workoutRepository.create(workout);
      
      // Save workout exercises
      for (final exercise in state.exercises) {
        await _workoutRepository.addExerciseToWorkout(
          savedWorkout.id,
          exercise.exerciseId,
          sets: exercise.sets,
          reps: exercise.reps,
          weight: exercise.weight,
          order: exercise.orderIndex,
        );
      }
      
      state = state.copyWith(isSaving: false);
      return savedWorkout;
      
    } catch (error) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to save workout: $error',
      );
      return null;
    }
  }
  
  void reset() {
    state = const WorkoutCreationState();
  }
}

// Provider
final workoutCreationProvider = StateNotifierProvider<WorkoutCreationNotifier, WorkoutCreationState>((ref) {
  final workoutRepo = ref.watch(workoutRepositoryProvider);
  final exerciseRepo = ref.watch(exerciseRepositoryProvider);
  return WorkoutCreationNotifier(workoutRepo, exerciseRepo);
});
```

## AsyncValue Handling

AsyncValue is Riverpod's way of handling asynchronous operations with loading, error, and data states:

### AsyncValue States

```dart
// AsyncValue can be in one of three states:
AsyncValue.loading()        // Operation in progress
AsyncValue.error(error, stackTrace)  // Operation failed
AsyncValue.data(value)      // Operation succeeded with data
```

### Using AsyncValue.when()

```dart
class ExercisesList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(exercisesProvider);
    
    return exercisesAsync.when(
      // Loading state
      loading: () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading exercises...'),
          ],
        ),
      ),
      
      // Error state
      error: (error, stackTrace) => ErrorScreen(
        title: 'Failed to load exercises',
        message: error.toString(),
        onRetry: () {
          // Refresh the provider
          ref.refresh(exercisesProvider);
        },
      ),
      
      // Data state
      data: (exercises) {
        if (exercises.isEmpty) {
          return EmptyStateWidget(
            title: 'No exercises found',
            message: 'Add some exercises to get started',
            actionLabel: 'Add Exercise',
            onAction: () => context.push('/exercises/create'),
          );
        }
        
        return ListView.builder(
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            return ExerciseTile(
              exercise: exercises[index],
              onTap: () => context.push('/exercises/${exercises[index].id}'),
            );
          },
        );
      },
    );
  }
}
```

### AsyncValue Pattern Matching

```dart
class WorkoutScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutAsync = ref.watch(workoutProvider(workoutId));
    
    return Scaffold(
      appBar: AppBar(
        title: workoutAsync.maybeWhen(
          data: (workout) => Text(workout.name),
          orElse: () => Text('Workout'),
        ),
        actions: [
          // Only show edit button when data is loaded
          workoutAsync.when(
            data: (workout) => IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => context.push('/workouts/${workout.id}/edit'),
            ),
            loading: () => SizedBox.shrink(),
            error: (_, __) => SizedBox.shrink(),
          ),
        ],
      ),
      body: workoutAsync.when(
        loading: () => WorkoutLoadingSkeleton(),
        error: (error, stack) => WorkoutErrorView(
          error: error,
          onRetry: () => ref.refresh(workoutProvider(workoutId)),
        ),
        data: (workout) => WorkoutDetailView(workout: workout),
      ),
    );
  }
}
```

### Converting AsyncValue

```dart
// Transform AsyncValue data
final exerciseNamesProvider = Provider<AsyncValue<List<String>>>((ref) {
  final exercisesAsync = ref.watch(exercisesProvider);
  
  return exercisesAsync.whenData((exercises) {
    return exercises.map((e) => e.name).toList();
  });
});

// Combine multiple AsyncValues
final workoutWithExercisesProvider = Provider.family<AsyncValue<WorkoutWithExercises>, String>((ref, workoutId) {
  final workoutAsync = ref.watch(workoutProvider(workoutId));
  final exercisesAsync = ref.watch(exercisesProvider);
  
  return AsyncValue.guard(() async {
    final workout = await workoutAsync.future;
    final exercises = await exercisesAsync.future;
    
    return WorkoutWithExercises(
      workout: workout,
      exercises: exercises.where((e) => workout.exerciseIds.contains(e.id)).toList(),
    );
  });
});
```

## Repository Integration

Our providers integrate seamlessly with the repository pattern:

### Repository Provider Pattern

```dart
// Base repository providers
final databaseManagerProvider = Provider<DatabaseManager>((ref) => DatabaseManager());

final exerciseRepositoryProvider = Provider<IExerciseRepository>((ref) {
  final dbManager = ref.watch(databaseManagerProvider);
  return LocalExerciseRepository(dbManager);
});

final workoutRepositoryProvider = Provider<IWorkoutRepository>((ref) {
  final dbManager = ref.watch(databaseManagerProvider);
  return LocalWorkoutRepository(dbManager);
});

// Data providers that use repositories
final exercisesProvider = FutureProvider<List<Exercise>>((ref) async {
  final repository = ref.watch(exerciseRepositoryProvider);
  return await repository.getAll();
});

final userWorkoutsProvider = FutureProvider.family<List<Workout>, String>((ref, userId) async {
  final repository = ref.watch(workoutRepositoryProvider);
  return await repository.findByUser(userId);
});
```

### Service Layer Integration

```dart
// Service providers
final exerciseServiceProvider = Provider<ExerciseService>((ref) {
  final repository = ref.watch(exerciseRepositoryProvider);
  return ExerciseService(repository);
});

final workoutServiceProvider = Provider<WorkoutService>((ref) {
  final workoutRepo = ref.watch(workoutRepositoryProvider);
  final exerciseRepo = ref.watch(exerciseRepositoryProvider);
  return WorkoutService(workoutRepo, exerciseRepo);
});

// Complex business logic providers
final workoutRecommendationsProvider = FutureProvider.family<List<Workout>, String>((ref, userId) async {
  final workoutService = ref.watch(workoutServiceProvider);
  final exerciseService = ref.watch(exerciseServiceProvider);
  
  // Complex business logic combining multiple services
  final userPreferences = await exerciseService.getUserPreferences(userId);
  final recommendations = await workoutService.getRecommendations(userPreferences);
  
  return recommendations;
});
```

### CRUD Operations with Providers

```dart
// StateNotifier for managing CRUD operations
class ExerciseManagerNotifier extends StateNotifier<AsyncValue<List<Exercise>>> {
  final IExerciseRepository _repository;
  
  ExerciseManagerNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadExercises();
  }
  
  Future<void> loadExercises() async {
    state = const AsyncValue.loading();
    try {
      final exercises = await _repository.getAll();
      state = AsyncValue.data(exercises);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  Future<void> createExercise(Exercise exercise) async {
    // Optimistic update
    final currentExercises = state.asData?.value ?? [];
    state = AsyncValue.data([...currentExercises, exercise]);
    
    try {
      await _repository.create(exercise);
      // Refresh to get the actual data from database
      await loadExercises();
    } catch (error) {
      // Revert optimistic update
      state = AsyncValue.data(currentExercises);
      rethrow;
    }
  }
  
  Future<void> updateExercise(Exercise exercise) async {
    final currentExercises = state.asData?.value ?? [];
    final index = currentExercises.indexWhere((e) => e.id == exercise.id);
    
    if (index != -1) {
      // Optimistic update
      final updatedExercises = [...currentExercises];
      updatedExercises[index] = exercise;
      state = AsyncValue.data(updatedExercises);
      
      try {
        await _repository.update(exercise);
      } catch (error) {
        // Revert optimistic update
        state = AsyncValue.data(currentExercises);
        rethrow;
      }
    }
  }
  
  Future<void> deleteExercise(String exerciseId) async {
    final currentExercises = state.asData?.value ?? [];
    final exerciseToDelete = currentExercises.firstWhere((e) => e.id == exerciseId);
    
    // Optimistic update
    final updatedExercises = currentExercises.where((e) => e.id != exerciseId).toList();
    state = AsyncValue.data(updatedExercises);
    
    try {
      await _repository.delete(exerciseId);
    } catch (error) {
      // Revert optimistic update
      state = AsyncValue.data([...currentExercises]);
      rethrow;
    }
  }
}

final exerciseManagerProvider = StateNotifierProvider<ExerciseManagerNotifier, AsyncValue<List<Exercise>>>((ref) {
  final repository = ref.watch(exerciseRepositoryProvider);
  return ExerciseManagerNotifier(repository);
});
```

## UI Integration Patterns

### ConsumerWidget vs ConsumerStatefulWidget

**Use ConsumerWidget for:**
- Simple widgets that only read providers
- Widgets without local state
- Most UI components

```dart
class ExerciseTile extends ConsumerWidget {
  final Exercise exercise;
  
  const ExerciseTile({required this.exercise});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoriteExercisesProvider).contains(exercise.id);
    
    return ListTile(
      title: Text(exercise.name),
      subtitle: Text(exercise.primaryMuscleGroups.join(', ')),
      trailing: IconButton(
        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
        onPressed: () {
          ref.read(favoriteExercisesProvider.notifier).toggle(exercise.id);
        },
      ),
    );
  }
}
```

**Use ConsumerStatefulWidget for:**
- Widgets with local state (animations, controllers)
- Widgets that need lifecycle methods

```dart
class WorkoutTimerWidget extends ConsumerStatefulWidget {
  @override
  _WorkoutTimerWidgetState createState() => _WorkoutTimerWidgetState();
}

class _WorkoutTimerWidgetState extends ConsumerState<WorkoutTimerWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _timer;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(workoutTimerProvider);
    
    // Listen to timer changes
    ref.listen(workoutTimerProvider, (previous, next) {
      if (next.isRunning != previous?.isRunning) {
        if (next.isRunning) {
          _controller.repeat();
        } else {
          _controller.stop();
        }
      }
    });
    
    return Column(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CircularProgressIndicator(
              value: _controller.value,
            );
          },
        ),
        Text(
          '${timerState.elapsed.inMinutes}:${(timerState.elapsed.inSeconds % 60).toString().padLeft(2, '0')}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: timerState.isRunning 
                ? () => ref.read(workoutTimerProvider.notifier).pause()
                : () => ref.read(workoutTimerProvider.notifier).start(),
              child: Text(timerState.isRunning ? 'Pause' : 'Start'),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: () => ref.read(workoutTimerProvider.notifier).reset(),
              child: Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
```

### Listening to Provider Changes

```dart
class ExerciseScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(exercisesProvider);
    
    // Listen to specific changes
    ref.listen(exerciseSearchQueryProvider, (previous, next) {
      if (next.isNotEmpty) {
        // Analytics: track search queries
        ref.read(analyticsServiceProvider).trackSearch('exercise', next);
      }
    });
    
    // Listen to error states
    ref.listen(exerciseManagerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $error'),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Retry',
                onPressed: () => ref.refresh(exerciseManagerProvider),
              ),
            ),
          );
        },
      );
    });
    
    return Scaffold(
      appBar: AppBar(title: Text('Exercises')),
      body: exercisesAsync.when(
        loading: () => LoadingScreen(),
        error: (error, stack) => ErrorScreen(error: error),
        data: (exercises) => ExerciseList(exercises: exercises),
      ),
    );
  }
}
```

### Form Integration with Providers

```dart
class CreateExerciseForm extends ConsumerStatefulWidget {
  @override
  _CreateExerciseFormState createState() => _CreateExerciseFormState();
}

class _CreateExerciseFormState extends ConsumerState<CreateExerciseForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final creationState = ref.watch(exerciseCreationProvider);
    
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Exercise Name'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter an exercise name';
              }
              return null;
            },
            onChanged: (value) {
              ref.read(exerciseCreationProvider.notifier).setName(value);
            },
          ),
          
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
            maxLines: 3,
            onChanged: (value) {
              ref.read(exerciseCreationProvider.notifier).setDescription(value);
            },
          ),
          
          DropdownButtonFormField<String>(
            value: creationState.difficultyLevel,
            decoration: InputDecoration(labelText: 'Difficulty Level'),
            items: ['beginner', 'intermediate', 'advanced']
                .map((level) => DropdownMenuItem(
                      value: level,
                      child: Text(level.capitalize()),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                ref.read(exerciseCreationProvider.notifier).setDifficultyLevel(value);
              }
            },
          ),
          
          SizedBox(height: 24),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: creationState.isSaving ? null : _saveExercise,
              child: creationState.isSaving 
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Saving...'),
                    ],
                  )
                : Text('Create Exercise'),
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _saveExercise() async {
    if (!_formKey.currentState!.validate()) return;
    
    try {
      final exercise = await ref.read(exerciseCreationProvider.notifier).saveExercise();
      
      if (exercise != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exercise created successfully!')),
        );
        Navigator.of(context).pop(exercise);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create exercise: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
```

## Error Handling

### Global Error Handling

```dart
// Global error provider
final globalErrorProvider = StateProvider<String?>((ref) => null);

// Error handling service
class ErrorHandlingService {
  final WidgetRef ref;
  
  ErrorHandlingService(this.ref);
  
  void handleError(Object error, StackTrace? stackTrace) {
    String message;
    
    if (error is NetworkException) {
      if (error.isNoConnection) {
        message = 'No internet connection. Please check your network.';
      } else if (error.isTimeout) {
        message = 'Request timed out. Please try again.';
      } else {
        message = 'Network error: ${error.message}';
      }
    } else if (error is DatabaseException) {
      message = 'Database error: ${error.message}';
    } else if (error is ValidationException) {
      message = 'Validation error: ${error.message}';
    } else {
      message = 'An unexpected error occurred: $error';
    }
    
    ref.read(globalErrorProvider.notifier).state = message;
    
    // Log error for debugging
    debugPrint('Error: $error');
    debugPrint('Stack trace: $stackTrace');
  }
}

final errorHandlingServiceProvider = Provider<ErrorHandlingService>((ref) {
  return ErrorHandlingService(ref);
});

// Global error listener widget
class ErrorListener extends ConsumerWidget {
  final Widget child;
  
  const ErrorListener({required this.child});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(globalErrorProvider, (previous, next) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () {
                ref.read(globalErrorProvider.notifier).state = null;
              },
            ),
          ),
        );
        
        // Clear error after showing
        Future.microtask(() {
          ref.read(globalErrorProvider.notifier).state = null;
        });
      }
    });
    
    return child;
  }
}
```

### Provider-Specific Error Handling

```dart
class ExerciseListNotifier extends StateNotifier<AsyncValue<List<Exercise>>> {
  final IExerciseRepository _repository;
  final ErrorHandlingService _errorService;
  
  ExerciseListNotifier(this._repository, this._errorService) 
      : super(const AsyncValue.loading()) {
    loadExercises();
  }
  
  Future<void> loadExercises() async {
    state = const AsyncValue.loading();
    
    try {
      final exercises = await _repository.getAll();
      state = AsyncValue.data(exercises);
    } catch (error, stackTrace) {
      _errorService.handleError(error, stackTrace);
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  Future<void> createExercise(Exercise exercise) async {
    try {
      await _repository.create(exercise);
      await loadExercises(); // Refresh list
    } catch (error, stackTrace) {
      _errorService.handleError(error, stackTrace);
      rethrow; // Re-throw so UI can handle it specifically
    }
  }
}
```

## Testing with Riverpod

### Unit Testing Providers

```dart
void main() {
  group('Exercise Providers', () {
    test('exercisesProvider should return exercises from repository', () async {
      final mockRepository = MockExerciseRepository();
      final container = ProviderContainer(
        overrides: [
          exerciseRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      
      when(mockRepository.getAll()).thenAnswer((_) async => [
        Exercise(id: '1', name: 'Push-ups'),
        Exercise(id: '2', name: 'Squats'),
      ]);
      
      final exercises = await container.read(exercisesProvider.future);
      
      expect(exercises, hasLength(2));
      expect(exercises.first.name, equals('Push-ups'));
      
      container.dispose();
    });
    
    test('exerciseSearchProvider should filter exercises correctly', () async {
      final mockRepository = MockExerciseRepository();
      final container = ProviderContainer(
        overrides: [
          exerciseRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      
      when(mockRepository.getAll()).thenAnswer((_) async => [
        Exercise(id: '1', name: 'Push-ups', primaryMuscleGroups: ['chest']),
        Exercise(id: '2', name: 'Squats', primaryMuscleGroups: ['legs']),
      ]);
      
      final notifier = container.read(exerciseSearchProvider.notifier);
      
      // Wait for initial load
      await container.read(exerciseSearchProvider.future);
      
      // Apply filter
      notifier.setQuery('push');
      
      final state = container.read(exerciseSearchProvider);
      expect(state.filteredExercises, hasLength(1));
      expect(state.filteredExercises.first.name, equals('Push-ups'));
      
      container.dispose();
    });
  });
}
```

### Widget Testing with Providers

```dart
void main() {
  group('ExercisesList Widget', () {
    testWidgets('should display loading indicator while loading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            exercisesProvider.overrideWith((ref) => 
              Future.delayed(Duration(seconds: 1), () => <Exercise>[])
            ),
          ],
          child: MaterialApp(
            home: ExercisesList(),
          ),
        ),
      );
      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
    
    testWidgets('should display error message on error', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            exercisesProvider.overrideWith((ref) => 
              Future.error('Network error')
            ),
          ],
          child: MaterialApp(
            home: ExercisesList(),
          ),
        ),
      );
      
      await tester.pump();
      
      expect(find.text('Network error'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
    
    testWidgets('should display exercises when loaded', (tester) async {
      final exercises = [
        Exercise(id: '1', name: 'Push-ups'),
        Exercise(id: '2', name: 'Squats'),
      ];
      
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            exercisesProvider.overrideWith((ref) => Future.value(exercises)),
          ],
          child: MaterialApp(
            home: ExercisesList(),
          ),
        ),
      );
      
      await tester.pump();
      
      expect(find.text('Push-ups'), findsOneWidget);
      expect(find.text('Squats'), findsOneWidget);
    });
  });
}
```

### Integration Testing

```dart
void main() {
  group('Full App Integration', () {
    testWidgets('should create exercise and update list', (tester) async {
      // Use real implementations but with test database
      final testContainer = ProviderContainer(
        overrides: [
          databaseManagerProvider.overrideWithValue(TestDatabaseManager()),
        ],
      );
      
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: testContainer,
          child: MaterialApp.router(
            routerConfig: GoRouter(
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => ExercisesList(),
                ),
                GoRoute(
                  path: '/create',
                  builder: (context, state) => CreateExerciseScreen(),
                ),
              ],
            ),
          ),
        ),
      );
      
      // Initially empty
      await tester.pump();
      expect(find.text('No exercises found'), findsOneWidget);
      
      // Navigate to create screen
      await tester.tap(find.text('Add Exercise'));
      await tester.pumpAndSettle();
      
      // Fill form
      await tester.enterText(find.byKey(Key('exercise_name')), 'Test Exercise');
      await tester.enterText(find.byKey(Key('exercise_description')), 'Test Description');
      
      // Save
      await tester.tap(find.text('Create Exercise'));
      await tester.pumpAndSettle();
      
      // Should navigate back and show exercise
      expect(find.text('Test Exercise'), findsOneWidget);
      
      testContainer.dispose();
    });
  });
}
```

## Performance Optimization

### Provider Optimization

**Use Provider.autoDispose for temporary data:**
```dart
// Automatically dispose when no longer used
final exerciseDetailProvider = FutureProvider.autoDispose.family<Exercise?, String>((ref, exerciseId) async {
  final repository = ref.watch(exerciseRepositoryProvider);
  return repository.getById(exerciseId);
});

// Keep alive when needed
final exercisesProvider = FutureProvider.autoDispose<List<Exercise>>((ref) async {
  // Keep alive while any widget is using it
  ref.keepAlive();
  
  final repository = ref.watch(exerciseRepositoryProvider);
  return repository.getAll();
});
```

**Use select() to reduce rebuilds:**
```dart
class ExerciseCounter extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only rebuild when the count changes, not when exercises change
    final count = ref.watch(exercisesProvider.select((async) => async.maybeWhen(
      data: (exercises) => exercises.length,
      orElse: () => 0,
    )));
    
    return Text('Total exercises: $count');
  }
}
```

**Cache expensive computations:**
```dart
final exerciseStatsProvider = Provider.family<ExerciseStats, String>((ref, exerciseId) {
  final exercise = ref.watch(exerciseProvider(exerciseId));
  final allLogs = ref.watch(exerciseLogsProvider);
  
  return exercise.when(
    data: (ex) => allLogs.when(
      data: (logs) {
        final exerciseLogs = logs.where((log) => log.exerciseId == exerciseId);
        return ExerciseStats.calculate(exerciseLogs);
      },
      loading: () => ExerciseStats.empty(),
      error: (_, __) => ExerciseStats.empty(),
    ),
    loading: () => ExerciseStats.empty(),
    error: (_, __) => ExerciseStats.empty(),
  );
});
```

### Memory Management

**Dispose providers when appropriate:**
```dart
class ExerciseDetailScreen extends ConsumerStatefulWidget {
  final String exerciseId;
  
  @override
  _ExerciseDetailScreenState createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends ConsumerState<ExerciseDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final exerciseAsync = ref.watch(exerciseDetailProvider(widget.exerciseId));
    
    return exerciseAsync.when(
      data: (exercise) => ExerciseDetailView(exercise: exercise),
      loading: () => LoadingScreen(),
      error: (error, stack) => ErrorScreen(error: error),
    );
  }
  
  @override
  void dispose() {
    // Provider is automatically disposed due to autoDispose
    super.dispose();
  }
}
```

## Next Steps

Now that you understand state management with Riverpod:

1. **Study Real Examples**: Look at the provider implementations in `lib/providers/`
2. **Learn Data Models**: Continue to [Data Models & Serialization](./07-data-models.md)
3. **Practice**: Try implementing a new feature using the provider patterns shown here
4. **Explore Testing**: Check out the test files to see testing patterns in action

**Questions about state management?**
- Check the Riverpod documentation for advanced patterns
- Look at existing provider implementations in the codebase
- The debug screens show good examples of provider usage

---

**Next:** Continue to [Data Models & Serialization](./07-data-models.md) to understand how our data structures work with Freezed and JSON serialization.