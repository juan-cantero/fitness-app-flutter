import '../../core/database/database_manager.dart';
import '../models/models.dart';
import 'base_repository.dart';
import 'errors/repository_exceptions.dart';

/// Filter options for workout session queries
class WorkoutSessionFilter {
  final List<String>? statuses;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? location;
  final int? minDuration;
  final int? maxDuration;
  final int? minRating;
  final int? maxRating;
  final int? minCalories;
  final int? maxCalories;

  const WorkoutSessionFilter({
    this.statuses,
    this.startDate,
    this.endDate,
    this.location,
    this.minDuration,
    this.maxDuration,
    this.minRating,
    this.maxRating,
    this.minCalories,
    this.maxCalories,
  });
}

/// Sorting options for workout sessions
enum WorkoutSessionSortBy {
  startedAt,
  duration,
  rating,
  caloriesBurned,
  status,
}

/// Repository for managing workout sessions and tracking execution
class WorkoutSessionRepository extends BaseRepository<WorkoutSession> {
  WorkoutSessionRepository(DatabaseManager databaseManager)
      : super(databaseManager, 'workout_sessions');

  @override
  WorkoutSession fromDatabase(Map<String, dynamic> map) => WorkoutSession.fromDatabase(map);

  @override
  Map<String, dynamic> toDatabase(WorkoutSession model) => model.toDatabase();

  @override
  String getId(WorkoutSession model) => model.id;

