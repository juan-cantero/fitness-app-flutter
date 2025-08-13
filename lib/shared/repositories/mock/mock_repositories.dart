import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../../models/models.dart';
import '../interfaces/repository_interfaces.dart';

/// Mock implementations for testing
/// These provide predictable test data and behavior without requiring a database

class MockExerciseRepository implements IExerciseRepository {
  final List<Exercise> _exercises = [];
  final List<SyncStatus> _syncStatuses = [];
  final List<SyncConflict> _syncConflicts = [];

  MockExerciseRepository() {
    _initializeMockData();
  }

  void _initializeMockData() {
    // Add some mock exercises
    _exercises.addAll([
      Exercise(
        id: 'mock_exercise_1',
        name: 'Push-ups',
        description: 'Basic bodyweight exercise for chest and arms',
        instructions: 'Start in plank position. Lower body to ground. Push back up.',
        primaryMuscleGroups: ['chest', 'triceps'],
        secondaryMuscleGroups: ['shoulders', 'core'],
        equipmentRequired: [],
        difficultyLevel: 'beginner',
        exerciseType: 'strength',
        movementPattern: 'push',
        isCompound: true,
        requiresSpotter: false,
        isUnilateral: false,
        tags: ['bodyweight', 'upper_body'],
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Exercise(
        id: 'mock_exercise_2',
        name: 'Squats',
        description: 'Fundamental lower body exercise',
        instructions: 'Stand with feet shoulder-width apart. Lower hips back and down. Return to standing.',
        primaryMuscleGroups: ['quadriceps', 'glutes'],
        secondaryMuscleGroups: ['hamstrings', 'core'],
        equipmentRequired: [],
        difficultyLevel: 'beginner',
        exerciseType: 'strength',
        movementPattern: 'squat',
        isCompound: true,
        requiresSpotter: false,
        isUnilateral: false,
        tags: ['bodyweight', 'lower_body'],
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
    ]);
  }

  @override
  Future<Exercise> create(Exercise model) async {
    await Future.delayed(const Duration(milliseconds: 100)); // Simulate network delay
    _exercises.add(model);
    return model;
  }

  @override
  Future<List<Exercise>> createBatch(List<Exercise> models) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _exercises.addAll(models);
    return models;
  }

  @override
  Future<Exercise?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return _exercises.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Exercise>> getAll({String? orderBy, int? limit, int? offset}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    var result = List<Exercise>.from(_exercises);
    
    if (orderBy == 'name ASC' || orderBy == null) {
      result.sort((a, b) => a.name.compareTo(b.name));
    } else if (orderBy == 'name DESC') {
      result.sort((a, b) => b.name.compareTo(a.name));
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
  Future<Exercise> update(Exercise model) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _exercises.indexWhere((e) => e.id == model.id);
    if (index == -1) {
      throw Exception('Exercise not found');
    }
    _exercises[index] = model;
    return model;
  }

  @override
  Future<void> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _exercises.removeWhere((e) => e.id == id);
  }

  @override
  Future<void> deleteBatch(List<String> ids) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _exercises.removeWhere((e) => ids.contains(e.id));
  }

  @override
  Future<bool> exists(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _exercises.any((e) => e.id == id);
  }

