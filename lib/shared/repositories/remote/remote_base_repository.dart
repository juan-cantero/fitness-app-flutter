import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/sync.dart';
import '../interfaces/repository_interfaces.dart';
import '../errors/repository_exceptions.dart';

/// Base class for remote Supabase repository implementations
/// Provides common functionality for all remote repositories
abstract class RemoteBaseRepository<T> implements ISyncAwareRepository<T> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String tableName;

  RemoteBaseRepository(this.tableName);

  /// Convert Supabase JSON to model
  T fromSupabaseJson(Map<String, dynamic> json);
  
  /// Convert model to Supabase JSON
  Map<String, dynamic> toSupabaseJson(T model);
  
  /// Extract ID from model
  String getId(T model);

  @override
  Future<T> create(T model) async {
    try {
      final response = await _supabase
          .from(tableName)
          .insert(toSupabaseJson(model))
          .select()
          .single();
      
      return fromSupabaseJson(response);
    } on PostgrestException catch (e) {
      throw GenericRepositoryException('Failed to create $tableName: ${e.message}');
    } catch (e) {
      throw GenericRepositoryException('Network error creating $tableName: $e');
    }
  }

  @override
  Future<List<T>> createBatch(List<T> models) async {
    if (models.isEmpty) return [];
    
    try {
      final response = await _supabase
          .from(tableName)
          .insert(models.map((m) => toSupabaseJson(m)).toList())
          .select();
      
      return response.map((json) => fromSupabaseJson(json)).toList();
    } on PostgrestException catch (e) {
      throw GenericRepositoryException('Failed to create batch $tableName: ${e.message}');
    } catch (e) {
      throw GenericRepositoryException('Network error creating batch $tableName: $e');
    }
  }

  @override
  Future<T?> getById(String id) async {
    try {
      final response = await _supabase
          .from(tableName)
          .select()
          .eq('id', id)
          .maybeSingle();
      
      return response != null ? fromSupabaseJson(response) : null;
    } on PostgrestException catch (e) {
      throw GenericRepositoryException('Failed to get $tableName by id: ${e.message}');
    } catch (e) {
      throw GenericRepositoryException('Network error getting $tableName: $e');
    }
  }

  @override
  Future<List<T>> getAll({String? orderBy, int? limit, int? offset}) async {
    try {
      dynamic query = _supabase.from(tableName).select();
      
      if (orderBy != null) {
        // Parse orderBy string (e.g., "name ASC" -> order by name ascending)
        final parts = orderBy.split(' ');
        final column = parts[0];
        final ascending = parts.length < 2 || parts[1].toUpperCase() != 'DESC';
        query = query.order(column, ascending: ascending);
      }
      
      if (offset != null && limit != null) {
        query = query.range(offset, offset + limit - 1);
      } else if (limit != null) {
        query = query.limit(limit);
      }
      
      final response = await query;
      return response.map((json) => fromSupabaseJson(json)).toList();
    } on PostgrestException catch (e) {
      throw GenericRepositoryException('Failed to get all $tableName: ${e.message}');
    } catch (e) {
      throw GenericRepositoryException('Network error getting all $tableName: $e');
    }
  }

  @override
  Future<T> update(T model) async {
    try {
      final response = await _supabase
          .from(tableName)
          .update(toSupabaseJson(model))
          .eq('id', getId(model))
          .select()
          .single();
      
      return fromSupabaseJson(response);
    } on PostgrestException catch (e) {
      throw GenericRepositoryException('Failed to update $tableName: ${e.message}');
    } catch (e) {
      throw GenericRepositoryException('Network error updating $tableName: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _supabase
          .from(tableName)
          .delete()
          .eq('id', id);
    } on PostgrestException catch (e) {
      throw GenericRepositoryException('Failed to delete $tableName: ${e.message}');
    } catch (e) {
      throw GenericRepositoryException('Network error deleting $tableName: $e');
    }
  }

  @override
  Future<void> deleteBatch(List<String> ids) async {
    if (ids.isEmpty) return;
    
    try {
      await _supabase
          .from(tableName)
          .delete()
          .inFilter('id', ids);
    } on PostgrestException catch (e) {
      throw GenericRepositoryException('Failed to delete batch $tableName: ${e.message}');
    } catch (e) {
      throw GenericRepositoryException('Network error deleting batch $tableName: $e');
    }
  }

  @override
  Future<bool> exists(String id) async {
    try {
      final response = await _supabase
          .from(tableName)
          .select('id')
          .eq('id', id)
          .maybeSingle();
      
      return response != null;
    } on PostgrestException catch (e) {
      throw GenericRepositoryException('Failed to check existence in $tableName: ${e.message}');
    } catch (e) {
      throw GenericRepositoryException('Network error checking existence in $tableName: $e');
    }
  }

  @override
  Future<int> count([String? where, List<Object?>? whereArgs]) async {
    try {
      var query = _supabase
          .from(tableName)
          .select('id');
      
      // Note: Supabase filters would need to be applied differently
      // This is a simplified implementation
      
      final response = await query;
      return response.length;
    } on PostgrestException catch (e) {
      throw GenericRepositoryException('Failed to count $tableName: ${e.message}');
    } catch (e) {
      throw GenericRepositoryException('Network error counting $tableName: $e');
    }
  }

  @override
  Future<List<T>> findWhere(
    String where,
    List<Object?> whereArgs, {
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    // Note: This is a placeholder implementation
    // Supabase uses a different query syntax than SQL WHERE clauses
    // Each repository should implement specific filtering methods
    throw UnimplementedError(
      'findWhere is not directly supported in remote repositories. '
      'Use specific filtering methods instead.'
    );
  }

  @override
  Future<List<T>> search(
    String query,
    List<String> searchFields, {
    String? additionalWhere,
    List<Object?>? additionalWhereArgs,
    String? orderBy,
    int? limit,
  }) async {
    try {
      dynamic supabaseQuery = _supabase.from(tableName).select();
      
      // Implement full-text search if available
      // This would require setting up text search in Supabase
      if (query.isNotEmpty) {
        // Simple implementation - would need proper text search setup
        supabaseQuery = supabaseQuery.textSearch('search_vector', query);
      }
      
      if (limit != null) {
        supabaseQuery = supabaseQuery.limit(limit);
      }
      
      final response = await supabaseQuery;
      return response.map((json) => fromSupabaseJson(json)).toList();
    } on PostgrestException catch (e) {
      throw GenericRepositoryException('Failed to search $tableName: ${e.message}');
    } catch (e) {
      throw GenericRepositoryException('Network error searching $tableName: $e');
    }
  }

  @override
  Future<R> transaction<R>(Future<R> Function(Transaction txn) action) async {
    // Supabase doesn't have client-side transactions in the same way
    // This would typically be handled by database functions or RPC calls
    throw UnimplementedError(
      'Client-side transactions are not supported in Supabase. '
      'Use database functions or RPC for complex operations.'
    );
  }

  // Sync-aware methods (simplified for remote repositories)
  @override
  Future<List<SyncStatus>> getPendingSyncOperations() async {
    // Remote repositories don't track sync operations locally
    return [];
  }

  @override
  Future<void> markSyncCompleted(String syncId, {DateTime? serverTimestamp}) async {
    // No-op for remote repositories
  }

  @override
  Future<void> markSyncFailed(String syncId, String errorMessage) async {
    // No-op for remote repositories
  }

  @override
  Future<List<T>> getModifiedSinceLastSync([DateTime? lastSyncTime]) async {
    if (lastSyncTime == null) {
      return getAll();
    }
    
    try {
      final response = await _supabase
          .from(tableName)
          .select()
          .gte('updated_at', lastSyncTime.toIso8601String());
      
      return response.map((json) => fromSupabaseJson(json)).toList();
    } on PostgrestException catch (e) {
      throw GenericRepositoryException('Failed to get modified records: ${e.message}');
    } catch (e) {
      throw GenericRepositoryException('Network error getting modified records: $e');
    }
  }

  @override
  Future<void> handleSyncConflict(SyncConflict conflict, String resolutionStrategy) async {
    // Server-side conflict resolution would be handled differently
    throw UnimplementedError('Server-side conflict resolution not implemented');
  }

  @override
  Future<List<SyncConflict>> getSyncConflicts() async {
    // Remote repositories would typically not have local conflicts
    return [];
  }

  @override
  Future<void> forceSyncRecord(String recordId) async {
    // For remote repositories, this might trigger a cache refresh
    // or force a re-fetch from the server
  }

  @override
  Future<DateTime?> getLastSyncTimestamp() async {
    // This would typically be stored in sync metadata
    return null;
  }

  @override
  Future<void> updateLastSyncTimestamp(DateTime timestamp) async {
    // This would typically update sync metadata
  }

  /// Get real-time subscription for table changes
  RealtimeChannel subscribeToChanges({
    void Function(Map<String, dynamic>)? onInsert,
    void Function(Map<String, dynamic>)? onUpdate,
    void Function(Map<String, dynamic>)? onDelete,
  }) {
    final channel = _supabase.channel('$tableName-changes');
    
    if (onInsert != null) {
      channel.onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: tableName,
        callback: (payload) => onInsert(payload.newRecord),
      );
    }
    
    if (onUpdate != null) {
      channel.onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: tableName,
        callback: (payload) => onUpdate(payload.newRecord),
      );
    }
    
    if (onDelete != null) {
      channel.onPostgresChanges(
        event: PostgresChangeEvent.delete,
        schema: 'public',
        table: tableName,
        callback: (payload) => onDelete(payload.oldRecord),
      );
    }
    
    channel.subscribe();
    return channel;
  }
}

/// Repository exception for remote operations
class RepositoryException implements Exception {
  final String message;
  const RepositoryException(this.message);
  
  @override
  String toString() => 'RepositoryException: $message';
}