import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_manager.dart';
import '../../models/models.dart';
import '../interfaces/repository_interfaces.dart';
import '../config/repository_config.dart';
import '../local/local_exercise_repository.dart';
import '../local/local_workout_repository.dart';
import '../local/local_workout_session_repository.dart';
import '../local/local_user_profile_repository.dart';
import '../local/local_equipment_repository.dart';
import '../local/local_exercise_log_repository.dart';
import '../remote/remote_exercise_repository.dart';
import '../remote/remote_workout_repository.dart';
import '../remote/remote_workout_session_repository.dart';
import '../remote/remote_user_profile_repository.dart';
import '../remote/remote_equipment_repository.dart';
import '../remote/remote_exercise_log_repository.dart';
import '../mock/mock_repositories.dart';

/// Core configuration and infrastructure providers

/// Repository configuration provider
final repositoryConfigProvider = FutureProvider<RepositoryConfig>((ref) async {
  return await RepositoryConfig.getInstance();
});

/// Database manager provider
final databaseManagerProvider = Provider<DatabaseManager>((ref) {
  return DatabaseManager();
});

/// Connectivity provider for monitoring network status
final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

/// Current connectivity status
final isConnectedProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return connectivity.when(
    data: (results) => results.isNotEmpty && !results.contains(ConnectivityResult.none),
    loading: () => false,
    error: (_, __) => false,
  );
});

/// Repository strategy provider
final repositoryStrategyProvider = Provider<RepositoryStrategy>((ref) {
  final config = ref.watch(repositoryConfigProvider).value;
  if (config == null) {
    throw Exception('Repository configuration not initialized');
  }
  return RepositoryStrategy(config);
});

/// Repository implementation selector
final repositoryImplementationProvider = FutureProvider<RepositoryImplementation>((ref) async {
  final config = await ref.watch(repositoryConfigProvider.future);
  return await config.getRepositoryImplementation();
});

/// Local Repository Providers

final localExerciseRepositoryProvider = Provider<IExerciseRepository>((ref) {
  final databaseManager = ref.watch(databaseManagerProvider);
  return LocalExerciseRepository(databaseManager);
});

final localWorkoutRepositoryProvider = Provider<IWorkoutRepository>((ref) {
  final databaseManager = ref.watch(databaseManagerProvider);
  return LocalWorkoutRepository(databaseManager);
});

final localWorkoutSessionRepositoryProvider = Provider<IWorkoutSessionRepository>((ref) {
  final databaseManager = ref.watch(databaseManagerProvider);
  return LocalWorkoutSessionRepository(databaseManager);
});

final localUserProfileRepositoryProvider = Provider<IUserProfileRepository>((ref) {
  final databaseManager = ref.watch(databaseManagerProvider);
  return LocalUserProfileRepository(databaseManager);
});

final localEquipmentRepositoryProvider = Provider<IEquipmentRepository>((ref) {
  final databaseManager = ref.watch(databaseManagerProvider);
  return LocalEquipmentRepository(databaseManager);
});

final localExerciseLogRepositoryProvider = Provider<IExerciseLogRepository>((ref) {
  final databaseManager = ref.watch(databaseManagerProvider);
  return LocalExerciseLogRepository(databaseManager);
});

/// Remote Repository Providers (Supabase implementations)

final remoteExerciseRepositoryProvider = Provider<IExerciseRepository>((ref) {
  return RemoteExerciseRepository();
});

final remoteWorkoutRepositoryProvider = Provider<IWorkoutRepository>((ref) {
  return RemoteWorkoutRepository();
});

final remoteWorkoutSessionRepositoryProvider = Provider<IWorkoutSessionRepository>((ref) {
  return RemoteWorkoutSessionRepository();
});

final remoteUserProfileRepositoryProvider = Provider<IUserProfileRepository>((ref) {
  return RemoteUserProfileRepository();
});

final remoteEquipmentRepositoryProvider = Provider<IEquipmentRepository>((ref) {
  return RemoteEquipmentRepository();
});

