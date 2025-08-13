import 'package:sqflite/sqflite.dart';
import '../../../shared/models/models.dart';

/// Base interface for all repository operations
/// This interface defines the common CRUD operations that all repositories must implement
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

  /// Delete multiple records
  Future<void> deleteBatch(List<String> ids);

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

/// Exercise repository interface
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

  /// Get exercise progressions
  Future<List<Exercise>> getProgressions(String exerciseId);

  /// Get exercise regressions
  Future<List<Exercise>> getRegressions(String exerciseId);

  /// Find exercises by category
  Future<List<Exercise>> findByCategory(
    String categoryId, {
    String? orderBy,
    int? limit,
  });

  /// Get popular exercises
  Future<List<Exercise>> getPopularExercises({
    int limit = 20,
    int? daysBack,
  });

  /// Add exercise to category
  Future<void> addToCategory(String exerciseId, String categoryId);

  /// Remove exercise from category
  Future<void> removeFromCategory(String exerciseId, String categoryId);

  /// Get exercise categories
  Future<List<Category>> getExerciseCategories(String exerciseId);
}

/// Workout repository interface
abstract class IWorkoutRepository extends ISyncAwareRepository<Workout> {
  /// Find workouts by user
  Future<List<Workout>> findByUser(String userId, {
    int? limit,
    int? offset,
  });

  /// Find public workouts
  Future<List<Workout>> findPublicWorkouts({
    String? query,
    List<String>? tags,
    String? difficultyLevel,
    int? maxDuration,
    int? limit,
    int? offset,
  });

  /// Get workout templates
  Future<List<Workout>> getTemplates({
    String? category,
    int? limit,
  });

  /// Clone workout
  Future<Workout> cloneWorkout(String workoutId, String newName);

  /// Get workout exercises
  Future<List<WorkoutExercise>> getWorkoutExercises(String workoutId);

  /// Add exercise to workout
  Future<void> addExerciseToWorkout(
    String workoutId,
    String exerciseId, {
    int? sets,
    int? reps,
    double? weight,
    int? restSeconds,
    int? order,
  });

  /// Remove exercise from workout
  Future<void> removeExerciseFromWorkout(String workoutId, String exerciseId);

  /// Update workout exercise
  Future<void> updateWorkoutExercise(WorkoutExercise workoutExercise);

  /// Get recent workouts
  Future<List<Workout>> getRecentWorkouts(String userId, {int limit = 10});

  /// Search workouts with comprehensive filtering
  Future<List<Workout>> searchWorkouts(
    String? query, {
    WorkoutFilter? filter,
    WorkoutSortBy sortBy = WorkoutSortBy.name,
    bool ascending = true,
    int? limit,
    int? offset,
  });

  /// Get popular workouts
  Future<List<Workout>> getPopularWorkouts({int limit = 10});
}

/// Workout Session repository interface
abstract class IWorkoutSessionRepository extends ISyncAwareRepository<WorkoutSession> {
  /// Find sessions by user
  Future<List<WorkoutSession>> findByUser(String userId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  });

  /// Find sessions by workout
  Future<List<WorkoutSession>> findByWorkout(String workoutId, {
    String? userId,
    int? limit,
  });

  /// Get active session for user
  Future<WorkoutSession?> getActiveSession(String userId);

  /// Start workout session
  Future<WorkoutSession> startSession(String workoutId, String userId);

  /// Complete workout session
  Future<WorkoutSession> completeSession(String sessionId);

  /// Cancel workout session
  Future<void> cancelSession(String sessionId);

  /// Add exercise log to session
  Future<void> addExerciseLog(String sessionId, ExerciseLog exerciseLog);

  /// Update exercise log
  Future<void> updateExerciseLog(ExerciseLog exerciseLog);

  /// Get session exercise logs
  Future<List<ExerciseLog>> getSessionExerciseLogs(String sessionId);

  /// Get session statistics
  Future<SessionStats> getSessionStats(String sessionId);

  /// Get user workout statistics
  Future<UserWorkoutStats> getUserStats(String userId, {
    DateTime? startDate,
    DateTime? endDate,
  });
}

/// User Profile repository interface
abstract class IUserProfileRepository extends ISyncAwareRepository<UserProfile> {
  /// Get user profile by user ID
  Future<UserProfile?> getUserProfile(String userId);

  /// Create or update user profile
  Future<UserProfile> upsertUserProfile(UserProfile profile);

  /// Update user preferences
  Future<void> updatePreferences(String userId, Map<String, dynamic> preferences);

  /// Get user preferences
  Future<Map<String, dynamic>?> getUserPreferences(String userId);

  /// Update user goals
  Future<void> updateGoals(String userId, List<Goal> goals);

  /// Get user goals
  Future<List<Goal>> getUserGoals(String userId);

  /// Add user measurement
  Future<void> addMeasurement(String userId, Measurement measurement);

