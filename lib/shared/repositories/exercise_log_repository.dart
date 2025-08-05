import '../../core/database/database_manager.dart';
import '../models/models.dart';
import 'base_repository.dart';
import 'errors/repository_exceptions.dart';

/// Filter options for exercise log queries
class ExerciseLogFilter {
  final List<String>? exerciseIds;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? minRpe;
  final int? maxRpe;
  final double? minWeight;
  final double? maxWeight;
  final int? minReps;
  final int? maxReps;
  final bool? personalRecordsOnly;
  final List<String>? equipmentUsed;

  const ExerciseLogFilter({
    this.exerciseIds,
    this.startDate,
    this.endDate,
    this.minRpe,
    this.maxRpe,
    this.minWeight,
    this.maxWeight,
    this.minReps,
    this.maxReps,
    this.personalRecordsOnly,
    this.equipmentUsed,
  });
}

/// Sorting options for exercise logs
enum ExerciseLogSortBy {
  date,
  weight,
  reps,
  duration,
  rpe,
  exerciseName,
}

/// Repository for managing exercise logs and performance tracking
class ExerciseLogRepository extends BaseRepository<ExerciseLog> {
  ExerciseLogRepository(DatabaseManager databaseManager)
      : super(databaseManager, 'exercise_logs');

  @override
  ExerciseLog fromDatabase(Map<String, dynamic> map) => ExerciseLog.fromDatabase(map);

  @override
  Map<String, dynamic> toDatabase(ExerciseLog model) => model.toDatabase();

  @override
  String getId(ExerciseLog model) => model.id;

