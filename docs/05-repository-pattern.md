# Repository Pattern & Local-First Architecture

This guide explains our repository pattern implementation and how it enables local-first functionality. You'll learn how we abstract data access, implement sync-aware operations, and maintain data consistency across local and remote sources.

## Table of Contents
1. [Repository Pattern Fundamentals](#repository-pattern-fundamentals)
2. [Local-First Implementation](#local-first-implementation)
3. [Repository Interfaces](#repository-interfaces)
4. [Sync-Aware Architecture](#sync-aware-architecture)
5. [Repository Implementations](#repository-implementations)
6. [Conflict Resolution](#conflict-resolution)
7. [Provider Integration](#provider-integration)
8. [Testing Strategies](#testing-strategies)
9. [Best Practices](#best-practices)

## Repository Pattern Fundamentals

### What is the Repository Pattern?

The Repository pattern encapsulates the logic needed to access data sources. It centralizes common data access functionality, providing better maintainability and decoupling business logic from data access.

```
┌─────────────────────────────────────────────────────────────┐
│                  Business Logic Layer                      │
│            (Doesn't know about databases)                  │
├─────────────────────────────────────────────────────────────┤
│                Repository Interface                        │
│        (Abstract contract for data operations)             │
├─────────────────────────────────────────────────────────────┤
│              Repository Implementations                    │
│     ┌─────────────┐ ┌─────────────┐ ┌─────────────────────┐ │
│     │   Local     │ │   Remote    │ │       Mock          │ │
│     │(SQLite)     │ │ (Supabase)  │ │    (Testing)        │ │
│     └─────────────┘ └─────────────┘ └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### Benefits in Our Context

**For Local-First Apps:**
- **Abstraction**: Business logic doesn't know if data comes from SQLite or Supabase
- **Flexibility**: Easy to switch between local-only, remote-only, or hybrid modes
- **Testing**: Mock implementations for unit tests
- **Sync Handling**: Repository can handle synchronization transparently
- **Caching**: Repository can implement intelligent caching strategies

**Code Example - Business Logic Doesn't Change:**
```dart
// This code works whether data comes from local SQLite or remote Supabase
class WorkoutService {
  final IWorkoutRepository _repository;
  
  WorkoutService(this._repository);
  
  Future<List<Workout>> getUserWorkouts(String userId) async {
    // Repository handles whether to fetch from local, remote, or both
    return await _repository.findByUser(userId);
  }
  
  Future<void> createWorkout(Workout workout) async {
    // Repository handles local storage + sync queue
    await _repository.create(workout);
  }
}
```

## Local-First Implementation

### Core Principles

Our local-first architecture follows these principles:

**1. Local Database is Primary**
```dart
// All operations hit local database first
Future<Exercise> create(Exercise exercise) async {
  // 1. Save to local SQLite immediately
  final localExercise = await _localDB.insert(exercise);
  
  // 2. Update UI instantly
  return localExercise;
  
  // 3. Queue for background sync
  _syncService.queueForSync(exercise);
}
```

**2. Background Synchronization**
```dart
// Sync happens in background, doesn't block UI
class SyncService {
  Future<void> performBackgroundSync() async {
    final pendingChanges = await _localDB.getPendingSync();
    
    for (final change in pendingChanges) {
      try {
        await _remoteDB.sync(change);
        await _localDB.markSynced(change.id);
      } catch (e) {
        // Handle sync failures, retry later
        await _localDB.incrementRetryCount(change.id);
      }
    }
  }
}
```

**3. Optimistic Updates**
```dart
// UI updates immediately, then syncs in background
Future<void> updateExercise(Exercise exercise) async {
  try {
    // 1. Optimistic update - assume it will succeed
    await _localRepository.update(exercise);
    _notifyUI(); // UI updates immediately
    
    // 2. Background sync
    await _backgroundSync(exercise);
    
  } catch (e) {
    // 3. If sync fails, handle gracefully
    _showOfflineMessage();
    // Data is still saved locally
  }
}
```

### Data Flow Architecture

```
User Action (Create Exercise)
    ↓
Local Repository.create()
    ↓
SQLite Database (Immediate Save)
    ↓
UI Updates Instantly
    ↓
Background: Queue Sync Record
    ↓
Background Sync Service
    ↓ (when online)
Supabase API Call
    ↓
Success: Mark as Synced
Failure: Retry Later
```

## Repository Interfaces

### Base Repository Interface

All repositories implement a common interface:

```dart
/// Base interface for all repository operations
abstract class IBaseRepository<T> {
  /// Create a new record
  Future<T> create(T model);

  /// Create multiple records in a transaction
  Future<List<T>> createBatch(List<T> models);

  /// Get record by ID
  Future<T?> getById(String id);

  /// Get all records with optional parameters
  Future<List<T>> getAll({
    String? orderBy,
    int? limit,
    int? offset,
  });

  /// Update record
  Future<T> update(T model);

  /// Delete record by ID
  Future<void> delete(String id);

  /// Check if record exists
  Future<bool> exists(String id);

  /// Get count of records
  Future<int> count([String? where, List<Object?>? whereArgs]);

  /// Find records with custom where clause
  Future<List<T>> findWhere(
    String where,
    List<Object?> whereArgs, {
    String? orderBy,
    int? limit,
    int? offset,
  });

  /// Search records with text query
  Future<List<T>> search(
    String query,
    List<String> searchFields, {
    String? additionalWhere,
    List<Object?>? additionalWhereArgs,
    String? orderBy,
    int? limit,
  });

  /// Execute operation in transaction
  Future<R> transaction<R>(Future<R> Function(Transaction txn) action);
}
```

### Sync-Aware Repository Interface

For repositories that need synchronization:

```dart
/// Sync-aware repository interface for repositories that support synchronization
abstract class ISyncAwareRepository<T> extends IBaseRepository<T> {
  /// Get pending sync operations for this repository
  Future<List<SyncStatus>> getPendingSyncOperations();

  /// Mark sync operation as completed
  Future<void> markSyncCompleted(String syncId, {DateTime? serverTimestamp});

  /// Mark sync operation as failed
  Future<void> markSyncFailed(String syncId, String errorMessage);

  /// Get records that have been modified locally since last sync
  Future<List<T>> getModifiedSinceLastSync([DateTime? lastSyncTime]);

  /// Handle sync conflict
  Future<void> handleSyncConflict(SyncConflict conflict, String resolutionStrategy);

  /// Get sync conflicts for this repository
  Future<List<SyncConflict>> getSyncConflicts();

  /// Force sync a specific record
  Future<void> forceSyncRecord(String recordId);

  /// Get last successful sync timestamp
  Future<DateTime?> getLastSyncTimestamp();

  /// Update last sync timestamp
  Future<void> updateLastSyncTimestamp(DateTime timestamp);
}
```

### Domain-Specific Interfaces

Each domain has its own interface with specialized methods:

```dart
/// Exercise repository interface with fitness-specific operations
abstract class IExerciseRepository extends ISyncAwareRepository<Exercise> {
  /// Search exercises with comprehensive filtering
  Future<List<Exercise>> searchExercises(
    String? query, {
    ExerciseFilter? filter,
    ExerciseSortBy sortBy = ExerciseSortBy.name,
    bool ascending = true,
    int? limit,
    int? offset,
  });

  /// Find exercises by muscle groups
  Future<List<Exercise>> findByMuscleGroups(
    List<String> muscleGroups, {
    bool requireAll = false,
    int? limit,
  });

  /// Find exercises by equipment availability
  Future<List<Exercise>> findByEquipment(
    List<String> availableEquipmentIds, {
    bool requireExactMatch = false,
    int? limit,
  });

  /// Get exercises with similar movement patterns
  Future<List<Exercise>> findSimilarExercises(
    String exerciseId, {
    int limit = 10,
  });

  /// Get exercise progressions and regressions
  Future<List<Exercise>> getProgressions(String exerciseId);
  Future<List<Exercise>> getRegressions(String exerciseId);

  /// Get popular exercises based on usage
  Future<List<Exercise>> getPopularExercises({
    int limit = 20,
    int? daysBack,
  });
}
```

**Why Domain-Specific Interfaces?**
- **Fitness Logic**: Methods like `findByMuscleGroups()` encode fitness domain knowledge
- **Performance**: Specialized queries optimized for fitness use cases
- **Type Safety**: Parameters and return types specific to fitness domain
- **Discoverability**: IDE can suggest relevant methods for each domain

## Sync-Aware Architecture

### Sync Status Tracking

Every data modification creates a sync record:

```dart
abstract class SyncAwareRepository<T> implements ISyncAwareRepository<T> {
  final DatabaseManager _dbManager;
  final String tableName;
  
  SyncAwareRepository(this._dbManager, this.tableName);
  
  @override
  Future<T> create(T model) async {
    final db = await _dbManager.database;
    
    return await db.transaction((txn) async {
      // 1. Insert the record
      await txn.insert(tableName, toDatabase(model));
      
      // 2. Create sync record
      await txn.insert('sync_status', {
        'id': generateId(),
        'table_name': tableName,
        'record_id': getId(model),
        'operation': 'create',
        'sync_status': 'pending',
        'local_timestamp': DateTime.now().toIso8601String(),
        'record_data': jsonEncode(model.toJson()),
      });
      
      return model;
    });
  }
  
  @override
  Future<T> update(T model) async {
    final db = await _dbManager.database;
    
    return await db.transaction((txn) async {
      // 1. Update the record
      await txn.update(
        tableName,
        toDatabase(model),
        where: 'id = ?',
        whereArgs: [getId(model)],
      );
      
      // 2. Create sync record
      await txn.insert('sync_status', {
        'id': generateId(),
        'table_name': tableName,
        'record_id': getId(model),
        'operation': 'update',
        'sync_status': 'pending',
        'local_timestamp': DateTime.now().toIso8601String(),
        'record_data': jsonEncode(model.toJson()),
      });
      
      return model;
    });
  }
}
```

### Sync Operations

```dart
class SyncAwareRepository<T> {
  /// Get all pending sync operations
  @override
  Future<List<SyncStatus>> getPendingSyncOperations() async {
    final db = await _dbManager.database;
    
    final maps = await db.query(
      'sync_status',
      where: 'table_name = ? AND sync_status = ?',
      whereArgs: [tableName, 'pending'],
      orderBy: 'local_timestamp ASC',
    );
    
    return maps.map((map) => SyncStatus.fromDatabase(map)).toList();
  }
  
  /// Mark sync as completed
  @override
  Future<void> markSyncCompleted(String syncId, {DateTime? serverTimestamp}) async {
    final db = await _dbManager.database;
    
    await db.update(
      'sync_status',
      {
        'sync_status': 'synced',
        'server_timestamp': (serverTimestamp ?? DateTime.now()).toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [syncId],
    );
  }
  
  /// Get records modified since last sync
  @override
  Future<List<T>> getModifiedSinceLastSync([DateTime? lastSyncTime]) async {
    final db = await _dbManager.database;
    
    final lastSync = lastSyncTime ?? DateTime(1970); // Beginning of time if null
    
    final maps = await db.rawQuery('''
      SELECT DISTINCT r.*
      FROM $tableName r
      INNER JOIN sync_status s ON r.id = s.record_id
      WHERE s.table_name = ?
        AND s.local_timestamp > ?
        AND s.sync_status IN ('pending', 'failed')
      ORDER BY s.local_timestamp ASC
    ''', [tableName, lastSync.toIso8601String()]);
    
    return maps.map((map) => fromDatabase(map)).toList();
  }
}
```

## Repository Implementations

### Local Repository (SQLite)

```dart
class LocalExerciseRepository extends SyncAwareRepository<Exercise> 
    implements IExerciseRepository {
  
  LocalExerciseRepository(DatabaseManager databaseManager)
      : super(databaseManager, 'exercises');

  // Required abstract method implementations
  @override
  Exercise fromDatabase(Map<String, dynamic> map) => Exercise.fromDatabase(map);

  @override
  Map<String, dynamic> toDatabase(Exercise model) => model.toDatabase();

  @override
  String getId(Exercise model) => model.id;

  // Domain-specific implementations
  @override
  Future<List<Exercise>> searchExercises(
    String? query, {
    ExerciseFilter? filter,
    ExerciseSortBy sortBy = ExerciseSortBy.name,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    
    // Build complex WHERE clause
    final whereConditions = <String>[];
    final whereArgs = <Object?>[];

    // Text search across multiple fields
    if (query != null && query.trim().isNotEmpty) {
      whereConditions.add('''
        (LOWER(name) LIKE ? OR 
         LOWER(description) LIKE ? OR 
         LOWER(instructions) LIKE ? OR 
         LOWER(primary_muscle_groups) LIKE ?)
      ''');
      final searchTerm = '%${query.toLowerCase()}%';
      whereArgs.addAll([searchTerm, searchTerm, searchTerm, searchTerm]);
    }

    // Apply fitness-specific filters
    if (filter != null) {
      _applyExerciseFilter(filter, whereConditions, whereArgs);
    }

    // Build ORDER BY clause
    final orderBy = _buildOrderBy(sortBy, ascending);

    final results = await db.query(
      tableName,
      where: whereConditions.isEmpty ? null : whereConditions.join(' AND '),
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

    return results.map((map) => fromDatabase(map)).toList();
  }

  @override
  Future<List<Exercise>> findByMuscleGroups(
    List<String> muscleGroups, {
    bool requireAll = false,
    int? limit,
  }) async {
    if (muscleGroups.isEmpty) return [];

    final db = await database;
    
    String whereClause;
    List<Object?> whereArgs;

    if (requireAll) {
      // All muscle groups must be present (AND logic)
      whereClause = muscleGroups
          .map((_) => '(LOWER(primary_muscle_groups) LIKE ? OR LOWER(secondary_muscle_groups) LIKE ?)')
          .join(' AND ');
      whereArgs = muscleGroups
          .expand((mg) => ['%${mg.toLowerCase()}%', '%${mg.toLowerCase()}%'])
          .toList();
    } else {
      // Any muscle group can be present (OR logic)
      whereClause = muscleGroups
          .map((_) => '(LOWER(primary_muscle_groups) LIKE ? OR LOWER(secondary_muscle_groups) LIKE ?)')
          .join(' OR ');
      whereArgs = muscleGroups
          .expand((mg) => ['%${mg.toLowerCase()}%', '%${mg.toLowerCase()}%'])
          .toList();
    }

    final results = await db.query(
      tableName,
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'name ASC',
      limit: limit,
    );

    return results.map((map) => fromDatabase(map)).toList();
  }

  @override
  Future<List<Exercise>> findSimilarExercises(
    String exerciseId, {
    int limit = 10,
  }) async {
    final exercise = await getById(exerciseId);
    if (exercise == null) return [];

    final db = await database;
    
    // Complex similarity scoring query
    final results = await db.rawQuery('''
      SELECT *, 
      (
        CASE WHEN movement_pattern = ? THEN 3 ELSE 0 END +
        CASE WHEN exercise_type = ? THEN 2 ELSE 0 END +
        CASE WHEN difficulty_level = ? THEN 1 ELSE 0 END +
        CASE WHEN (
          SELECT COUNT(*) FROM (
            -- Check for overlapping muscle groups
            SELECT TRIM(value) as mg1 
            FROM json_each('[' || '"' || REPLACE(?, ',', '","') || '"' || ']')
          ) mg1
          INNER JOIN (
            SELECT TRIM(value) as mg2 
            FROM json_each('[' || '"' || REPLACE(primary_muscle_groups, ',', '","') || '"' || ']')
          ) mg2 ON LOWER(mg1.mg1) = LOWER(mg2.mg2)
        ) > 0 THEN 2 ELSE 0 END
      ) as similarity_score
      FROM exercises 
      WHERE id != ? 
      HAVING similarity_score > 0
      ORDER BY similarity_score DESC, name ASC
      LIMIT ?
    ''', [
      exercise.movementPattern ?? '',
      exercise.exerciseType,
      exercise.difficultyLevel,
      exercise.primaryMuscleGroups.join(','),
      exerciseId,
      limit,
    ]);

    return results.map((map) => fromDatabase(map)).toList();
  }
}
```

### Remote Repository (Supabase)

```dart
class RemoteExerciseRepository extends RemoteBaseRepository<Exercise> 
    implements IExerciseRepository {
  
  RemoteExerciseRepository(SupabaseClient supabase) : super(supabase, 'exercises');

  @override
  Exercise fromJson(Map<String, dynamic> json) => Exercise.fromJson(json);

  @override
  Map<String, dynamic> toJson(Exercise model) => model.toJson();

  @override
  String getId(Exercise model) => model.id;

  @override
  Future<List<Exercise>> searchExercises(
    String? query, {
    ExerciseFilter? filter,
    ExerciseSortBy sortBy = ExerciseSortBy.name,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    var queryBuilder = supabase.from(tableName).select();

    // Text search using Supabase full-text search
    if (query != null && query.trim().isNotEmpty) {
      queryBuilder = queryBuilder.textSearch('name,description', query);
    }

    // Apply filters
    if (filter?.muscleGroups != null && filter!.muscleGroups!.isNotEmpty) {
      queryBuilder = queryBuilder.overlaps('primary_muscle_groups', filter.muscleGroups!);
    }

    if (filter?.difficultyLevel != null) {
      queryBuilder = queryBuilder.eq('difficulty_level', filter.difficultyLevel!);
    }

    // Apply sorting
    final orderColumn = _getSortColumn(sortBy);
    queryBuilder = queryBuilder.order(orderColumn, ascending: ascending);

    // Apply pagination
    if (limit != null) {
      queryBuilder = queryBuilder.limit(limit);
    }
    if (offset != null) {
      queryBuilder = queryBuilder.range(offset, offset + (limit ?? 100) - 1);
    }

    final response = await queryBuilder;
    return response.map((json) => fromJson(json)).toList();
  }

  @override
  Future<List<Exercise>> findByMuscleGroups(
    List<String> muscleGroups, {
    bool requireAll = false,
    int? limit,
  }) async {
    if (muscleGroups.isEmpty) return [];

    var queryBuilder = supabase.from(tableName).select();

    if (requireAll) {
      // PostgreSQL: check that all muscle groups are present
      queryBuilder = queryBuilder.contains('primary_muscle_groups', muscleGroups);
    } else {
      // PostgreSQL: check that any muscle groups overlap
      queryBuilder = queryBuilder.overlaps('primary_muscle_groups', muscleGroups);
    }

    if (limit != null) {
      queryBuilder = queryBuilder.limit(limit);
    }

    final response = await queryBuilder.order('name');
    return response.map((json) => fromJson(json)).toList();
  }
}
```

### Mock Repository (Testing)

```dart
class MockExerciseRepository implements IExerciseRepository {
  final List<Exercise> _exercises = [];
  final List<SyncStatus> _syncStatuses = [];
  
  // Generate predictable test data
  MockExerciseRepository() {
    _exercises.addAll([
      Exercise(
        id: 'mock_1',
        name: 'Push-ups',
        primaryMuscleGroups: ['chest', 'shoulders', 'triceps'],
        difficultyLevel: 'beginner',
      ),
      Exercise(
        id: 'mock_2',
        name: 'Squats',
        primaryMuscleGroups: ['quadriceps', 'glutes'],
        difficultyLevel: 'beginner',
      ),
      // ... more test data
    ]);
  }

  @override
  Future<List<Exercise>> getAll({String? orderBy, int? limit, int? offset}) async {
    // Simulate async operation
    await Future.delayed(Duration(milliseconds: 100));
    
    var result = List<Exercise>.from(_exercises);
    
    if (orderBy == 'name') {
      result.sort((a, b) => a.name.compareTo(b.name));
    }
    
    if (offset != null) {
      result = result.skip(offset).toList();
    }
    
    if (limit != null) {
      result = result.take(limit).toList();
    }
    
    return result;
  }

  @override
  Future<Exercise> create(Exercise exercise) async {
    await Future.delayed(Duration(milliseconds: 50));
    
    _exercises.add(exercise);
    
    // Mock sync record
    _syncStatuses.add(SyncStatus(
      id: generateId(),
      tableName: 'exercises',
      recordId: exercise.id,
      operation: 'create',
      localTimestamp: DateTime.now(),
    ));
    
    return exercise;
  }

  @override
  Future<List<Exercise>> searchExercises(
    String? query, {
    ExerciseFilter? filter,
    ExerciseSortBy sortBy = ExerciseSortBy.name,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    await Future.delayed(Duration(milliseconds: 100));
    
    var results = _exercises.where((exercise) {
      if (query != null && query.isNotEmpty) {
        final queryLower = query.toLowerCase();
        if (!exercise.name.toLowerCase().contains(queryLower) &&
            !(exercise.description?.toLowerCase().contains(queryLower) ?? false)) {
          return false;
        }
      }
      
      if (filter?.muscleGroups != null && filter!.muscleGroups!.isNotEmpty) {
        final hasMatch = filter.muscleGroups!.any(
          (mg) => exercise.primaryMuscleGroups.contains(mg)
        );
        if (!hasMatch) return false;
      }
      
      return true;
    }).toList();
    
    if (sortBy == ExerciseSortBy.name) {
      results.sort((a, b) => ascending 
        ? a.name.compareTo(b.name)
        : b.name.compareTo(a.name));
    }
    
    return results;
  }

  // Mock sync operations
  @override
  Future<List<SyncStatus>> getPendingSyncOperations() async {
    return _syncStatuses.where((s) => s.syncStatus == 'pending').toList();
  }

  @override
  Future<void> markSyncCompleted(String syncId, {DateTime? serverTimestamp}) async {
    final index = _syncStatuses.indexWhere((s) => s.id == syncId);
    if (index != -1) {
      _syncStatuses[index] = _syncStatuses[index].copyWith(
        syncStatus: 'synced',
        serverTimestamp: serverTimestamp ?? DateTime.now(),
      );
    }
  }
}
```

## Conflict Resolution

### Conflict Detection

```dart
class SyncService {
  Future<void> syncExercise(Exercise localExercise) async {
    try {
      final remoteExercise = await _remoteRepository.getById(localExercise.id);
      
      if (remoteExercise != null) {
        // Check for conflicts
        final conflict = _detectConflict(localExercise, remoteExercise);
        
        if (conflict != null) {
          await _handleConflict(conflict);
          return;
        }
      }
      
      // No conflict, proceed with sync
      await _remoteRepository.update(localExercise);
      await _localRepository.markSyncCompleted(localExercise.id);
      
    } catch (e) {
      await _localRepository.markSyncFailed(localExercise.id, e.toString());
    }
  }
  
  SyncConflict? _detectConflict(Exercise local, Exercise remote) {
    // Compare timestamps, checksums, or version numbers
    final localTimestamp = local.updatedAt ?? DateTime(0);
    final remoteTimestamp = remote.updatedAt ?? DateTime(0);
    
    if (localTimestamp.isAfter(remoteTimestamp) && 
        !_areEqual(local, remote)) {
      return SyncConflict(
        id: generateId(),
        tableName: 'exercises',
        recordId: local.id,
        localData: jsonEncode(local.toJson()),
        serverData: jsonEncode(remote.toJson()),
        conflictType: 'concurrent_modification',
        createdAt: DateTime.now(),
      );
    }
    
    return null;
  }
}
```

### Conflict Resolution Strategies

```dart
class ConflictResolver {
  Future<void> resolveConflict(
    SyncConflict conflict,
    ConflictResolutionStrategy strategy,
  ) async {
    final localData = jsonDecode(conflict.localData);
    final serverData = jsonDecode(conflict.serverData);
    
    switch (strategy) {
      case ConflictResolutionStrategy.localWins:
        await _resolveLocalWins(conflict, localData);
        break;
        
      case ConflictResolutionStrategy.serverWins:
        await _resolveServerWins(conflict, serverData);
        break;
        
      case ConflictResolutionStrategy.merge:
        await _resolveMerge(conflict, localData, serverData);
        break;
        
      case ConflictResolutionStrategy.manual:
        await _presentManualResolution(conflict, localData, serverData);
        break;
    }
  }
  
  Future<void> _resolveLocalWins(SyncConflict conflict, Map<String, dynamic> localData) async {
    // Update remote with local data
    await _remoteRepository.update(Exercise.fromJson(localData));
    
    // Mark conflict as resolved
    await _markConflictResolved(conflict, 'local_wins', localData);
  }
  
  Future<void> _resolveMerge(
    SyncConflict conflict,
    Map<String, dynamic> localData,
    Map<String, dynamic> serverData,
  ) async {
    // Intelligent merge logic
    final merged = <String, dynamic>{};
    
    // Merge rules for Exercise
    merged['id'] = localData['id'];
    merged['name'] = localData['name']; // Local name wins
    merged['description'] = serverData['description'] ?? localData['description']; // Server description wins if exists
    
    // Merge muscle groups (union of both)
    final localMuscles = List<String>.from(localData['primaryMuscleGroups'] ?? []);
    final serverMuscles = List<String>.from(serverData['primaryMuscleGroups'] ?? []);
    merged['primaryMuscleGroups'] = {...localMuscles, ...serverMuscles}.toList();
    
    // Use latest timestamp
    final localTime = DateTime.parse(localData['updatedAt'] ?? '1970-01-01');
    final serverTime = DateTime.parse(serverData['updatedAt'] ?? '1970-01-01');
    merged['updatedAt'] = localTime.isAfter(serverTime) 
        ? localData['updatedAt'] 
        : serverData['updatedAt'];
    
    final mergedExercise = Exercise.fromJson(merged);
    
    // Update both local and remote
    await _localRepository.update(mergedExercise);
    await _remoteRepository.update(mergedExercise);
    
    await _markConflictResolved(conflict, 'merge', merged);
  }
}
```

## Provider Integration

### Repository Providers

```dart
// Database provider
final databaseManagerProvider = Provider<DatabaseManager>((ref) {
  return DatabaseManager();
});

// Repository providers with automatic implementation selection
final exerciseRepositoryProvider = Provider<IExerciseRepository>((ref) {
  final config = ref.watch(repositoryConfigProvider);
  final dbManager = ref.watch(databaseManagerProvider);
  
  switch (config.mode) {
    case RepositoryMode.localOnly:
      return LocalExerciseRepository(dbManager);
      
    case RepositoryMode.remoteOnly:
      final supabase = ref.watch(supabaseProvider);
      return RemoteExerciseRepository(supabase);
      
    case RepositoryMode.localFirst:
      // Use hybrid repository that prefers local
      return HybridExerciseRepository(
        local: LocalExerciseRepository(dbManager),
        remote: RemoteExerciseRepository(ref.watch(supabaseProvider)),
        strategy: HybridStrategy.localFirst,
      );
      
    case RepositoryMode.mock:
      return MockExerciseRepository();
  }
});

// Business logic providers
final exerciseServiceProvider = Provider<ExerciseService>((ref) {
  final repository = ref.watch(exerciseRepositoryProvider);
  return ExerciseService(repository);
});

// UI state providers
final exercisesProvider = StateNotifierProvider<ExercisesNotifier, AsyncValue<List<Exercise>>>((ref) {
  final service = ref.watch(exerciseServiceProvider);
  return ExercisesNotifier(service);
});
```

### Configuration Provider

```dart
enum RepositoryMode {
  localOnly,
  remoteOnly,
  localFirst,
  remoteFirst,
  hybrid,
  mock,
}

class RepositoryConfig {
  final RepositoryMode mode;
  final bool syncEnabled;
  final bool offlineModeEnabled;
  final ConflictResolutionStrategy defaultConflictResolution;
  
  const RepositoryConfig({
    required this.mode,
    this.syncEnabled = true,
    this.offlineModeEnabled = true,
    this.defaultConflictResolution = ConflictResolutionStrategy.manual,
  });
}

final repositoryConfigProvider = StateProvider<RepositoryConfig>((ref) {
  // Default configuration
  return RepositoryConfig(
    mode: RepositoryMode.localFirst,
    syncEnabled: true,
    offlineModeEnabled: true,
  );
});

// Configuration helper
class RepositoryConfigBuilder {
  RepositoryMode _mode = RepositoryMode.localFirst;
  bool _syncEnabled = true;
  bool _offlineModeEnabled = true;
  ConflictResolutionStrategy _conflictResolution = ConflictResolutionStrategy.manual;
  
  RepositoryConfigBuilder setMode(RepositoryMode mode) {
    _mode = mode;
    return this;
  }
  
  RepositoryConfigBuilder setSyncEnabled(bool enabled) {
    _syncEnabled = enabled;
    return this;
  }
  
  RepositoryConfigBuilder setConflictResolution(ConflictResolutionStrategy strategy) {
    _conflictResolution = strategy;
    return this;
  }
  
  RepositoryConfig build() {
    return RepositoryConfig(
      mode: _mode,
      syncEnabled: _syncEnabled,
      offlineModeEnabled: _offlineModeEnabled,
      defaultConflictResolution: _conflictResolution,
    );
  }
}
```

## Testing Strategies

### Unit Testing Repositories

```dart
void main() {
  group('LocalExerciseRepository', () {
    late LocalExerciseRepository repository;
    late DatabaseManager mockDbManager;
    
    setUp(() async {
      mockDbManager = MockDatabaseManager();
      repository = LocalExerciseRepository(mockDbManager);
    });
    
    test('create should save exercise and create sync record', () async {
      final exercise = Exercise(
        id: 'test_1',
        name: 'Test Exercise',
        primaryMuscleGroups: ['chest'],
      );
      
      final result = await repository.create(exercise);
      
      expect(result, equals(exercise));
      
      // Verify sync record was created
      final syncOps = await repository.getPendingSyncOperations();
      expect(syncOps, hasLength(1));
      expect(syncOps.first.operation, equals('create'));
      expect(syncOps.first.recordId, equals('test_1'));
    });
    
    test('searchExercises should filter by muscle groups', () async {
      // Setup test data
      await repository.create(Exercise(
        id: '1', name: 'Push-ups', primaryMuscleGroups: ['chest']));
      await repository.create(Exercise(
        id: '2', name: 'Squats', primaryMuscleGroups: ['legs']));
      
      final results = await repository.searchExercises(
        null,
        filter: ExerciseFilter(muscleGroups: ['chest']),
      );
      
      expect(results, hasLength(1));
      expect(results.first.name, equals('Push-ups'));
    });
    
    test('findSimilarExercises should return exercises with similar characteristics', () async {
      // Setup test data with similar exercises
      final pushUps = Exercise(
        id: '1',
        name: 'Push-ups',
        primaryMuscleGroups: ['chest', 'shoulders'],
        movementPattern: 'push',
        exerciseType: 'strength',
      );
      
      final benchPress = Exercise(
        id: '2',
        name: 'Bench Press',
        primaryMuscleGroups: ['chest', 'shoulders'],
        movementPattern: 'push',
        exerciseType: 'strength',
      );
      
      final squats = Exercise(
        id: '3',
        name: 'Squats',
        primaryMuscleGroups: ['legs'],
        movementPattern: 'squat',
        exerciseType: 'strength',
      );
      
      await repository.create(pushUps);
      await repository.create(benchPress);
      await repository.create(squats);
      
      final similar = await repository.findSimilarExercises('1');
      
      // Should find bench press as similar (same muscle groups and movement pattern)
      // Should not include squats (different muscle groups and movement pattern)
      expect(similar, hasLength(1));
      expect(similar.first.name, equals('Bench Press'));
    });
  });
}
```

### Integration Testing

```dart
void main() {
  group('Repository Integration Tests', () {
    late IExerciseRepository localRepo;
    late IExerciseRepository remoteRepo;
    late SyncService syncService;
    
    setUp(() async {
      // Setup test database
      final dbManager = await DatabaseManager().database;
      localRepo = LocalExerciseRepository(dbManager);
      
      // Setup test Supabase client
      final supabase = SupabaseClient('test_url', 'test_key');
      remoteRepo = RemoteExerciseRepository(supabase);
      
      syncService = SyncService(localRepo, remoteRepo);
    });
    
    test('sync should handle local-to-remote updates', () async {
      // Create exercise locally
      final exercise = Exercise(id: 'sync_test', name: 'Sync Test');
      await localRepo.create(exercise);
      
      // Perform sync
      await syncService.syncPendingChanges();
      
      // Verify it exists remotely
      final remoteExercise = await remoteRepo.getById('sync_test');
      expect(remoteExercise, isNotNull);
      expect(remoteExercise!.name, equals('Sync Test'));
      
      // Verify sync status is updated
      final pendingOps = await localRepo.getPendingSyncOperations();
      expect(pendingOps, isEmpty);
    });
    
    test('sync should detect and handle conflicts', () async {
      // Create exercise in both local and remote with different data
      final localExercise = Exercise(
        id: 'conflict_test',
        name: 'Local Version',
        description: 'Local description',
      );
      
      final remoteExercise = Exercise(
        id: 'conflict_test',
        name: 'Remote Version',
        description: 'Remote description',
      );
      
      await localRepo.create(localExercise);
      await remoteRepo.create(remoteExercise);
      
      // Attempt sync - should detect conflict
      await syncService.syncPendingChanges();
      
      // Verify conflict was created
      final conflicts = await localRepo.getSyncConflicts();
      expect(conflicts, hasLength(1));
      expect(conflicts.first.conflictType, equals('concurrent_modification'));
    });
  });
}
```

### Mock Testing

```dart
void main() {
  group('Business Logic with Mock Repository', () {
    test('ExerciseService should handle repository errors gracefully', () async {
      final mockRepo = MockExerciseRepository();
      final service = ExerciseService(mockRepo);
      
      // Configure mock to throw error
      when(mockRepo.create(any)).thenThrow(DatabaseException('Mock error'));
      
      final exercise = Exercise(id: 'test', name: 'Test');
      
      expect(
        () => service.createExercise(exercise),
        throwsA(isA<DatabaseException>()),
      );
    });
    
    test('ExerciseService should return consistent results', () async {
      final mockRepo = MockExerciseRepository();
      final service = ExerciseService(mockRepo);
      
      final exercises = await service.getAllExercises();
      
      // Mock repository provides consistent test data
      expect(exercises, hasLength(2));
      expect(exercises.first.name, equals('Push-ups'));
      expect(exercises.last.name, equals('Squats'));
    });
  });
}
```

## Best Practices

### Repository Design

**✅ Do:**
- Use interfaces for all repositories
- Implement sync-aware base classes
- Handle errors gracefully with specific exception types
- Use transactions for multi-table operations
- Implement intelligent caching where appropriate

**❌ Don't:**
- Expose database implementation details to business logic
- Perform UI operations inside repository methods
- Ignore sync status tracking
- Make repositories depend on each other directly
- Skip input validation

### Sync Strategy

**✅ Do:**
- Queue all operations for background sync
- Implement optimistic updates for better UX
- Handle offline scenarios gracefully
- Provide clear conflict resolution options
- Monitor sync health and performance

**❌ Don't:**
- Block UI operations waiting for sync
- Lose data when sync fails
- Auto-resolve all conflicts without user input
- Sync too frequently (respect battery/data usage)
- Ignore sync failures

### Testing

**✅ Do:**
- Test each repository implementation independently
- Use mock repositories for business logic tests
- Test sync scenarios including conflicts
- Test offline/online transitions
- Test error conditions and recovery

**❌ Don't:**
- Skip testing repository edge cases
- Test only happy path scenarios
- Ignore performance testing for large datasets
- Test against production databases
- Forget to test cross-platform compatibility

### Performance

**✅ Do:**
- Use database indexes for common queries
- Implement pagination for large result sets
- Cache frequently accessed data appropriately
- Use batch operations for multiple records
- Monitor query performance with EXPLAIN

**❌ Don't:**
- Load all data into memory at once
- Perform N+1 queries in loops
- Skip database optimization
- Ignore memory usage patterns
- Over-cache data that changes frequently

## Next Steps

Now that you understand the repository pattern:

1. **Study the Implementation**: Explore the actual repository code in `lib/shared/repositories/`
2. **Learn State Management**: See how repositories integrate with [State Management](./06-state-management.md)
3. **Understand Data Models**: Learn how [Data Models](./07-data-models.md) work with repositories
4. **Practice**: Try implementing a new repository following the established patterns

**Questions about repositories?**
- Look at existing repository implementations for patterns
- Check the interfaces in `lib/shared/repositories/interfaces/`
- Use the mock repositories for testing examples

---

**Next:** Continue to [State Management with Riverpod](./06-state-management.md) to understand how repositories integrate with the UI layer through state management.