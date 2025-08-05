import '../../../core/database/database_manager.dart';
import '../../models/models.dart';
import '../errors/repository_exceptions.dart' as repo_exceptions;
import '../interfaces/repository_interfaces.dart';
import '../sync/sync_aware_repository.dart';

/// Local SQLite implementation of the Workout Session repository
class LocalWorkoutSessionRepository extends SyncAwareRepository<WorkoutSession> implements IWorkoutSessionRepository {
  LocalWorkoutSessionRepository(DatabaseManager databaseManager)
      : super(databaseManager, 'workout_sessions');

  @override
  WorkoutSession fromDatabase(Map<String, dynamic> map) => WorkoutSession.fromDatabase(map);

  @override
  Map<String, dynamic> toDatabase(WorkoutSession model) => model.toDatabase();

  @override
  String getId(WorkoutSession model) => model.id;

  @override
  Future<List<WorkoutSession>> findByUser(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) async {
    final whereConditions = ['user_id = ?'];
    final whereArgs = <Object?>[userId];

    if (startDate != null) {
      whereConditions.add('started_at >= ?');
      whereArgs.add(startDate.toIso8601String());
    }

    if (endDate != null) {
      whereConditions.add('started_at <= ?');
      whereArgs.add(endDate.toIso8601String());
    }

    return findWhere(
      whereConditions.join(' AND '),
      whereArgs,
      orderBy: 'started_at DESC',
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<List<WorkoutSession>> findByWorkout(
    String workoutId, {
    String? userId,
    int? limit,
  }) async {
    final whereConditions = ['workout_id = ?'];
    final whereArgs = <Object?>[workoutId];

    if (userId != null) {
      whereConditions.add('user_id = ?');
      whereArgs.add(userId);
    }

    return findWhere(
      whereConditions.join(' AND '),
      whereArgs,
      orderBy: 'started_at DESC',
      limit: limit,
    );
  }

  @override
  Future<WorkoutSession?> getActiveSession(String userId) async {
    final results = await findWhere(
      'user_id = ? AND status = ?',
      [userId, 'in_progress'],
      limit: 1,
    );

    return results.isNotEmpty ? results.first : null;
  }

  @override
  Future<WorkoutSession> startSession(String workoutId, String userId) async {
    // Check if user already has an active session
    final activeSession = await getActiveSession(userId);
    if (activeSession != null) {
      throw repo_exceptions.DatabaseException('User already has an active workout session');
    }

    final session = WorkoutSession(
      id: generateId(),
      workoutId: workoutId,
      userId: userId,
      startedAt: DateTime.now(),
      status: 'in_progress',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return await create(session);
  }

  @override
  Future<WorkoutSession> completeSession(String sessionId) async {
    final session = await getById(sessionId);
    if (session == null) {
      throw repo_exceptions.DatabaseException('Workout session not found: $sessionId');
    }

    if (session.status != 'in_progress') {
      throw repo_exceptions.DatabaseException('Session is not in progress');
    }

    final completedSession = session.copyWith(
      status: 'completed',
      endedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return await update(completedSession);
  }

  @override
  Future<void> cancelSession(String sessionId) async {
    final session = await getById(sessionId);
    if (session == null) {
      throw repo_exceptions.DatabaseException('Workout session not found: $sessionId');
    }

    final cancelledSession = session.copyWith(
      status: 'cancelled',
      endedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await update(cancelledSession);
  }

  @override
  Future<void> addExerciseLog(String sessionId, ExerciseLog exerciseLog) async {
    final db = await database;
    try {
      final logWithSession = exerciseLog.copyWith(
        workoutSessionId: sessionId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await db.insert('exercise_logs', logWithSession.toDatabase());
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to add exercise log: $e');
    }
  }

  @override
  Future<void> updateExerciseLog(ExerciseLog exerciseLog) async {
    final db = await database;
    try {
      final updatedLog = exerciseLog.copyWith(updatedAt: DateTime.now());
      
      await db.update(
        'exercise_logs',
        updatedLog.toDatabase(),
        where: 'id = ?',
        whereArgs: [exerciseLog.id],
      );
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to update exercise log: $e');
    }
  }

  @override
  Future<List<ExerciseLog>> getSessionExerciseLogs(String sessionId) async {
    final db = await database;
    try {
      final results = await db.query(
        'exercise_logs',
        where: 'session_id = ?',
        whereArgs: [sessionId],
        orderBy: 'created_at ASC',
      );

      return results.map((map) => ExerciseLog.fromDatabase(map)).toList();
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to get session exercise logs: $e');
    }
  }

  @override
  Future<SessionStats> getSessionStats(String sessionId) async {
    final session = await getById(sessionId);
    if (session == null) {
      throw repo_exceptions.DatabaseException('Session not found: $sessionId');
    }

    final logs = await getSessionExerciseLogs(sessionId);
    
    // Calculate statistics
    final totalExercises = logs.map((log) => log.exerciseId).toSet().length;
    final completedExercises = logs.where((log) => log.isCompleted).map((log) => log.exerciseId).toSet().length;
    
    final totalDuration = session.endedAt != null 
        ? session.endedAt!.difference(session.startedAt)
        : DateTime.now().difference(session.startedAt);
    
    // Calculate work time vs rest time (simplified)
    final actualWorkTime = Duration(
      minutes: logs.fold(0, (sum, log) => sum + (log.durationSeconds ?? 0)) ~/ 60,
    );
    final restTime = totalDuration - actualWorkTime;
    
    final totalVolume = logs.fold(0.0, (sum, log) => 
        sum + (log.weightKg ?? 0) * (log.repsCompleted ?? 0));
    
    final totalSets = logs.length;
    final totalReps = logs.fold(0, (sum, log) => sum + (log.repsCompleted ?? 0));

    return SessionStats(
      sessionId: sessionId,
      totalExercises: totalExercises,
      completedExercises: completedExercises,
      totalDuration: totalDuration,
      actualWorkTime: actualWorkTime,
      restTime: restTime,
      totalVolume: totalVolume,
      totalSets: totalSets,
      totalReps: totalReps,
    );
  }

  @override
  Future<UserWorkoutStats> getUserStats(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;
    try {
      final whereConditions = ['user_id = ?', 'status = ?'];
      final whereArgs = <Object?>[userId, 'completed'];

      if (startDate != null) {
        whereConditions.add('started_at >= ?');
        whereArgs.add(startDate.toIso8601String());
      }

      if (endDate != null) {
        whereConditions.add('started_at <= ?');
        whereArgs.add(endDate.toIso8601String());
      }

      // Get session count and total time
      final sessionResults = await db.rawQuery('''
        SELECT 
          COUNT(*) as total_sessions,
          SUM(
            CASE 
              WHEN ended_at IS NOT NULL THEN
                (julianday(ended_at) - julianday(started_at)) * 24 * 60 * 60
              ELSE 0
            END
          ) as total_seconds
        FROM workout_sessions
        WHERE ${whereConditions.join(' AND ')}
      ''', whereArgs);

      final totalSessions = sessionResults.first['total_sessions'] as int;
      final totalSeconds = (sessionResults.first['total_seconds'] as double?) ?? 0.0;
      final totalTime = Duration(seconds: totalSeconds.toInt());

      // Get exercise logs for volume and rep calculations
      final logResults = await db.rawQuery('''
        SELECT 
          el.exercise_id,
          COUNT(*) as set_count,
          SUM(el.reps) as total_reps,
          SUM(el.weight * el.reps) as total_volume
        FROM exercise_logs el
        INNER JOIN workout_sessions ws ON el.session_id = ws.id
        WHERE ${whereConditions.join(' AND ')}
        GROUP BY el.exercise_id
        ORDER BY set_count DESC
      ''', whereArgs);

      final exerciseFrequency = <String, int>{};
      var totalSets = 0;
      var totalReps = 0;
      var totalVolume = 0.0;

      for (final row in logResults) {
        final exerciseId = row['exercise_id'] as String;
        final setCount = row['set_count'] as int;
        exerciseFrequency[exerciseId] = setCount;
        totalSets += setCount;
        totalReps += (row['total_reps'] as int?) ?? 0;
        totalVolume += (row['total_volume'] as double?) ?? 0.0;
      }

      final favoriteExercises = exerciseFrequency.entries
          .toList()
          ..sort((a, b) => b.value.compareTo(a.value))
          ..take(10);

      return UserWorkoutStats(
        userId: userId,
        totalSessions: totalSessions,
        totalTime: totalTime,
        totalVolume: totalVolume,
        totalSets: totalSets,
        totalReps: totalReps,
        exerciseFrequency: exerciseFrequency,
        favoriteExercises: favoriteExercises.map((e) => e.key).toList(),
      );
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to get user workout stats: $e');
    }
  }
}