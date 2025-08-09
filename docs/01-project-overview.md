# Project Overview & Architecture

**Welcome to the Fitness App!** This document will give you a complete understanding of what we're building, why we chose our technical approach, and how everything fits together.

## Table of Contents
1. [What We're Building](#what-were-building)
2. [Why Local-First Architecture?](#why-local-first-architecture)
3. [Technology Stack Overview](#technology-stack-overview)
4. [System Architecture](#system-architecture)
5. [Data Flow & Synchronization](#data-flow--synchronization)
6. [Key Architectural Decisions](#key-architectural-decisions)
7. [Development Approach](#development-approach)

## What We're Building

The Fitness App is an AI-powered fitness application that helps users:

**Core Features:**
- 📚 **Exercise Library**: Comprehensive database of exercises with instructions, muscle groups, and equipment
- 💪 **Workout Creation**: Build custom workouts or use AI-generated recommendations
- 📊 **Progress Tracking**: Log workouts, track personal records, and visualize progress
- 🤖 **AI Recommendations**: Intelligent workout suggestions based on goals and performance
- 👥 **Social Features**: Share workouts, rate routines, and follow other users

**Key Business Requirements:**
- **Works Offline**: Users should be able to work out without internet
- **Sync Across Devices**: Seamless experience on phone, tablet, and web
- **Fast Performance**: Instant response for exercise lookups and workout logging
- **Data Privacy**: User workout data stays local until they choose to sync

## Why Local-First Architecture?

### The Problem with Traditional Apps

Most fitness apps today follow a "remote-first" approach:

```
User Action → Network Request → Server → Database → Response → Update UI
```

**Problems:**
- 🐌 **Slow**: Every action requires a network round-trip
- 📶 **Unreliable**: No internet = no app functionality
- 🔋 **Battery Drain**: Constant network requests
- 😤 **Poor UX**: Loading spinners everywhere

### Our Local-First Solution

```
User Action → Local Database → Instant UI Update → Background Sync (when online)
```

**Benefits:**
- ⚡ **Instant**: All actions feel immediate
- 🌐 **Offline-First**: Full functionality without internet
- 🔋 **Efficient**: Minimal network usage
- 😊 **Great UX**: No loading states for basic operations

### Real-World Example

**Traditional App:**
```
User opens exercise list
→ Show loading spinner
→ API call to server
→ Wait 2-3 seconds
→ Display exercises
```

**Our App:**
```
User opens exercise list
→ Query local SQLite database
→ Display exercises immediately (< 50ms)
→ Background: Check for updates if online
```

## Technology Stack Overview

Let's understand each technology choice and why we made it:

### Frontend: Flutter 🎯

**What:** Google's UI framework for building natively compiled applications

**Why Flutter?**
- **Single Codebase**: Write once, run on iOS, Android, Web, Desktop
- **High Performance**: Compiled to native code, smooth 60fps animations
- **Rich Ecosystem**: Excellent packages for our needs
- **Future-Proof**: Google's backing ensures long-term support

**Alternatives Considered:**
- React Native: Good, but performance isn't quite as smooth
- Native (Swift/Kotlin): Best performance, but would require 2 codebases

### State Management: Riverpod 🎣

**What:** A reactive caching and data-binding framework for Flutter

**Why Riverpod?**
- **Type Safe**: Compile-time error checking prevents runtime crashes
- **Testable**: Easy to mock and test business logic
- **Performance**: Automatic optimizations and smart rebuilds
- **Future-Ready**: Built by the same author as Provider, more modern approach

**Code Example:**
```dart
// Define a provider for exercise data
final exercisesProvider = FutureProvider<List<Exercise>>((ref) async {
  final repository = ref.watch(exerciseRepositoryProvider);
  return repository.getAll();
});

// Use in widget - automatically handles loading, error, and data states
class ExerciseList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(exercisesProvider);
    
    return exercisesAsync.when(
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error),
      data: (exercises) => ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) => ExerciseTile(exercises[index]),
      ),
    );
  }
}
```

### Local Database: SQLite 🗄️

**What:** A lightweight, file-based SQL database

**Why SQLite?**
- **Cross-Platform**: Works identically on all platforms
- **Performance**: Extremely fast for local queries
- **Reliability**: ACID compliant, mature and battle-tested
- **Size**: Entire database fits in a single file
- **SQL**: Powerful query capabilities for complex fitness data

**Example Query:**
```sql
-- Find all exercises that work chest muscles and use dumbbells
SELECT e.*, COUNT(we.exercise_id) as popularity
FROM exercises e
LEFT JOIN workout_exercises we ON e.id = we.exercise_id
WHERE LOWER(e.primary_muscle_groups) LIKE '%chest%'
  AND LOWER(e.equipment_required) LIKE '%dumbbell%'
GROUP BY e.id
ORDER BY popularity DESC, e.name ASC;
```

### Remote Database: Supabase ☁️

**What:** Open-source Firebase alternative with PostgreSQL backend

**Why Supabase?**
- **PostgreSQL**: Full SQL database with advanced features
- **Real-time**: Built-in subscriptions for live updates
- **Auth**: Comprehensive authentication system
- **Open Source**: No vendor lock-in
- **API**: Automatic REST and GraphQL APIs

**Sync Strategy:**
```dart
// Local-first pattern
final exercise = await localRepository.create(newExercise);  // Instant
backgroundSync.scheduleSync();  // Sync to Supabase later
```

### Data Models: Freezed 🧊

**What:** Code generation package for immutable classes

**Why Freezed?**
- **Immutability**: Prevents accidental data mutations
- **Equality**: Automatic == and hashCode implementation
- **Serialization**: Built-in JSON serialization
- **Union Types**: Type-safe handling of different states

**Example:**
```dart
@freezed
class Exercise with _$Exercise {
  const factory Exercise({
    required String id,
    required String name,
    String? description,
    @Default([]) List<String> muscleGroups,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) => _$ExerciseFromJson(json);
}

// Usage - completely type-safe
final exercise = Exercise(id: '1', name: 'Push-ups');
final updated = exercise.copyWith(description: 'Great for chest');  // Creates new instance
```

## System Architecture

Here's how all the pieces fit together:

```
┌─────────────────────────────────────────────────────────────┐
│                         UI Layer                            │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────────┐ │
│  │  Screens    │ │   Widgets   │ │      Navigation         │ │
│  │             │ │             │ │     (GoRouter)          │ │
│  └─────────────┘ └─────────────┘ └─────────────────────────┘ │
├─────────────────────────────────────────────────────────────┤
│                    State Management                         │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────────┐ │
│  │  Providers  │ │  Notifiers  │ │       Services          │ │
│  │ (Riverpod)  │ │             │ │                         │ │
│  └─────────────┘ └─────────────┘ └─────────────────────────┘ │
├─────────────────────────────────────────────────────────────┤
│                    Business Logic                           │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────────┐ │
│  │Repositories │ │   Models    │ │       Services          │ │
│  │  (Local +   │ │ (Freezed)   │ │    (Validation,         │ │
│  │   Remote)   │ │             │ │     AI, Analytics)      │ │
│  └─────────────┘ └─────────────┘ └─────────────────────────┘ │
├─────────────────────────────────────────────────────────────┤
│                      Data Layer                             │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────────┐ │
│  │   SQLite    │ │  Supabase   │ │    Sync Engine          │ │
│  │  (Local)    │ │ (Remote)    │ │  (Conflict Resolution)  │ │
│  └─────────────┘ └─────────────┘ └─────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

**UI Layer:**
- Displays data to users
- Handles user interactions
- Navigation between screens
- **Never directly accesses data** - always goes through state management

**State Management:**
- Manages application state
- Provides data to UI components
- Handles loading, error, and success states
- Coordinates between UI and business logic

**Business Logic:**
- Repository pattern for data access
- Data validation and transformation
- Business rules and calculations
- **Platform-agnostic** - can be tested independently

**Data Layer:**
- SQLite for local storage
- Supabase for remote sync
- Conflict resolution for sync conflicts
- **Single source of truth** for all app data

## Data Flow & Synchronization

### Read Operations (Local-First)

```
User wants exercise list
     ↓
UI requests data via Riverpod Provider
     ↓
Provider calls Exercise Repository
     ↓
Repository checks LOCAL SQLite first
     ↓
Return data immediately (< 50ms)
     ↓
Background: Check Supabase for updates
     ↓
If newer data exists: Update local & notify UI
```

### Write Operations (Optimistic Updates)

```
User creates new workout
     ↓
Repository saves to LOCAL SQLite immediately
     ↓
UI updates instantly (optimistic update)
     ↓
Background: Queue sync to Supabase
     ↓
If sync fails: Show conflict resolution UI
If sync succeeds: Mark as synced
```

### Sync Conflict Resolution

```
Local Data:  {name: "My Workout", exercises: [1, 2, 3]}
Server Data: {name: "My Workout", exercises: [1, 2, 4]}
                         ↓
Conflict Detected: Different exercise lists
                         ↓
Resolution Strategies:
1. Local Wins (user's device is authority)
2. Server Wins (remote data is authority)  
3. Manual (show user both versions)
4. Merge (intelligent combination)
```

### Example: Creating a New Exercise

```dart
// User taps "Create Exercise" button
Future<void> createExercise(Exercise exercise) async {
  try {
    // 1. Save locally first (instant feedback)
    final localExercise = await localRepository.create(exercise);
    
    // 2. Update UI immediately
    ref.refresh(exercisesProvider);
    
    // 3. Schedule background sync
    syncService.scheduleSync(
      table: 'exercises',
      operation: 'create',
      recordId: exercise.id,
    );
    
    // 4. Show success message
    showSnackbar('Exercise created!');
    
  } catch (e) {
    // 5. Handle errors gracefully
    showErrorDialog('Failed to create exercise: $e');
  }
}
```

## Key Architectural Decisions

### 1. Repository Pattern with Interface Segregation

**Decision:** Use repository interfaces with multiple implementations

**Why:**
- **Testability**: Easy to mock for unit tests
- **Flexibility**: Switch between local/remote/hybrid strategies
- **Separation of Concerns**: Business logic doesn't know about data sources

**Implementation:**
```dart
// Interface defines contract
abstract class IExerciseRepository {
  Future<List<Exercise>> getAll();
  Future<Exercise> create(Exercise exercise);
  // ... more methods
}

// Local implementation
class LocalExerciseRepository implements IExerciseRepository {
  Future<List<Exercise>> getAll() async {
    final db = await database;
    final maps = await db.query('exercises');
    return maps.map((map) => Exercise.fromDatabase(map)).toList();
  }
}

// Remote implementation (future)
class RemoteExerciseRepository implements IExerciseRepository {
  Future<List<Exercise>> getAll() async {
    final response = await supabase.from('exercises').select();
    return response.map((json) => Exercise.fromJson(json)).toList();
  }
}

// Provider automatically selects implementation
final exerciseRepositoryProvider = Provider<IExerciseRepository>((ref) {
  final config = ref.watch(repositoryConfigProvider);
  
  switch (config.mode) {
    case RepositoryMode.localFirst:
      return LocalExerciseRepository(ref.watch(databaseProvider));
    case RepositoryMode.remoteFirst:
      return RemoteExerciseRepository(ref.watch(supabaseProvider));
    case RepositoryMode.hybrid:
      return HybridExerciseRepository(/* both implementations */);
  }
});
```

### 2. Sync-Aware Data Models

**Decision:** Every model tracks its sync status

**Why:**
- **Offline Reliability**: Know which data is synced vs local-only
- **Conflict Detection**: Identify when local and remote data diverge
- **User Feedback**: Show sync status in UI

**Implementation:**
```dart
@freezed
class SyncStatus with _$SyncStatus {
  const factory SyncStatus({
    required String id,
    required String tableName,
    required String recordId,
    required String operation,  // 'create', 'update', 'delete'
    required DateTime localTimestamp,
    DateTime? serverTimestamp,
    @Default('pending') String syncStatus,  // 'pending', 'synced', 'conflict'
    int retryCount = 0,
    String? errorMessage,
  }) = _SyncStatus;
}

// Every repository operation creates sync record
Future<Exercise> create(Exercise exercise) async {
  await transaction((txn) async {
    // Save the exercise
    await txn.insert('exercises', exercise.toDatabase());
    
    // Create sync record
    await txn.insert('sync_status', SyncStatus(
      id: generateId(),
      tableName: 'exercises',
      recordId: exercise.id,
      operation: 'create',
      localTimestamp: DateTime.now(),
    ).toDatabase());
  });
}
```

### 3. Cross-Platform Database Compatibility

**Decision:** Use SQLite with platform-specific optimizations

**Why:**
- **Consistency**: Same database works on mobile, web, and desktop
- **Performance**: Native SQLite performance on each platform
- **Reliability**: Battle-tested database engine

**Implementation:**
```dart
class DatabaseManager {
  // Initialize appropriate database factory for each platform
  static void _initializeDatabaseFactory() {
    if (kIsWeb) {
      // Web uses sql.js (SQLite compiled to WebAssembly)
      databaseFactory = databaseFactoryFfiWeb;
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Desktop uses FFI (Foreign Function Interface)
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    // Mobile uses default platform-optimized SQLite
  }
}
```

### 4. Feature-Based Project Structure

**Decision:** Organize code by feature, not by type

**Why:**
- **Maintainability**: All related code is co-located
- **Team Scaling**: Different teams can work on different features
- **Clear Ownership**: Easy to understand what each part does

**Structure:**
```
lib/
├── features/
│   ├── exercises/          # Everything exercise-related
│   │   ├── data/          # Repository implementations
│   │   ├── domain/        # Business logic & interfaces
│   │   └── presentation/  # UI components
│   ├── workouts/          # Everything workout-related
│   └── profile/           # User profile features
├── shared/                # Code used across features
│   ├── models/           # Data models
│   ├── repositories/     # Base repository classes
│   └── widgets/          # Reusable UI components
└── core/                 # App-wide configuration
    ├── database/         # Database setup & migrations
    ├── config/           # App configuration
    └── utils/            # Utility functions
```

## Development Approach

### Progressive Development Strategy

We're building this app in phases:

**Phase 1: Local-First Foundation (Current)**
- ✅ SQLite database with comprehensive schema
- ✅ Repository pattern with local implementations
- ✅ Freezed data models with serialization
- ✅ Basic UI structure and navigation
- 🔄 Core features (exercise management, workout creation)

**Phase 2: Remote Sync Integration**
- 📋 Supabase repository implementations
- 📋 Background sync service
- 📋 Conflict resolution UI
- 📋 Real-time updates

**Phase 3: AI & Advanced Features**
- 📋 AI workout recommendations
- 📋 Progress analytics
- 📋 Social features
- 📋 Performance optimizations

### Testing Strategy

**Unit Tests:** Every repository method, model serialization, business logic
**Integration Tests:** Database operations, sync scenarios
**Widget Tests:** UI components and user interactions
**End-to-End Tests:** Complete user workflows

### Code Quality Principles

1. **Type Safety First**: Use Dart's type system to prevent runtime errors
2. **Immutable Data**: All models are immutable for predictable behavior
3. **Single Responsibility**: Each class has one clear purpose
4. **Dependency Injection**: Use Riverpod for testable, modular code
5. **Error Handling**: Comprehensive error handling with user-friendly messages

## Questions & Next Steps

**Common Questions:**

**Q: Why not use Firebase instead of Supabase?**
A: Supabase gives us more control, uses PostgreSQL (more powerful than Firestore), and is open-source so we avoid vendor lock-in.

**Q: Why SQLite instead of a NoSQL local database?**
A: Our fitness data is highly relational (exercises, workouts, sessions, logs). SQL provides powerful queries for analytics and reporting.

**Q: How does the app handle large datasets?**
A: We use pagination, lazy loading, and database indexes. SQLite can handle millions of records efficiently.

**Q: What happens if sync conflicts can't be resolved automatically?**
A: We present a conflict resolution UI showing both versions and let the user choose or merge them manually.

---

**Next:** Continue to [Developer Setup Guide](./02-developer-setup.md) to get your development environment running, or dive deeper into [Code Architecture](./03-code-architecture.md) to understand the project structure.