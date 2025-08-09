# Code Architecture

This guide will help you understand how the Fitness App codebase is organized, why we chose this structure, and how to work within it effectively. By the end, you'll know exactly where to find code and where to add new features.

## Table of Contents
1. [Architecture Philosophy](#architecture-philosophy)
2. [Project Structure Overview](#project-structure-overview)
3. [Core Directory](#core-directory)
4. [Features Directory](#features-directory)
5. [Shared Directory](#shared-directory)
6. [Navigation & Routing](#navigation--routing)
7. [Dependency Injection](#dependency-injection)
8. [Error Handling Strategy](#error-handling-strategy)
9. [Code Organization Patterns](#code-organization-patterns)

## Architecture Philosophy

### Clean Architecture Principles

Our architecture follows **Clean Architecture** principles adapted for Flutter:

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│              (UI, State Management)                         │
├─────────────────────────────────────────────────────────────┤
│                    Domain Layer                             │
│              (Business Logic, Interfaces)                  │
├─────────────────────────────────────────────────────────────┤
│                    Data Layer                               │
│              (Repositories, Database, API)                 │
└─────────────────────────────────────────────────────────────┘
```

**Key Principles:**
1. **Dependency Inversion**: Higher layers depend on abstractions, not concrete implementations
2. **Single Responsibility**: Each class has one reason to change
3. **Separation of Concerns**: Business logic is separate from UI and data access
4. **Testability**: Each layer can be tested independently

### Feature-First Organization

Instead of organizing by technical layers (all controllers together, all models together), we organize by **business features**:

```
❌ Technical Organization (Hard to maintain)
lib/
├── controllers/     # All controllers mixed together
├── models/         # All models mixed together  
├── views/          # All views mixed together
└── services/       # All services mixed together

✅ Feature Organization (Easy to maintain)
lib/
├── features/
│   ├── exercises/   # Everything exercise-related
│   ├── workouts/    # Everything workout-related
│   └── profile/     # Everything profile-related
└── shared/         # Code used across features
```

**Benefits:**
- **Team Scaling**: Different teams can work on different features
- **Maintainability**: Related code is co-located
- **Discoverability**: Easy to find where to make changes
- **Testing**: Feature-specific tests are organized together

## Project Structure Overview

Let's walk through the complete project structure:

```
fitness-app-flutter/
├── lib/                          # Main source code
│   ├── main.dart                # App entry point
│   ├── app.dart                 # Root app widget
│   ├── core/                    # App-wide configuration
│   ├── features/                # Business features
│   ├── shared/                  # Shared across features
│   └── providers/               # Global providers
├── assets/                      # Static resources
├── test/                        # Unit tests
├── integration_test/            # Integration tests
├── docs/                        # Documentation (you're here!)
├── pubspec.yaml                 # Dependencies & metadata
└── analysis_options.yaml       # Code analysis rules
```

### Entry Points

**`lib/main.dart`** - Application bootstrap:
```dart
void main() {
  runApp(
    const ProviderScope(  // Riverpod dependency injection
      child: FitnessApp(),
    ),
  );
}
```

**`lib/app.dart`** - Root application widget:
```dart
class FitnessApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);          // Navigation
    final themeMode = ref.watch(themeModeProvider);    // Theme
    
    // Watch app initialization (database setup, etc.)
    final appInitialization = ref.watch(appInitializationProvider);
    
    return appInitialization.when(
      data: (_) => MaterialApp.router(
        routerConfig: router,
        theme: ThemeConfig.lightTheme,
        darkTheme: ThemeConfig.darkTheme,
        themeMode: themeMode,
      ),
      loading: () => SplashScreen(),      // Show splash while initializing
      error: (error, stack) => ErrorApp(error),  // Handle init errors
    );
  }
}
```

**Why this structure?**
- **Clean Separation**: Entry point is separate from app configuration
- **Dependency Injection**: ProviderScope wraps the entire app
- **Error Handling**: Graceful handling of initialization failures
- **Loading States**: User sees splash screen during setup

## Core Directory

The `core/` directory contains app-wide configuration and utilities:

```
core/
├── config/                      # Configuration files
│   ├── app_config.dart         # App-wide constants & settings
│   ├── router_config.dart      # Navigation routing setup
│   ├── theme_config.dart       # UI theme configuration
│   └── supabase_config.dart    # Supabase client setup
├── database/                    # Database management
│   ├── database_manager.dart   # SQLite database manager
│   ├── *.sql                   # SQL schema & seed data files
│   └── web_database_manager.dart  # Web-specific database code
├── constants/                   # App constants
│   └── app_constants.dart      # Route paths, API endpoints, etc.
├── errors/                      # Error handling
│   └── app_exceptions.dart     # Custom exception classes
├── extensions/                  # Dart extensions
│   └── string_extensions.dart  # Useful string methods
└── utils/                       # Utility functions
    └── validators.dart         # Input validation functions
```

### Key Core Components

**App Configuration (`core/config/app_config.dart`):**
```dart
class AppConfig {
  // Environment-specific settings
  static const String appName = 'Fitness App';
  static const String version = '1.0.0';
  
  // Feature flags
  static const bool enableAIRecommendations = true;
  static const bool enableSocialFeatures = false;
  
  // Database settings
  static const String databaseName = 'fitness_app.db';
  static const int databaseVersion = 1;
}
```

**Theme Configuration (`core/config/theme_config.dart`):**
```dart
class ThemeConfig {
  static const Color primaryColor = Color(0xFF6366F1);  // Indigo
  static const Color secondaryColor = Color(0xFF10B981); // Emerald
  
  static ThemeData get lightTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    // ... more theme configuration
  );
}
```

**Database Manager (`core/database/database_manager.dart`):**
This is a critical component - it handles:
- Cross-platform SQLite initialization
- Database schema creation and migrations
- Seed data loading
- Performance optimization (WAL mode, indexes)
- Backup and restore functionality

**Why organize core this way?**
- **Single Source of Truth**: All app-wide settings in one place
- **Environment Management**: Easy to swap configurations for dev/prod
- **Reusability**: Core utilities can be used by any feature
- **Maintainability**: Changes to app-wide behavior are centralized

## Features Directory

Each feature is a self-contained module with its own data, domain, and presentation layers:

```
features/
├── exercises/                   # Exercise management feature
│   ├── data/                   # Data layer (repositories, data sources)
│   ├── domain/                 # Business logic (entities, use cases)
│   └── presentation/           # UI layer (screens, widgets, providers)
│       └── screens/
│           ├── exercises_screen.dart      # Main exercise list
│           └── exercise_detail_screen.dart # Exercise details
├── workouts/                    # Workout management feature
│   ├── data/
│   ├── domain/
│   └── presentation/
│       └── screens/
│           ├── workouts_screen.dart       # Workout list
│           ├── create_workout_screen.dart # Create new workout
│           └── workout_detail_screen.dart # Workout details
├── profile/                     # User profile feature
│   ├── data/
│   ├── domain/
│   └── presentation/
│       └── screens/
│           └── profile_screen.dart        # User profile & settings
├── auth/                        # Authentication feature
│   ├── data/
│   ├── domain/
│   └── presentation/
│       └── screens/
│           ├── login_screen.dart          # Login form
│           └── register_screen.dart       # Registration form
└── debug/                       # Development/debugging tools
    └── presentation/
        └── screens/
            ├── database_debug_screen.dart  # Database inspection
            └── database_demo_screen.dart   # Demo data for UI development
```

### Feature Structure Deep Dive

**Data Layer (`features/*/data/`):**
- Repository implementations (local, remote, mock)
- Data source abstractions
- Data transfer objects (DTOs)
- API clients

**Domain Layer (`features/*/domain/`):**
- Business entities (pure Dart objects)
- Use cases (business logic)
- Repository interfaces
- Domain services

**Presentation Layer (`features/*/presentation/`):**
- Screens and pages
- Widgets and UI components
- State management (Riverpod providers)
- View models/controllers

### Example: Exercise Feature Structure

```dart
// Domain: What is an exercise? (Business rules)
class Exercise {
  final String id;
  final String name;
  final List<String> muscleGroups;
  final String difficultyLevel;
  
  // Business logic methods
  bool canBePerformedWith(List<Equipment> availableEquipment) {
    // Business rule implementation
  }
}

// Data: How do we store/retrieve exercises?
abstract class IExerciseRepository {
  Future<List<Exercise>> getAll();
  Future<Exercise> create(Exercise exercise);
  Future<List<Exercise>> searchByMuscleGroup(String muscleGroup);
}

class LocalExerciseRepository implements IExerciseRepository {
  // SQLite implementation
}

// Presentation: How do we show exercises to users?
class ExercisesScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercises = ref.watch(exercisesProvider);
    
    return exercises.when(
      loading: () => LoadingScreen(),
      error: (error, stack) => ErrorScreen(error),
      data: (exercises) => ExerciseList(exercises),
    );
  }
}
```

**Benefits of this structure:**
- **Clear Responsibilities**: Each layer has a specific purpose
- **Testability**: Mock repositories for testing presentation layer
- **Flexibility**: Swap data sources without affecting business logic
- **Team Collaboration**: Frontend and backend developers can work independently

## Shared Directory

Code that's used across multiple features lives in `shared/`:

```
shared/
├── models/                      # Data models used across features
│   ├── exercise.dart           # Exercise data model
│   ├── workout.dart            # Workout data model
│   ├── user_profile.dart       # User profile model
│   └── sync.dart               # Sync-related models
├── repositories/                # Repository base classes & interfaces
│   ├── interfaces/             # Repository contracts
│   ├── local/                  # Local (SQLite) implementations
│   ├── remote/                 # Remote (Supabase) implementations
│   ├── mock/                   # Mock implementations for testing
│   └── providers/              # Riverpod repository providers
├── widgets/                     # Reusable UI components
│   ├── main_navigation.dart    # Bottom navigation bar
│   └── splash_screen.dart      # Loading screen
└── services/                    # Cross-cutting concerns
    ├── sync_service.dart       # Background synchronization
    ├── analytics_service.dart  # Usage analytics
    └── notification_service.dart  # Push notifications
```

### Data Models

All our data models use **Freezed** for immutability and type safety:

```dart
@freezed
class Exercise with _$Exercise {
  const factory Exercise({
    required String id,
    required String name,
    String? description,
    @Default([]) List<String> muscleGroups,
    @Default('beginner') String difficultyLevel,
    DateTime? createdAt,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) => _$ExerciseFromJson(json);
  
  // Database serialization
  factory Exercise.fromDatabase(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      muscleGroups: _parseStringList(map['muscle_groups']),
      difficultyLevel: map['difficulty_level'] as String? ?? 'beginner',
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at'] as String) 
          : null,
    );
  }
}

// Extension for database operations
extension ExerciseDatabase on Exercise {
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'muscle_groups': muscleGroups.join(','),
      'difficulty_level': difficultyLevel,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
```

**Why Freezed?**
- **Immutability**: Prevents accidental data mutations
- **Equality**: Automatic `==` and `hashCode` implementation
- **Copy With**: Easy object updates with `copyWith()`
- **JSON Serialization**: Built-in serialization support
- **Union Types**: Type-safe handling of different states

### Repository Pattern

Our repository pattern provides a clean abstraction over data sources:

```dart
// Interface (contract)
abstract class IExerciseRepository {
  Future<List<Exercise>> getAll();
  Future<Exercise> create(Exercise exercise);
  Future<Exercise?> getById(String id);
}

// Local implementation
class LocalExerciseRepository implements IExerciseRepository {
  final DatabaseManager _dbManager;
  
  LocalExerciseRepository(this._dbManager);
  
  @override
  Future<List<Exercise>> getAll() async {
    final db = await _dbManager.database;
    final maps = await db.query('exercises');
    return maps.map((map) => Exercise.fromDatabase(map)).toList();
  }
}

// Provider for dependency injection
final exerciseRepositoryProvider = Provider<IExerciseRepository>((ref) {
  final dbManager = ref.watch(databaseManagerProvider);
  return LocalExerciseRepository(dbManager);
});
```

**Repository Benefits:**
- **Testability**: Easy to mock for unit tests
- **Flexibility**: Switch between local/remote/hybrid implementations
- **Separation**: Business logic doesn't know about database details
- **Caching**: Repository can implement caching strategies

## Navigation & Routing

We use **GoRouter** for declarative navigation:

### Route Configuration

```dart
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/workouts',
    routes: [
      // Shell route for main app with bottom navigation
      ShellRoute(
        builder: (context, state, child) => MainNavigation(child: child),
        routes: [
          GoRoute(
            path: '/workouts',
            name: 'workouts',
            builder: (context, state) => const WorkoutsScreen(),
          ),
          GoRoute(
            path: '/exercises',
            name: 'exercises', 
            builder: (context, state) => const ExercisesScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      
      // Full-screen routes (outside shell)
      GoRoute(
        path: '/workout/:id',
        name: 'workout-detail',
        builder: (context, state) {
          final workoutId = state.pathParameters['id']!;
          return WorkoutDetailScreen(workoutId: workoutId);
        },
      ),
      
      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
    ],
    
    // Authentication redirect logic
    redirect: (context, state) {
      final isAuthenticated = ref.read(isAuthenticatedProvider);
      final isLoginRoute = state.location == '/login';
      
      if (!isAuthenticated && !isLoginRoute) {
        return '/login';
      }
      if (isAuthenticated && isLoginRoute) {
        return '/workouts';
      }
      return null; // No redirect needed
    },
  );
});
```

### Navigation Helpers

```dart
// Extension methods for easy navigation
extension GoRouterExtensions on GoRouter {
  void pushWorkoutDetail(String workoutId) {
    push('/workout/$workoutId');
  }
  
  void pushExerciseDetail(String exerciseId) {
    push('/exercise/$exerciseId');
  }
}

// Usage in widgets
class WorkoutTile extends StatelessWidget {
  final Workout workout;
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(workout.name),
      onTap: () {
        context.go('/workout/${workout.id}');
        // Or using extension:
        // GoRouter.of(context).pushWorkoutDetail(workout.id);
      },
    );
  }
}
```

## Dependency Injection

We use **Riverpod** for dependency injection throughout the app:

### Provider Types

```dart
// Simple value provider
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig();
});

// Async provider for database initialization
final databaseProvider = FutureProvider<Database>((ref) async {
  final dbManager = DatabaseManager();
  return await dbManager.database;
});

// State provider for mutable state
final selectedTabProvider = StateProvider<int>((ref) => 0);

// StateNotifier for complex state management
final exercisesProvider = StateNotifierProvider<ExercisesNotifier, AsyncValue<List<Exercise>>>((ref) {
  final repository = ref.watch(exerciseRepositoryProvider);
  return ExercisesNotifier(repository);
});

class ExercisesNotifier extends StateNotifier<AsyncValue<List<Exercise>>> {
  final IExerciseRepository _repository;
  
  ExercisesNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadExercises();
  }
  
  Future<void> loadExercises() async {
    try {
      final exercises = await _repository.getAll();
      state = AsyncValue.data(exercises);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  Future<void> createExercise(Exercise exercise) async {
    try {
      await _repository.create(exercise);
      await loadExercises(); // Refresh list
    } catch (error) {
      // Handle error - maybe show snackbar
    }
  }
}
```

### Dependency Graph

```
App Initialization Provider
    ↓
Database Manager Provider
    ↓
Repository Providers
    ↓
Business Logic Providers (StateNotifiers)
    ↓
UI Widgets (Consumers)
```

**Benefits:**
- **Automatic Cleanup**: Providers are automatically disposed
- **Lazy Loading**: Providers are only created when needed
- **Testing**: Easy to override providers for testing
- **Type Safety**: Compile-time dependency checking

## Error Handling Strategy

### Exception Hierarchy

```dart
// Base exception class
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  
  const AppException(this.message, {this.code, this.originalError});
}

// Specific exception types
class NetworkException extends AppException {
  const NetworkException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
  
  bool get isTimeout => code == 'timeout';
  bool get isNoConnection => code == 'no_connection';
}

class DatabaseException extends AppException {
  const DatabaseException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
  
  bool get isCorrupted => code == 'corrupted';
  bool get isLocked => code == 'locked';
}

class ValidationException extends AppException {
  final Map<String, List<String>> fieldErrors;
  
  const ValidationException(String message, this.fieldErrors)
      : super(message);
}
```

### Error Handling in Providers

```dart
class ExercisesNotifier extends StateNotifier<AsyncValue<List<Exercise>>> {
  Future<void> createExercise(Exercise exercise) async {
    try {
      // Optimistic update
      final currentExercises = state.asData?.value ?? [];
      state = AsyncValue.data([...currentExercises, exercise]);
      
      // Actual creation
      await _repository.create(exercise);
      
    } on ValidationException catch (e) {
      // Revert optimistic update
      await loadExercises();
      
      // Show validation errors
      ref.read(globalErrorProvider.notifier).state = 
          'Validation failed: ${e.fieldErrors}';
          
    } on NetworkException catch (e) {
      // Revert optimistic update
      await loadExercises();
      
      if (e.isNoConnection) {
        // Handle offline scenario
        ref.read(globalErrorProvider.notifier).state = 
            'No internet connection. Changes saved locally.';
      } else {
        ref.read(globalErrorProvider.notifier).state = 
            'Network error: ${e.message}';
      }
      
    } catch (e) {
      // Revert optimistic update
      await loadExercises();
      
      // Generic error handling
      ref.read(globalErrorProvider.notifier).state = 
          'Unexpected error: $e';
    }
  }
}
```

### Error Display in UI

```dart
class ExercisesScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(exercisesProvider);
    final globalError = ref.watch(globalErrorProvider);
    
    // Show error snackbar when global error occurs
    ref.listen(globalErrorProvider, (previous, next) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next)),
        );
        // Clear error after showing
        Future.microtask(() => 
          ref.read(globalErrorProvider.notifier).state = null);
      }
    });
    
    return exercisesAsync.when(
      loading: () => const LoadingScreen(),
      error: (error, stack) => ErrorScreen(
        error: error,
        onRetry: () => ref.refresh(exercisesProvider),
      ),
      data: (exercises) => ExercisesList(exercises: exercises),
    );
  }
}
```

## Code Organization Patterns

### File Naming Conventions

```
// Screens (main UI pages)
exercises_screen.dart
workout_detail_screen.dart

// Widgets (reusable UI components)
exercise_tile.dart
workout_card.dart

// Models (data classes)
exercise.dart
workout.dart

// Repositories (data access)
exercise_repository.dart
local_exercise_repository.dart

// Providers (state management)
exercise_providers.dart

// Services (business logic)
sync_service.dart
analytics_service.dart

// Constants
app_constants.dart
api_constants.dart

// Extensions
string_extensions.dart
datetime_extensions.dart
```

### Import Organization

```dart
// Dart imports first
import 'dart:async';
import 'dart:io';

// Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Third-party package imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Local imports (grouped by feature)
import '../../../core/config/theme_config.dart';
import '../../../shared/models/exercise.dart';
import '../../../shared/repositories/exercise_repository.dart';
import '../../data/local_exercise_repository.dart';
```

### Class Organization

```dart
class ExercisesScreen extends ConsumerWidget {
  // 1. Constants
  static const String routeName = '/exercises';
  
  // 2. Constructor
  const ExercisesScreen({super.key});
  
  // 3. Build method
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: _buildAppBar(context, ref),
      body: _buildBody(context, ref),
      floatingActionButton: _buildFab(context, ref),
    );
  }
  
  // 4. Private helper methods (alphabetically)
  Widget _buildAppBar(BuildContext context, WidgetRef ref) {
    // Implementation
  }
  
  Widget _buildBody(BuildContext context, WidgetRef ref) {
    // Implementation
  }
  
  Widget _buildFab(BuildContext context, WidgetRef ref) {
    // Implementation
  }
}
```

### Documentation Standards

```dart
/// Service for managing exercise data and operations.
/// 
/// This service provides a high-level interface for exercise-related
/// operations, handling both local storage and remote synchronization.
/// 
/// Example usage:
/// ```dart
/// final service = ref.read(exerciseServiceProvider);
/// final exercises = await service.searchExercises('chest');
/// ```
class ExerciseService {
  final IExerciseRepository _repository;
  
  /// Creates an exercise service with the given repository.
  const ExerciseService(this._repository);
  
  /// Searches for exercises matching the given query.
  /// 
  /// Returns a list of exercises that match the search criteria.
  /// The search is performed against exercise names, descriptions,
  /// and muscle group tags.
  /// 
  /// Throws [ValidationException] if the query is invalid.
  /// Throws [NetworkException] if remote search fails.
  Future<List<Exercise>> searchExercises(String query) async {
    if (query.trim().isEmpty) {
      throw const ValidationException('Search query cannot be empty', {});
    }
    
    try {
      return await _repository.search(query);
    } on NetworkException {
      // Fall back to local search if remote fails
      return await _repository.searchLocal(query);
    }
  }
}
```

## Next Steps

Now that you understand the code architecture:

1. **Explore the Codebase**: Open the project in your IDE and navigate through the directories
2. **Study a Feature**: Pick one feature (like exercises) and trace through all its layers
3. **Understand the Database**: Read [Database Architecture](./04-database-architecture.md) next
4. **Learn the Repository Pattern**: Deep dive into [Repository Pattern](./05-repository-pattern.md)

**Questions about the architecture?** 
- Check if your question is answered in other documentation sections
- Look at existing code examples for patterns
- The `debug/` feature has great examples of how to work with the architecture

---

**Next:** Continue to [Database Architecture](./04-database-architecture.md) to understand how we store and manage data.