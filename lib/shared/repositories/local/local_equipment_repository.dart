import '../../../core/database/database_manager.dart';
import '../../models/models.dart';
import '../errors/repository_exceptions.dart' as repo_exceptions;
import '../interfaces/repository_interfaces.dart';
import '../sync/sync_aware_repository.dart';

/// Local SQLite implementation of the Equipment repository
class LocalEquipmentRepository extends SyncAwareRepository<Equipment> implements IEquipmentRepository {
  LocalEquipmentRepository(DatabaseManager databaseManager)
      : super(databaseManager, 'equipment');

  @override
  Equipment fromDatabase(Map<String, dynamic> map) => Equipment.fromDatabase(map);

  @override
  Map<String, dynamic> toDatabase(Equipment model) => model.toDatabase();

  @override
  String getId(Equipment model) => model.id;

  @override
  Future<List<Equipment>> findByCategory(String category, {int? limit}) async {
    return findWhere(
      'category = ?',
      [category],
      orderBy: 'name ASC',
      limit: limit,
    );
  }

  @override
  Future<List<Equipment>> searchEquipment(String query, {int? limit}) async {
    if (query.trim().isEmpty) {
      return getAll(orderBy: 'name ASC', limit: limit);
    }

    return search(
      query,
      ['name', 'description', 'category'],
      orderBy: 'name ASC',
      limit: limit,
    );
  }

  @override
  Future<List<Equipment>> findByAvailability(bool isAvailable, {int? limit}) async {
    return findWhere(
      'is_available = ?',
      [isAvailable ? 1 : 0],
      orderBy: 'name ASC',
      limit: limit,
    );
  }

  @override
  Future<List<Equipment>> getUserEquipment(String userId) async {
    final db = await database;
    try {
      final results = await db.rawQuery('''
        SELECT e.* 
        FROM equipment e
        INNER JOIN user_equipment ue ON e.id = ue.equipment_id
        WHERE ue.user_id = ?
        ORDER BY e.name ASC
      ''', [userId]);

      return results.map((map) => fromDatabase(map)).toList();
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to get user equipment: $e');
    }
  }

  @override
  Future<void> addToUser(String userId, String equipmentId) async {
    final db = await database;
    try {
      await db.insert('user_equipment', {
        'id': generateId(),
        'user_id': userId,
        'equipment_id': equipmentId,
        'added_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        // Already exists, ignore
        return;
      }
      throw repo_exceptions.DatabaseException('Failed to add equipment to user: $e');
    }
  }

  @override
  Future<void> removeFromUser(String userId, String equipmentId) async {
    final db = await database;
    try {
      await db.delete(
        'user_equipment',
        where: 'user_id = ? AND equipment_id = ?',
        whereArgs: [userId, equipmentId],
      );
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to remove equipment from user: $e');
    }
  }

  @override
  Future<Map<String, int>> getUsageStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;
    try {
      final whereConditions = <String>[];
      final whereArgs = <Object?>[];

      if (startDate != null) {
        whereConditions.add('ws.started_at >= ?');
        whereArgs.add(startDate.toIso8601String());
      }

      if (endDate != null) {
        whereConditions.add('ws.started_at <= ?');
        whereArgs.add(endDate.toIso8601String());
      }

      final whereClause = whereConditions.isNotEmpty
          ? 'WHERE ${whereConditions.join(' AND ')}'
          : '';

      final results = await db.rawQuery('''
        SELECT 
          e.name as equipment_name,
          COUNT(DISTINCT ws.id) as usage_count
        FROM equipment e
        INNER JOIN exercises ex ON ex.equipment_required LIKE '%' || e.id || '%'
        INNER JOIN workout_exercises we ON ex.id = we.exercise_id
        INNER JOIN workouts w ON we.workout_id = w.id
        INNER JOIN workout_sessions ws ON w.id = ws.workout_id
        $whereClause
        GROUP BY e.id, e.name
        ORDER BY usage_count DESC
      ''', whereArgs);

      final stats = <String, int>{};
      for (final row in results) {
        stats[row['equipment_name'] as String] = row['usage_count'] as int;
      }

      return stats;
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to get equipment usage stats: $e');
    }
  }
}