final remoteExerciseLogRepositoryProvider = Provider<IExerciseLogRepository>((ref) {
  return RemoteExerciseLogRepository();
});

/// Mock Repository Providers (for testing)

final mockExerciseRepositoryProvider = Provider<IExerciseRepository>((ref) {
  return MockExerciseRepository();
});

final mockWorkoutRepositoryProvider = Provider<IWorkoutRepository>((ref) {
  return MockWorkoutRepository();
});

final mockWorkoutSessionRepositoryProvider = Provider<IWorkoutSessionRepository>((ref) {
  return MockWorkoutSessionRepository();
});

final mockUserProfileRepositoryProvider = Provider<IUserProfileRepository>((ref) {
  return MockUserProfileRepository();
});

final mockEquipmentRepositoryProvider = Provider<IEquipmentRepository>((ref) {
  return MockEquipmentRepository();
});

final mockExerciseLogRepositoryProvider = Provider<IExerciseLogRepository>((ref) {
  return MockExerciseLogRepository();
});

/// Dynamic Repository Providers (automatically switch based on configuration)

/// Exercise repository provider that switches based on configuration
final exerciseRepositoryProvider = Provider<IExerciseRepository>((ref) {
  final implementation = ref.watch(repositoryImplementationProvider).value;
  
  switch (implementation) {
    case RepositoryImplementation.local:
      return ref.watch(localExerciseRepositoryProvider);
    case RepositoryImplementation.remote:
      return ref.watch(remoteExerciseRepositoryProvider);
    case RepositoryImplementation.hybrid:
      // For hybrid, we'll use a wrapper that manages both
      return HybridExerciseRepository(
        local: ref.watch(localExerciseRepositoryProvider),
        remote: ref.watch(remoteExerciseRepositoryProvider),
        strategy: ref.watch(repositoryStrategyProvider),
      );
    case RepositoryImplementation.mock:
      return ref.watch(mockExerciseRepositoryProvider);
    case null:
      // Default to local if configuration not loaded
      return ref.watch(localExerciseRepositoryProvider);
  }
});

/// Workout repository provider that switches based on configuration
final workoutRepositoryProvider = Provider<IWorkoutRepository>((ref) {
  final implementation = ref.watch(repositoryImplementationProvider).value;
  
  switch (implementation) {
    case RepositoryImplementation.local:
      return ref.watch(localWorkoutRepositoryProvider);
    case RepositoryImplementation.remote:
      return ref.watch(remoteWorkoutRepositoryProvider);
    case RepositoryImplementation.hybrid:
      return HybridWorkoutRepository(
        local: ref.watch(localWorkoutRepositoryProvider),
        remote: ref.watch(remoteWorkoutRepositoryProvider),
        strategy: ref.watch(repositoryStrategyProvider),
      );
    case RepositoryImplementation.mock:
      return ref.watch(mockWorkoutRepositoryProvider);
    case null:
      return ref.watch(localWorkoutRepositoryProvider);
  }
});

/// Workout session repository provider that switches based on configuration
final workoutSessionRepositoryProvider = Provider<IWorkoutSessionRepository>((ref) {
  final implementation = ref.watch(repositoryImplementationProvider).value;
  
  switch (implementation) {
    case RepositoryImplementation.local:
      return ref.watch(localWorkoutSessionRepositoryProvider);
    case RepositoryImplementation.remote:
      return ref.watch(remoteWorkoutSessionRepositoryProvider);
    case RepositoryImplementation.hybrid:
      return HybridWorkoutSessionRepository(
        local: ref.watch(localWorkoutSessionRepositoryProvider),
        remote: ref.watch(remoteWorkoutSessionRepositoryProvider),
        strategy: ref.watch(repositoryStrategyProvider),
      );
    case RepositoryImplementation.mock:
      return ref.watch(mockWorkoutSessionRepositoryProvider);
    case null:
      return ref.watch(localWorkoutSessionRepositoryProvider);
  }
});

