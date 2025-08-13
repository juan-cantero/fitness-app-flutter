import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../../../core/database/web_database_manager.dart';
import '../../models/models.dart';
import '../interfaces/repository_interfaces.dart';

/// Web-compatible Workout repository using browser storage
/// This provides basic workout functionality for web platforms
class WebWorkoutRepository implements IWorkoutRepository {
  final WebDatabaseManager _webDb;

  WebWorkoutRepository(this._webDb);

  @override
  Future<Workout> create(Workout model) async {
    // For web demo, we won't support creating new workouts
    throw UnimplementedError('Creating workouts not supported in web demo');
  }

  @override
  Future<Workout?> getById(String id) async {
    final workouts = await _webDb.query('workouts', where: 'id = ?', whereArgs: [id]);
    if (workouts.isEmpty) return null;
    return Workout.fromDatabase(workouts.first);
  }

  @override
  Future<Workout> update(Workout model) async {
    throw UnimplementedError('Updating workouts not supported in web demo');
  }

  @override
  Future<void> delete(String id) async {
    throw UnimplementedError('Deleting workouts not supported in web demo');
  }

  @override
  Future<List<Workout>> getAll({String? orderBy, int? limit, int? offset}) async {
    final workouts = await _webDb.query('workouts', limit: limit, offset: offset);
    return workouts.map((w) => Workout.fromDatabase(w)).toList();
  }

  @override
  Future<bool> exists(String id) async {
    final result = await getById(id);
    return result != null;
  }

  @override
  Future<int> count([String? where, List<Object?>? whereArgs]) async {
    return await _webDb.getCount('workouts');
  }

  @override
  Future<List<Workout>> createBatch(List<Workout> models) async {
    throw UnimplementedError('Batch operations not supported in web demo');
  }

  @override
  Future<void> deleteBatch(List<String> ids) async {
    throw UnimplementedError('Batch operations not supported in web demo');
  }

  @override
  Future<List<Workout>> findWhere(String where, List<Object?> whereArgs,
      {String? orderBy, int? limit, int? offset}) async {
    // Simple implementation - just return all workouts for now
    return await getAll(orderBy: orderBy, limit: limit, offset: offset);
  }

  @override
  Future<List<Workout>> search(String query, List<String> searchFields,
      {String? additionalWhere,
      List<Object?>? additionalWhereArgs,
      String? orderBy,
      int? limit}) async {
    // Simple search implementation
    final allWorkouts = await getAll(limit: limit);
    if (query.isEmpty) return allWorkouts;
    
    final searchLower = query.toLowerCase();
    return allWorkouts.where((workout) {
      return workout.name.toLowerCase().contains(searchLower) ||
          (workout.description?.toLowerCase() ?? '').contains(searchLower) ||
          workout.targetMuscleGroups.any((muscle) => muscle.toLowerCase().contains(searchLower));
    }).toList();
  }

  @override
  Future<R> transaction<R>(Future<R> Function(Transaction txn) action) async {
    throw UnimplementedError('Transactions not supported in web demo');
  }

  // IWorkoutRepository specific methods

  @override
  Future<List<Workout>> findByUser(String userId, {int? limit, int? offset}) async {
    final allWorkouts = await getAll(limit: limit, offset: offset);
    return allWorkouts.where((w) => w.createdBy == userId).toList();
  }

  @override
  Future<List<Workout>> findPublicWorkouts({
    String? query,
    List<String>? tags,
    String? difficultyLevel,
    int? maxDuration,
    int? limit,
    int? offset,
  }) async {
    var workouts = await getAll(limit: limit, offset: offset);
    workouts = workouts.where((w) => w.isPublic).toList();

    if (query != null && query.trim().isNotEmpty) {
      final searchLower = query.toLowerCase();
      workouts = workouts.where((w) =>
          w.name.toLowerCase().contains(searchLower) ||
          (w.description?.toLowerCase() ?? '').contains(searchLower)).toList();
    }

    if (tags != null && tags.isNotEmpty) {
      workouts = workouts.where((w) =>
          tags.any((tag) => w.tags.any((wTag) => wTag.toLowerCase().contains(tag.toLowerCase())))).toList();
    }

    if (difficultyLevel != null) {
      workouts = workouts.where((w) => w.difficultyLevel == difficultyLevel).toList();
    }

    if (maxDuration != null) {
      workouts = workouts.where((w) => (w.estimatedDurationMinutes ?? 0) <= maxDuration).toList();
    }

    return workouts;
  }

  @override
  Future<List<Workout>> getTemplates({String? category, int? limit}) async {
    var workouts = await getAll(limit: limit);
    workouts = workouts.where((w) => w.isTemplate).toList();

    if (category != null) {
      workouts = workouts.where((w) => w.templateCategory == category).toList();
    }

    return workouts;
  }

  @override
  Future<Workout> cloneWorkout(String workoutId, String newName) async {
    throw UnimplementedError('Cloning workouts not supported in web demo');
  }

  @override
  Future<List<WorkoutExercise>> getWorkoutExercises(String workoutId) async {
    // For web demo, return empty list as we don't have workout exercises stored
    return [];
  }

