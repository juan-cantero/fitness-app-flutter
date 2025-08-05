import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync.freezed.dart';
part 'sync.g.dart';

@freezed
class SyncStatus with _$SyncStatus {
  const factory SyncStatus({
    required String id,
    required String tableName,
    required String recordId,
    required String operation,
    required DateTime localTimestamp,
    DateTime? serverTimestamp,
    @Default('pending') String syncStatus,
    @Default(0) int retryCount,
    String? errorMessage,
    String? recordData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _SyncStatus;

  factory SyncStatus.fromJson(Map<String, dynamic> json) =>
      _$SyncStatusFromJson(json);

  factory SyncStatus.fromDatabase(Map<String, dynamic> map) {
    return SyncStatus(
      id: map['id'] as String,
      tableName: map['table_name'] as String,
      recordId: map['record_id'] as String,
      operation: map['operation'] as String,
      localTimestamp: DateTime.parse(map['local_timestamp'] as String),
      serverTimestamp: map['server_timestamp'] != null
          ? DateTime.parse(map['server_timestamp'] as String)
          : null,
      syncStatus: map['sync_status'] as String? ?? 'pending',
      retryCount: map['retry_count'] as int? ?? 0,
      errorMessage: map['error_message'] as String?,
      recordData: map['record_data'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

}

@freezed
class SyncConflict with _$SyncConflict {
  const factory SyncConflict({
    required String id,
    required String tableName,
    required String recordId,
    required String localData,
    required String serverData,
    required String conflictType,
    String? resolutionStrategy,
    DateTime? resolvedAt,
    String? resolvedBy,
    String? resolutionData,
    DateTime? createdAt,
  }) = _SyncConflict;

  factory SyncConflict.fromJson(Map<String, dynamic> json) =>
      _$SyncConflictFromJson(json);

  factory SyncConflict.fromDatabase(Map<String, dynamic> map) {
    return SyncConflict(
      id: map['id'] as String,
      tableName: map['table_name'] as String,
      recordId: map['record_id'] as String,
      localData: map['local_data'] as String,
      serverData: map['server_data'] as String,
      conflictType: map['conflict_type'] as String,
      resolutionStrategy: map['resolution_strategy'] as String?,
      resolvedAt: map['resolved_at'] != null
          ? DateTime.parse(map['resolved_at'] as String)
          : null,
      resolvedBy: map['resolved_by'] as String?,
      resolutionData: map['resolution_data'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
    );
  }

}

extension SyncStatusDatabase on SyncStatus {
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'table_name': tableName,
      'record_id': recordId,
      'operation': operation,
      'local_timestamp': localTimestamp.toIso8601String(),
      'server_timestamp': serverTimestamp?.toIso8601String(),
      'sync_status': syncStatus,
      'retry_count': retryCount,
      'error_message': errorMessage,
      'record_data': recordData,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

extension SyncConflictDatabase on SyncConflict {
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'table_name': tableName,
      'record_id': recordId,
      'local_data': localData,
      'server_data': serverData,
      'conflict_type': conflictType,
      'resolution_strategy': resolutionStrategy,
      'resolved_at': resolvedAt?.toIso8601String(),
      'resolved_by': resolvedBy,
      'resolution_data': resolutionData,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}