/// User profile repository provider that switches based on configuration
final userProfileRepositoryProvider = Provider<IUserProfileRepository>((ref) {
  final implementation = ref.watch(repositoryImplementationProvider).value;
  
  switch (implementation) {
    case RepositoryImplementation.local:
      return ref.watch(localUserProfileRepositoryProvider);
    case RepositoryImplementation.remote:
      return ref.watch(remoteUserProfileRepositoryProvider);
    case RepositoryImplementation.hybrid:
      return HybridUserProfileRepository(
        local: ref.watch(localUserProfileRepositoryProvider),
        remote: ref.watch(remoteUserProfileRepositoryProvider),
        strategy: ref.watch(repositoryStrategyProvider),
      );
    case RepositoryImplementation.mock:
      return ref.watch(mockUserProfileRepositoryProvider);
    case null:
      return ref.watch(localUserProfileRepositoryProvider);
  }
});

/// Equipment repository provider that switches based on configuration
final equipmentRepositoryProvider = Provider<IEquipmentRepository>((ref) {
  final implementation = ref.watch(repositoryImplementationProvider).value;
  
  switch (implementation) {
    case RepositoryImplementation.local:
      return ref.watch(localEquipmentRepositoryProvider);
    case RepositoryImplementation.remote:
      return ref.watch(remoteEquipmentRepositoryProvider);
    case RepositoryImplementation.hybrid:
      return HybridEquipmentRepository(
        local: ref.watch(localEquipmentRepositoryProvider),
        remote: ref.watch(remoteEquipmentRepositoryProvider),
        strategy: ref.watch(repositoryStrategyProvider),
      );
    case RepositoryImplementation.mock:
      return ref.watch(mockEquipmentRepositoryProvider);
    case null:
      return ref.watch(localEquipmentRepositoryProvider);
  }
});

/// Exercise log repository provider that switches based on configuration
final exerciseLogRepositoryProvider = Provider<IExerciseLogRepository>((ref) {
  final implementation = ref.watch(repositoryImplementationProvider).value;
  
  switch (implementation) {
    case RepositoryImplementation.local:
      return ref.watch(localExerciseLogRepositoryProvider);
    case RepositoryImplementation.remote:
      return ref.watch(remoteExerciseLogRepositoryProvider);
    case RepositoryImplementation.hybrid:
      return HybridExerciseLogRepository(
        local: ref.watch(localExerciseLogRepositoryProvider),
        remote: ref.watch(remoteExerciseLogRepositoryProvider),
        strategy: ref.watch(repositoryStrategyProvider),
      );
    case RepositoryImplementation.mock:
      return ref.watch(mockExerciseLogRepositoryProvider);
    case null:
      return ref.watch(localExerciseLogRepositoryProvider);
  }
});

/// Sync Status Providers

/// Sync status provider for monitoring synchronization state
final syncStatusProvider = StreamProvider<SyncStatus>((ref) async* {
  // This would monitor sync operations across all repositories
  // Implementation would depend on the sync service architecture
  yield SyncStatus(
    id: 'initial',
    tableName: 'sync_monitor',
    recordId: 'system',
    operation: 'monitor',
    localTimestamp: DateTime.now(),
    syncStatus: 'idle',
  );
});

/// Pending sync operations count
final pendingSyncCountProvider = FutureProvider<int>((ref) async {
  // Count pending sync operations across all repositories
  var totalPending = 0;
  
  final repos = [
    ref.watch(exerciseRepositoryProvider),
    ref.watch(workoutRepositoryProvider),
    ref.watch(workoutSessionRepositoryProvider),
    ref.watch(userProfileRepositoryProvider),
    ref.watch(equipmentRepositoryProvider),
    ref.watch(exerciseLogRepositoryProvider),
  ];
  
  for (final repo in repos) {
    if (repo is ISyncAwareRepository) {
      final pending = await repo.getPendingSyncOperations();
      totalPending += pending.length;
    }
  }
  
  return totalPending;
});