  /// Get user measurements
  Future<List<Measurement>> getUserMeasurements(
    String userId, {
    String? type,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get latest measurement by type
  Future<Measurement?> getLatestMeasurement(String userId, String type);
}

/// Equipment repository interface
abstract class IEquipmentRepository extends ISyncAwareRepository<Equipment> {
  /// Find equipment by category
  Future<List<Equipment>> findByCategory(String category, {int? limit});

  /// Search equipment
  Future<List<Equipment>> searchEquipment(String query, {int? limit});

  /// Get equipment by availability
  Future<List<Equipment>> findByAvailability(bool isAvailable, {int? limit});

  /// Get user's equipment
  Future<List<Equipment>> getUserEquipment(String userId);

  /// Add equipment to user
  Future<void> addToUser(String userId, String equipmentId);

  /// Remove equipment from user
  Future<void> removeFromUser(String userId, String equipmentId);

  /// Get equipment usage statistics
  Future<Map<String, int>> getUsageStats({
    DateTime? startDate,
    DateTime? endDate,
  });
}

/// Exercise Log repository interface
abstract class IExerciseLogRepository extends ISyncAwareRepository<ExerciseLog> {
  /// Find logs by user
  Future<List<ExerciseLog>> findByUser(String userId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  });

  /// Find logs by exercise
  Future<List<ExerciseLog>> findByExercise(String exerciseId, {
    String? userId,
    int? limit,
  });

  /// Find logs by workout session
  Future<List<ExerciseLog>> findBySession(String sessionId);

  /// Get personal records
  Future<List<PersonalRecord>> getPersonalRecords(String userId, {
    String? exerciseId,
    String? recordType,
  });

  /// Get progress data for exercise
  Future<List<ProgressPoint>> getProgressData(
    String userId,
    String exerciseId, {
    DateTime? startDate,
    DateTime? endDate,
    String? metric,
  });

  /// Get exercise statistics
  Future<ExerciseStats> getExerciseStats(
    String userId,
    String exerciseId, {
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get volume data
  Future<List<VolumePoint>> getVolumeData(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    String? groupBy,
  });
}

/// Filter and sorting classes for exercises
class ExerciseFilter {
  final List<String>? muscleGroups;
  final List<String>? equipmentIds;
  final String? difficultyLevel;
  final String? exerciseType;
  final String? movementPattern;
  final bool? isCompound;
  final bool? requiresSpotter;
  final bool? isUnilateral;
  final List<String>? tags;
  final bool? isPublic;
  final String? createdBy;
  final int? maxSetupTime;
  final int? maxCleanupTime;

  const ExerciseFilter({
    this.muscleGroups,
    this.equipmentIds,
    this.difficultyLevel,
    this.exerciseType,
    this.movementPattern,
    this.isCompound,
    this.requiresSpotter,
    this.isUnilateral,
    this.tags,
    this.isPublic,
    this.createdBy,
    this.maxSetupTime,
    this.maxCleanupTime,
  });
}

enum ExerciseSortBy {
  name,
  difficulty,
  createdAt,
  popularity,
  setupTime,
  muscleGroups,
}

/// Statistics and data classes
class SessionStats {
  final String sessionId;
  final int totalExercises;
  final int completedExercises;
  final Duration totalDuration;
  final Duration actualWorkTime;
  final Duration restTime;
  final double totalVolume;
  final int totalSets;
  final int totalReps;

  const SessionStats({
    required this.sessionId,
    required this.totalExercises,
    required this.completedExercises,
    required this.totalDuration,
    required this.actualWorkTime,
    required this.restTime,
    required this.totalVolume,
    required this.totalSets,
    required this.totalReps,
  });
}

class UserWorkoutStats {
  final String userId;
  final int totalSessions;
  final Duration totalTime;
  final double totalVolume;
  final int totalSets;
  final int totalReps;
  final Map<String, int> exerciseFrequency;
  final List<String> favoriteExercises;

  const UserWorkoutStats({
    required this.userId,
    required this.totalSessions,
    required this.totalTime,
    required this.totalVolume,
    required this.totalSets,
    required this.totalReps,
    required this.exerciseFrequency,
    required this.favoriteExercises,
  });
}


class ProgressPoint {
  final DateTime date;
  final double value;
  final String metric;
  final String? notes;

  const ProgressPoint({
    required this.date,
    required this.value,
    required this.metric,
    this.notes,
  });
}

class ExerciseStats {
  final String userId;
  final String exerciseId;
  final int totalSessions;
  final int totalSets;
  final int totalReps;
  final double totalVolume;
  final double maxWeight;
  final double averageWeight;
  final PersonalRecord? bestRecord;
  final DateTime? lastPerformed;

  const ExerciseStats({
    required this.userId,
    required this.exerciseId,
    required this.totalSessions,
    required this.totalSets,
    required this.totalReps,
    required this.totalVolume,
    required this.maxWeight,
    required this.averageWeight,
    this.bestRecord,
    this.lastPerformed,
  });
}

class VolumePoint {
  final DateTime date;
  final double volume;
  final int sets;
  final int reps;
  final String groupBy;

  const VolumePoint({
    required this.date,
    required this.volume,
    required this.sets,
    required this.reps,
    required this.groupBy,
  });
}

class Goal {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String description;
  final double? targetValue;
  final String? unit;
  final DateTime? targetDate;
  final double? currentValue;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;

  const Goal({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.description,
    this.targetValue,
    this.unit,
    this.targetDate,
    this.currentValue,
    required this.isCompleted,
    required this.createdAt,
    this.completedAt,
  });
}

class Measurement {
  final String id;
  final String userId;
  final String type;
  final double value;
  final String unit;
  final DateTime recordedAt;
  final String? notes;

  const Measurement({
    required this.id,
    required this.userId,
    required this.type,
    required this.value,
    required this.unit,
    required this.recordedAt,
    this.notes,
  });
}


