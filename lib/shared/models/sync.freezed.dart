// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SyncStatus _$SyncStatusFromJson(Map<String, dynamic> json) {
  return _SyncStatus.fromJson(json);
}

/// @nodoc
mixin _$SyncStatus {
  String get id => throw _privateConstructorUsedError;
  String get tableName => throw _privateConstructorUsedError;
  String get recordId => throw _privateConstructorUsedError;
  String get operation => throw _privateConstructorUsedError;
  DateTime get localTimestamp => throw _privateConstructorUsedError;
  DateTime? get serverTimestamp => throw _privateConstructorUsedError;
  String get syncStatus => throw _privateConstructorUsedError;
  int get retryCount => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  String? get recordData => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SyncStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncStatusCopyWith<SyncStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncStatusCopyWith<$Res> {
  factory $SyncStatusCopyWith(
    SyncStatus value,
    $Res Function(SyncStatus) then,
  ) = _$SyncStatusCopyWithImpl<$Res, SyncStatus>;
  @useResult
  $Res call({
    String id,
    String tableName,
    String recordId,
    String operation,
    DateTime localTimestamp,
    DateTime? serverTimestamp,
    String syncStatus,
    int retryCount,
    String? errorMessage,
    String? recordData,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$SyncStatusCopyWithImpl<$Res, $Val extends SyncStatus>
    implements $SyncStatusCopyWith<$Res> {
  _$SyncStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tableName = null,
    Object? recordId = null,
    Object? operation = null,
    Object? localTimestamp = null,
    Object? serverTimestamp = freezed,
    Object? syncStatus = null,
    Object? retryCount = null,
    Object? errorMessage = freezed,
    Object? recordData = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            tableName: null == tableName
                ? _value.tableName
                : tableName // ignore: cast_nullable_to_non_nullable
                      as String,
            recordId: null == recordId
                ? _value.recordId
                : recordId // ignore: cast_nullable_to_non_nullable
                      as String,
            operation: null == operation
                ? _value.operation
                : operation // ignore: cast_nullable_to_non_nullable
                      as String,
            localTimestamp: null == localTimestamp
                ? _value.localTimestamp
                : localTimestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            serverTimestamp: freezed == serverTimestamp
                ? _value.serverTimestamp
                : serverTimestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            syncStatus: null == syncStatus
                ? _value.syncStatus
                : syncStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            retryCount: null == retryCount
                ? _value.retryCount
                : retryCount // ignore: cast_nullable_to_non_nullable
                      as int,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            recordData: freezed == recordData
                ? _value.recordData
                : recordData // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SyncStatusImplCopyWith<$Res>
    implements $SyncStatusCopyWith<$Res> {
  factory _$$SyncStatusImplCopyWith(
    _$SyncStatusImpl value,
    $Res Function(_$SyncStatusImpl) then,
  ) = __$$SyncStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String tableName,
    String recordId,
    String operation,
    DateTime localTimestamp,
    DateTime? serverTimestamp,
    String syncStatus,
    int retryCount,
    String? errorMessage,
    String? recordData,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$SyncStatusImplCopyWithImpl<$Res>
    extends _$SyncStatusCopyWithImpl<$Res, _$SyncStatusImpl>
    implements _$$SyncStatusImplCopyWith<$Res> {
  __$$SyncStatusImplCopyWithImpl(
    _$SyncStatusImpl _value,
    $Res Function(_$SyncStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tableName = null,
    Object? recordId = null,
    Object? operation = null,
    Object? localTimestamp = null,
    Object? serverTimestamp = freezed,
    Object? syncStatus = null,
    Object? retryCount = null,
    Object? errorMessage = freezed,
    Object? recordData = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$SyncStatusImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        tableName: null == tableName
            ? _value.tableName
            : tableName // ignore: cast_nullable_to_non_nullable
                  as String,
        recordId: null == recordId
            ? _value.recordId
            : recordId // ignore: cast_nullable_to_non_nullable
                  as String,
        operation: null == operation
            ? _value.operation
            : operation // ignore: cast_nullable_to_non_nullable
                  as String,
        localTimestamp: null == localTimestamp
            ? _value.localTimestamp
            : localTimestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        serverTimestamp: freezed == serverTimestamp
            ? _value.serverTimestamp
            : serverTimestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        syncStatus: null == syncStatus
            ? _value.syncStatus
            : syncStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        retryCount: null == retryCount
            ? _value.retryCount
            : retryCount // ignore: cast_nullable_to_non_nullable
                  as int,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        recordData: freezed == recordData
            ? _value.recordData
            : recordData // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SyncStatusImpl implements _SyncStatus {
  const _$SyncStatusImpl({
    required this.id,
    required this.tableName,
    required this.recordId,
    required this.operation,
    required this.localTimestamp,
    this.serverTimestamp,
    this.syncStatus = 'pending',
    this.retryCount = 0,
    this.errorMessage,
    this.recordData,
    this.createdAt,
    this.updatedAt,
  });

  factory _$SyncStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncStatusImplFromJson(json);

  @override
  final String id;
  @override
  final String tableName;
  @override
  final String recordId;
  @override
  final String operation;
  @override
  final DateTime localTimestamp;
  @override
  final DateTime? serverTimestamp;
  @override
  @JsonKey()
  final String syncStatus;
  @override
  @JsonKey()
  final int retryCount;
  @override
  final String? errorMessage;
  @override
  final String? recordData;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'SyncStatus(id: $id, tableName: $tableName, recordId: $recordId, operation: $operation, localTimestamp: $localTimestamp, serverTimestamp: $serverTimestamp, syncStatus: $syncStatus, retryCount: $retryCount, errorMessage: $errorMessage, recordData: $recordData, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncStatusImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tableName, tableName) ||
                other.tableName == tableName) &&
            (identical(other.recordId, recordId) ||
                other.recordId == recordId) &&
            (identical(other.operation, operation) ||
                other.operation == operation) &&
            (identical(other.localTimestamp, localTimestamp) ||
                other.localTimestamp == localTimestamp) &&
            (identical(other.serverTimestamp, serverTimestamp) ||
                other.serverTimestamp == serverTimestamp) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.retryCount, retryCount) ||
                other.retryCount == retryCount) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.recordData, recordData) ||
                other.recordData == recordData) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    tableName,
    recordId,
    operation,
    localTimestamp,
    serverTimestamp,
    syncStatus,
    retryCount,
    errorMessage,
    recordData,
    createdAt,
    updatedAt,
  );

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncStatusImplCopyWith<_$SyncStatusImpl> get copyWith =>
      __$$SyncStatusImplCopyWithImpl<_$SyncStatusImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncStatusImplToJson(this);
  }
}

abstract class _SyncStatus implements SyncStatus {
  const factory _SyncStatus({
    required final String id,
    required final String tableName,
    required final String recordId,
    required final String operation,
    required final DateTime localTimestamp,
    final DateTime? serverTimestamp,
    final String syncStatus,
    final int retryCount,
    final String? errorMessage,
    final String? recordData,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$SyncStatusImpl;

  factory _SyncStatus.fromJson(Map<String, dynamic> json) =
      _$SyncStatusImpl.fromJson;

  @override
  String get id;
  @override
  String get tableName;
  @override
  String get recordId;
  @override
  String get operation;
  @override
  DateTime get localTimestamp;
  @override
  DateTime? get serverTimestamp;
  @override
  String get syncStatus;
  @override
  int get retryCount;
  @override
  String? get errorMessage;
  @override
  String? get recordData;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncStatusImplCopyWith<_$SyncStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SyncConflict _$SyncConflictFromJson(Map<String, dynamic> json) {
  return _SyncConflict.fromJson(json);
}

/// @nodoc
mixin _$SyncConflict {
  String get id => throw _privateConstructorUsedError;
  String get tableName => throw _privateConstructorUsedError;
  String get recordId => throw _privateConstructorUsedError;
  String get localData => throw _privateConstructorUsedError;
  String get serverData => throw _privateConstructorUsedError;
  String get conflictType => throw _privateConstructorUsedError;
  String? get resolutionStrategy => throw _privateConstructorUsedError;
  DateTime? get resolvedAt => throw _privateConstructorUsedError;
  String? get resolvedBy => throw _privateConstructorUsedError;
  String? get resolutionData => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SyncConflict to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SyncConflict
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncConflictCopyWith<SyncConflict> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncConflictCopyWith<$Res> {
  factory $SyncConflictCopyWith(
    SyncConflict value,
    $Res Function(SyncConflict) then,
  ) = _$SyncConflictCopyWithImpl<$Res, SyncConflict>;
  @useResult
  $Res call({
    String id,
    String tableName,
    String recordId,
    String localData,
    String serverData,
    String conflictType,
    String? resolutionStrategy,
    DateTime? resolvedAt,
    String? resolvedBy,
    String? resolutionData,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$SyncConflictCopyWithImpl<$Res, $Val extends SyncConflict>
    implements $SyncConflictCopyWith<$Res> {
  _$SyncConflictCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncConflict
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tableName = null,
    Object? recordId = null,
    Object? localData = null,
    Object? serverData = null,
    Object? conflictType = null,
    Object? resolutionStrategy = freezed,
    Object? resolvedAt = freezed,
    Object? resolvedBy = freezed,
    Object? resolutionData = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            tableName: null == tableName
                ? _value.tableName
                : tableName // ignore: cast_nullable_to_non_nullable
                      as String,
            recordId: null == recordId
                ? _value.recordId
                : recordId // ignore: cast_nullable_to_non_nullable
                      as String,
            localData: null == localData
                ? _value.localData
                : localData // ignore: cast_nullable_to_non_nullable
                      as String,
            serverData: null == serverData
                ? _value.serverData
                : serverData // ignore: cast_nullable_to_non_nullable
                      as String,
            conflictType: null == conflictType
                ? _value.conflictType
                : conflictType // ignore: cast_nullable_to_non_nullable
                      as String,
            resolutionStrategy: freezed == resolutionStrategy
                ? _value.resolutionStrategy
                : resolutionStrategy // ignore: cast_nullable_to_non_nullable
                      as String?,
            resolvedAt: freezed == resolvedAt
                ? _value.resolvedAt
                : resolvedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            resolvedBy: freezed == resolvedBy
                ? _value.resolvedBy
                : resolvedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            resolutionData: freezed == resolutionData
                ? _value.resolutionData
                : resolutionData // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SyncConflictImplCopyWith<$Res>
    implements $SyncConflictCopyWith<$Res> {
  factory _$$SyncConflictImplCopyWith(
    _$SyncConflictImpl value,
    $Res Function(_$SyncConflictImpl) then,
  ) = __$$SyncConflictImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String tableName,
    String recordId,
    String localData,
    String serverData,
    String conflictType,
    String? resolutionStrategy,
    DateTime? resolvedAt,
    String? resolvedBy,
    String? resolutionData,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$SyncConflictImplCopyWithImpl<$Res>
    extends _$SyncConflictCopyWithImpl<$Res, _$SyncConflictImpl>
    implements _$$SyncConflictImplCopyWith<$Res> {
  __$$SyncConflictImplCopyWithImpl(
    _$SyncConflictImpl _value,
    $Res Function(_$SyncConflictImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncConflict
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tableName = null,
    Object? recordId = null,
    Object? localData = null,
    Object? serverData = null,
    Object? conflictType = null,
    Object? resolutionStrategy = freezed,
    Object? resolvedAt = freezed,
    Object? resolvedBy = freezed,
    Object? resolutionData = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$SyncConflictImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        tableName: null == tableName
            ? _value.tableName
            : tableName // ignore: cast_nullable_to_non_nullable
                  as String,
        recordId: null == recordId
            ? _value.recordId
            : recordId // ignore: cast_nullable_to_non_nullable
                  as String,
        localData: null == localData
            ? _value.localData
            : localData // ignore: cast_nullable_to_non_nullable
                  as String,
        serverData: null == serverData
            ? _value.serverData
            : serverData // ignore: cast_nullable_to_non_nullable
                  as String,
        conflictType: null == conflictType
            ? _value.conflictType
            : conflictType // ignore: cast_nullable_to_non_nullable
                  as String,
        resolutionStrategy: freezed == resolutionStrategy
            ? _value.resolutionStrategy
            : resolutionStrategy // ignore: cast_nullable_to_non_nullable
                  as String?,
        resolvedAt: freezed == resolvedAt
            ? _value.resolvedAt
            : resolvedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        resolvedBy: freezed == resolvedBy
            ? _value.resolvedBy
            : resolvedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        resolutionData: freezed == resolutionData
            ? _value.resolutionData
            : resolutionData // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SyncConflictImpl implements _SyncConflict {
  const _$SyncConflictImpl({
    required this.id,
    required this.tableName,
    required this.recordId,
    required this.localData,
    required this.serverData,
    required this.conflictType,
    this.resolutionStrategy,
    this.resolvedAt,
    this.resolvedBy,
    this.resolutionData,
    this.createdAt,
  });

  factory _$SyncConflictImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncConflictImplFromJson(json);

  @override
  final String id;
  @override
  final String tableName;
  @override
  final String recordId;
  @override
  final String localData;
  @override
  final String serverData;
  @override
  final String conflictType;
  @override
  final String? resolutionStrategy;
  @override
  final DateTime? resolvedAt;
  @override
  final String? resolvedBy;
  @override
  final String? resolutionData;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'SyncConflict(id: $id, tableName: $tableName, recordId: $recordId, localData: $localData, serverData: $serverData, conflictType: $conflictType, resolutionStrategy: $resolutionStrategy, resolvedAt: $resolvedAt, resolvedBy: $resolvedBy, resolutionData: $resolutionData, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncConflictImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tableName, tableName) ||
                other.tableName == tableName) &&
            (identical(other.recordId, recordId) ||
                other.recordId == recordId) &&
            (identical(other.localData, localData) ||
                other.localData == localData) &&
            (identical(other.serverData, serverData) ||
                other.serverData == serverData) &&
            (identical(other.conflictType, conflictType) ||
                other.conflictType == conflictType) &&
            (identical(other.resolutionStrategy, resolutionStrategy) ||
                other.resolutionStrategy == resolutionStrategy) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt) &&
            (identical(other.resolvedBy, resolvedBy) ||
                other.resolvedBy == resolvedBy) &&
            (identical(other.resolutionData, resolutionData) ||
                other.resolutionData == resolutionData) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    tableName,
    recordId,
    localData,
    serverData,
    conflictType,
    resolutionStrategy,
    resolvedAt,
    resolvedBy,
    resolutionData,
    createdAt,
  );

  /// Create a copy of SyncConflict
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncConflictImplCopyWith<_$SyncConflictImpl> get copyWith =>
      __$$SyncConflictImplCopyWithImpl<_$SyncConflictImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncConflictImplToJson(this);
  }
}

abstract class _SyncConflict implements SyncConflict {
  const factory _SyncConflict({
    required final String id,
    required final String tableName,
    required final String recordId,
    required final String localData,
    required final String serverData,
    required final String conflictType,
    final String? resolutionStrategy,
    final DateTime? resolvedAt,
    final String? resolvedBy,
    final String? resolutionData,
    final DateTime? createdAt,
  }) = _$SyncConflictImpl;

  factory _SyncConflict.fromJson(Map<String, dynamic> json) =
      _$SyncConflictImpl.fromJson;

  @override
  String get id;
  @override
  String get tableName;
  @override
  String get recordId;
  @override
  String get localData;
  @override
  String get serverData;
  @override
  String get conflictType;
  @override
  String? get resolutionStrategy;
  @override
  DateTime? get resolvedAt;
  @override
  String? get resolvedBy;
  @override
  String? get resolutionData;
  @override
  DateTime? get createdAt;

  /// Create a copy of SyncConflict
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncConflictImplCopyWith<_$SyncConflictImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