/// Sync conflicts count
final syncConflictsCountProvider = FutureProvider<int>((ref) async {
  var totalConflicts = 0;
  
  final repos = [
    ref.watch(exerciseRepositoryProvider),
    ref.watch(workoutRepositoryProvider),
    ref.watch(workoutSessionRepositoryProvider),
    ref.watch(userProfileRepositoryProvider),
    ref.watch(equipmentRepositoryProvider),
    ref.watch(exerciseLogRepositoryProvider),
  ];
  
  for (final repo in repos) {
    if (repo is ISyncAwareRepository) {
      final conflicts = await repo.getSyncConflicts();
      totalConflicts += conflicts.length;
    }
  }
  
  return totalConflicts;
});

/// Utility Providers

/// Repository health check
final repositoryHealthProvider = FutureProvider<Map<String, bool>>((ref) async {
  final health = <String, bool>{};
  
  try {
    // Test each repository's basic functionality
    final exerciseRepo = ref.watch(exerciseRepositoryProvider);
    health['exercise'] = await _testRepositoryHealth(exerciseRepo);
    
    final workoutRepo = ref.watch(workoutRepositoryProvider);
    health['workout'] = await _testRepositoryHealth(workoutRepo);
    
    final sessionRepo = ref.watch(workoutSessionRepositoryProvider);
    health['workout_session'] = await _testRepositoryHealth(sessionRepo);
    
    final profileRepo = ref.watch(userProfileRepositoryProvider);
    health['user_profile'] = await _testRepositoryHealth(profileRepo);
    
    final equipmentRepo = ref.watch(equipmentRepositoryProvider);
    health['equipment'] = await _testRepositoryHealth(equipmentRepo);
    
    final logRepo = ref.watch(exerciseLogRepositoryProvider);
    health['exercise_log'] = await _testRepositoryHealth(logRepo);
  } catch (e) {
    // If any repository fails, mark all as unhealthy
    health.updateAll((key, value) => false);
  }
  
  return health;
});

/// Test repository health by attempting a basic operation
Future<bool> _testRepositoryHealth<T>(IBaseRepository<T> repository) async {
  try {
    // Simple count operation to test database connectivity
    await repository.count();
    return true;
  } catch (e) {
    return false;
  }
}

/// Override providers for testing
final testOverridesProvider = Provider<List<Override>>((ref) {
  // This can be used to provide test overrides
  return const [];
});

/// Hybrid Repository Implementations
/// These classes manage both local and remote repositories based on strategy

abstract class HybridRepository<T> implements ISyncAwareRepository<T> {
  final ISyncAwareRepository<T> local;
  final ISyncAwareRepository<T> remote;
  final RepositoryStrategy strategy;

  const HybridRepository({
    required this.local,
    required this.remote,
    required this.strategy,
  });

  @override
  Future<T> create(T model) async {
    // Always create locally first for immediate response
    final result = await local.create(model);
    
    // Trigger sync if strategy requires it
    if (await strategy.shouldTriggerImmediateSync()) {
      _scheduleSyncOperation(() => remote.create(model));
    }
    
    return result;
  }

  @override
  Future<T?> getById(String id) async {
    final readStrategy = await strategy.getReadStrategy();
    
    if (readStrategy == RepositoryImplementation.remote) {
      try {
        final result = await remote.getById(id);
        // Cache locally if strategy requires it
        if (await strategy.shouldCacheLocally() && result != null) {
          await local.create(result);
        }
        return result;
      } catch (e) {
        // Fallback to local
        return await local.getById(id);
      }
    } else {
      return await local.getById(id);
    }
  }

  @override
  Future<T> update(T model) async {
    // Always update locally first
    final result = await local.update(model);
    
    // Trigger sync if strategy requires it
    if (await strategy.shouldTriggerImmediateSync()) {
      _scheduleSyncOperation(() => remote.update(model));
    }
    
    return result;
  }

