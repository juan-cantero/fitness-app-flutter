import '../../core/database/database_manager.dart';
import '../models/models.dart';
import 'base_repository.dart';
import 'errors/repository_exceptions.dart';

/// Filter options for workout queries
class WorkoutFilter {
  final List<String>? difficultyLevels;
  final List<String>? workoutTypes;
  final List<String>? targetMuscleGroups;
  final List<String>? equipmentNeeded;
  final List<String>? spaceRequirements;
  final List<String>? intensityLevels;
  final int? maxDurationMinutes;
  final int? minDurationMinutes;
  final bool? isTemplate;
  final bool? isPublic;
  final String? createdBy;
  final List<String>? tags;

  const WorkoutFilter({
    this.difficultyLevels,
    this.workoutTypes,
    this.targetMuscleGroups,
    this.equipmentNeeded,
    this.spaceRequirements,
    this.intensityLevels,
    this.maxDurationMinutes,
    this.minDurationMinutes,
    this.isTemplate,
    this.isPublic,
    this.createdBy,
    this.tags,
  });
}

/// Sorting options for workouts
enum WorkoutSortBy {
  name,
  difficulty,
  duration,
  createdAt,
  popularity,
  rating,
}

/// Repository for managing workouts with exercise relationships and template functionality
class WorkoutRepository extends BaseRepository<Workout> {
  WorkoutRepository(DatabaseManager databaseManager)
      : super(databaseManager, 'workouts');

  @override
  Workout fromDatabase(Map<String, dynamic> map) => Workout.fromDatabase(map);

  @override
  Map<String, dynamic> toDatabase(Workout model) => model.toDatabase();

  @override
  String getId(Workout model) => model.id;

  /// Create workout with exercises in a transaction
  Future<Workout> createWorkoutWithExercises(
    Workout workout,
    List<WorkoutExercise> exercises,
  ) async {
    return transaction((txn) async {
      // Insert workout
      await txn.insert(tableName, toDatabase(workout));

      // Insert workout exercises
      for (final exercise in exercises) {
        await txn.insert('workout_exercises', exercise.toDatabase());
      }

      return workout.copyWith(exercises: exercises);
    });
  }

  /// Update workout with exercises
  Future<Workout> updateWorkoutWithExercises(
    Workout workout,
    List<WorkoutExercise> exercises,
  ) async {
    return transaction((txn) async {
      // Update workout
      await txn.update(
        tableName,
        toDatabase(workout),
        where: 'id = ?',
        whereArgs: [workout.id],
      );

      // Delete existing workout exercises
      await txn.delete(
        'workout_exercises',
        where: 'workout_id = ?',
        whereArgs: [workout.id],
      );

      // Insert new workout exercises
      for (final exercise in exercises) {
        await txn.insert('workout_exercises', exercise.toDatabase());
      }

      return workout.copyWith(exercises: exercises);
    });
  }

  /// Get workout with exercises
  Future<Workout?> getWorkoutWithExercises(String workoutId) async {
    final workout = await getById(workoutId);
    if (workout == null) return null;

    final exercises = await getWorkoutExercises(workoutId);
    return workout.copyWith(exercises: exercises);
  }

  /// Get workout exercises with exercise details
  Future<List<WorkoutExercise>> getWorkoutExercises(String workoutId) async {
    final db = await database;

    try {
      final results = await db.rawQuery('''
        SELECT 
          we.*,
          e.name as exercise_name,
          e.description as exercise_description,
          e.primary_muscle_groups,
          e.equipment_required,
          e.difficulty_level as exercise_difficulty,
          e.exercise_type,
          e.image_url as exercise_image_url
        FROM workout_exercises we
        LEFT JOIN exercises e ON we.exercise_id = e.id
        WHERE we.workout_id = ?
        ORDER BY we.order_index ASC
      ''', [workoutId]);

      return results.map((map) {
        final workoutExercise = WorkoutExercise.fromDatabase(map);
        
        // Create exercise object if exercise data exists
        Exercise? exercise;
        if (map['exercise_name'] != null) {
          exercise = Exercise(
            id: map['exercise_id'] as String,
            name: map['exercise_name'] as String,
            description: map['exercise_description'] as String?,
            primaryMuscleGroups: _parseJsonList(map['primary_muscle_groups']),
            equipmentRequired: _parseJsonList(map['equipment_required']),
            difficultyLevel: map['exercise_difficulty'] as String? ?? 'beginner',
            exerciseType: map['exercise_type'] as String? ?? 'strength',
            imageUrl: map['exercise_image_url'] as String?,
          );
        }

        return workoutExercise.copyWith(exercise: exercise);
      }).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to get workout exercises: $e');
    }
  }