  @override
  Future<void> addExerciseToWorkout(
    String workoutId,
    String exerciseId, {
    int? sets,
    int? reps,
    double? weight,
    int? restSeconds,
    int? order,
  }) async {
    throw UnimplementedError('Adding exercises to workouts not supported in web demo');
  }

  @override
  Future<void> removeExerciseFromWorkout(String workoutId, String exerciseId) async {
    throw UnimplementedError('Removing exercises from workouts not supported in web demo');
  }

  @override
  Future<void> updateWorkoutExercise(WorkoutExercise workoutExercise) async {
    throw UnimplementedError('Updating workout exercises not supported in web demo');
  }

  @override
  Future<List<Workout>> getRecentWorkouts(String userId, {int limit = 10}) async {
    final workouts = await findByUser(userId, limit: limit);
    workouts.sort((a, b) => (b.updatedAt ?? DateTime.now()).compareTo(a.updatedAt ?? DateTime.now()));
    return workouts;
  }

  @override
  Future<List<Workout>> searchWorkouts(
    String? query, {
    WorkoutFilter? filter,
    WorkoutSortBy sortBy = WorkoutSortBy.name,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    var workouts = await getAll(limit: limit, offset: offset);

    // Apply text search if provided
    if (query != null && query.trim().isNotEmpty) {
      final searchLower = query.toLowerCase();
      workouts = workouts.where((workout) {
        return workout.name.toLowerCase().contains(searchLower) ||
            (workout.description?.toLowerCase() ?? '').contains(searchLower) ||
            workout.targetMuscleGroups.any((muscle) => muscle.toLowerCase().contains(searchLower));
      }).toList();
    }

    // Apply filters if provided
    if (filter != null) {
      if (filter.difficultyLevel != null) {
        workouts = workouts.where((w) => w.difficultyLevel == filter.difficultyLevel).toList();
      }
      if (filter.workoutType != null) {
        workouts = workouts.where((w) => w.workoutType == filter.workoutType).toList();
      }
      if (filter.intensityLevel != null) {
        workouts = workouts.where((w) => w.intensityLevel == filter.intensityLevel).toList();
      }
      if (filter.isTemplate != null) {
        workouts = workouts.where((w) => w.isTemplate == filter.isTemplate).toList();
      }
      if (filter.isPublic != null) {
        workouts = workouts.where((w) => w.isPublic == filter.isPublic).toList();
      }
      if (filter.targetMuscleGroups != null && filter.targetMuscleGroups!.isNotEmpty) {
        workouts = workouts.where((w) {
          return filter.targetMuscleGroups!.any((muscle) => 
              w.targetMuscleGroups.any((wMuscle) => wMuscle.toLowerCase().contains(muscle.toLowerCase())));
        }).toList();
      }
      if (filter.equipmentNeeded != null && filter.equipmentNeeded!.isNotEmpty) {
        workouts = workouts.where((w) {
          return filter.equipmentNeeded!.any((equipment) => 
              w.equipmentNeeded.any((wEquip) => wEquip.toLowerCase().contains(equipment.toLowerCase())));
        }).toList();
      }
    }

    // Apply sorting
    switch (sortBy) {
      case WorkoutSortBy.name:
        workouts.sort((a, b) => ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
        break;
      case WorkoutSortBy.difficulty:
        workouts.sort((a, b) {
          final difficultyOrder = {'beginner': 1, 'intermediate': 2, 'advanced': 3, 'expert': 4};
          final aOrder = difficultyOrder[a.difficultyLevel] ?? 2;
          final bOrder = difficultyOrder[b.difficultyLevel] ?? 2;
          return ascending ? aOrder.compareTo(bOrder) : bOrder.compareTo(aOrder);
        });
        break;
      case WorkoutSortBy.duration:
        workouts.sort((a, b) {
          final aDuration = a.estimatedDurationMinutes ?? 0;
          final bDuration = b.estimatedDurationMinutes ?? 0;
          return ascending ? aDuration.compareTo(bDuration) : bDuration.compareTo(aDuration);
        });
        break;
      case WorkoutSortBy.createdAt:
        workouts.sort((a, b) => ascending ? 
            (a.createdAt ?? DateTime.now()).compareTo(b.createdAt ?? DateTime.now()) : 
            (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
        break;
    }

    return workouts;
  }

  @override
  Future<List<Workout>> getPopularWorkouts({int limit = 10}) async {
    // For web demo, return public workouts as popular ones
    return findPublicWorkouts(limit: limit);
  }

  // Sync-aware repository methods (not implemented in web demo)
  @override
  Future<List<SyncStatus>> getPendingSyncOperations() async => [];

  @override
  Future<void> markSyncCompleted(String syncId, {DateTime? serverTimestamp}) async {}

  @override
  Future<void> markSyncFailed(String syncId, String errorMessage) async {}

  @override
  Future<List<Workout>> getModifiedSinceLastSync([DateTime? lastSyncTime]) async => [];

  @override
  Future<void> handleSyncConflict(SyncConflict conflict, String resolutionStrategy) async {}

  @override
  Future<List<SyncConflict>> getSyncConflicts() async => [];

  @override
  Future<void> forceSyncRecord(String recordId) async {}

  @override
  Future<DateTime?> getLastSyncTimestamp() async => null;

  @override
  Future<void> updateLastSyncTimestamp(DateTime timestamp) async {}
}