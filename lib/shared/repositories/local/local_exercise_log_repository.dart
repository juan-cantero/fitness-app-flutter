import '../../../core/database/database_manager.dart';
import '../../models/models.dart';
import '../errors/repository_exceptions.dart' as repo_exceptions;
import '../interfaces/repository_interfaces.dart';
import '../sync/sync_aware_repository.dart';

/// Local SQLite implementation of the Exercise Log repository
class LocalExerciseLogRepository extends SyncAwareRepository<ExerciseLog> implements IExerciseLogRepository {
  LocalExerciseLogRepository(DatabaseManager databaseManager)
      : super(databaseManager, 'exercise_logs');

  @override
  ExerciseLog fromDatabase(Map<String, dynamic> map) => ExerciseLog.fromDatabase(map);

  @override
  Map<String, dynamic> toDatabase(ExerciseLog model) => model.toDatabase();

  @override
  String getId(ExerciseLog model) => model.id;

  @override
  Future<List<ExerciseLog>> findByUser(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    final whereConditions = ['user_id = ?'];
    final whereArgs = <Object?>[userId];

    if (startDate != null) {
      whereConditions.add('created_at >= ?');
      whereArgs.add(startDate.toIso8601String());
    }

    if (endDate != null) {
      whereConditions.add('created_at <= ?');
      whereArgs.add(endDate.toIso8601String());
    }

    return findWhere(
      whereConditions.join(' AND '),
      whereArgs,
      orderBy: 'created_at DESC',
      limit: limit,
    );
  }

  @override
  Future<List<ExerciseLog>> findByExercise(
    String exerciseId, {
    String? userId,
    int? limit,
  }) async {
    final whereConditions = ['exercise_id = ?'];
    final whereArgs = <Object?>[exerciseId];

    if (userId != null) {
      whereConditions.add('user_id = ?');
      whereArgs.add(userId);
    }

    return findWhere(
      whereConditions.join(' AND '),
      whereArgs,
      orderBy: 'created_at DESC',
      limit: limit,
    );
  }

  @override
  Future<List<ExerciseLog>> findBySession(String sessionId) async {
    return findWhere(
      'session_id = ?',
      [sessionId],
      orderBy: 'created_at ASC',
    );
  }

  @override
  Future<List<PersonalRecord>> getPersonalRecords(
    String userId, {
    String? exerciseId,
    String? recordType,
  }) async {
    final db = await database;
    try {
      final whereConditions = ['user_id = ?'];
      final whereArgs = <Object?>[userId];

      if (exerciseId != null) {
        whereConditions.add('exercise_id = ?');
        whereArgs.add(exerciseId);
      }

      if (recordType != null) {
        whereConditions.add('record_type = ?');
        whereArgs.add(recordType);
      }

      final results = await db.query(
        'personal_records',
        where: whereConditions.join(' AND '),
        whereArgs: whereArgs,
        orderBy: 'achieved_at DESC',
      );

      return results.map((map) => _personalRecordFromDatabase(map)).toList();
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to get personal records: $e');
    }
  }

  @override
  Future<List<ProgressPoint>> getProgressData(
    String userId,
    String exerciseId, {
    DateTime? startDate,
    DateTime? endDate,
    String? metric,
  }) async {
    final db = await database;
    try {
      final whereConditions = ['user_id = ?', 'exercise_id = ?'];
      final whereArgs = <Object?>[userId, exerciseId];

      if (startDate != null) {
        whereConditions.add('created_at >= ?');
        whereArgs.add(startDate.toIso8601String());
      }

      if (endDate != null) {
        whereConditions.add('created_at <= ?');
        whereArgs.add(endDate.toIso8601String());
      }

      String selectMetric = 'weight';
      if (metric != null) {
        selectMetric = metric;
      }

      final results = await db.rawQuery('''
        SELECT 
          DATE(created_at) as date,
          MAX($selectMetric) as value,
          '$selectMetric' as metric
        FROM exercise_logs
        WHERE ${whereConditions.join(' AND ')} AND $selectMetric IS NOT NULL
        GROUP BY DATE(created_at)
        ORDER BY date ASC
      ''', whereArgs);

      return results.map((map) => ProgressPoint(
        date: DateTime.parse(map['date'] as String),
        value: (map['value'] as num).toDouble(),
        metric: map['metric'] as String,
      )).toList();
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to get progress data: $e');
    }
  }

