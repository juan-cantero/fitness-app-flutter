import '../../../core/database/database_manager.dart';
import '../../models/models.dart';
import '../errors/repository_exceptions.dart' as repo_exceptions;
import '../interfaces/repository_interfaces.dart';
import '../sync/sync_aware_repository.dart';

/// Local SQLite implementation of the Workout repository
class LocalWorkoutRepository extends SyncAwareRepository<Workout> implements IWorkoutRepository {
  LocalWorkoutRepository(DatabaseManager databaseManager)
      : super(databaseManager, 'workouts');

  @override
  Workout fromDatabase(Map<String, dynamic> map) => Workout.fromDatabase(map);

  @override
  Map<String, dynamic> toDatabase(Workout model) => model.toDatabase();

  @override
  String getId(Workout model) => model.id;

  @override
  Future<List<Workout>> findByUser(String userId, {int? limit, int? offset}) async {
    return findWhere(
      'created_by = ?',
      [userId],
      orderBy: 'created_at DESC',
      limit: limit,
      offset: offset,
    );
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
    final whereConditions = ['is_public = 1'];
    final whereArgs = <Object?>[];

    if (query != null && query.trim().isNotEmpty) {
      whereConditions.add('(LOWER(name) LIKE ? OR LOWER(description) LIKE ?)');
      final searchTerm = '%${query.toLowerCase()}%';
      whereArgs.addAll([searchTerm, searchTerm]);
    }

    if (tags != null && tags.isNotEmpty) {
      final tagConditions = tags.map((_) => 'LOWER(tags) LIKE ?').join(' OR ');
      whereConditions.add('($tagConditions)');
      whereArgs.addAll(tags.map((tag) => '%${tag.toLowerCase()}%'));
    }

    if (difficultyLevel != null) {
      whereConditions.add('difficulty_level = ?');
      whereArgs.add(difficultyLevel);
    }

    if (maxDuration != null) {
      whereConditions.add('estimated_duration_minutes <= ?');
      whereArgs.add(maxDuration);
    }

    return findWhere(
      whereConditions.join(' AND '),
      whereArgs,
      orderBy: 'created_at DESC',
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<List<Workout>> getTemplates({String? category, int? limit}) async {
    final whereConditions = ['is_template = 1'];
    final whereArgs = <Object?>[];

    if (category != null) {
      whereConditions.add('category = ?');
      whereArgs.add(category);
    }

    return findWhere(
      whereConditions.join(' AND '),
      whereArgs,
      orderBy: 'name ASC',
      limit: limit,
    );
  }

  @override
  Future<Workout> cloneWorkout(String workoutId, String newName) async {
    final originalWorkout = await getById(workoutId);
    if (originalWorkout == null) {
      throw repo_exceptions.DatabaseException('Workout not found: $workoutId');
    }

    final clonedWorkout = originalWorkout.copyWith(
      id: generateId(),
      name: newName,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Create the cloned workout
    final result = await create(clonedWorkout);

    // Clone the workout exercises
    final exercises = await getWorkoutExercises(workoutId);
    for (final exercise in exercises) {
      await addExerciseToWorkout(
        result.id,
        exercise.exerciseId,
        sets: exercise.sets,
        reps: exercise.reps,
        weight: exercise.weightKg,
        restSeconds: exercise.restTimeSeconds,
        order: exercise.orderIndex,
      );
    }

    return result;
  }

  @override
  Future<List<WorkoutExercise>> getWorkoutExercises(String workoutId) async {
    final db = await database;
    try {
      final results = await db.query(
        'workout_exercises',
        where: 'workout_id = ?',
        whereArgs: [workoutId],
        orderBy: 'order ASC',
      );

      return results.map((map) => WorkoutExercise.fromDatabase(map)).toList();
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to get workout exercises: $e');
    }
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
    final db = await database;
    try {
      // Determine the order if not provided
      int exerciseOrder = order ?? 0;
      if (order == null) {
        final result = await db.query(
          'workout_exercises',
          columns: ['MAX(order) as max_order'],
          where: 'workout_id = ?',
          whereArgs: [workoutId],
        );
        exerciseOrder = (result.first['max_order'] as int? ?? 0) + 1;
      }

      final workoutExercise = WorkoutExercise(
        id: generateId(),
        workoutId: workoutId,
        exerciseId: exerciseId,
        orderIndex: exerciseOrder,
        sets: sets ?? 1,
        reps: reps,
        weightKg: weight,
        restTimeSeconds: restSeconds ?? 60,
        createdAt: DateTime.now(),
      );

      await db.insert('workout_exercises', workoutExercise.toDatabase());
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to add exercise to workout: $e');
    }
  }

  @override
  Future<void> removeExerciseFromWorkout(String workoutId, String exerciseId) async {
    final db = await database;
    try {
      await db.delete(
        'workout_exercises',
        where: 'workout_id = ? AND exercise_id = ?',
        whereArgs: [workoutId, exerciseId],
      );
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to remove exercise from workout: $e');
    }
  }

  @override
  Future<void> updateWorkoutExercise(WorkoutExercise workoutExercise) async {
    final db = await database;
    try {
      await db.update(
        'workout_exercises',
        workoutExercise.toDatabase(),
        where: 'id = ?',
        whereArgs: [workoutExercise.id],
      );
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to update workout exercise: $e');
    }
  }

  @override
  Future<List<Workout>> getRecentWorkouts(String userId, {int limit = 10}) async {
    return findWhere(
      'created_by = ?',
      [userId],
      orderBy: 'updated_at DESC',
      limit: limit,
    );
  }

  @override
  Future<List<Workout>> searchWorkouts(
    String query, {
    String? userId,
    bool? isPublic,
    List<String>? tags,
    int? limit,
  }) async {
    final whereConditions = <String>[];
    final whereArgs = <Object?>[];

    // Text search
    if (query.trim().isNotEmpty) {
      whereConditions.add('(LOWER(name) LIKE ? OR LOWER(description) LIKE ?)');
      final searchTerm = '%${query.toLowerCase()}%';
      whereArgs.addAll([searchTerm, searchTerm]);
    }

    // User filter
    if (userId != null) {
      whereConditions.add('created_by = ?');
      whereArgs.add(userId);
    }

    // Public filter
    if (isPublic != null) {
      whereConditions.add('is_public = ?');
      whereArgs.add(isPublic ? 1 : 0);
    }

    // Tags filter
    if (tags != null && tags.isNotEmpty) {
      final tagConditions = tags.map((_) => 'LOWER(tags) LIKE ?').join(' OR ');
      whereConditions.add('($tagConditions)');
      whereArgs.addAll(tags.map((tag) => '%${tag.toLowerCase()}%'));
    }

    if (whereConditions.isEmpty) {
      return getAll(limit: limit, orderBy: 'name ASC');
    }

    return findWhere(
      whereConditions.join(' AND '),
      whereArgs,
      orderBy: 'name ASC',
      limit: limit,
    );
  }
}