  @override
  Future<void> delete(String id) async {
    await local.delete(id);
    
    if (await strategy.shouldTriggerImmediateSync()) {
      _scheduleSyncOperation(() => remote.delete(id));
    }
  }

  // Delegate sync operations to local repository
  @override
  Future<List<SyncStatus>> getPendingSyncOperations() => local.getPendingSyncOperations();
  
  @override
  Future<void> markSyncCompleted(String syncId, {DateTime? serverTimestamp}) =>
      local.markSyncCompleted(syncId, serverTimestamp: serverTimestamp);
  
  @override
  Future<void> markSyncFailed(String syncId, String errorMessage) =>
      local.markSyncFailed(syncId, errorMessage);
  
  @override
  Future<List<T>> getModifiedSinceLastSync([DateTime? lastSyncTime]) =>
      local.getModifiedSinceLastSync(lastSyncTime);
  
  @override
  Future<void> handleSyncConflict(SyncConflict conflict, String resolutionStrategy) =>
      local.handleSyncConflict(conflict, resolutionStrategy);
  
  @override
  Future<List<SyncConflict>> getSyncConflicts() => local.getSyncConflicts();
  
  @override
  Future<void> forceSyncRecord(String recordId) => local.forceSyncRecord(recordId);
  
  @override
  Future<DateTime?> getLastSyncTimestamp() => local.getLastSyncTimestamp();
  
  @override
  Future<void> updateLastSyncTimestamp(DateTime timestamp) =>
      local.updateLastSyncTimestamp(timestamp);

  // Delegate other base operations to local (with potential remote sync)
  @override
  Future<List<T>> createBatch(List<T> models) => local.createBatch(models);
  
  @override
  Future<List<T>> getAll({String? orderBy, int? limit, int? offset}) =>
      local.getAll(orderBy: orderBy, limit: limit, offset: offset);
  
  @override
  Future<void> deleteBatch(List<String> ids) => local.deleteBatch(ids);
  
  @override
  Future<bool> exists(String id) => local.exists(id);
  
  @override
  Future<int> count([String? where, List<Object?>? whereArgs]) =>
      local.count(where, whereArgs);
  
  @override
  Future<List<T>> findWhere(String where, List<Object?> whereArgs,
          {String? orderBy, int? limit, int? offset}) =>
      local.findWhere(where, whereArgs, orderBy: orderBy, limit: limit, offset: offset);
  
  @override
  Future<List<T>> search(String query, List<String> searchFields,
          {String? additionalWhere, List<Object?>? additionalWhereArgs, String? orderBy, int? limit}) =>
      local.search(query, searchFields,
          additionalWhere: additionalWhere,
          additionalWhereArgs: additionalWhereArgs,
          orderBy: orderBy,
          limit: limit);
  
  @override
  Future<R> transaction<R>(Future<R> Function(Transaction txn) action) => local.transaction(action);

  /// Schedule sync operation (can be queued for background processing)
  void _scheduleSyncOperation(Future<void> Function() operation) {
    // This could add to a queue for background processing
    // For now, we'll execute immediately but catch errors
    operation().catchError((error) {
      // Log sync error but don't fail the main operation
      print('Sync operation failed: $error');
    });
  }
}

/// Specific hybrid implementations for each repository type
class HybridExerciseRepository extends HybridRepository<Exercise> implements IExerciseRepository {
  const HybridExerciseRepository({
    required super.local,
    required super.remote,
    required super.strategy,
  });

  // Delegate specific exercise operations to local repository
  @override
  Future<List<Exercise>> searchExercises(String? query, {ExerciseFilter? filter, ExerciseSortBy sortBy = ExerciseSortBy.name, bool ascending = true, int? limit, int? offset}) =>
      (local as IExerciseRepository).searchExercises(query, filter: filter, sortBy: sortBy, ascending: ascending, limit: limit, offset: offset);

