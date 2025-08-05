import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_manager.dart';
import '../../models/sync.dart';
import '../interfaces/repository_interfaces.dart';
import '../base_repository.dart';
import '../errors/repository_exceptions.dart';

/// Enhanced base repository with comprehensive sync awareness
/// This repository handles local-first operations with sync tracking, conflict resolution,
/// and background synchronization support
abstract class SyncAwareRepository<T> extends BaseRepository<T> implements ISyncAwareRepository<T> {
  final String _syncTableName;
  final String _conflictTableName = 'sync_conflicts';

  SyncAwareRepository(
    DatabaseManager databaseManager,
    String tableName,
  ) : _syncTableName = 'sync_status',
      super(databaseManager, tableName);

  /// Get pending sync operations for this repository
  @override
  Future<List<SyncStatus>> getPendingSyncOperations() async {
    final db = await database;
    try {
      final results = await db.query(
        _syncTableName,
        where: 'table_name = ? AND sync_status = ?',
        whereArgs: [tableName, 'pending'],
        orderBy: 'local_timestamp ASC',
      );

      return results.map((map) => SyncStatus.fromDatabase(map)).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to get pending sync operations: $e');
    }
  }

  /// Mark sync operation as completed
  @override
  Future<void> markSyncCompleted(String syncId, {DateTime? serverTimestamp}) async {
    final db = await database;
    try {
      await db.update(
        _syncTableName,
        {
          'sync_status': 'completed',
          'server_timestamp': serverTimestamp?.toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [syncId],
      );
    } catch (e) {
      throw GenericRepositoryException('Failed to mark sync as completed: $e');
    }
  }

  /// Mark sync operation as failed
  @override
  Future<void> markSyncFailed(String syncId, String errorMessage) async {
    final db = await database;
    try {
      await db.update(
        _syncTableName,
        {
          'sync_status': 'failed',
          'error_message': errorMessage,
          'retry_count': await _getRetryCount(syncId) + 1,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [syncId],
      );
    } catch (e) {
      throw GenericRepositoryException('Failed to mark sync as failed: $e');
    }
  }

  /// Get records that have been modified locally since last sync
  @override
  Future<List<T>> getModifiedSinceLastSync([DateTime? lastSyncTime]) async {
    final db = await database;
    try {
      String whereClause;
      List<Object?> whereArgs;
      
      if (lastSyncTime != null) {
        // Get records modified after last sync
        final syncIds = await db.query(
          _syncTableName,
          columns: ['record_id'],
          where: 'table_name = ? AND local_timestamp > ?',
          whereArgs: [tableName, lastSyncTime.toIso8601String()],
        );
        
        if (syncIds.isEmpty) return [];
        
        final recordIds = syncIds.map((row) => row['record_id'] as String).toList();
        whereClause = 'id IN (${recordIds.map((_) => '?').join(',')})';
        whereArgs = recordIds;
      } else {
        // Get all records that have been modified (have sync entries)
        final syncIds = await db.query(
          _syncTableName,
          columns: ['record_id'],
          where: 'table_name = ?',
          whereArgs: [tableName],
        );
        
        if (syncIds.isEmpty) return [];
        
        final recordIds = syncIds.map((row) => row['record_id'] as String).toList();
        whereClause = 'id IN (${recordIds.map((_) => '?').join(',')})';  
        whereArgs = recordIds;
      }

      final results = await db.query(
        tableName,
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: 'updated_at DESC',
      );

      return results.map((map) => fromDatabase(map)).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to get modified records: $e');
    }
  }

  /// Handle sync conflict with different resolution strategies
  @override
  Future<void> handleSyncConflict(SyncConflict conflict, String resolutionStrategy) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        switch (resolutionStrategy) {
          case 'local_wins':
            await _resolveConflictLocalWins(txn, conflict);
            break;
          case 'server_wins':
            await _resolveConflictServerWins(txn, conflict);
            break;
          case 'merge':
            await _resolveConflictMerge(txn, conflict);
            break;
          case 'manual':
            // Mark as requiring manual resolution
            await _markConflictForManualResolution(txn, conflict);
            return;
          default:
            throw GenericRepositoryException('Unknown conflict resolution strategy: $resolutionStrategy');
        }

        // Mark conflict as resolved
        await txn.update(
          _conflictTableName,
          {
            'resolution_strategy': resolutionStrategy,
            'resolved_at': DateTime.now().toIso8601String(),
            'resolved_by': 'system', // Could be user ID for manual resolution
          },
          where: 'id = ?',
          whereArgs: [conflict.id],
        );
      });
    } catch (e) {
      throw GenericRepositoryException('Failed to handle sync conflict: $e');
    }
  }

  /// Get sync conflicts for this repository
  @override
  Future<List<SyncConflict>> getSyncConflicts() async {
    final db = await database;
    try {
      final results = await db.query(
        _conflictTableName,
        where: 'table_name = ? AND resolved_at IS NULL',
        whereArgs: [tableName],
        orderBy: 'created_at ASC',
      );

      return results.map((map) => SyncConflict.fromDatabase(map)).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to get sync conflicts: $e');
    }
  }

  /// Force sync a specific record
  @override
  Future<void> forceSyncRecord(String recordId) async {
    final record = await getById(recordId);
    if (record == null) {
      throw GenericRepositoryException('Record not found: $recordId');
    }

    // Create a sync entry to force synchronization
    // TODO: Implement sync operation tracking
    print('Force sync requested for record: $recordId');
  }

  /// Get last successful sync timestamp
  @override
  Future<DateTime?> getLastSyncTimestamp() async {
    final db = await database;
    try {
      final result = await db.query(
        _syncTableName,
        columns: ['MAX(server_timestamp) as last_sync'],
        where: 'table_name = ? AND sync_status = ? AND server_timestamp IS NOT NULL',
        whereArgs: [tableName, 'completed'],
      );

      if (result.isEmpty || result.first['last_sync'] == null) {
        return null;
      }

      return DateTime.parse(result.first['last_sync'] as String);
    } catch (e) {
      throw GenericRepositoryException('Failed to get last sync timestamp: $e');
    }
  }

  /// Update last sync timestamp
  @override
  Future<void> updateLastSyncTimestamp(DateTime timestamp) async {
    // This could be stored in a separate table for repository-level sync tracking
    // For now, we'll use the sync_status table entries
    // Implementation would depend on specific sync architecture needs
  }

  /// Enhanced create with conflict detection
  @override
  Future<T> create(T model) async {
    final db = await database;
    final data = toDatabase(model);
    final id = getId(model);

    try {
      await db.transaction((txn) async {
        // Check for potential conflicts before creating
        await _checkForConflictsBeforeCreate(txn, id, data);
        
        await txn.insert(tableName, data);
        
        // Track for sync with enhanced metadata
        if (await _shouldTrackSync()) {
          await _trackSyncOperationEnhanced(txn, id, 'insert', data);
        }
      });

      return model;
    } catch (e) {
      throw GenericRepositoryException('Failed to create $tableName: $e');
    }
  }

  /// Enhanced update with conflict detection
  @override
  Future<T> update(T model) async {
    final db = await database;
    final data = toDatabase(model);
    final id = getId(model);

    try {
      await db.transaction((txn) async {
        // Get current version for conflict detection
        final currentRecord = await _getCurrentRecord(txn, id);
        if (currentRecord == null) {
          throw GenericRepositoryException('$tableName with id $id not found');
        }

        // Check for conflicts
        await _checkForConflictsBeforeUpdate(txn, id, currentRecord, data);

        final count = await txn.update(
          tableName,
          data,
          where: 'id = ?',
          whereArgs: [id],
        );

        if (count == 0) {
          throw GenericRepositoryException('$tableName with id $id not found');
        }

        // Track for sync with conflict detection metadata
        if (await _shouldTrackSync()) {
          await _trackSyncOperationEnhanced(txn, id, 'update', data, previousData: currentRecord);
        }
      });

      return model;
    } catch (e) {
      throw GenericRepositoryException('Failed to update $tableName: $e');
    }
  }

  /// Enhanced delete with conflict tracking
  @override
  Future<void> delete(String id) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        // Get current record for conflict tracking
        final currentRecord = await _getCurrentRecord(txn, id);
        if (currentRecord == null) {
          throw GenericRepositoryException('$tableName with id $id not found');
        }

        final count = await txn.delete(
          tableName,
          where: 'id = ?',
          whereArgs: [id],
        );

        if (count == 0) {
          throw GenericRepositoryException('$tableName with id $id not found');
        }

        // Track for sync with deletion metadata
        if (await _shouldTrackSync()) {
          await _trackSyncOperationEnhanced(txn, id, 'delete', {'id': id}, previousData: currentRecord);
        }
      });
    } catch (e) {
      throw GenericRepositoryException('Failed to delete $tableName: $e');
    }
  }

  /// Create sync conflict record
  Future<void> createSyncConflict({
    required String recordId,
    required Map<String, dynamic> localData,
    required Map<String, dynamic> serverData,
    required String conflictType,
  }) async {
    final db = await database;
    try {
      final conflict = SyncConflict(
        id: generateId(),
        tableName: tableName,
        recordId: recordId,
        localData: jsonEncode(localData),
        serverData: jsonEncode(serverData),
        conflictType: conflictType,
        createdAt: DateTime.now(),
      );

      await db.insert(_conflictTableName, conflict.toDatabase());
    } catch (e) {
      throw GenericRepositoryException('Failed to create sync conflict: $e');
    }
  }

  /// Private helper methods for sync operations

  Future<int> _getRetryCount(String syncId) async {
    final db = await database;
    final result = await db.query(
      _syncTableName,
      columns: ['retry_count'],
      where: 'id = ?',
      whereArgs: [syncId],
    );
    
    if (result.isEmpty) return 0;
    return result.first['retry_count'] as int? ?? 0;
  }

  Future<Map<String, dynamic>?> _getCurrentRecord(Transaction txn, String id) async {
    final results = await txn.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    
    return results.isEmpty ? null : results.first;
  }

  Future<void> _checkForConflictsBeforeCreate(
    Transaction txn,
    String id,
    Map<String, dynamic> data,
  ) async {
    // Check if record already exists (could indicate sync conflict)
    final existing = await _getCurrentRecord(txn, id);
    if (existing != null) {
      // Create conflict record for duplicate creation
      await createSyncConflict(
        recordId: id,
        localData: data,
        serverData: existing,
        conflictType: 'duplicate_create',
      );
      throw GenericRepositoryException('Conflict detected: Record already exists');
    }
  }

  Future<void> _checkForConflictsBeforeUpdate(
    Transaction txn,
    String id,
    Map<String, dynamic> currentRecord,
    Map<String, dynamic> newData,
  ) async {
    // Check for concurrent modifications
    final lastModified = currentRecord['updated_at'] as String?;
    if (lastModified != null) {
      final lastModifiedTime = DateTime.parse(lastModified);
      final recentSyncOps = await txn.query(
        _syncTableName,
        where: 'table_name = ? AND record_id = ? AND local_timestamp > ?',
        whereArgs: [tableName, id, lastModifiedTime.toIso8601String()],
      );

      if (recentSyncOps.isNotEmpty) {
        // Potential conflict - record was modified since last known state
        await createSyncConflict(
          recordId: id,
          localData: newData,
          serverData: currentRecord,
          conflictType: 'concurrent_modification',
        );
      }
    }
  }

  Future<void> _trackSyncOperationEnhanced(
    Transaction txn,
    String recordId,
    String operation,
    Map<String, dynamic> data, {
    Map<String, dynamic>? previousData,
  }) async {
    try {
      final syncRecord = SyncStatus(
        id: generateId(),
        tableName: tableName,
        recordId: recordId,
        operation: operation,
        localTimestamp: DateTime.now(),
        recordData: jsonEncode({
          'current': data,
          if (previousData != null) 'previous': previousData,
        }),
        createdAt: DateTime.now(),
      );

      await txn.insert(_syncTableName, syncRecord.toDatabase());
    } catch (e) {
      // Don't fail the main operation if sync tracking fails
      print('Warning: Failed to track sync operation: $e');
    }
  }

  /// Conflict resolution strategies

  Future<void> _resolveConflictLocalWins(Transaction txn, SyncConflict conflict) async {
    // Keep local version, mark server version as overridden
    final localData = jsonDecode(conflict.localData) as Map<String, dynamic>;
    
    await txn.update(
      tableName,
      localData,
      where: 'id = ?',
      whereArgs: [conflict.recordId],
    );

    // Create sync entry to push local version to server
    await _trackSyncOperationEnhanced(
      txn,
      conflict.recordId,
      'update',
      localData,
    );
  }

  Future<void> _resolveConflictServerWins(Transaction txn, SyncConflict conflict) async {
    // Accept server version, overwrite local
    final serverData = jsonDecode(conflict.serverData) as Map<String, dynamic>;
    
    await txn.update(
      tableName,
      serverData,
      where: 'id = ?',
      whereArgs: [conflict.recordId],
    );

    // No sync entry needed as we're accepting server version
  }

  Future<void> _resolveConflictMerge(Transaction txn, SyncConflict conflict) async {
    // Implement smart merge logic
    final localData = jsonDecode(conflict.localData) as Map<String, dynamic>;
    final serverData = jsonDecode(conflict.serverData) as Map<String, dynamic>;
    
    final mergedData = await _mergeConflictingData(localData, serverData);
    
    await txn.update(
      tableName,
      mergedData,
      where: 'id = ?',
      whereArgs: [conflict.recordId],
    );

    // Create sync entry to push merged version
    await _trackSyncOperationEnhanced(
      txn,
      conflict.recordId,
      'update',
      mergedData,
    );
  }

  Future<void> _markConflictForManualResolution(Transaction txn, SyncConflict conflict) async {
    // Update conflict record to indicate manual resolution needed
    await txn.update(
      _conflictTableName,
      {
        'resolution_strategy': 'manual',
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [conflict.id],
    );
  }

  /// Smart merge logic for conflicting data
  /// This is a basic implementation - can be enhanced with field-specific merge rules
  Future<Map<String, dynamic>> _mergeConflictingData(
    Map<String, dynamic> localData,
    Map<String, dynamic> serverData,
  ) async {
    final merged = Map<String, dynamic>.from(serverData);
    
    // Basic merge strategy: prefer local changes for certain fields
    final localPreferenceFields = ['name', 'description', 'notes'];
    
    for (final field in localPreferenceFields) {
      if (localData.containsKey(field) && localData[field] != null) {
        merged[field] = localData[field];
      }
    }
    
    // Always use the latest timestamp
    final localTimestamp = localData['updated_at'] as String?;
    final serverTimestamp = serverData['updated_at'] as String?;
    
    if (localTimestamp != null && serverTimestamp != null) {
      final localTime = DateTime.parse(localTimestamp);
      final serverTime = DateTime.parse(serverTimestamp);
      
      merged['updated_at'] = localTime.isAfter(serverTime) 
          ? localTimestamp 
          : serverTimestamp;
    }
    
    return merged;
  }

  /// Override to customize sync tracking per repository
  Future<bool> _shouldTrackSync() async {
    return true; // Can be overridden per repository type
  }
}