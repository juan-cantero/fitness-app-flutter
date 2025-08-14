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
    return _findWorkoutsWithExercises(
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
    String? query, {
    WorkoutFilter? filter,
    WorkoutSortBy sortBy = WorkoutSortBy.name,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    final whereConditions = <String>[];
    final whereArgs = <Object?>[];

    // Text search
    if (query != null && query.trim().isNotEmpty) {
      whereConditions.add('(LOWER(name) LIKE ? OR LOWER(description) LIKE ?)');
      final searchTerm = '%${query.toLowerCase()}%';
      whereArgs.addAll([searchTerm, searchTerm]);
    }

    // Apply filters
    if (filter != null) {
      if (filter.targetMuscleGroups != null && filter.targetMuscleGroups!.isNotEmpty) {
        final muscleConditions = filter.targetMuscleGroups!.map((_) => 'LOWER(target_muscle_groups) LIKE ?').join(' OR ');
        whereConditions.add('($muscleConditions)');
        whereArgs.addAll(filter.targetMuscleGroups!.map((muscle) => '%${muscle.toLowerCase()}%'));
      }

      if (filter.equipmentNeeded != null && filter.equipmentNeeded!.isNotEmpty) {
        final equipConditions = filter.equipmentNeeded!.map((_) => 'LOWER(equipment_needed) LIKE ?').join(' OR ');
        whereConditions.add('($equipConditions)');
        whereArgs.addAll(filter.equipmentNeeded!.map((equip) => '%${equip.toLowerCase()}%'));
      }

      if (filter.difficultyLevel != null) {
        whereConditions.add('difficulty_level = ?');
        whereArgs.add(filter.difficultyLevel);
      }

      if (filter.workoutType != null) {
        whereConditions.add('workout_type = ?');
        whereArgs.add(filter.workoutType);
      }

      if (filter.intensityLevel != null) {
        whereConditions.add('intensity_level = ?');
        whereArgs.add(filter.intensityLevel);
      }

      if (filter.isTemplate != null) {
        whereConditions.add('is_template = ?');
        whereArgs.add(filter.isTemplate! ? 1 : 0);
      }

      if (filter.isPublic != null) {
        whereConditions.add('is_public = ?');
        whereArgs.add(filter.isPublic! ? 1 : 0);
      }
    }

    // Build order by clause
    String orderByClause;
    switch (sortBy) {
      case WorkoutSortBy.name:
        orderByClause = 'name';
        break;
      case WorkoutSortBy.difficulty:
        orderByClause = 'difficulty_level';
        break;
      case WorkoutSortBy.duration:
        orderByClause = 'estimated_duration_minutes';
        break;
      case WorkoutSortBy.createdAt:
        orderByClause = 'created_at';
        break;
    }
    
    orderByClause += ascending ? ' ASC' : ' DESC';

    if (whereConditions.isEmpty) {
      return getAll(limit: limit, offset: offset, orderBy: orderByClause);
    }

    return findWhere(
      whereConditions.join(' AND '),
      whereArgs,
      orderBy: orderByClause,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<List<Workout>> getPopularWorkouts({int limit = 10}) async {
    // For now, return recent workouts as popular ones
    // In a real implementation, this could be based on usage statistics
    return _findWorkoutsWithExercises(
      'is_public = 1',
      [1],
      orderBy: 'created_at DESC',
      limit: limit,
    );
  }

  @override
  Future<List<Workout>> getAll({
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    try {
      // Get all workout records
      final workoutResults = await db.query(
        'workouts',
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );

      final List<Workout> workouts = [];
      
      // For each workout, load its exercises
      for (final workoutMap in workoutResults) {
        final workoutId = workoutMap['id'] as String;
        
        // Get exercises for this workout
        final exerciseResults = await db.query(
          'workout_exercises',
          where: 'workout_id = ?',
          whereArgs: [workoutId],
          orderBy: 'order_index ASC',
        );

        final List<WorkoutExercise> exercises = [];
        for (final exerciseMap in exerciseResults) {
          final workoutExercise = WorkoutExercise.fromDatabase(exerciseMap);
          
          // Load the associated exercise data
          final exerciseData = await db.query(
            'exercises',
            where: 'id = ?',
            whereArgs: [workoutExercise.exerciseId],
          );
          
          if (exerciseData.isNotEmpty) {
            final exercise = Exercise.fromDatabase(exerciseData.first);
            exercises.add(workoutExercise.copyWith(exercise: exercise));
          } else {
            exercises.add(workoutExercise);
          }
        }

        // Create workout with exercises
        final workout = Workout.fromDatabase(workoutMap);
        workouts.add(workout.copyWith(exercises: exercises));
      }

      return workouts;
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to get all workouts: $e');
    }
  }

  /// Helper method to load workouts with their exercises
  Future<List<Workout>> _findWorkoutsWithExercises(
    String where,
    List<Object?> whereArgs, {
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    try {
      // 1. Get workout records
      final workoutResults = await db.query(
        'workouts',
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );

      final List<Workout> workouts = [];
      
      // 2. For each workout, load its exercises
      for (final workoutMap in workoutResults) {
        final workoutId = workoutMap['id'] as String;
        
        // Get exercises for this workout
        final exerciseResults = await db.query(
          'workout_exercises',
          where: 'workout_id = ?',
          whereArgs: [workoutId],
          orderBy: 'order_index ASC',
        );

        final List<WorkoutExercise> exercises = [];
        for (final exerciseMap in exerciseResults) {
          final workoutExercise = WorkoutExercise.fromDatabase(exerciseMap);
          
          // Load the associated exercise data
          final exerciseData = await db.query(
            'exercises',
            where: 'id = ?',
            whereArgs: [workoutExercise.exerciseId],
          );
          
          if (exerciseData.isNotEmpty) {
            final exercise = Exercise.fromDatabase(exerciseData.first);
            exercises.add(workoutExercise.copyWith(exercise: exercise));
          } else {
            exercises.add(workoutExercise);
          }
        }

        // Create workout with exercises
        final workout = Workout.fromDatabase(workoutMap);
        workouts.add(workout.copyWith(exercises: exercises));
      }

      return workouts;
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to find workouts with exercises: $e');
    }
  }

  @override
  Future<Workout?> getById(String id) async {
    final db = await database;
    try {
      // 1. Get the main workout record
      final workoutResults = await db.query(
        'workouts',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (workoutResults.isEmpty) {
        return null;
      }

      // 2. Get the workout exercises
      final exerciseResults = await db.query(
        'workout_exercises',
        where: 'workout_id = ?',
        whereArgs: [id],
        orderBy: 'order_index ASC',
      );

      // 3. Convert exercises from database
      final List<WorkoutExercise> exercises = [];
      for (final exerciseMap in exerciseResults) {
        final workoutExercise = WorkoutExercise.fromDatabase(exerciseMap);
        
        // Load the associated exercise data if needed
        final exerciseData = await db.query(
          'exercises',
          where: 'id = ?',
          whereArgs: [workoutExercise.exerciseId],
        );
        
        if (exerciseData.isNotEmpty) {
          final exercise = Exercise.fromDatabase(exerciseData.first);
          exercises.add(workoutExercise.copyWith(exercise: exercise));
        } else {
          exercises.add(workoutExercise);
        }
      }

      // 4. Create workout with exercises
      final workout = Workout.fromDatabase(workoutResults.first);
      return workout.copyWith(exercises: exercises);
      
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to get workout by id: $e');
    }
  }

  @override
  Future<Workout> create(Workout model) async {
    final db = await database;
    
    try {
      return await db.transaction<Workout>((txn) async {
        // 1. Insert the main workout record (without exercises)
        final workoutData = model.toDatabase();
        
        await txn.insert('workouts', workoutData);
        
        // 2. Insert the workout exercises separately
        for (int i = 0; i < model.exercises.length; i++) {
          final exercise = model.exercises[i];
          final exerciseData = exercise.toDatabase();
          // Ensure correct order and workout ID
          exerciseData['order_index'] = i;
          exerciseData['workout_id'] = model.id;
          
          await txn.insert('workout_exercises', exerciseData);
        }
        
        return model;
      });
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to create workout: $e');
    }
  }

  @override
  Future<Workout> update(Workout model) async {
    final db = await database;
    
    try {
      return await db.transaction<Workout>((txn) async {
        // 1. Update the main workout record (without exercises to avoid serialization issues)
        final workoutData = model.toDatabase();
        // Remove exercises from the main workout data as they're handled separately
        workoutData.remove('exercises');
        
        final count = await txn.update(
          'workouts',
          workoutData,
          where: 'id = ?',
          whereArgs: [model.id],
        );
        
        if (count == 0) {
          throw repo_exceptions.DatabaseException('Workout with id ${model.id} not found');
        }
        
        // 2. Handle workout exercises separately
        // First, remove all existing exercises for this workout
        await txn.delete(
          'workout_exercises',
          where: 'workout_id = ?',
          whereArgs: [model.id],
        );
        
        // 3. Insert the new/updated exercises
        for (int i = 0; i < model.exercises.length; i++) {
          final exercise = model.exercises[i];
          final exerciseData = exercise.toDatabase();
          // Ensure correct order and workout ID
          exerciseData['order_index'] = i;
          exerciseData['workout_id'] = model.id;
          
          await txn.insert('workout_exercises', exerciseData);
        }
        
        // Note: Sync tracking is handled by the base transaction mechanism
        
        return model;
      });
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to update workout: $e');
    }
  }
}