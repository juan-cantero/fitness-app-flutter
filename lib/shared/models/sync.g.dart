// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SyncStatusImpl _$$SyncStatusImplFromJson(Map<String, dynamic> json) =>
    _$SyncStatusImpl(
      id: json['id'] as String,
      tableName: json['tableName'] as String,
      recordId: json['recordId'] as String,
      operation: json['operation'] as String,
      localTimestamp: DateTime.parse(json['localTimestamp'] as String),
      serverTimestamp: json['serverTimestamp'] == null
          ? null
          : DateTime.parse(json['serverTimestamp'] as String),
      syncStatus: json['syncStatus'] as String? ?? 'pending',
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
      errorMessage: json['errorMessage'] as String?,
      recordData: json['recordData'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$SyncStatusImplToJson(_$SyncStatusImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tableName': instance.tableName,
      'recordId': instance.recordId,
      'operation': instance.operation,
      'localTimestamp': instance.localTimestamp.toIso8601String(),
      'serverTimestamp': instance.serverTimestamp?.toIso8601String(),
      'syncStatus': instance.syncStatus,
      'retryCount': instance.retryCount,
      'errorMessage': instance.errorMessage,
      'recordData': instance.recordData,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$SyncConflictImpl _$$SyncConflictImplFromJson(Map<String, dynamic> json) =>
    _$SyncConflictImpl(
      id: json['id'] as String,
      tableName: json['tableName'] as String,
      recordId: json['recordId'] as String,
      localData: json['localData'] as String,
      serverData: json['serverData'] as String,
      conflictType: json['conflictType'] as String,
      resolutionStrategy: json['resolutionStrategy'] as String?,
      resolvedAt: json['resolvedAt'] == null
          ? null
          : DateTime.parse(json['resolvedAt'] as String),
      resolvedBy: json['resolvedBy'] as String?,
      resolutionData: json['resolutionData'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SyncConflictImplToJson(_$SyncConflictImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tableName': instance.tableName,
      'recordId': instance.recordId,
      'localData': instance.localData,
      'serverData': instance.serverData,
      'conflictType': instance.conflictType,
      'resolutionStrategy': instance.resolutionStrategy,
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
      'resolvedBy': instance.resolvedBy,
      'resolutionData': instance.resolutionData,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