  /// Log an exercise performance
  Future<ExerciseLog> logExercise(
    String workoutSessionId,
    String exerciseId, {
    String? workoutExerciseId,
    required int orderIndex,
    int setsCompleted = 1,
    int setsPlanned = 1,
    int? repsCompleted,
    int? repsPlanned,
    double? weightKg,
    int? durationSeconds,
    double? distanceMeters,
    int? restTimeSeconds,
    double? intensityPercentage,
    int? rpe,
    int? formRating,
    List<String>? equipmentUsed,
    String? notes,
  }) async {
    // Check for personal records
    final isPersonalRecord = await _checkPersonalRecord(
      workoutSessionId,
      exerciseId,
      weightKg: weightKg,
      repsCompleted: repsCompleted,
      durationSeconds: durationSeconds,
    );

    // Get previous best values
    final previousBests = await _getPreviousBests(workoutSessionId, exerciseId);

    final exerciseLog = ExerciseLog(
      id: generateId(),
      workoutSessionId: workoutSessionId,
      exerciseId: exerciseId,
      workoutExerciseId: workoutExerciseId,
      orderIndex: orderIndex,
      setsCompleted: setsCompleted,
      setsPlanned: setsPlanned,
      repsCompleted: repsCompleted,
      repsPlanned: repsPlanned,
      weightKg: weightKg,
      durationSeconds: durationSeconds,
      distanceMeters: distanceMeters,
      restTimeSeconds: restTimeSeconds,
      intensityPercentage: intensityPercentage,
      rpe: rpe,
      formRating: formRating,
      equipmentUsed: equipmentUsed ?? [],
      notes: notes,
      isPersonalRecord: isPersonalRecord,
      previousBestWeight: previousBests['weight'],
      previousBestReps: previousBests['reps'],
      previousBestDuration: previousBests['duration'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final createdLog = await create(exerciseLog);

    // Update personal records if needed
    if (isPersonalRecord) {
      await _updatePersonalRecords(createdLog);
    }

    return createdLog;
  }

  /// Get exercise logs with filtering and sorting
  Future<List<ExerciseLog>> searchExerciseLogs(
    String userId, {
    ExerciseLogFilter? filter,
    ExerciseLogSortBy sortBy = ExerciseLogSortBy.date,
    bool ascending = false,
    int? limit,
    int? offset,
  }) async {
    final db = await database;

    try {
      // Build the WHERE clause
      final whereConditions = <String>[];
      final whereArgs = <Object?>[];

      // Join with workout_sessions to filter by user
      whereConditions.add('''
        exercise_logs.workout_session_id IN (
          SELECT id FROM workout_sessions WHERE user_id = ?
        )
      ''');
      whereArgs.add(userId);

      // Apply filters
      if (filter != null) {
        _applyFilter(filter, whereConditions, whereArgs);
      }

      // Build ORDER BY clause
      final orderBy = _buildOrderBy(sortBy, ascending);

      final whereClause = whereConditions.join(' AND ');

      final results = await db.rawQuery('''
        SELECT 
          exercise_logs.*,
          exercises.name as exercise_name,
          exercises.primary_muscle_groups,
          exercises.equipment_required,
          workout_sessions.started_at as session_date
        FROM exercise_logs
        LEFT JOIN exercises ON exercise_logs.exercise_id = exercises.id
        LEFT JOIN workout_sessions ON exercise_logs.workout_session_id = workout_sessions.id
        WHERE $whereClause
        ORDER BY $orderBy
        ${limit != null ? 'LIMIT $limit' : ''}
        ${offset != null ? 'OFFSET $offset' : ''}
      ''', whereArgs);

      return results.map((map) {
        final log = fromDatabase(map);
        
        // Create exercise object if data exists
        Exercise? exercise;
        if (map['exercise_name'] != null) {
          exercise = Exercise(
            id: map['exercise_id'] as String,
            name: map['exercise_name'] as String,
            primaryMuscleGroups: _parseJsonList(map['primary_muscle_groups']),
            equipmentRequired: _parseJsonList(map['equipment_required']),
          );
        }

        return log.copyWith(exercise: exercise);
      }).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to search exercise logs: $e');
    }
  }

  /// Get exercise logs for a specific exercise
  Future<List<ExerciseLog>> getExerciseHistory(
    String userId,
    String exerciseId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    final filter = ExerciseLogFilter(
      exerciseIds: [exerciseId],
      startDate: startDate,
      endDate: endDate,
    );

    return searchExerciseLogs(
      userId,
      filter: filter,
      sortBy: ExerciseLogSortBy.date,
      ascending: false,
      limit: limit,
    );
  }

  /// Get exercise logs for a workout session
  Future<List<ExerciseLog>> getSessionLogs(String workoutSessionId) async {
    final db = await database;

    try {
      final results = await db.rawQuery('''
        SELECT 
          el.*,
          e.name as exercise_name,
          e.primary_muscle_groups,
          e.equipment_required
        FROM exercise_logs el
        LEFT JOIN exercises e ON el.exercise_id = e.id
        WHERE el.workout_session_id = ?
        ORDER BY el.order_index ASC
      ''', [workoutSessionId]);

      return results.map((map) {
        final log = fromDatabase(map);
        
        // Create exercise object if data exists
        Exercise? exercise;
        if (map['exercise_name'] != null) {
          exercise = Exercise(
            id: map['exercise_id'] as String,
            name: map['exercise_name'] as String,
            primaryMuscleGroups: _parseJsonList(map['primary_muscle_groups']),
            equipmentRequired: _parseJsonList(map['equipment_required']),
          );
        }

        return log.copyWith(exercise: exercise);
      }).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to get session logs: $e');
    }
  }

  /// Get personal records for user
  Future<List<ExerciseLog>> getPersonalRecords(
    String userId, {
    String? exerciseId,
    int? limit,
  }) async {
    final conditions = <String>[];
    final args = <Object?>[];

    // Filter by user through workout sessions
    conditions.add('''
      exercise_logs.workout_session_id IN (
        SELECT id FROM workout_sessions WHERE user_id = ?
      )
    ''');
    args.add(userId);

    conditions.add('exercise_logs.is_personal_record = 1');

    if (exerciseId != null) {
      conditions.add('exercise_logs.exercise_id = ?');
      args.add(exerciseId);
    }

    final db = await database;

    try {
      final results = await db.rawQuery('''
        SELECT 
          exercise_logs.*,
          exercises.name as exercise_name,
          exercises.primary_muscle_groups,
          workout_sessions.started_at as session_date
        FROM exercise_logs
        LEFT JOIN exercises ON exercise_logs.exercise_id = exercises.id
        LEFT JOIN workout_sessions ON exercise_logs.workout_session_id = workout_sessions.id
        WHERE ${conditions.join(' AND ')}
        ORDER BY workout_sessions.started_at DESC
        ${limit != null ? 'LIMIT $limit' : ''}
      ''', args);

      return results.map((map) {
        final log = fromDatabase(map);
        
        // Create exercise object if data exists
        Exercise? exercise;
        if (map['exercise_name'] != null) {
          exercise = Exercise(
            id: map['exercise_id'] as String,
            name: map['exercise_name'] as String,
            primaryMuscleGroups: _parseJsonList(map['primary_muscle_groups']),
          );
        }

        return log.copyWith(exercise: exercise);
      }).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to get personal records: $e');
    }
  }

  /// Get exercise progress over time
  Future<List<Map<String, dynamic>>> getExerciseProgress(
    String userId,
    String exerciseId, {
    DateTime? startDate,
    DateTime? endDate,
    String metric = 'weight', // weight, reps, duration, volume
  }) async {
    final db = await database;

    try {
      final conditions = <String>[];
      final args = <Object?>[];

      conditions.add('''
        el.workout_session_id IN (
          SELECT id FROM workout_sessions WHERE user_id = ?
        )
      ''');
      args.add(userId);

      conditions.add('el.exercise_id = ?');
      args.add(exerciseId);

      if (startDate != null) {
        conditions.add('ws.started_at >= ?');
        args.add(startDate.toIso8601String());
      }

      if (endDate != null) {
        conditions.add('ws.started_at <= ?');
        args.add(endDate.toIso8601String());
      }

      String selectClause;
      switch (metric) {
        case 'weight':
          selectClause = 'el.weight_kg as value';
          break;
        case 'reps':
          selectClause = 'el.reps_completed as value';
          break;
        case 'duration':
          selectClause = 'el.duration_seconds as value';
          break;
        case 'volume':
          selectClause = '(el.weight_kg * el.reps_completed * el.sets_completed) as value';
          break;
        default:
          selectClause = 'el.weight_kg as value';
      }

      final results = await db.rawQuery('''
        SELECT 
          DATE(ws.started_at) as date,
          MAX($selectClause) as value,
          AVG(el.rpe) as avg_rpe,
          SUM(el.sets_completed) as total_sets
        FROM exercise_logs el
        INNER JOIN workout_sessions ws ON el.workout_session_id = ws.id
        WHERE ${conditions.join(' AND ')} AND $selectClause IS NOT NULL
        GROUP BY DATE(ws.started_at)
        ORDER BY date ASC
      ''', args);

      return results;
    } catch (e) {
      throw GenericRepositoryException('Failed to get exercise progress: $e');
    }
  }

  /// Get exercise performance statistics
  Future<Map<String, dynamic>> getExerciseStats(
    String userId,
    String exerciseId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;

    try {
      final conditions = <String>[];
      final args = <Object?>[];

      conditions.add('''
        el.workout_session_id IN (
          SELECT id FROM workout_sessions WHERE user_id = ?
        )
      ''');
      args.add(userId);

      conditions.add('el.exercise_id = ?');
      args.add(exerciseId);

      if (startDate != null) {
        conditions.add('ws.started_at >= ?');
        args.add(startDate.toIso8601String());
      }

      if (endDate != null) {
        conditions.add('ws.started_at <= ?');
        args.add(endDate.toIso8601String());
      }

      final results = await db.rawQuery('''
        SELECT 
          COUNT(*) as total_sessions,
          SUM(el.sets_completed) as total_sets,
          SUM(el.reps_completed) as total_reps,
          MAX(el.weight_kg) as max_weight,
          AVG(el.weight_kg) as avg_weight,
          MAX(el.reps_completed) as max_reps,
          AVG(el.reps_completed) as avg_reps,
          MAX(el.duration_seconds) as max_duration,
          AVG(el.duration_seconds) as avg_duration,
          AVG(el.rpe) as avg_rpe,
          AVG(el.form_rating) as avg_form_rating,
          MAX(el.weight_kg * el.reps_completed) as max_volume,
          AVG(el.weight_kg * el.reps_completed) as avg_volume,
          COUNT(CASE WHEN el.is_personal_record = 1 THEN 1 END) as personal_records,
          MIN(ws.started_at) as first_session,
          MAX(ws.started_at) as last_session
        FROM exercise_logs el
        INNER JOIN workout_sessions ws ON el.workout_session_id = ws.id
        WHERE ${conditions.join(' AND ')}
      ''', args);

      if (results.isEmpty) {
        return {
          'total_sessions': 0,
          'total_sets': 0,
          'total_reps': 0,
          'max_weight': null,
          'avg_weight': null,
          'max_reps': null,
          'avg_reps': null,
          'max_duration': null,
          'avg_duration': null,
          'avg_rpe': null,
          'avg_form_rating': null,
          'max_volume': null,
          'avg_volume': null,
          'personal_records': 0,
          'first_session': null,
          'last_session': null,
        };
      }

      return results.first;
    } catch (e) {
      throw GenericRepositoryException('Failed to get exercise stats: $e');
    }
  }

  /// Get workout volume over time
  Future<List<Map<String, dynamic>>> getVolumeOverTime(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    String groupBy = 'week', // day, week, month
  }) async {
    final db = await database;

    try {
      final conditions = <String>[];
      final args = <Object?>[];

      conditions.add('''
        el.workout_session_id IN (
          SELECT id FROM workout_sessions WHERE user_id = ?
        )
      ''');
      args.add(userId);

      if (startDate != null) {
        conditions.add('ws.started_at >= ?');
        args.add(startDate.toIso8601String());
      }

      if (endDate != null) {
        conditions.add('ws.started_at <= ?');
        args.add(endDate.toIso8601String());
      }

      String dateFormat;
      switch (groupBy) {
        case 'day':
          dateFormat = '%Y-%m-%d';
          break;
        case 'week':
          dateFormat = '%Y-%W';
          break;
        case 'month':
          dateFormat = '%Y-%m';
          break;
        default:
          dateFormat = '%Y-%W';
      }

      final results = await db.rawQuery('''
        SELECT 
          strftime('$dateFormat', ws.started_at) as period,
          SUM(el.weight_kg * el.reps_completed * el.sets_completed) as total_volume,
          COUNT(DISTINCT el.workout_session_id) as sessions,
          COUNT(*) as total_exercises,
          SUM(el.sets_completed) as total_sets,
          AVG(el.rpe) as avg_rpe
        FROM exercise_logs el
        INNER JOIN workout_sessions ws ON el.workout_session_id = ws.id
        WHERE ${conditions.join(' AND ')} 
          AND el.weight_kg IS NOT NULL 
          AND el.reps_completed IS NOT NULL
        GROUP BY strftime('$dateFormat', ws.started_at)
        ORDER BY period ASC
      ''', args);

      return results;
    } catch (e) {
      throw GenericRepositoryException('Failed to get volume over time: $e');
    }
  }

  /// Update exercise log
  Future<ExerciseLog> updateExerciseLog(
    String logId, {
    int? setsCompleted,
    int? repsCompleted,
    double? weightKg,
    int? durationSeconds,
    double? distanceMeters,
    int? restTimeSeconds,
    double? intensityPercentage,
    int? rpe,
    int? formRating,
    List<String>? equipmentUsed,
    String? notes,
  }) async {
    final existingLog = await getById(logId);
    if (existingLog == null) {
      throw GenericRepositoryException('Exercise log not found: $logId');
    }

    final updatedLog = existingLog.copyWith(
      setsCompleted: setsCompleted ?? existingLog.setsCompleted,
      repsCompleted: repsCompleted ?? existingLog.repsCompleted,
      weightKg: weightKg ?? existingLog.weightKg,
      durationSeconds: durationSeconds ?? existingLog.durationSeconds,
      distanceMeters: distanceMeters ?? existingLog.distanceMeters,
      restTimeSeconds: restTimeSeconds ?? existingLog.restTimeSeconds,
      intensityPercentage: intensityPercentage ?? existingLog.intensityPercentage,
      rpe: rpe ?? existingLog.rpe,
      formRating: formRating ?? existingLog.formRating,
      equipmentUsed: equipmentUsed ?? existingLog.equipmentUsed,
      notes: notes ?? existingLog.notes,
      updatedAt: DateTime.now(),
    );

    // Check if this creates a new personal record
    final isPersonalRecord = await _checkPersonalRecord(
      updatedLog.workoutSessionId,
      updatedLog.exerciseId,
      weightKg: updatedLog.weightKg,
      repsCompleted: updatedLog.repsCompleted,
      durationSeconds: updatedLog.durationSeconds,
    );

    final finalLog = updatedLog.copyWith(isPersonalRecord: isPersonalRecord);
    
    final result = await update(finalLog);

    // Update personal records if needed
    if (isPersonalRecord) {
      await _updatePersonalRecords(result);
    }

    return result;
  }

  /// Check if performance is a personal record
  Future<bool> _checkPersonalRecord(
    String workoutSessionId,
    String exerciseId, {
    double? weightKg,
    int? repsCompleted,
    int? durationSeconds,
  }) async {
    final db = await database;

    try {
      // Get user ID from workout session
      final sessionResults = await db.query(
        'workout_sessions',
        columns: ['user_id'],
        where: 'id = ?',
        whereArgs: [workoutSessionId],
        limit: 1,
      );

      if (sessionResults.isEmpty) return false;

      final userId = sessionResults.first['user_id'] as String;

      // Check for weight PR
      if (weightKg != null) {
        final weightResults = await db.rawQuery('''
          SELECT MAX(el.weight_kg) as max_weight
          FROM exercise_logs el
          INNER JOIN workout_sessions ws ON el.workout_session_id = ws.id
          WHERE ws.user_id = ? AND el.exercise_id = ? AND el.weight_kg IS NOT NULL
        ''', [userId, exerciseId]);

        if (weightResults.isNotEmpty) {
          final maxWeight = weightResults.first['max_weight'] as double?;
          if (maxWeight == null || weightKg > maxWeight) {
            return true;
          }
        }
      }

      // Check for reps PR (at same or higher weight)
      if (repsCompleted != null && weightKg != null) {
        final repsResults = await db.rawQuery('''
          SELECT MAX(el.reps_completed) as max_reps
          FROM exercise_logs el
          INNER JOIN workout_sessions ws ON el.workout_session_id = ws.id
          WHERE ws.user_id = ? AND el.exercise_id = ? 
            AND el.weight_kg >= ? AND el.reps_completed IS NOT NULL
        ''', [userId, exerciseId, weightKg]);

        if (repsResults.isNotEmpty) {
          final maxReps = repsResults.first['max_reps'] as int?;
          if (maxReps == null || repsCompleted > maxReps) {
            return true;
          }
        }
      }

      // Check for duration PR
      if (durationSeconds != null) {
        final durationResults = await db.rawQuery('''
          SELECT MAX(el.duration_seconds) as max_duration
          FROM exercise_logs el
          INNER JOIN workout_sessions ws ON el.workout_session_id = ws.id
          WHERE ws.user_id = ? AND el.exercise_id = ? AND el.duration_seconds IS NOT NULL
        ''', [userId, exerciseId]);

        if (durationResults.isNotEmpty) {
          final maxDuration = durationResults.first['max_duration'] as int?;
          if (maxDuration == null || durationSeconds > maxDuration) {
            return true;
          }
        }
      }

      return false;
    } catch (e) {
      print('Error checking personal record: $e');
      return false;
    }
  }

  /// Get previous best values for comparison
  Future<Map<String, dynamic>> _getPreviousBests(
    String workoutSessionId,
    String exerciseId,
  ) async {
    final db = await database;

    try {
      // Get user ID from workout session
      final sessionResults = await db.query(
        'workout_sessions',
        columns: ['user_id'],
        where: 'id = ?',
        whereArgs: [workoutSessionId],
        limit: 1,
      );

      if (sessionResults.isEmpty) {
        return {'weight': null, 'reps': null, 'duration': null};
      }

      final userId = sessionResults.first['user_id'] as String;

      final results = await db.rawQuery('''
        SELECT 
          MAX(el.weight_kg) as best_weight,
          MAX(el.reps_completed) as best_reps,
          MAX(el.duration_seconds) as best_duration
        FROM exercise_logs el
        INNER JOIN workout_sessions ws ON el.workout_session_id = ws.id
        WHERE ws.user_id = ? AND el.exercise_id = ?
      ''', [userId, exerciseId]);

      if (results.isEmpty) {
        return {'weight': null, 'reps': null, 'duration': null};
      }

      return {
        'weight': results.first['best_weight'] as double?,
        'reps': results.first['best_reps'] as int?,
        'duration': results.first['best_duration'] as int?,
      };
    } catch (e) {
      return {'weight': null, 'reps': null, 'duration': null};
    }
  }

  /// Update personal records table
  Future<void> _updatePersonalRecords(ExerciseLog log) async {
    final db = await database;

    try {
      // Get user ID from workout session
      final sessionResults = await db.query(
        'workout_sessions',
        columns: ['user_id'],
        where: 'id = ?',
        whereArgs: [log.workoutSessionId],
        limit: 1,
      );

      if (sessionResults.isEmpty) return;

      final userId = sessionResults.first['user_id'] as String;

      // Update weight PR
      if (log.weightKg != null) {
        await db.rawInsert('''
          INSERT OR REPLACE INTO personal_records 
          (id, user_id, exercise_id, record_type, value, unit, achieved_at, 
           workout_session_id, exercise_log_id, created_at)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', [
          generateId(),
          userId,
          log.exerciseId,
          'max_weight',
          log.weightKg,
          'kg',
          DateTime.now().toIso8601String(),
          log.workoutSessionId,
          log.id,
          DateTime.now().toIso8601String(),
        ]);
      }

      // Update reps PR
      if (log.repsCompleted != null) {
        await db.rawInsert('''
          INSERT OR REPLACE INTO personal_records 
          (id, user_id, exercise_id, record_type, value, unit, achieved_at, 
           workout_session_id, exercise_log_id, created_at)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', [
          generateId(),
          userId,
          log.exerciseId,
          'max_reps',
          log.repsCompleted,
          'reps',
          DateTime.now().toIso8601String(),
          log.workoutSessionId,
          log.id,
          DateTime.now().toIso8601String(),
        ]);
      }

      // Update duration PR
      if (log.durationSeconds != null) {
        await db.rawInsert('''
          INSERT OR REPLACE INTO personal_records 
          (id, user_id, exercise_id, record_type, value, unit, achieved_at, 
           workout_session_id, exercise_log_id, created_at)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', [
          generateId(),
          userId,
          log.exerciseId,
          'max_duration',
          log.durationSeconds,
          'seconds',
          DateTime.now().toIso8601String(),
          log.workoutSessionId,
          log.id,
          DateTime.now().toIso8601String(),
        ]);
      }
    } catch (e) {
      print('Error updating personal records: $e');
    }
  }

  /// Helper method to apply filters
  void _applyFilter(
    ExerciseLogFilter filter,
    List<String> whereConditions,
    List<Object?> whereArgs,
  ) {
    if (filter.exerciseIds != null && filter.exerciseIds!.isNotEmpty) {
      whereConditions.add('exercise_logs.exercise_id IN (${filter.exerciseIds!.map((_) => '?').join(', ')})');
      whereArgs.addAll(filter.exerciseIds!);
    }

    if (filter.startDate != null) {
      whereConditions.add('workout_sessions.started_at >= ?');
      whereArgs.add(filter.startDate!.toIso8601String());
    }

    if (filter.endDate != null) {
      whereConditions.add('workout_sessions.started_at <= ?');
      whereArgs.add(filter.endDate!.toIso8601String());
    }

    if (filter.minRpe != null) {
      whereConditions.add('exercise_logs.rpe >= ?');
      whereArgs.add(filter.minRpe);
    }

    if (filter.maxRpe != null) {
      whereConditions.add('exercise_logs.rpe <= ?');
      whereArgs.add(filter.maxRpe);
    }

    if (filter.minWeight != null) {
      whereConditions.add('exercise_logs.weight_kg >= ?');
      whereArgs.add(filter.minWeight);
    }

    if (filter.maxWeight != null) {
      whereConditions.add('exercise_logs.weight_kg <= ?');
      whereArgs.add(filter.maxWeight);
    }

    if (filter.minReps != null) {
      whereConditions.add('exercise_logs.reps_completed >= ?');
      whereArgs.add(filter.minReps);
    }

    if (filter.maxReps != null) {
      whereConditions.add('exercise_logs.reps_completed <= ?');
      whereArgs.add(filter.maxReps);
    }

    if (filter.personalRecordsOnly == true) {
      whereConditions.add('exercise_logs.is_personal_record = 1');
    }

    if (filter.equipmentUsed != null && filter.equipmentUsed!.isNotEmpty) {
      final equipmentConditions = filter.equipmentUsed!
          .map((_) => 'exercise_logs.equipment_used LIKE ?')
          .join(' OR ');
      whereConditions.add('($equipmentConditions)');
      whereArgs.addAll(filter.equipmentUsed!.map((eq) => '%$eq%'));
    }
  }

  /// Helper method to build ORDER BY clause
  String _buildOrderBy(ExerciseLogSortBy sortBy, bool ascending) {
    final direction = ascending ? 'ASC' : 'DESC';

    switch (sortBy) {
      case ExerciseLogSortBy.date:
        return 'workout_sessions.started_at $direction';
      case ExerciseLogSortBy.weight:
        return 'exercise_logs.weight_kg $direction, workout_sessions.started_at DESC';
      case ExerciseLogSortBy.reps:
        return 'exercise_logs.reps_completed $direction, workout_sessions.started_at DESC';
      case ExerciseLogSortBy.duration:
        return 'exercise_logs.duration_seconds $direction, workout_sessions.started_at DESC';
      case ExerciseLogSortBy.rpe:
        return 'exercise_logs.rpe $direction, workout_sessions.started_at DESC';
      case ExerciseLogSortBy.exerciseName:
        return 'exercises.name $direction, workout_sessions.started_at DESC';
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