  /// Start a new workout session
  Future<WorkoutSession> startSession(
    String userId, {
    String? workoutId,
    String? customName,
    String? location,
    String? weatherConditions,
    int? energyLevelStart,
    String? moodBefore,
  }) async {
    final session = WorkoutSession(
      id: generateId(),
      userId: userId,
      workoutId: workoutId,
      name: customName,
      startedAt: DateTime.now(),
      status: 'in_progress',
      location: location,
      weatherConditions: weatherConditions,
      energyLevelStart: energyLevelStart,
      moodBefore: moodBefore,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return create(session);
  }

  /// Complete workout session
  Future<WorkoutSession> completeSession(
    String sessionId, {
    int? energyLevelEnd,
    int? perceivedExertion,
    String? moodAfter,
    int? caloriesBurned,
    int? heartRateAvg,
    int? heartRateMax,
    String? notes,
    int? workoutRating,
  }) async {
    final session = await getById(sessionId);
    if (session == null) {
      throw GenericRepositoryException('Workout session not found: $sessionId');
    }

    final completedAt = DateTime.now();
    final duration = completedAt.difference(session.startedAt).inMinutes;

    final updatedSession = session.copyWith(
      completedAt: completedAt,
      durationMinutes: duration,
      status: 'completed',
      energyLevelEnd: energyLevelEnd ?? session.energyLevelEnd,
      perceivedExertion: perceivedExertion ?? session.perceivedExertion,
      moodAfter: moodAfter ?? session.moodAfter,
      caloriesBurned: caloriesBurned ?? session.caloriesBurned,
      heartRateAvg: heartRateAvg ?? session.heartRateAvg,
      heartRateMax: heartRateMax ?? session.heartRateMax,
      notes: notes ?? session.notes,
      workoutRating: workoutRating ?? session.workoutRating,
      updatedAt: DateTime.now(),
    );

    return update(updatedSession);
  }

  /// Pause workout session
  Future<WorkoutSession> pauseSession(String sessionId) async {
    final session = await getById(sessionId);
    if (session == null) {
      throw GenericRepositoryException('Workout session not found: $sessionId');
    }

    final updatedSession = session.copyWith(
      status: 'paused',
      updatedAt: DateTime.now(),
    );

    return update(updatedSession);
  }

  /// Resume workout session
  Future<WorkoutSession> resumeSession(String sessionId) async {
    final session = await getById(sessionId);
    if (session == null) {
      throw GenericRepositoryException('Workout session not found: $sessionId');
    }

    final updatedSession = session.copyWith(
      status: 'in_progress',
      updatedAt: DateTime.now(),
    );

    return update(updatedSession);
  }

  /// Cancel workout session
  Future<WorkoutSession> cancelSession(String sessionId, String? reason) async {
    final session = await getById(sessionId);
    if (session == null) {
      throw GenericRepositoryException('Workout session not found: $sessionId');
    }

    final updatedSession = session.copyWith(
      status: 'cancelled',
      notes: reason != null ? '${session.notes ?? ''}\nCancelled: $reason' : session.notes,
      updatedAt: DateTime.now(),
    );

    return update(updatedSession);
  }

  /// Get workout session with related data
  Future<WorkoutSession?> getSessionWithDetails(String sessionId) async {
    final session = await getById(sessionId);
    if (session == null) return null;

    final db = await database;

    try {
      // Get workout details if available
      Workout? workout;
      if (session.workoutId != null) {
        final workoutResults = await db.query(
          'workouts',
          where: 'id = ?',
          whereArgs: [session.workoutId],
          limit: 1,
        );

        if (workoutResults.isNotEmpty) {
          workout = Workout.fromDatabase(workoutResults.first);
        }
      }

      // Get exercise logs
      final exerciseLogResults = await db.rawQuery('''
        SELECT 
          el.*,
          e.name as exercise_name,
          e.primary_muscle_groups,
          e.equipment_required
        FROM exercise_logs el
        LEFT JOIN exercises e ON el.exercise_id = e.id
        WHERE el.workout_session_id = ?
        ORDER BY el.order_index ASC
      ''', [sessionId]);

      final exerciseLogs = exerciseLogResults.map((map) {
        final log = ExerciseLog.fromDatabase(map);
        
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

      return session.copyWith(
        workout: workout,
        exerciseLogs: exerciseLogs,
      );
    } catch (e) {
      throw GenericRepositoryException('Failed to get session with details: $e');
    }
  }

  /// Search workout sessions with filtering
  Future<List<WorkoutSession>> searchSessions(
    String userId, {
    String? query,
    WorkoutSessionFilter? filter,
    WorkoutSessionSortBy sortBy = WorkoutSessionSortBy.startedAt,
    bool ascending = false,
    int? limit,
    int? offset,
  }) async {
    final db = await database;

    try {
      // Build the WHERE clause
      final whereConditions = ['user_id = ?'];
      final whereArgs = <Object?>[userId];

      // Text search
      if (query != null && query.trim().isNotEmpty) {
        whereConditions.add('''
          (LOWER(name) LIKE ? OR 
           LOWER(location) LIKE ? OR 
           LOWER(notes) LIKE ?)
        ''');
        final searchTerm = '%${query.toLowerCase()}%';
        whereArgs.addAll([searchTerm, searchTerm, searchTerm]);
      }

      // Apply filters
      if (filter != null) {
        _applyFilter(filter, whereConditions, whereArgs);
      }

      // Build ORDER BY clause
      final orderBy = _buildOrderBy(sortBy, ascending);

      final whereClause = whereConditions.join(' AND ');

      final results = await db.query(
        tableName,
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );

      return results.map((map) => fromDatabase(map)).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to search workout sessions: $e');
    }
  }

  /// Get user's recent sessions
  Future<List<WorkoutSession>> getRecentSessions(
    String userId, {
    int limit = 10,
    int? daysBack,
  }) async {
    final conditions = ['user_id = ?'];
    final args = <Object?>[userId];

    if (daysBack != null) {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysBack));
      conditions.add('started_at >= ?');
      args.add(cutoffDate.toIso8601String());
    }

    return findWhere(
      conditions.join(' AND '),
      args,
      orderBy: 'started_at DESC',
      limit: limit,
    );
  }

  /// Get user's sessions for a specific workout
  Future<List<WorkoutSession>> getWorkoutSessions(
    String userId,
    String workoutId, {
    int? limit,
  }) async {
    return findWhere(
      'user_id = ? AND workout_id = ?',
      [userId, workoutId],
      orderBy: 'started_at DESC',
      limit: limit,
    );
  }

  /// Get user's active session (in_progress or paused)
  Future<WorkoutSession?> getActiveSession(String userId) async {
    final results = await findWhere(
      'user_id = ? AND (status = ? OR status = ?)',
      [userId, 'in_progress', 'paused'],
      orderBy: 'started_at DESC',
      limit: 1,
    );

    return results.isEmpty ? null : results.first;
  }

  /// Get workout session statistics
  Future<Map<String, dynamic>> getUserSessionStats(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;

    try {
      final conditions = ['user_id = ?', 'status = ?'];
      final args = <Object?>[userId, 'completed'];

      if (startDate != null) {
        conditions.add('started_at >= ?');
        args.add(startDate.toIso8601String());
      }

      if (endDate != null) {
        conditions.add('started_at <= ?');
        args.add(endDate.toIso8601String());
      }

      final results = await db.rawQuery('''
        SELECT 
          COUNT(*) as total_sessions,
          AVG(duration_minutes) as avg_duration,
          SUM(duration_minutes) as total_duration,
          AVG(workout_rating) as avg_rating,
          SUM(calories_burned) as total_calories,
          AVG(calories_burned) as avg_calories,
          AVG(perceived_exertion) as avg_rpe,
          AVG(energy_level_start) as avg_energy_start,
          AVG(energy_level_end) as avg_energy_end,
          MIN(started_at) as first_session,
          MAX(started_at) as last_session,
          COUNT(DISTINCT DATE(started_at)) as active_days
        FROM workout_sessions
        WHERE ${conditions.join(' AND ')}
      ''', args);

      if (results.isEmpty) {
        return {
          'total_sessions': 0,
          'avg_duration': null,
          'total_duration': 0,
          'avg_rating': null,
          'total_calories': 0,
          'avg_calories': null,
          'avg_rpe': null,
          'avg_energy_start': null,
          'avg_energy_end': null,
          'first_session': null,
          'last_session': null,
          'active_days': 0,
        };
      }

      return results.first;
    } catch (e) {
      throw GenericRepositoryException('Failed to get user session stats: $e');
    }
  }

  /// Get workout frequency by day of week
  Future<List<Map<String, dynamic>>> getWorkoutFrequencyByDayOfWeek(
    String userId, {
    int? daysBack,
  }) async {
    final db = await database;

    try {
      final conditions = ['user_id = ?', 'status = ?'];
      final args = <Object?>[userId, 'completed'];

      if (daysBack != null) {
        final cutoffDate = DateTime.now().subtract(Duration(days: daysBack));
        conditions.add('started_at >= ?');
        args.add(cutoffDate.toIso8601String());
      }

      final results = await db.rawQuery('''
        SELECT 
          CAST(strftime('%w', started_at) AS INTEGER) as day_of_week,
          COUNT(*) as session_count,
          AVG(duration_minutes) as avg_duration
        FROM workout_sessions
        WHERE ${conditions.join(' AND ')}
        GROUP BY day_of_week
        ORDER BY day_of_week
      ''', args);

      return results;
    } catch (e) {
      throw GenericRepositoryException('Failed to get workout frequency by day: $e');
    }
  }

  /// Get workout streaks
  Future<Map<String, dynamic>> getWorkoutStreaks(String userId) async {
    final db = await database;

    try {
      final results = await db.rawQuery('''
        WITH daily_workouts AS (
          SELECT DISTINCT DATE(started_at) as workout_date
          FROM workout_sessions
          WHERE user_id = ? AND status = 'completed'
          ORDER BY workout_date DESC
        ),
        streak_data AS (
          SELECT 
            workout_date,
            ROW_NUMBER() OVER (ORDER BY workout_date DESC) as row_num,
            julianday(workout_date) - ROW_NUMBER() OVER (ORDER BY workout_date DESC) as streak_group
          FROM daily_workouts
        )
        SELECT 
          COUNT(*) as current_streak,
          MIN(workout_date) as streak_start,
          MAX(workout_date) as streak_end
        FROM streak_data
        WHERE streak_group = (
          SELECT streak_group 
          FROM streak_data 
          WHERE workout_date = DATE('now') OR workout_date = DATE('now', '-1 day')
          LIMIT 1
        )
      ''', [userId]);

      Map<String, dynamic> streakInfo = {
        'current_streak': 0,
        'streak_start': null,
        'streak_end': null,
      };

      if (results.isNotEmpty && results.first['current_streak'] != null) {
        streakInfo = results.first;
      }

      // Get longest streak
      final longestStreakResults = await db.rawQuery('''
        WITH daily_workouts AS (
          SELECT DISTINCT DATE(started_at) as workout_date
          FROM workout_sessions
          WHERE user_id = ? AND status = 'completed'
          ORDER BY workout_date
        ),
        streak_groups AS (
          SELECT 
            workout_date,
            ROW_NUMBER() OVER (ORDER BY workout_date) as row_num,
            julianday(workout_date) - ROW_NUMBER() OVER (ORDER BY workout_date) as streak_group
          FROM daily_workouts
        ),
        streak_lengths AS (
          SELECT 
            COUNT(*) as streak_length,
            MIN(workout_date) as start_date,
            MAX(workout_date) as end_date
          FROM streak_groups
          GROUP BY streak_group
        )
        SELECT 
          MAX(streak_length) as longest_streak,
          start_date as longest_streak_start,
          end_date as longest_streak_end
        FROM streak_lengths
      ''', [userId]);

      if (longestStreakResults.isNotEmpty) {
        streakInfo.addAll({
          'longest_streak': longestStreakResults.first['longest_streak'] ?? 0,
          'longest_streak_start': longestStreakResults.first['longest_streak_start'],
          'longest_streak_end': longestStreakResults.first['longest_streak_end'],
        });
      }

      return streakInfo;
    } catch (e) {
      throw GenericRepositoryException('Failed to get workout streaks: $e');
    }
  }

  /// Get monthly workout summary
  Future<List<Map<String, dynamic>>> getMonthlyWorkoutSummary(
    String userId, {
    int monthsBack = 12,
  }) async {
    final db = await database;

    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: monthsBack * 30));

