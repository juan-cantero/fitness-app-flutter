import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../../core/database/database_manager.dart';
import '../models/sync.dart';
import 'errors/repository_exceptions.dart' as repo_exceptions;

/// Base repository class providing common CRUD operations and sync support
abstract class BaseRepository<T> {
  final DatabaseManager _databaseManager;
  final String tableName;
  final Uuid _uuid = const Uuid();

  BaseRepository(this._databaseManager, this.tableName);

  /// Get database instance
  Future<Database> get database => _databaseManager.database;

  /// Convert database map to model
  T fromDatabase(Map<String, dynamic> map);

  /// Convert model to database map
  Map<String, dynamic> toDatabase(T model);

  /// Extract ID from model
  String getId(T model);

  /// Create a new record
  Future<T> create(T model) async {
    final db = await database;
    final data = toDatabase(model);
    final id = getId(model);

    try {
      await db.insert(tableName, data);
      
      // Track for sync
      if (await _shouldTrackSync()) {
        await _trackSyncOperation(id, 'insert', data);
      }

      return model;
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to create $tableName: $e');
    }
  }

  /// Create multiple records in a transaction
  Future<List<T>> createBatch(List<T> models) async {
    if (models.isEmpty) return [];

    final db = await database;
    try {
      await db.transaction((txn) async {
        for (final model in models) {
          final data = toDatabase(model);
          await txn.insert(tableName, data);
          
          // Track for sync
          if (await _shouldTrackSync()) {
            await _trackSyncOperation(getId(model), 'insert', data);
          }
        }
      });
      
      return models;
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to create batch $tableName: $e');
    }
  }

  /// Get record by ID
  Future<T?> getById(String id) async {
    final db = await database;
    try {
      final results = await db.query(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (results.isEmpty) return null;
      return fromDatabase(results.first);
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to get $tableName by id: $e');
    }
  }

  /// Get all records
  Future<List<T>> getAll({
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    try {
      final results = await db.query(
        tableName,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );

      return results.map((map) => fromDatabase(map)).toList();
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to get all $tableName: $e');
    }
  }

  /// Update record
  Future<T> update(T model) async {
    final db = await database;
    final data = toDatabase(model);
    final id = getId(model);

    try {
      final count = await db.update(
        tableName,
        data,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (count == 0) {
        throw repo_exceptions.DatabaseException('$tableName with id $id not found');
      }

      // Track for sync
      if (await _shouldTrackSync()) {
        await _trackSyncOperation(id, 'update', data);
      }

      return model;
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to update $tableName: $e');
    }
  }

  /// Delete record by ID
  Future<void> delete(String id) async {
    final db = await database;
    try {
      final count = await db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (count == 0) {
        throw repo_exceptions.DatabaseException('$tableName with id $id not found');
      }

      // Track for sync
      if (await _shouldTrackSync()) {
        await _trackSyncOperation(id, 'delete', {'id': id});
      }
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to delete $tableName: $e');
    }
  }

  /// Delete multiple records
  Future<void> deleteBatch(List<String> ids) async {
    if (ids.isEmpty) return;

    final db = await database;
    try {
      await db.transaction((txn) async {
        for (final id in ids) {
          await txn.delete(
            tableName,
            where: 'id = ?',
            whereArgs: [id],
          );

          // Track for sync
          if (await _shouldTrackSync()) {
            await _trackSyncOperation(id, 'delete', {'id': id});
          }
        }
      });
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to delete batch $tableName: $e');
    }
  }

  /// Check if record exists
  Future<bool> exists(String id) async {
    final db = await database;
    try {
      final result = await db.query(
        tableName,
        columns: ['COUNT(*) as count'],
        where: 'id = ?',
        whereArgs: [id],
      );

      return (result.first['count'] as int) > 0;
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to check existence in $tableName: $e');
    }
  }

  /// Get count of records
  Future<int> count([String? where, List<Object?>? whereArgs]) async {
    final db = await database;
    try {
      final result = await db.query(
        tableName,
        columns: ['COUNT(*) as count'],
        where: where,
        whereArgs: whereArgs,
      );

      return result.first['count'] as int;
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to count $tableName: $e');
    }
  }

  /// Find records with custom where clause
  Future<List<T>> findWhere(
    String where,
    List<Object?> whereArgs, {
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    try {
      final results = await db.query(
        tableName,
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );

      return results.map((map) => fromDatabase(map)).toList();
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to find $tableName: $e');
    }
  }

  /// Execute raw query and return models
  Future<List<T>> rawQuery(String sql, [List<Object?>? arguments]) async {
    final db = await database;
    try {
      final results = await db.rawQuery(sql, arguments);
      return results.map((map) => fromDatabase(map)).toList();
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to execute raw query on $tableName: $e');
    }
  }

  /// Generate new UUID
  String generateId() => _uuid.v4();

  /// Check if sync tracking is enabled
  Future<bool> _shouldTrackSync() async {
    // Override in subclasses if sync should be disabled for certain tables
    return true;
  }

  /// Track sync operation
  Future<void> _trackSyncOperation(
    String recordId,
    String operation,
    Map<String, dynamic> data,
  ) async {
    final db = await database;
    try {
      final syncRecord = SyncStatus(
        id: generateId(),
        tableName: tableName,
        recordId: recordId,
        operation: operation,
        localTimestamp: DateTime.now(),
        recordData: jsonEncode(data),
        createdAt: DateTime.now(),
      );

      await db.insert('sync_status', syncRecord.toDatabase());
    } catch (e) {
      // Don't fail the main operation if sync tracking fails
      print('Warning: Failed to track sync operation: $e');
    }
  }

  /// Search records with text query
  Future<List<T>> search(
    String query,
    List<String> searchFields, {
    String? additionalWhere,
    List<Object?>? additionalWhereArgs,
    String? orderBy,
    int? limit,
  }) async {
    if (query.trim().isEmpty) {
      return getAll(orderBy: orderBy, limit: limit);
    }

    final db = await database;
    try {
      // Build search conditions
      final searchConditions = searchFields
          .map((field) => '$field LIKE ?')
          .join(' OR ');
      
      final searchArgs = searchFields
          .map((_) => '%${query.toLowerCase()}%')
          .toList();

      String whereClause = '($searchConditions)';
      List<Object?> whereArgs = searchArgs;

      // Add additional where conditions
      if (additionalWhere != null) {
        whereClause = '$whereClause AND ($additionalWhere)';
        whereArgs.addAll(additionalWhereArgs ?? []);
      }

      final results = await db.query(
        tableName,
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: limit,
      );

      return results.map((map) => fromDatabase(map)).toList();
    } catch (e) {
      throw repo_exceptions.DatabaseException('Failed to search $tableName: $e');
    }
  }

  /// Execute operation in transaction
  Future<R> transaction<R>(Future<R> Function(Transaction txn) action) async {
    final db = await database;
    try {
      return await db.transaction(action);
    } catch (e) {
      throw repo_exceptions.DatabaseException('Transaction failed for $tableName: $e');
    }
  }
}