import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../../../core/database/web_database_manager.dart';
import '../../models/models.dart';
import '../interfaces/repository_interfaces.dart';

/// Web-compatible Exercise repository using browser storage
/// This provides basic exercise functionality for web platforms
class WebExerciseRepository implements IExerciseRepository {
  final WebDatabaseManager _webDb;

  WebExerciseRepository(this._webDb);

  @override
  Future<Exercise> create(Exercise model) async {
    // For web demo, we won't support creating new exercises
    throw UnimplementedError('Creating exercises not supported in web demo');
  }

  @override
  Future<Exercise?> getById(String id) async {
    final exercises = await _webDb.query('exercises', where: 'id = ?', whereArgs: [id]);
    if (exercises.isEmpty) return null;
    return Exercise.fromDatabase(exercises.first);
  }

  @override
  Future<Exercise> update(Exercise model) async {
    throw UnimplementedError('Updating exercises not supported in web demo');
  }

  @override
  Future<void> delete(String id) async {
    throw UnimplementedError('Deleting exercises not supported in web demo');
  }

  @override
  Future<List<Exercise>> getAll({String? orderBy, int? limit, int? offset}) async {
    final exercises = await _webDb.query('exercises', limit: limit, offset: offset);
    return exercises.map((e) => Exercise.fromDatabase(e)).toList();
  }

  @override
  Future<bool> exists(String id) async {
    final result = await getById(id);
    return result != null;
  }

  @override
  Future<int> count([String? where, List<Object?>? whereArgs]) async {
    return await _webDb.getCount('exercises');
  }

  @override
  Future<List<Exercise>> createBatch(List<Exercise> models) async {
    throw UnimplementedError('Batch operations not supported in web demo');
  }

  @override
  Future<void> deleteBatch(List<String> ids) async {
    throw UnimplementedError('Batch operations not supported in web demo');
  }

  @override
  Future<List<Exercise>> findWhere(String where, List<Object?> whereArgs,
      {String? orderBy, int? limit, int? offset}) async {
    // Simple implementation - just return all exercises for now
    return await getAll(orderBy: orderBy, limit: limit, offset: offset);
  }

  @override
  Future<List<Exercise>> search(String query, List<String> searchFields,
      {String? additionalWhere,
      List<Object?>? additionalWhereArgs,
      String? orderBy,
      int? limit}) async {
    // Simple search implementation
    final allExercises = await getAll(limit: limit);
    if (query.isEmpty) return allExercises;
    
    final searchLower = query.toLowerCase();
    return allExercises.where((exercise) {
      return exercise.name.toLowerCase().contains(searchLower) ||
          (exercise.description?.toLowerCase() ?? '').contains(searchLower) ||
          exercise.primaryMuscleGroups.any((muscle) => muscle.toLowerCase().contains(searchLower));
    }).toList();
  }

  @override
  Future<R> transaction<R>(Future<R> Function(Transaction txn) action) async {
    // Web implementation doesn't support transactions - create a fake transaction
    // Since we can't create a real Transaction, we'll throw an exception for now
    throw UnimplementedError('Transactions not supported in web demo');
  }

  // IExerciseRepository specific methods