      final results = await db.rawQuery('''
        SELECT 
          strftime('%Y-%m', started_at) as month,
          COUNT(*) as session_count,
          SUM(duration_minutes) as total_duration,
          AVG(duration_minutes) as avg_duration,
          SUM(calories_burned) as total_calories,
          AVG(workout_rating) as avg_rating,
          COUNT(DISTINCT DATE(started_at)) as active_days
        FROM workout_sessions
        WHERE user_id = ? AND status = 'completed' AND started_at >= ?
        GROUP BY strftime('%Y-%m', started_at)
        ORDER BY month DESC
      ''', [userId, cutoffDate.toIso8601String()]);

      return results;
    } catch (e) {
      throw GenericRepositoryException('Failed to get monthly workout summary: $e');
    }
  }

  /// Helper method to apply filters
  void _applyFilter(
    WorkoutSessionFilter filter,
    List<String> whereConditions,
    List<Object?> whereArgs,
  ) {
    if (filter.statuses != null && filter.statuses!.isNotEmpty) {
      whereConditions.add('status IN (${filter.statuses!.map((_) => '?').join(', ')})');
      whereArgs.addAll(filter.statuses!);
    }

    if (filter.startDate != null) {
      whereConditions.add('started_at >= ?');
      whereArgs.add(filter.startDate!.toIso8601String());
    }

    if (filter.endDate != null) {
      whereConditions.add('started_at <= ?');
      whereArgs.add(filter.endDate!.toIso8601String());
    }

    if (filter.location != null) {
      whereConditions.add('LOWER(location) LIKE ?');
      whereArgs.add('%${filter.location!.toLowerCase()}%');
    }

    if (filter.minDuration != null) {
      whereConditions.add('duration_minutes >= ?');
      whereArgs.add(filter.minDuration);
    }

    if (filter.maxDuration != null) {
      whereConditions.add('duration_minutes <= ?');
      whereArgs.add(filter.maxDuration);
    }

    if (filter.minRating != null) {
      whereConditions.add('workout_rating >= ?');
      whereArgs.add(filter.minRating);
    }

    if (filter.maxRating != null) {
      whereConditions.add('workout_rating <= ?');
      whereArgs.add(filter.maxRating);
    }

    if (filter.minCalories != null) {
      whereConditions.add('calories_burned >= ?');
      whereArgs.add(filter.minCalories);
    }

    if (filter.maxCalories != null) {
      whereConditions.add('calories_burned <= ?');
      whereArgs.add(filter.maxCalories);
    }
  }

  /// Helper method to build ORDER BY clause
  String _buildOrderBy(WorkoutSessionSortBy sortBy, bool ascending) {
    final direction = ascending ? 'ASC' : 'DESC';

    switch (sortBy) {
      case WorkoutSessionSortBy.startedAt:
        return 'started_at $direction';
      case WorkoutSessionSortBy.duration:
        return 'duration_minutes $direction, started_at DESC';
      case WorkoutSessionSortBy.rating:
        return 'workout_rating $direction, started_at DESC';
      case WorkoutSessionSortBy.caloriesBurned:
        return 'calories_burned $direction, started_at DESC';
      case WorkoutSessionSortBy.status:
        return '''
          CASE status 
            WHEN 'in_progress' THEN 1 
            WHEN 'paused' THEN 2 
            WHEN 'completed' THEN 3 
            WHEN 'cancelled' THEN 4 
            ELSE 5 
          END $direction, started_at DESC
        ''';
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