  /// Search workouts with comprehensive filtering
  Future<List<Workout>> searchWorkouts(
    String? query, {
    WorkoutFilter? filter,
    WorkoutSortBy sortBy = WorkoutSortBy.name,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    final db = await database;

    try {
      // Build the WHERE clause
      final whereConditions = <String>[];
      final whereArgs = <Object?>[];

      // Text search
      if (query != null && query.trim().isNotEmpty) {
        whereConditions.add('''
          (LOWER(name) LIKE ? OR 
           LOWER(description) LIKE ? OR 
           LOWER(target_muscle_groups) LIKE ? OR 
           LOWER(tags) LIKE ?)
        ''');
        final searchTerm = '%${query.toLowerCase()}%';
        whereArgs.addAll([searchTerm, searchTerm, searchTerm, searchTerm]);
      }

      // Apply filters
      if (filter != null) {
        _applyFilter(filter, whereConditions, whereArgs);
      }

      // Build ORDER BY clause
      final orderBy = _buildOrderBy(sortBy, ascending);

      final whereClause = whereConditions.isEmpty 
          ? null 
          : whereConditions.join(' AND ');

      final results = await db.query(
        tableName,
        where: whereClause,
        whereArgs: whereArgs.isEmpty ? null : whereArgs,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );

      return results.map((map) => fromDatabase(map)).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to search workouts: $e');
    }
  }

  /// Get workout templates
  Future<List<Workout>> getTemplates({
    String? category,
    String? difficultyLevel,
    int? maxDuration,
    int? limit,
  }) async {
    final conditions = ['is_template = 1'];
    final args = <Object?>[];

    if (category != null) {
      conditions.add('template_category = ?');
      args.add(category);
    }

    if (difficultyLevel != null) {
      conditions.add('difficulty_level = ?');
      args.add(difficultyLevel);
    }

    if (maxDuration != null) {
      conditions.add('estimated_duration_minutes <= ?');
      args.add(maxDuration);
    }

    return findWhere(
      conditions.join(' AND '),
      args,
      orderBy: 'name ASC',
      limit: limit,
    );
  }

  /// Get workouts by muscle groups
  Future<List<Workout>> getByMuscleGroups(
    List<String> muscleGroups, {
    bool requireAll = false,
    int? limit,
  }) async {
    if (muscleGroups.isEmpty) return [];

    final db = await database;

    try {
      String whereClause;
      List<Object?> whereArgs;

      if (requireAll) {
        // All muscle groups must be targeted
        whereClause = muscleGroups
            .map((_) => 'LOWER(target_muscle_groups) LIKE ?')
            .join(' AND ');
        whereArgs = muscleGroups
            .map((mg) => '%${mg.toLowerCase()}%')
            .toList();
      } else {
        // Any muscle group can be targeted
        whereClause = muscleGroups
            .map((_) => 'LOWER(target_muscle_groups) LIKE ?')
            .join(' OR ');
        whereArgs = muscleGroups
            .map((mg) => '%${mg.toLowerCase()}%')
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
    } catch (e) {
      throw GenericRepositoryException('Failed to get workouts by muscle groups: $e');
    }
  }

  /// Get workouts by equipment availability
  Future<List<Workout>> getByEquipment(
    List<String> availableEquipmentIds, {
    bool exactMatch = false,
    int? limit,
  }) async {
    final db = await database;

    try {
      if (exactMatch) {
        // Find workouts that use only the available equipment
        final results = await db.rawQuery('''
          SELECT * FROM workouts 
          WHERE id NOT IN (
            SELECT DISTINCT w.id 
            FROM workouts w
            WHERE w.equipment_needed != '' 
            AND EXISTS (
              SELECT 1 
              FROM (
                SELECT TRIM(value) as equipment_id 
                FROM json_each('[' || '"' || REPLACE(w.equipment_needed, ',', '","') || '"' || ']')
                WHERE TRIM(value) != ''
              ) 
              WHERE equipment_id NOT IN (${availableEquipmentIds.map((_) => '?').join(',')})
            )
          )
          ORDER BY name ASC
          ${limit != null ? 'LIMIT ?' : ''}
        ''', [
          ...availableEquipmentIds,
          if (limit != null) limit,
        ]);

        return results.map((map) => fromDatabase(map)).toList();
      } else {
        // Find workouts that can be performed with available equipment
        final whereClause = '''
          (equipment_needed = '' OR equipment_needed IS NULL OR ${
            availableEquipmentIds.map((_) => 'LOWER(equipment_needed) LIKE ?').join(' OR ')
          })
        ''';

        final whereArgs = availableEquipmentIds
            .map((id) => '%${id.toLowerCase()}%')
            .toList();

        final results = await db.query(
          tableName,
          where: whereClause,
          whereArgs: whereArgs,
          orderBy: 'name ASC',
          limit: limit,
        );

        return results.map((map) => fromDatabase(map)).toList();
      }
    } catch (e) {
      throw GenericRepositoryException('Failed to get workouts by equipment: $e');
    }
  }

  /// Get popular workouts (based on usage)
  Future<List<Workout>> getPopularWorkouts({
    int limit = 20,
    int? daysBack,
  }) async {
    final db = await database;

    try {
      String dateFilter = '';
      if (daysBack != null) {
        dateFilter = "AND ws.started_at >= datetime('now', '-$daysBack days')";
      }

      final results = await db.rawQuery('''
        SELECT w.*, COUNT(ws.workout_id) as usage_count
        FROM workouts w
        LEFT JOIN workout_sessions ws ON w.id = ws.workout_id
        WHERE 1=1 $dateFilter
        GROUP BY w.id
        ORDER BY usage_count DESC, w.name ASC
        LIMIT ?
      ''', [limit]);

      return results.map((map) => fromDatabase(map)).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to get popular workouts: $e');
    }
  }

  /// Get user's favorite workouts
  Future<List<Workout>> getUserFavorites(String userId) async {
    final db = await database;

    try {
      final results = await db.rawQuery('''
        SELECT w.* FROM workouts w
        INNER JOIN favorites f ON w.id = f.favoritable_id
        WHERE f.user_id = ? AND f.favoritable_type = 'workout'
        ORDER BY f.created_at DESC
      ''', [userId]);

      return results.map((map) => fromDatabase(map)).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to get user favorites: $e');
    }
  }

  /// Get workouts created by user
  Future<List<Workout>> getUserCreated(String userId, {int? limit}) async {
    return findWhere(
      'created_by = ?',
      [userId],
      orderBy: 'created_at DESC',
      limit: limit,
    );
  }

  /// Get workout statistics
  Future<Map<String, dynamic>> getWorkoutStats(String workoutId) async {
    final db = await database;

    try {
      final results = await db.rawQuery('''
        SELECT 
          COUNT(ws.id) as total_sessions,
          AVG(ws.duration_minutes) as avg_duration,
          AVG(ws.workout_rating) as avg_rating,
          AVG(ws.calories_burned) as avg_calories,
          MIN(ws.started_at) as first_session,
          MAX(ws.started_at) as last_session
        FROM workout_sessions ws
        WHERE ws.workout_id = ?
      ''', [workoutId]);

      if (results.isEmpty) {
        return {
          'total_sessions': 0,
          'avg_duration': null,
          'avg_rating': null,
          'avg_calories': null,
          'first_session': null,
          'last_session': null,
        };
      }

      return results.first;
    } catch (e) {
      throw GenericRepositoryException('Failed to get workout stats: $e');
    }
  }

  /// Clone workout as template
  Future<Workout> cloneAsTemplate(
    String workoutId,
    String newName,
    String? templateCategory,
  ) async {
    final workout = await getWorkoutWithExercises(workoutId);
    if (workout == null) {
      throw GenericRepositoryException('Workout not found: $workoutId');
    }

    final newWorkout = workout.copyWith(
      id: generateId(),
      name: newName,
      isTemplate: true,
      templateCategory: templateCategory,
      isPublic: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final newExercises = workout.exercises.map((exercise) => 
      exercise.copyWith(
        id: generateId(),
        workoutId: newWorkout.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      )
    ).toList();

    return createWorkoutWithExercises(newWorkout, newExercises);
  }

  /// Duplicate workout
  Future<Workout> duplicateWorkout(String workoutId, String newName) async {
    final workout = await getWorkoutWithExercises(workoutId);
    if (workout == null) {
      throw GenericRepositoryException('Workout not found: $workoutId');
    }

    final newWorkout = workout.copyWith(
      id: generateId(),
      name: newName,
      isTemplate: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final newExercises = workout.exercises.map((exercise) => 
      exercise.copyWith(
        id: generateId(),
        workoutId: newWorkout.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      )
    ).toList();

    return createWorkoutWithExercises(newWorkout, newExercises);
  }

  /// Helper method to apply filters
  void _applyFilter(
    WorkoutFilter filter,
    List<String> whereConditions,
    List<Object?> whereArgs,
  ) {
    if (filter.difficultyLevels != null && filter.difficultyLevels!.isNotEmpty) {
      whereConditions.add('difficulty_level IN (${filter.difficultyLevels!.map((_) => '?').join(', ')})');
      whereArgs.addAll(filter.difficultyLevels!);
    }

    if (filter.workoutTypes != null && filter.workoutTypes!.isNotEmpty) {
      whereConditions.add('workout_type IN (${filter.workoutTypes!.map((_) => '?').join(', ')})');
      whereArgs.addAll(filter.workoutTypes!);
    }

    if (filter.targetMuscleGroups != null && filter.targetMuscleGroups!.isNotEmpty) {
      final muscleConditions = filter.targetMuscleGroups!
          .map((_) => 'LOWER(target_muscle_groups) LIKE ?')
          .join(' OR ');
      whereConditions.add('($muscleConditions)');
      whereArgs.addAll(filter.targetMuscleGroups!.map((mg) => '%${mg.toLowerCase()}%'));
    }

    if (filter.equipmentNeeded != null && filter.equipmentNeeded!.isNotEmpty) {
      final equipmentConditions = filter.equipmentNeeded!
          .map((_) => 'LOWER(equipment_needed) LIKE ?')
          .join(' OR ');
      whereConditions.add('(equipment_needed = "" OR equipment_needed IS NULL OR ($equipmentConditions))');
      whereArgs.addAll(filter.equipmentNeeded!.map((eq) => '%${eq.toLowerCase()}%'));
    }

    if (filter.spaceRequirements != null && filter.spaceRequirements!.isNotEmpty) {
      whereConditions.add('space_requirement IN (${filter.spaceRequirements!.map((_) => '?').join(', ')})');
      whereArgs.addAll(filter.spaceRequirements!);
    }

    if (filter.intensityLevels != null && filter.intensityLevels!.isNotEmpty) {
      whereConditions.add('intensity_level IN (${filter.intensityLevels!.map((_) => '?').join(', ')})');
      whereArgs.addAll(filter.intensityLevels!);
    }

    if (filter.maxDurationMinutes != null) {
      whereConditions.add('estimated_duration_minutes <= ?');
      whereArgs.add(filter.maxDurationMinutes);
    }

    if (filter.minDurationMinutes != null) {
      whereConditions.add('estimated_duration_minutes >= ?');
      whereArgs.add(filter.minDurationMinutes);
    }

    if (filter.isTemplate != null) {
      whereConditions.add('is_template = ?');
      whereArgs.add(filter.isTemplate! ? 1 : 0);
    }

    if (filter.isPublic != null) {
      whereConditions.add('is_public = ?');
      whereArgs.add(filter.isPublic! ? 1 : 0);
    }

    if (filter.createdBy != null) {
      whereConditions.add('created_by = ?');
      whereArgs.add(filter.createdBy);
    }

    if (filter.tags != null && filter.tags!.isNotEmpty) {
      final tagConditions = filter.tags!
          .map((_) => 'LOWER(tags) LIKE ?')
          .join(' OR ');
      whereConditions.add('($tagConditions)');
      whereArgs.addAll(filter.tags!.map((tag) => '%${tag.toLowerCase()}%'));
    }
  }

  /// Helper method to build ORDER BY clause
  String _buildOrderBy(WorkoutSortBy sortBy, bool ascending) {
    final direction = ascending ? 'ASC' : 'DESC';

    switch (sortBy) {
      case WorkoutSortBy.name:
        return 'name $direction';
      case WorkoutSortBy.difficulty:
        return '''
          CASE difficulty_level 
            WHEN 'beginner' THEN 1 
            WHEN 'intermediate' THEN 2 
            WHEN 'advanced' THEN 3 
            ELSE 0 
          END $direction, name ASC
        ''';
      case WorkoutSortBy.duration:
        return 'estimated_duration_minutes $direction, name ASC';
      case WorkoutSortBy.createdAt:
        return 'created_at $direction';
      case WorkoutSortBy.popularity:
        // This would require a join with workout_sessions, simplified for now
        return 'name $direction';
      case WorkoutSortBy.rating:
        // This would require a join with workout_ratings, simplified for now
        return 'name $direction';
    }
  }

  /// Helper method to parse JSON lists
  static List<String> _parseJsonList(dynamic value) {
    if (value == null) return [];
    if (value is String) {
      if (value.isEmpty) return [];
      return List<String>.from(value.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty));
    }
    if (value is List) return List<String>.from(value);
    return [];
  }
}

/// Repository for managing workout exercises
class WorkoutExerciseRepository extends BaseRepository<WorkoutExercise> {
  WorkoutExerciseRepository(DatabaseManager databaseManager)
      : super(databaseManager, 'workout_exercises');

  @override
  WorkoutExercise fromDatabase(Map<String, dynamic> map) => WorkoutExercise.fromDatabase(map);

  @override
  Map<String, dynamic> toDatabase(WorkoutExercise model) => model.toDatabase();

  @override
  String getId(WorkoutExercise model) => model.id;

  /// Add exercise to workout
  Future<WorkoutExercise> addExerciseToWorkout(
    String workoutId,
    String exerciseId, {
    int? sets,
    int? reps,
    double? weightKg,
    int? durationSeconds,
    double? distanceMeters,
    int? restTimeSeconds,
    String? notes,
  }) async {
    // Get the next order index
    final orderIndex = await getNextOrderIndex(workoutId);

    final workoutExercise = WorkoutExercise(
      id: generateId(),
      workoutId: workoutId,
      exerciseId: exerciseId,
      orderIndex: orderIndex,
      sets: sets ?? 1,
      reps: reps,
      weightKg: weightKg,
      durationSeconds: durationSeconds,
      distanceMeters: distanceMeters,
      restTimeSeconds: restTimeSeconds ?? 60,
      notes: notes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return create(workoutExercise);
  }

  /// Remove exercise from workout
  Future<void> removeExerciseFromWorkout(String workoutId, String exerciseId) async {
    await transaction((txn) async {
      // Get the workout exercise to remove
      final workoutExercises = await txn.query(
        tableName,
        where: 'workout_id = ? AND exercise_id = ?',
        whereArgs: [workoutId, exerciseId],
      );

      if (workoutExercises.isEmpty) return;

      final removedOrderIndex = workoutExercises.first['order_index'] as int;

      // Delete the workout exercise
      await txn.delete(
        tableName,
        where: 'workout_id = ? AND exercise_id = ?',
        whereArgs: [workoutId, exerciseId],
      );

      // Update order indexes of subsequent exercises
      await txn.rawUpdate('''
        UPDATE workout_exercises 
        SET order_index = order_index - 1 
        WHERE workout_id = ? AND order_index > ?
      ''', [workoutId, removedOrderIndex]);
    });
  }

  /// Reorder exercises in workout
  Future<void> reorderExercises(
    String workoutId,
    List<String> exerciseIds,
  ) async {
    await transaction((txn) async {
      for (int i = 0; i < exerciseIds.length; i++) {
        await txn.update(
          tableName,
          {'order_index': i, 'updated_at': DateTime.now().toIso8601String()},
          where: 'workout_id = ? AND exercise_id = ?',
          whereArgs: [workoutId, exerciseIds[i]],
        );
      }
    });
  }

  /// Get next order index for workout
  Future<int> getNextOrderIndex(String workoutId) async {
    final db = await database;

    try {
      final result = await db.rawQuery('''
        SELECT COALESCE(MAX(order_index), -1) + 1 as next_order
        FROM workout_exercises
        WHERE workout_id = ?
      ''', [workoutId]);

      return result.first['next_order'] as int;
    } catch (e) {
      throw GenericRepositoryException('Failed to get next order index: $e');
    }
  }

  /// Get exercises for workout ordered by index
  Future<List<WorkoutExercise>> getWorkoutExercises(String workoutId) async {
    return findWhere(
      'workout_id = ?',
      [workoutId],
      orderBy: 'order_index ASC',
    );
  }
}