  @override
  Future<List<Exercise>> findByMuscleGroups(List<String> muscleGroups, {bool requireAll = false, int? limit}) =>
      (local as IExerciseRepository).findByMuscleGroups(muscleGroups, requireAll: requireAll, limit: limit);

  @override
  Future<List<Exercise>> findByEquipment(List<String> availableEquipmentIds, {bool requireExactMatch = false, int? limit}) =>
      (local as IExerciseRepository).findByEquipment(availableEquipmentIds, requireExactMatch: requireExactMatch, limit: limit);

  @override
  Future<List<Exercise>> findSimilarExercises(String exerciseId, {int limit = 10}) =>
      (local as IExerciseRepository).findSimilarExercises(exerciseId, limit: limit);

  @override
  Future<List<Exercise>> getProgressions(String exerciseId) =>
      (local as IExerciseRepository).getProgressions(exerciseId);

  @override
  Future<List<Exercise>> getRegressions(String exerciseId) =>
      (local as IExerciseRepository).getRegressions(exerciseId);

  @override
  Future<List<Exercise>> findByCategory(String categoryId, {String? orderBy, int? limit}) =>
      (local as IExerciseRepository).findByCategory(categoryId, orderBy: orderBy, limit: limit);

  @override
  Future<List<Exercise>> getPopularExercises({int limit = 20, int? daysBack}) =>
      (local as IExerciseRepository).getPopularExercises(limit: limit, daysBack: daysBack);

  @override
  Future<void> addToCategory(String exerciseId, String categoryId) =>
      (local as IExerciseRepository).addToCategory(exerciseId, categoryId);

  @override
  Future<void> removeFromCategory(String exerciseId, String categoryId) =>
      (local as IExerciseRepository).removeFromCategory(exerciseId, categoryId);

  @override
  Future<List<Category>> getExerciseCategories(String exerciseId) =>
      (local as IExerciseRepository).getExerciseCategories(exerciseId);
}

// Similar hybrid implementations would be created for other repository types
class HybridWorkoutRepository extends HybridRepository<Workout> implements IWorkoutRepository {
  const HybridWorkoutRepository({
    required super.local,
    required super.remote,
    required super.strategy,
  });

  // Implement IWorkoutRepository methods by delegating to local
  @override
  Future<List<Workout>> findByUser(String userId, {int? limit, int? offset}) =>
      (local as IWorkoutRepository).findByUser(userId, limit: limit, offset: offset);

  @override
  Future<List<Workout>> findPublicWorkouts({String? query, List<String>? tags, String? difficultyLevel, int? maxDuration, int? limit, int? offset}) =>
      (local as IWorkoutRepository).findPublicWorkouts(query: query, tags: tags, difficultyLevel: difficultyLevel, maxDuration: maxDuration, limit: limit, offset: offset);

  @override
  Future<List<Workout>> getTemplates({String? category, int? limit}) =>
      (local as IWorkoutRepository).getTemplates(category: category, limit: limit);

  @override
  Future<Workout> cloneWorkout(String workoutId, String newName) =>
      (local as IWorkoutRepository).cloneWorkout(workoutId, newName);

  @override
  Future<List<WorkoutExercise>> getWorkoutExercises(String workoutId) =>
      (local as IWorkoutRepository).getWorkoutExercises(workoutId);

  @override
  Future<void> addExerciseToWorkout(String workoutId, String exerciseId, {int? sets, int? reps, double? weight, int? restSeconds, int? order}) =>
      (local as IWorkoutRepository).addExerciseToWorkout(workoutId, exerciseId, sets: sets, reps: reps, weight: weight, restSeconds: restSeconds, order: order);

  @override
  Future<void> removeExerciseFromWorkout(String workoutId, String exerciseId) =>
      (local as IWorkoutRepository).removeExerciseFromWorkout(workoutId, exerciseId);

