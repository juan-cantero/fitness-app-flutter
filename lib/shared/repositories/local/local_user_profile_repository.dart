import '../../../core/database/database_manager.dart';
import '../../models/models.dart';
import '../errors/repository_exceptions.dart' as repo_exceptions;
import '../interfaces/repository_interfaces.dart';
import '../sync/sync_aware_repository.dart';

/// Local SQLite implementation of the User Profile repository
class LocalUserProfileRepository extends SyncAwareRepository<UserProfile> implements IUserProfileRepository {
  LocalUserProfileRepository(DatabaseManager databaseManager)
      : super(databaseManager, 'user_profiles');

  @override
  UserProfile fromDatabase(Map<String, dynamic> map) => UserProfile.fromDatabase(map);

  @override
  Map<String, dynamic> toDatabase(UserProfile model) => model.toDatabase();

  @override
  String getId(UserProfile model) => model.id;

  @override
  Future<UserProfile?> getUserProfile(String userId) async {
    final results = await findWhere('user_id = ?', [userId], limit: 1);
    return results.isNotEmpty ? results.first : null;
  }

  @override
  Future<UserProfile> upsertUserProfile(UserProfile profile) async {
    final existing = await getUserProfile(profile.userId);
    
    if (existing != null) {
      // Update existing profile
      final updatedProfile = profile.copyWith(
        id: existing.id,
        updatedAt: DateTime.now(),
      );
      return await update(updatedProfile);
    } else {
      // Create new profile
      final newProfile = profile.copyWith(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      return await create(newProfile);
    }
  }

  @override
  Future<void> updatePreferences(String userId, Map<String, dynamic> preferences) async {
    final profile = await getUserProfile(userId);
    if (profile == null) {
      throw repo_exceptions.DatabaseException('User profile not found: $userId');
    }

    final updatedProfile = profile.copyWith(
      preferredUnits: preferences['preferredUnits'] as String? ?? profile.preferredUnits,
      timezone: preferences['timezone'] as String? ?? profile.timezone,
      updatedAt: DateTime.now(),
    );

    await update(updatedProfile);
  }

  @override
  Future<Map<String, dynamic>?> getUserPreferences(String userId) async {
    final profile = await getUserProfile(userId);
    if (profile == null) return null;
    
    return {
      'preferredUnits': profile.preferredUnits,
      'timezone': profile.timezone,
      'fitnessLevel': profile.fitnessLevel,
      'activityLevel': profile.activityLevel,
    };
  }

  @override
  Future<void> updateGoals(String userId, List<Goal> goals) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        // Remove existing goals
        await txn.delete(
          'user_goals',
          where: 'user_id = ?',
          whereArgs: [userId],
        );

        // Insert new goals
        for (final goal in goals) {
          await txn.insert('user_goals', _goalToDatabase(goal));
        }
      });
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to update goals: $e');
    }
  }

  @override
  Future<List<Goal>> getUserGoals(String userId) async {
    final db = await database;
    try {
      final results = await db.query(
        'user_goals',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );

      return results.map((map) => _goalFromDatabase(map)).toList();
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to get user goals: $e');
    }
  }

  @override
  Future<void> addMeasurement(String userId, Measurement measurement) async {
    final db = await database;
    try {
      final measurementWithUser = Measurement(
        id: measurement.id,
        userId: userId,
        type: measurement.type,
        value: measurement.value,
        unit: measurement.unit,
        recordedAt: measurement.recordedAt,
        notes: measurement.notes,
      );

      await db.insert('user_measurements', _measurementToDatabase(measurementWithUser));
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to add measurement: $e');
    }
  }

  @override
  Future<List<Measurement>> getUserMeasurements(
    String userId, {
    String? type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;
    try {
      final whereConditions = ['user_id = ?'];
      final whereArgs = <Object?>[userId];

      if (type != null) {
        whereConditions.add('type = ?');
        whereArgs.add(type);
      }

      if (startDate != null) {
        whereConditions.add('recorded_at >= ?');
        whereArgs.add(startDate.toIso8601String());
      }

      if (endDate != null) {
        whereConditions.add('recorded_at <= ?');
        whereArgs.add(endDate.toIso8601String());
      }

      final results = await db.query(
        'user_measurements',
        where: whereConditions.join(' AND '),
        whereArgs: whereArgs,
        orderBy: 'recorded_at DESC',
      );

      return results.map((map) => _measurementFromDatabase(map)).toList();
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to get user measurements: $e');
    }
  }

  @override
  Future<Measurement?> getLatestMeasurement(String userId, String type) async {
    final measurements = await getUserMeasurements(userId, type: type);
    return measurements.isNotEmpty ? measurements.first : null;
  }

  /// Helper methods for Goal serialization
  Map<String, dynamic> _goalToDatabase(Goal goal) {
    return {
      'id': goal.id,
      'user_id': goal.userId,
      'type': goal.type,
      'title': goal.title,
      'description': goal.description,
      'target_value': goal.targetValue,
      'unit': goal.unit,
      'target_date': goal.targetDate?.toIso8601String(),
      'current_value': goal.currentValue,
      'is_completed': goal.isCompleted ? 1 : 0,
      'created_at': goal.createdAt.toIso8601String(),
      'completed_at': goal.completedAt?.toIso8601String(),
    };
  }

  Goal _goalFromDatabase(Map<String, dynamic> map) {
    return Goal(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      type: map['type'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      targetValue: map['target_value'] as double?,
      unit: map['unit'] as String?,
      targetDate: map['target_date'] != null
          ? DateTime.parse(map['target_date'] as String)
          : null,
      currentValue: map['current_value'] as double?,
      isCompleted: (map['is_completed'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      completedAt: map['completed_at'] != null
          ? DateTime.parse(map['completed_at'] as String)
          : null,
    );
  }

  /// Helper methods for Measurement serialization
  Map<String, dynamic> _measurementToDatabase(Measurement measurement) {
    return {
      'id': measurement.id,
      'user_id': measurement.userId,
      'type': measurement.type,
      'value': measurement.value,
      'unit': measurement.unit,
      'recorded_at': measurement.recordedAt.toIso8601String(),
      'notes': measurement.notes,
    };
  }

  Measurement _measurementFromDatabase(Map<String, dynamic> map) {
    return Measurement(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      type: map['type'] as String,
      value: map['value'] as double,
      unit: map['unit'] as String,
      recordedAt: DateTime.parse(map['recorded_at'] as String),
      notes: map['notes'] as String?,
    );
  }
}