  @override
  Future<ExerciseStats> getExerciseStats(
    String userId,
    String exerciseId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;
    try {
      final whereConditions = ['user_id = ?', 'exercise_id = ?'];
      final whereArgs = <Object?>[userId, exerciseId];

      if (startDate != null) {
        whereConditions.add('created_at >= ?');
        whereArgs.add(startDate.toIso8601String());
      }

      if (endDate != null) {
        whereConditions.add('created_at <= ?');
        whereArgs.add(endDate.toIso8601String());
      }

      final statsResults = await db.rawQuery('''
        SELECT 
          COUNT(DISTINCT session_id) as total_sessions,
          COUNT(*) as total_sets,
          SUM(reps) as total_reps,
          SUM(weight * reps) as total_volume,
          MAX(weight) as max_weight,
          AVG(weight) as average_weight,
          MAX(created_at) as last_performed
        FROM exercise_logs
        WHERE ${whereConditions.join(' AND ')}
      ''', whereArgs);

      final stats = statsResults.first;

      // Get best personal record
      final recordResults = await db.query(
        'personal_records',
        where: 'user_id = ? AND exercise_id = ?',
        whereArgs: [userId, exerciseId],
        orderBy: 'value DESC',
        limit: 1,
      );

      PersonalRecord? bestRecord;
      if (recordResults.isNotEmpty) {
        bestRecord = _personalRecordFromDatabase(recordResults.first);
      }

      return ExerciseStats(
        userId: userId,
        exerciseId: exerciseId,
        totalSessions: stats['total_sessions'] as int? ?? 0,
        totalSets: stats['total_sets'] as int? ?? 0,
        totalReps: stats['total_reps'] as int? ?? 0,
        totalVolume: (stats['total_volume'] as num?)?.toDouble() ?? 0.0,
        maxWeight: (stats['max_weight'] as num?)?.toDouble() ?? 0.0,
        averageWeight: (stats['average_weight'] as num?)?.toDouble() ?? 0.0,
        bestRecord: bestRecord,
        lastPerformed: stats['last_performed'] != null
            ? DateTime.parse(stats['last_performed'] as String)
            : null,
      );
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to get exercise stats: $e');
    }
  }

  @override
  Future<List<VolumePoint>> getVolumeData(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    String? groupBy,
  }) async {
    final db = await database;
    try {
      final whereConditions = ['user_id = ?'];
      final whereArgs = <Object?>[userId];

      if (startDate != null) {
        whereConditions.add('created_at >= ?');
        whereArgs.add(startDate.toIso8601String());
      }

      if (endDate != null) {
        whereConditions.add('created_at <= ?');
        whereArgs.add(endDate.toIso8601String());
      }

      String dateGroup = "DATE(created_at)";
      String groupByValue = "day";
      
      if (groupBy == "week") {
        dateGroup = "DATE(created_at, 'weekday 0', '-6 days')";
        groupByValue = "week";
      } else if (groupBy == "month") {
        dateGroup = "DATE(created_at, 'start of month')";
        groupByValue = "month";
      }

      final results = await db.rawQuery('''
        SELECT 
          $dateGroup as date,
          SUM(weight * reps) as volume,
          COUNT(*) as sets,
          SUM(reps) as reps,
          '$groupByValue' as group_by
        FROM exercise_logs
        WHERE ${whereConditions.join(' AND ')} AND weight IS NOT NULL AND reps IS NOT NULL
        GROUP BY $dateGroup
        ORDER BY date ASC
      ''', whereArgs);

      return results.map((map) => VolumePoint(
        date: DateTime.parse(map['date'] as String),
        volume: (map['volume'] as num).toDouble(),
        sets: map['sets'] as int,
        reps: map['reps'] as int,
        groupBy: map['group_by'] as String,
      )).toList();
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to get volume data: $e');
    }
  }

  /// Helper method to convert database map to PersonalRecord
  PersonalRecord _personalRecordFromDatabase(Map<String, dynamic> map) {
    return PersonalRecord(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      exerciseId: map['exercise_id'] as String,
      recordType: map['record_type'] as String,
      value: (map['value'] as num).toDouble(),
      unit: map['unit'] as String,
      achievedAt: DateTime.parse(map['achieved_at'] as String),
      notes: map['notes'] as String?,
    );
  }
}