import 'dart:convert';
import 'dart:math';
import 'package:mutex/mutex.dart';
import 'package:path/path.dart';
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
  
  // Replace spinlock with proper mutex for clean synchronization
  static final Mutex _updateMutex = Mutex();

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

  /// Update record with proper mutex synchronization and exponential backoff
  Future<T> update(T model) async {
    return _updateMutex.protect(() async {
      final data = toDatabase(model);
      final id = getId(model);

      print('Starting update operation for $tableName with id: $id');
      
      // Retry logic with exponential backoff and jitter
      for (int attempt = 1; attempt <= 5; attempt++) {
        try {
          print('Update attempt $attempt/5');
          
          final db = await database;
          
          // Use a short transaction to minimize lock time
          final count = await db.transaction<int>((txn) async {
            return await txn.update(
              tableName,
              data,
              where: 'id = ?',
              whereArgs: [id],
            );
          });
          
          print('Update completed, affected rows: $count');

          if (count == 0) {
            throw repo_exceptions.DatabaseException('$tableName with id $id not found');
          }

          // Success! Return the updated model
          print('Update successful on attempt $attempt');
          return model;
          
        } catch (e) {
          final errorStr = e.toString().toLowerCase();
          
          // Check if this is a database lock error
          if (errorStr.contains('database is locked') || 
              errorStr.contains('database locked') ||
              errorStr.contains('locked')) {
            
            print('Database locked on attempt $attempt/5: $e');
            
            if (attempt == 5) {
              // Last attempt failed, give up
              throw repo_exceptions.DatabaseException('Database remained locked after 5 attempts: $e');
            }
            
            // Exponential backoff with jitter (more robust than linear)
            final base = 100; // ms
            final exponentialWait = base * (1 << (attempt - 1)); // 100, 200, 400, 800
            final jitter = Random().nextInt(50); // 0-49ms random jitter
            final waitMs = exponentialWait + jitter;
            
            print('Waiting ${waitMs}ms before retry (exponential backoff)...');
            await Future.delayed(Duration(milliseconds: waitMs));
            continue;
          } else {
            // Non-lock error, don't retry
            print('Non-lock error, not retrying: $e');
            throw repo_exceptions.DatabaseException('Failed to update $tableName: $e');
          }
        }
      }
      
      // Should never reach here due to the loop logic above
      throw repo_exceptions.DatabaseException('Update failed after all retry attempts');
    });
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
    try {
      // Get a fresh database connection to avoid deadlocks
      final db = await _databaseManager.database;
      
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
      // If sync table doesn't exist or there's a deadlock, continue anyway
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