  @override
  Future<void> updateWorkoutExercise(WorkoutExercise workoutExercise) =>
      (local as IWorkoutRepository).updateWorkoutExercise(workoutExercise);

  @override
  Future<List<Workout>> getRecentWorkouts(String userId, {int limit = 10}) =>
      (local as IWorkoutRepository).getRecentWorkouts(userId, limit: limit);

  @override
  Future<List<Workout>> searchWorkouts(String query, {String? userId, bool? isPublic, List<String>? tags, int? limit}) =>
      (local as IWorkoutRepository).searchWorkouts(query, userId: userId, isPublic: isPublic, tags: tags, limit: limit);
}

class HybridWorkoutSessionRepository extends HybridRepository<WorkoutSession> implements IWorkoutSessionRepository {
  const HybridWorkoutSessionRepository({
    required super.local,
    required super.remote,
    required super.strategy,
  });

  @override
  Future<List<WorkoutSession>> findByUser(String userId, {DateTime? startDate, DateTime? endDate, int? limit, int? offset}) =>
      (local as IWorkoutSessionRepository).findByUser(userId, startDate: startDate, endDate: endDate, limit: limit, offset: offset);

  @override
  Future<List<WorkoutSession>> findByWorkout(String workoutId, {String? userId, int? limit}) =>
      (local as IWorkoutSessionRepository).findByWorkout(workoutId, userId: userId, limit: limit);

  @override
  Future<WorkoutSession?> getActiveSession(String userId) =>
      (local as IWorkoutSessionRepository).getActiveSession(userId);

  @override
  Future<WorkoutSession> startSession(String workoutId, String userId) =>
      (local as IWorkoutSessionRepository).startSession(workoutId, userId);

  @override
  Future<WorkoutSession> completeSession(String sessionId) =>
      (local as IWorkoutSessionRepository).completeSession(sessionId);

  @override
  Future<void> cancelSession(String sessionId) =>
      (local as IWorkoutSessionRepository).cancelSession(sessionId);

  @override
  Future<void> addExerciseLog(String sessionId, ExerciseLog exerciseLog) =>
      (local as IWorkoutSessionRepository).addExerciseLog(sessionId, exerciseLog);

  @override
  Future<void> updateExerciseLog(ExerciseLog exerciseLog) =>
      (local as IWorkoutSessionRepository).updateExerciseLog(exerciseLog);

  @override
  Future<List<ExerciseLog>> getSessionExerciseLogs(String sessionId) =>
      (local as IWorkoutSessionRepository).getSessionExerciseLogs(sessionId);

  @override
  Future<SessionStats> getSessionStats(String sessionId) =>
      (local as IWorkoutSessionRepository).getSessionStats(sessionId);

  @override
  Future<UserWorkoutStats> getUserStats(String userId, {DateTime? startDate, DateTime? endDate}) =>
      (local as IWorkoutSessionRepository).getUserStats(userId, startDate: startDate, endDate: endDate);
}

class HybridUserProfileRepository extends HybridRepository<UserProfile> implements IUserProfileRepository {
  const HybridUserProfileRepository({
    required super.local,
    required super.remote,
    required super.strategy,
  });

  @override
  Future<UserProfile?> getUserProfile(String userId) =>
      (local as IUserProfileRepository).getUserProfile(userId);

  @override
  Future<UserProfile> upsertUserProfile(UserProfile profile) =>
      (local as IUserProfileRepository).upsertUserProfile(profile);

  @override
  Future<void> updatePreferences(String userId, Map<String, dynamic> preferences) =>
      (local as IUserProfileRepository).updatePreferences(userId, preferences);

  @override
  Future<Map<String, dynamic>?> getUserPreferences(String userId) =>
      (local as IUserProfileRepository).getUserPreferences(userId);

  @override
  Future<void> updateGoals(String userId, List<Goal> goals) =>
      (local as IUserProfileRepository).updateGoals(userId, goals);

  @override
  Future<List<Goal>> getUserGoals(String userId) =>
      (local as IUserProfileRepository).getUserGoals(userId);