  @override
  Future<int> count([String? where, List<Object?>? whereArgs]) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _exercises.length;
  }

  @override
  Future<List<Exercise>> findWhere(String where, List<Object?> whereArgs, {String? orderBy, int? limit, int? offset}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Simplified mock implementation
    return getAll(orderBy: orderBy, limit: limit, offset: offset);
  }

  @override
  Future<List<Exercise>> search(String query, List<String> searchFields, {String? additionalWhere, List<Object?>? additionalWhereArgs, String? orderBy, int? limit}) async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (query.isEmpty) return getAll(orderBy: orderBy, limit: limit);
    
    final results = _exercises.where((exercise) {
      return exercise.name.toLowerCase().contains(query.toLowerCase()) ||
             exercise.description?.toLowerCase().contains(query.toLowerCase()) == true ||
             exercise.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
    }).toList();
    
    if (limit != null) {
      return results.take(limit).toList();
    }
    
    return results;
  }

  @override
  Future<R> transaction<R>(Future<R> Function(Transaction txn) action) async {
    // Simple mock transaction - just execute the action
    // For mock implementation, we ignore the transaction parameter
    // since we don't have a real database transaction
    return await action(null as dynamic);
  }

  // Sync-aware methods
  @override
  Future<List<SyncStatus>> getPendingSyncOperations() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _syncStatuses.where((s) => s.syncStatus == 'pending').toList();
  }

  @override
  Future<void> markSyncCompleted(String syncId, {DateTime? serverTimestamp}) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final index = _syncStatuses.indexWhere((s) => s.id == syncId);
    if (index != -1) {
      _syncStatuses[index] = _syncStatuses[index].copyWith(
        syncStatus: 'completed',
        serverTimestamp: serverTimestamp,
      );
    }
  }

  @override
  Future<void> markSyncFailed(String syncId, String errorMessage) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final index = _syncStatuses.indexWhere((s) => s.id == syncId);
    if (index != -1) {
      _syncStatuses[index] = _syncStatuses[index].copyWith(
        syncStatus: 'failed',
        errorMessage: errorMessage,
        retryCount: _syncStatuses[index].retryCount + 1,
      );
    }
  }

  @override
  Future<List<Exercise>> getModifiedSinceLastSync([DateTime? lastSyncTime]) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (lastSyncTime == null) return _exercises;
    
    return _exercises.where((e) => e.updatedAt?.isAfter(lastSyncTime) == true).toList();
  }

  @override
  Future<void> handleSyncConflict(SyncConflict conflict, String resolutionStrategy) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Mock conflict resolution
  }

  @override
  Future<List<SyncConflict>> getSyncConflicts() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return List.from(_syncConflicts);
  }

  @override
  Future<void> forceSyncRecord(String recordId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Mock force sync
  }

  @override
  Future<DateTime?> getLastSyncTimestamp() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return DateTime.now().subtract(const Duration(hours: 1));
  }

  @override
  Future<void> updateLastSyncTimestamp(DateTime timestamp) async {
    await Future.delayed(const Duration(milliseconds: 50));
    // Mock timestamp update
  }

  // Exercise-specific methods
  @override
  Future<List<Exercise>> searchExercises(String? query, {ExerciseFilter? filter, ExerciseSortBy sortBy = ExerciseSortBy.name, bool ascending = true, int? limit, int? offset}) async {
    await Future.delayed(const Duration(milliseconds: 150));
    var results = List<Exercise>.from(_exercises);
    
    if (query != null && query.isNotEmpty) {
      results = results.where((e) => 
        e.name.toLowerCase().contains(query.toLowerCase()) ||
        e.description?.toLowerCase().contains(query.toLowerCase()) == true
      ).toList();
    }
    
    if (filter?.muscleGroups != null) {
      results = results.where((e) => 
        filter!.muscleGroups!.any((mg) => 
          e.primaryMuscleGroups.contains(mg) || e.secondaryMuscleGroups.contains(mg)
        )
      ).toList();
    }
    
    // Apply sorting
    switch (sortBy) {
      case ExerciseSortBy.name:
        results.sort((a, b) => ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
        break;
      case ExerciseSortBy.difficulty:
        results.sort((a, b) => ascending ? a.difficultyLevel.compareTo(b.difficultyLevel) : b.difficultyLevel.compareTo(a.difficultyLevel));
        break;
      case ExerciseSortBy.createdAt:
        results.sort((a, b) {
          final aDate = a.createdAt ?? DateTime.now();
          final bDate = b.createdAt ?? DateTime.now();
          return ascending ? aDate.compareTo(bDate) : bDate.compareTo(aDate);
        });
        break;
      default:
        break;
    }
    
    if (offset != null) results = results.skip(offset).toList();
    if (limit != null) results = results.take(limit).toList();
    
    return results;
  }

  @override
  Future<List<Exercise>> findByMuscleGroups(List<String> muscleGroups, {bool requireAll = false, int? limit}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    var results = _exercises.where((e) {
      if (requireAll) {
        return muscleGroups.every((mg) => 
          e.primaryMuscleGroups.contains(mg) || e.secondaryMuscleGroups.contains(mg)
        );
      } else {
        return muscleGroups.any((mg) => 
          e.primaryMuscleGroups.contains(mg) || e.secondaryMuscleGroups.contains(mg)
        );
      }
    }).toList();
    
    if (limit != null) results = results.take(limit).toList();
    return results;
  }

  @override
  Future<List<Exercise>> findByEquipment(List<String> availableEquipmentIds, {bool requireExactMatch = false, int? limit}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    var results = _exercises.where((e) {
      if (e.equipmentRequired.isEmpty) return true; // No equipment needed
      
      if (requireExactMatch) {
        return e.equipmentRequired.every((eq) => availableEquipmentIds.contains(eq));
      } else {
        return e.equipmentRequired.any((eq) => availableEquipmentIds.contains(eq));
      }
    }).toList();
    
    if (limit != null) results = results.take(limit).toList();
    return results;
  }

  @override
  Future<List<Exercise>> findSimilarExercises(String exerciseId, {int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final exercise = await getById(exerciseId);
    if (exercise == null) return [];
    
    var results = _exercises.where((e) => 
      e.id != exerciseId && 
      (e.primaryMuscleGroups.any((mg) => exercise.primaryMuscleGroups.contains(mg)) ||
       e.exerciseType == exercise.exerciseType)
    ).toList();
    
    return results.take(limit).toList();
  }

  @override
  Future<List<Exercise>> getProgressions(String exerciseId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final exercise = await getById(exerciseId);
    if (exercise == null || exercise.progressions.isEmpty) return [];
    
    return _exercises.where((e) => exercise.progressions.contains(e.id)).toList();
  }

  @override
  Future<List<Exercise>> getRegressions(String exerciseId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final exercise = await getById(exerciseId);
    if (exercise == null || exercise.regressions.isEmpty) return [];
    
    return _exercises.where((e) => exercise.regressions.contains(e.id)).toList();
  }

  @override
  Future<List<Exercise>> findByCategory(String categoryId, {String? orderBy, int? limit}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Mock implementation - return random exercises
    var results = _exercises.take(limit ?? _exercises.length).toList();
    return results;
  }

  @override
  Future<List<Exercise>> getPopularExercises({int limit = 20, int? daysBack}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Mock implementation - return exercises sorted by name (simulating popularity)
    var results = List<Exercise>.from(_exercises);
    results.sort((a, b) => a.name.compareTo(b.name));
    return results.take(limit).toList();
  }

  @override
  Future<void> addToCategory(String exerciseId, String categoryId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    // Mock implementation
  }

  @override
  Future<void> removeFromCategory(String exerciseId, String categoryId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    // Mock implementation
  }

  @override
  Future<List<Category>> getExerciseCategories(String exerciseId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return [
      Category(
        id: 'mock_category_1',
        name: 'Upper Body',
        description: 'Exercises targeting upper body muscles',
        sortOrder: 1,
        isActive: true,
        createdAt: DateTime.now(),
      ),
    ];
  }
}

// Similar mock implementations for other repositories
class MockWorkoutRepository implements IWorkoutRepository {
  final List<Workout> _workouts = [];
  
  // Implement all required methods with mock behavior
  @override
  Future<Workout> create(Workout model) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _workouts.add(model);
    return model;
  }
  
  // ... (implement other methods similarly)
  @override
  Future<List<Workout>> createBatch(List<Workout> models) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<Workout?> getById(String id) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<Workout>> getAll({String? orderBy, int? limit, int? offset}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<Workout> update(Workout model) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<void> delete(String id) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<void> deleteBatch(List<String> ids) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<bool> exists(String id) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<int> count([String? where, List<Object?>? whereArgs]) async {
    return _workouts.length;
  }

  @override
  Future<List<Workout>> findWhere(String where, List<Object?> whereArgs, {String? orderBy, int? limit, int? offset}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<Workout>> search(String query, List<String> searchFields, {String? additionalWhere, List<Object?>? additionalWhereArgs, String? orderBy, int? limit}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<R> transaction<R>(Future<R> Function(Transaction txn) action) async {
    return await action(null as dynamic);
  }

  @override
  Future<List<SyncStatus>> getPendingSyncOperations() async {
    return [];
  }

  @override
  Future<void> markSyncCompleted(String syncId, {DateTime? serverTimestamp}) async {}

  @override
  Future<void> markSyncFailed(String syncId, String errorMessage) async {}

  @override
  Future<List<Workout>> getModifiedSinceLastSync([DateTime? lastSyncTime]) async {
    return _workouts;
  }

  @override
  Future<void> handleSyncConflict(SyncConflict conflict, String resolutionStrategy) async {}

  @override
  Future<List<SyncConflict>> getSyncConflicts() async {
    return [];
  }

  @override
  Future<void> forceSyncRecord(String recordId) async {}

  @override
  Future<DateTime?> getLastSyncTimestamp() async {
    return null;
  }

  @override
  Future<void> updateLastSyncTimestamp(DateTime timestamp) async {}

  @override
  Future<List<Workout>> findByUser(String userId, {int? limit, int? offset}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<Workout>> findPublicWorkouts({String? query, List<String>? tags, String? difficultyLevel, int? maxDuration, int? limit, int? offset}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<Workout>> getTemplates({String? category, int? limit}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<Workout> cloneWorkout(String workoutId, String newName) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<WorkoutExercise>> getWorkoutExercises(String workoutId) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<void> addExerciseToWorkout(String workoutId, String exerciseId, {int? sets, int? reps, double? weight, int? restSeconds, int? order}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<void> removeExerciseFromWorkout(String workoutId, String exerciseId) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<void> updateWorkoutExercise(WorkoutExercise workoutExercise) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<Workout>> getRecentWorkouts(String userId, {int limit = 10}) async {
    throw UnimplementedError('Mock method not fully implemented');
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
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<Workout>> getPopularWorkouts({int limit = 10}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }
}

// Placeholder mock implementations for other repositories
class MockWorkoutSessionRepository implements IWorkoutSessionRepository {
  @override
  Future<WorkoutSession> create(WorkoutSession model) async {
    throw UnimplementedError('Mock implementation not complete');
  }
  
  // ... (other methods would be implemented similarly)
  @override
  Future<List<WorkoutSession>> createBatch(List<WorkoutSession> models) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<WorkoutSession?> getById(String id) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<WorkoutSession>> getAll({String? orderBy, int? limit, int? offset}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<WorkoutSession> update(WorkoutSession model) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<void> delete(String id) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<void> deleteBatch(List<String> ids) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<bool> exists(String id) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<int> count([String? where, List<Object?>? whereArgs]) async {
    return 0;
  }

  @override
  Future<List<WorkoutSession>> findWhere(String where, List<Object?> whereArgs, {String? orderBy, int? limit, int? offset}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<WorkoutSession>> search(String query, List<String> searchFields, {String? additionalWhere, List<Object?>? additionalWhereArgs, String? orderBy, int? limit}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<R> transaction<R>(Future<R> Function(Transaction txn) action) async {
    return await action(null as dynamic);
  }

  @override
  Future<List<SyncStatus>> getPendingSyncOperations() async {
    return [];
  }

  @override
  Future<void> markSyncCompleted(String syncId, {DateTime? serverTimestamp}) async {}

  @override
  Future<void> markSyncFailed(String syncId, String errorMessage) async {}

  @override
  Future<List<WorkoutSession>> getModifiedSinceLastSync([DateTime? lastSyncTime]) async {
    return [];
  }

  @override
  Future<void> handleSyncConflict(SyncConflict conflict, String resolutionStrategy) async {}

  @override
  Future<List<SyncConflict>> getSyncConflicts() async {
    return [];
  }

  @override
  Future<void> forceSyncRecord(String recordId) async {}

  @override
  Future<DateTime?> getLastSyncTimestamp() async {
    return null;
  }

  @override
  Future<void> updateLastSyncTimestamp(DateTime timestamp) async {}

  @override
  Future<List<WorkoutSession>> findByUser(String userId, {DateTime? startDate, DateTime? endDate, int? limit, int? offset}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<WorkoutSession>> findByWorkout(String workoutId, {String? userId, int? limit}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<WorkoutSession?> getActiveSession(String userId) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<WorkoutSession> startSession(String workoutId, String userId) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<WorkoutSession> completeSession(String sessionId) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<void> cancelSession(String sessionId) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<void> addExerciseLog(String sessionId, ExerciseLog exerciseLog) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<void> updateExerciseLog(ExerciseLog exerciseLog) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<ExerciseLog>> getSessionExerciseLogs(String sessionId) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<SessionStats> getSessionStats(String sessionId) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<UserWorkoutStats> getUserStats(String userId, {DateTime? startDate, DateTime? endDate}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }
}

class MockUserProfileRepository implements IUserProfileRepository {
  // Placeholder implementation
  @override
  Future<UserProfile> create(UserProfile model) async {
    throw UnimplementedError('Mock implementation not complete');
  }

  @override
  Future<List<UserProfile>> createBatch(List<UserProfile> models) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<UserProfile?> getById(String id) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<UserProfile>> getAll({String? orderBy, int? limit, int? offset}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<UserProfile> update(UserProfile model) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<void> delete(String id) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<void> deleteBatch(List<String> ids) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<bool> exists(String id) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<int> count([String? where, List<Object?>? whereArgs]) async {
    return 0;
  }

  @override
  Future<List<UserProfile>> findWhere(String where, List<Object?> whereArgs, {String? orderBy, int? limit, int? offset}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<UserProfile>> search(String query, List<String> searchFields, {String? additionalWhere, List<Object?>? additionalWhereArgs, String? orderBy, int? limit}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<R> transaction<R>(Future<R> Function(Transaction txn) action) async {
    return await action(null as dynamic);
  }

  @override
  Future<List<SyncStatus>> getPendingSyncOperations() async {
    return [];
  }

  @override
  Future<void> markSyncCompleted(String syncId, {DateTime? serverTimestamp}) async {}

  @override
  Future<void> markSyncFailed(String syncId, String errorMessage) async {}

  @override
  Future<List<UserProfile>> getModifiedSinceLastSync([DateTime? lastSyncTime]) async {
    return [];
  }

  @override
  Future<void> handleSyncConflict(SyncConflict conflict, String resolutionStrategy) async {}

  @override
  Future<List<SyncConflict>> getSyncConflicts() async {
    return [];
  }

  @override
  Future<void> forceSyncRecord(String recordId) async {}

  @override
  Future<DateTime?> getLastSyncTimestamp() async {
    return null;
  }

  @override
  Future<void> updateLastSyncTimestamp(DateTime timestamp) async {}

  @override
  Future<UserProfile?> getUserProfile(String userId) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<UserProfile> upsertUserProfile(UserProfile profile) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<void> updatePreferences(String userId, Map<String, dynamic> preferences) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<Map<String, dynamic>?> getUserPreferences(String userId) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<void> updateGoals(String userId, List<Goal> goals) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<Goal>> getUserGoals(String userId) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<void> addMeasurement(String userId, Measurement measurement) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<Measurement>> getUserMeasurements(String userId, {String? type, DateTime? startDate, DateTime? endDate}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<Measurement?> getLatestMeasurement(String userId, String type) async {
    throw UnimplementedError('Mock method not fully implemented');
  }
}

class MockEquipmentRepository implements IEquipmentRepository {
  // Placeholder implementation
  @override
  Future<Equipment> create(Equipment model) async {
    throw UnimplementedError('Mock implementation not complete');
  }

  @override
  Future<List<Equipment>> createBatch(List<Equipment> models) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<Equipment?> getById(String id) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<Equipment>> getAll({String? orderBy, int? limit, int? offset}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<Equipment> update(Equipment model) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<void> delete(String id) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<void> deleteBatch(List<String> ids) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<bool> exists(String id) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<int> count([String? where, List<Object?>? whereArgs]) async {
    return 0;
  }

  @override
  Future<List<Equipment>> findWhere(String where, List<Object?> whereArgs, {String? orderBy, int? limit, int? offset}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<Equipment>> search(String query, List<String> searchFields, {String? additionalWhere, List<Object?>? additionalWhereArgs, String? orderBy, int? limit}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<R> transaction<R>(Future<R> Function(Transaction txn) action) async {
    return await action(null as dynamic);
  }

  @override
  Future<List<SyncStatus>> getPendingSyncOperations() async {
    return [];
  }

  @override
  Future<void> markSyncCompleted(String syncId, {DateTime? serverTimestamp}) async {}

  @override
  Future<void> markSyncFailed(String syncId, String errorMessage) async {}

  @override
  Future<List<Equipment>> getModifiedSinceLastSync([DateTime? lastSyncTime]) async {
    return [];
  }

  @override
  Future<void> handleSyncConflict(SyncConflict conflict, String resolutionStrategy) async {}

  @override
  Future<List<SyncConflict>> getSyncConflicts() async {
    return [];
  }

  @override
  Future<void> forceSyncRecord(String recordId) async {}

  @override
  Future<DateTime?> getLastSyncTimestamp() async {
    return null;
  }

  @override
  Future<void> updateLastSyncTimestamp(DateTime timestamp) async {}

  @override
  Future<List<Equipment>> findByCategory(String category, {int? limit}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<Equipment>> searchEquipment(String query, {int? limit}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<Equipment>> findByAvailability(bool isAvailable, {int? limit}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<Equipment>> getUserEquipment(String userId) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<void> addToUser(String userId, String equipmentId) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<void> removeFromUser(String userId, String equipmentId) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<Map<String, int>> getUsageStats({DateTime? startDate, DateTime? endDate}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }
}

class MockExerciseLogRepository implements IExerciseLogRepository {
  // Placeholder implementation
  @override
  Future<ExerciseLog> create(ExerciseLog model) async {
    throw UnimplementedError('Mock implementation not complete');
  }

  @override
  Future<List<ExerciseLog>> createBatch(List<ExerciseLog> models) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<ExerciseLog?> getById(String id) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<ExerciseLog>> getAll({String? orderBy, int? limit, int? offset}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<ExerciseLog> update(ExerciseLog model) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<void> delete(String id) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<void> deleteBatch(List<String> ids) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<bool> exists(String id) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<int> count([String? where, List<Object?>? whereArgs]) async {
    return 0;
  }

  @override
  Future<List<ExerciseLog>> findWhere(String where, List<Object?> whereArgs, {String? orderBy, int? limit, int? offset}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<ExerciseLog>> search(String query, List<String> searchFields, {String? additionalWhere, List<Object?>? additionalWhereArgs, String? orderBy, int? limit}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<R> transaction<R>(Future<R> Function(Transaction txn) action) async {
    return await action(null as dynamic);
  }

  @override
  Future<List<SyncStatus>> getPendingSyncOperations() async {
    return [];
  }

  @override
  Future<void> markSyncCompleted(String syncId, {DateTime? serverTimestamp}) async {}

  @override
  Future<void> markSyncFailed(String syncId, String errorMessage) async {}

  @override
  Future<List<ExerciseLog>> getModifiedSinceLastSync([DateTime? lastSyncTime]) async {
    return [];
  }

  @override
  Future<void> handleSyncConflict(SyncConflict conflict, String resolutionStrategy) async {}

  @override
  Future<List<SyncConflict>> getSyncConflicts() async {
    return [];
  }

  @override
  Future<void> forceSyncRecord(String recordId) async {}

  @override
  Future<DateTime?> getLastSyncTimestamp() async {
    return null;
  }

  @override
  Future<void> updateLastSyncTimestamp(DateTime timestamp) async {}

  @override
  Future<List<ExerciseLog>> findByUser(String userId, {DateTime? startDate, DateTime? endDate, int? limit}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<ExerciseLog>> findByExercise(String exerciseId, {String? userId, int? limit}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<ExerciseLog>> findBySession(String sessionId) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<PersonalRecord>> getPersonalRecords(String userId, {String? exerciseId, String? recordType}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<ProgressPoint>> getProgressData(String userId, String exerciseId, {DateTime? startDate, DateTime? endDate, String? metric}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<ExerciseStats> getExerciseStats(String userId, String exerciseId, {DateTime? startDate, DateTime? endDate}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }

  @override
  Future<List<VolumePoint>> getVolumeData(String userId, {DateTime? startDate, DateTime? endDate, String? groupBy}) async {
    throw UnimplementedError('Mock method not fully implemented');
  }
}