  @override
  Future<List<Exercise>> searchExercises(String? query,
      {ExerciseFilter? filter,
      ExerciseSortBy sortBy = ExerciseSortBy.name,
      bool ascending = true,
      int? limit,
      int? offset}) async {
    var exercises = await getAll(limit: limit, offset: offset);

    // Apply text search if provided
    if (query != null && query.trim().isNotEmpty) {
      final searchLower = query.toLowerCase();
      exercises = exercises.where((exercise) {
        return exercise.name.toLowerCase().contains(searchLower) ||
            (exercise.description?.toLowerCase() ?? '').contains(searchLower) ||
            exercise.primaryMuscleGroups.any((muscle) => muscle.toLowerCase().contains(searchLower));
      }).toList();
    }

    // Apply filters if provided
    if (filter != null) {
      if (filter.difficultyLevel != null) {
        exercises = exercises.where((e) => e.difficultyLevel == filter.difficultyLevel).toList();
      }
      if (filter.exerciseType != null) {
        exercises = exercises.where((e) => e.exerciseType == filter.exerciseType).toList();
      }
      if (filter.muscleGroups != null && filter.muscleGroups!.isNotEmpty) {
        exercises = exercises.where((e) {
          return filter.muscleGroups!.any((muscle) => 
              e.primaryMuscleGroups.contains(muscle) || 
              e.secondaryMuscleGroups.contains(muscle));
        }).toList();
      }
      if (filter.equipmentIds != null && filter.equipmentIds!.isNotEmpty) {
        // Simple equipment filtering - if equipment is required and it's in the filter list
        exercises = exercises.where((e) {
          if (e.equipmentRequired.isEmpty) return true; // Bodyweight exercises
          return filter.equipmentIds!.any((eq) => e.equipmentRequired.contains(eq));
        }).toList();
      }
    }

    // Apply sorting
    switch (sortBy) {
      case ExerciseSortBy.name:
        exercises.sort((a, b) => ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
        break;
      case ExerciseSortBy.difficulty:
        exercises.sort((a, b) {
          final difficultyOrder = {'beginner': 1, 'intermediate': 2, 'advanced': 3};
          final aOrder = difficultyOrder[a.difficultyLevel] ?? 2;
          final bOrder = difficultyOrder[b.difficultyLevel] ?? 2;
          return ascending ? aOrder.compareTo(bOrder) : bOrder.compareTo(aOrder);
        });
        break;
      case ExerciseSortBy.muscleGroups:
        exercises.sort((a, b) {
          final aMuscles = a.primaryMuscleGroups.join(',');
          final bMuscles = b.primaryMuscleGroups.join(',');
          return ascending ? aMuscles.compareTo(bMuscles) : bMuscles.compareTo(aMuscles);
        });
        break;
      case ExerciseSortBy.popularity:
        // For web demo, just sort by name as we don't have popularity data
        exercises.sort((a, b) => ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
        break;
      case ExerciseSortBy.createdAt:
        exercises.sort((a, b) => ascending ? 
            (a.createdAt ?? DateTime.now()).compareTo(b.createdAt ?? DateTime.now()) : 
            (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
        break;
      case ExerciseSortBy.setupTime:
        exercises.sort((a, b) => ascending ? 
            (a.setupTimeSeconds ?? 0).compareTo(b.setupTimeSeconds ?? 0) : 
            (b.setupTimeSeconds ?? 0).compareTo(a.setupTimeSeconds ?? 0));
        break;
    }

    return exercises;
  }

  @override
  Future<List<Exercise>> findByMuscleGroups(List<String> muscleGroups,
      {bool requireAll = false, int? limit}) async {
    final exercises = await getAll(limit: limit);
    return exercises.where((exercise) {
      if (requireAll) {
        return muscleGroups.every((muscle) =>
            exercise.primaryMuscleGroups.contains(muscle) ||
            exercise.secondaryMuscleGroups.contains(muscle));
      } else {
        return muscleGroups.any((muscle) =>
            exercise.primaryMuscleGroups.contains(muscle) ||
            exercise.secondaryMuscleGroups.contains(muscle));
      }
    }).toList();
  }

  @override
  Future<List<Exercise>> findByEquipment(List<String> availableEquipmentIds,
      {bool requireExactMatch = false, int? limit}) async {
    final exercises = await getAll(limit: limit);
    return exercises.where((exercise) {
      if (exercise.equipmentRequired.isEmpty) return true; // Bodyweight exercises
      if (requireExactMatch) {
        return exercise.equipmentRequired.every((eq) => availableEquipmentIds.contains(eq));
      } else {
        return exercise.equipmentRequired.any((eq) => availableEquipmentIds.contains(eq));
      }
    }).toList();
  }

  @override
  Future<List<Exercise>> findSimilarExercises(String exerciseId, {int limit = 10}) async {
    final exercise = await getById(exerciseId);
    if (exercise == null) return [];

    final allExercises = await getAll();
    return allExercises
        .where((e) => e.id != exerciseId)
        .where((e) => e.primaryMuscleGroups.any((muscle) => exercise.primaryMuscleGroups.contains(muscle)))
        .take(limit)
        .toList();
  }

  @override
  Future<List<Exercise>> getProgressions(String exerciseId) async {
    // Not implemented in web demo
    return [];
  }

  @override
  Future<List<Exercise>> getRegressions(String exerciseId) async {
    // Not implemented in web demo
    return [];
  }

  @override
  Future<List<Exercise>> findByCategory(String categoryId, {String? orderBy, int? limit}) async {
    // Simple implementation - return exercises based on type
    final exercises = await getAll(limit: limit);
    return exercises.where((e) {
      // Map category IDs to exercise types/muscle groups
      switch (categoryId) {
        case 'cat_strength':
        case 'cat_upper_body':
        case 'cat_lower_body':
          return e.exerciseType == 'strength';
        case 'cat_cardio':
          return e.exerciseType == 'cardio';
        case 'cat_flexibility':
          return e.exerciseType == 'flexibility';
        default:
          return true;
      }
    }).toList();
  }

  @override
  Future<List<Exercise>> getPopularExercises({int limit = 20, int? daysBack}) async {
    // For web demo, just return first exercises as "popular"
    return await getAll(limit: limit);
  }

  @override
  Future<void> addToCategory(String exerciseId, String categoryId) async {
    // Not implemented in web demo
  }

  @override
  Future<void> removeFromCategory(String exerciseId, String categoryId) async {
    // Not implemented in web demo
  }

  @override
  Future<List<Category>> getExerciseCategories(String exerciseId) async {
    // Simple implementation - return default categories
    final categories = await _webDb.query('categories');
    return categories.map((c) => Category.fromDatabase(c)).toList();
  }

  // Sync-aware repository methods (not implemented in web demo)
  @override
  Future<List<SyncStatus>> getPendingSyncOperations() async => [];

  @override
  Future<void> markSyncCompleted(String syncId, {DateTime? serverTimestamp}) async {}

  @override
  Future<void> markSyncFailed(String syncId, String errorMessage) async {}

  @override
  Future<List<Exercise>> getModifiedSinceLastSync([DateTime? lastSyncTime]) async => [];

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