  @override
  Future<void> addMeasurement(String userId, Measurement measurement) =>
      (local as IUserProfileRepository).addMeasurement(userId, measurement);

  @override
  Future<List<Measurement>> getUserMeasurements(String userId, {String? type, DateTime? startDate, DateTime? endDate}) =>
      (local as IUserProfileRepository).getUserMeasurements(userId, type: type, startDate: startDate, endDate: endDate);

  @override
  Future<Measurement?> getLatestMeasurement(String userId, String type) =>
      (local as IUserProfileRepository).getLatestMeasurement(userId, type);
}

class HybridEquipmentRepository extends HybridRepository<Equipment> implements IEquipmentRepository {
  const HybridEquipmentRepository({
    required super.local,
    required super.remote,
    required super.strategy,
  });

  @override
  Future<List<Equipment>> findByCategory(String category, {int? limit}) =>
      (local as IEquipmentRepository).findByCategory(category, limit: limit);

  @override
  Future<List<Equipment>> searchEquipment(String query, {int? limit}) =>
      (local as IEquipmentRepository).searchEquipment(query, limit: limit);

  @override
  Future<List<Equipment>> findByAvailability(bool isAvailable, {int? limit}) =>
      (local as IEquipmentRepository).findByAvailability(isAvailable, limit: limit);

  @override
  Future<List<Equipment>> getUserEquipment(String userId) =>
      (local as IEquipmentRepository).getUserEquipment(userId);

  @override
  Future<void> addToUser(String userId, String equipmentId) =>
      (local as IEquipmentRepository).addToUser(userId, equipmentId);

  @override
  Future<void> removeFromUser(String userId, String equipmentId) =>
      (local as IEquipmentRepository).removeFromUser(userId, equipmentId);

  @override
  Future<Map<String, int>> getUsageStats({DateTime? startDate, DateTime? endDate}) =>
      (local as IEquipmentRepository).getUsageStats(startDate: startDate, endDate: endDate);
}

class HybridExerciseLogRepository extends HybridRepository<ExerciseLog> implements IExerciseLogRepository {
  const HybridExerciseLogRepository({
    required super.local,
    required super.remote,
    required super.strategy,
  });

  @override
  Future<List<ExerciseLog>> findByUser(String userId, {DateTime? startDate, DateTime? endDate, int? limit}) =>
      (local as IExerciseLogRepository).findByUser(userId, startDate: startDate, endDate: endDate, limit: limit);

  @override
  Future<List<ExerciseLog>> findByExercise(String exerciseId, {String? userId, int? limit}) =>
      (local as IExerciseLogRepository).findByExercise(exerciseId, userId: userId, limit: limit);

  @override
  Future<List<ExerciseLog>> findBySession(String sessionId) =>
      (local as IExerciseLogRepository).findBySession(sessionId);

  @override
  Future<List<PersonalRecord>> getPersonalRecords(String userId, {String? exerciseId, String? recordType}) =>
      (local as IExerciseLogRepository).getPersonalRecords(userId, exerciseId: exerciseId, recordType: recordType);

  @override
  Future<List<ProgressPoint>> getProgressData(String userId, String exerciseId, {DateTime? startDate, DateTime? endDate, String? metric}) =>
      (local as IExerciseLogRepository).getProgressData(userId, exerciseId, startDate: startDate, endDate: endDate, metric: metric);

  @override
  Future<ExerciseStats> getExerciseStats(String userId, String exerciseId, {DateTime? startDate, DateTime? endDate}) =>
      (local as IExerciseLogRepository).getExerciseStats(userId, exerciseId, startDate: startDate, endDate: endDate);

  @override
  Future<List<VolumePoint>> getVolumeData(String userId, {DateTime? startDate, DateTime? endDate, String? groupBy}) =>
      (local as IExerciseLogRepository).getVolumeData(userId, startDate: startDate, endDate: endDate, groupBy: groupBy);
}