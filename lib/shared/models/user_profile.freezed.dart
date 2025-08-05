// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  DateTime? get dateOfBirth => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  int? get heightCm => throw _privateConstructorUsedError;
  double? get weightKg => throw _privateConstructorUsedError;
  String get fitnessLevel => throw _privateConstructorUsedError;
  List<String> get fitnessGoals => throw _privateConstructorUsedError;
  String get activityLevel => throw _privateConstructorUsedError;
  String get preferredUnits => throw _privateConstructorUsedError;
  String get timezone => throw _privateConstructorUsedError;
  bool get isPublic => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
    UserProfile value,
    $Res Function(UserProfile) then,
  ) = _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call({
    String id,
    String userId,
    String? displayName,
    String? avatarUrl,
    String? bio,
    DateTime? dateOfBirth,
    String? gender,
    int? heightCm,
    double? weightKg,
    String fitnessLevel,
    List<String> fitnessGoals,
    String activityLevel,
    String preferredUnits,
    String timezone,
    bool isPublic,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? displayName = freezed,
    Object? avatarUrl = freezed,
    Object? bio = freezed,
    Object? dateOfBirth = freezed,
    Object? gender = freezed,
    Object? heightCm = freezed,
    Object? weightKg = freezed,
    Object? fitnessLevel = null,
    Object? fitnessGoals = null,
    Object? activityLevel = null,
    Object? preferredUnits = null,
    Object? timezone = null,
    Object? isPublic = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String?,
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            bio: freezed == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as String?,
            dateOfBirth: freezed == dateOfBirth
                ? _value.dateOfBirth
                : dateOfBirth // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            gender: freezed == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as String?,
            heightCm: freezed == heightCm
                ? _value.heightCm
                : heightCm // ignore: cast_nullable_to_non_nullable
                      as int?,
            weightKg: freezed == weightKg
                ? _value.weightKg
                : weightKg // ignore: cast_nullable_to_non_nullable
                      as double?,
            fitnessLevel: null == fitnessLevel
                ? _value.fitnessLevel
                : fitnessLevel // ignore: cast_nullable_to_non_nullable
                      as String,
            fitnessGoals: null == fitnessGoals
                ? _value.fitnessGoals
                : fitnessGoals // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            activityLevel: null == activityLevel
                ? _value.activityLevel
                : activityLevel // ignore: cast_nullable_to_non_nullable
                      as String,
            preferredUnits: null == preferredUnits
                ? _value.preferredUnits
                : preferredUnits // ignore: cast_nullable_to_non_nullable
                      as String,
            timezone: null == timezone
                ? _value.timezone
                : timezone // ignore: cast_nullable_to_non_nullable
                      as String,
            isPublic: null == isPublic
                ? _value.isPublic
                : isPublic // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
    _$UserProfileImpl value,
    $Res Function(_$UserProfileImpl) then,
  ) = __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String? displayName,
    String? avatarUrl,
    String? bio,
    DateTime? dateOfBirth,
    String? gender,
    int? heightCm,
    double? weightKg,
    String fitnessLevel,
    List<String> fitnessGoals,
    String activityLevel,
    String preferredUnits,
    String timezone,
    bool isPublic,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
    _$UserProfileImpl _value,
    $Res Function(_$UserProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? displayName = freezed,
    Object? avatarUrl = freezed,
    Object? bio = freezed,
    Object? dateOfBirth = freezed,
    Object? gender = freezed,
    Object? heightCm = freezed,
    Object? weightKg = freezed,
    Object? fitnessLevel = null,
    Object? fitnessGoals = null,
    Object? activityLevel = null,
    Object? preferredUnits = null,
    Object? timezone = null,
    Object? isPublic = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$UserProfileImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: freezed == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        bio: freezed == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as String?,
        dateOfBirth: freezed == dateOfBirth
            ? _value.dateOfBirth
            : dateOfBirth // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        gender: freezed == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as String?,
        heightCm: freezed == heightCm
            ? _value.heightCm
            : heightCm // ignore: cast_nullable_to_non_nullable
                  as int?,
        weightKg: freezed == weightKg
            ? _value.weightKg
            : weightKg // ignore: cast_nullable_to_non_nullable
                  as double?,
        fitnessLevel: null == fitnessLevel
            ? _value.fitnessLevel
            : fitnessLevel // ignore: cast_nullable_to_non_nullable
                  as String,
        fitnessGoals: null == fitnessGoals
            ? _value._fitnessGoals
            : fitnessGoals // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        activityLevel: null == activityLevel
            ? _value.activityLevel
            : activityLevel // ignore: cast_nullable_to_non_nullable
                  as String,
        preferredUnits: null == preferredUnits
            ? _value.preferredUnits
            : preferredUnits // ignore: cast_nullable_to_non_nullable
                  as String,
        timezone: null == timezone
            ? _value.timezone
            : timezone // ignore: cast_nullable_to_non_nullable
                  as String,
        isPublic: null == isPublic
            ? _value.isPublic
            : isPublic // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl({
    required this.id,
    required this.userId,
    this.displayName,
    this.avatarUrl,
    this.bio,
    this.dateOfBirth,
    this.gender,
    this.heightCm,
    this.weightKg,
    this.fitnessLevel = 'beginner',
    final List<String> fitnessGoals = const [],
    this.activityLevel = 'moderately_active',
    this.preferredUnits = 'metric',
    this.timezone = 'UTC',
    this.isPublic = false,
    this.createdAt,
    this.updatedAt,
  }) : _fitnessGoals = fitnessGoals;

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? displayName;
  @override
  final String? avatarUrl;
  @override
  final String? bio;
  @override
  final DateTime? dateOfBirth;
  @override
  final String? gender;
  @override
  final int? heightCm;
  @override
  final double? weightKg;
  @override
  @JsonKey()
  final String fitnessLevel;
  final List<String> _fitnessGoals;
  @override
  @JsonKey()
  List<String> get fitnessGoals {
    if (_fitnessGoals is EqualUnmodifiableListView) return _fitnessGoals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fitnessGoals);
  }

  @override
  @JsonKey()
  final String activityLevel;
  @override
  @JsonKey()
  final String preferredUnits;
  @override
  @JsonKey()
  final String timezone;
  @override
  @JsonKey()
  final bool isPublic;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UserProfile(id: $id, userId: $userId, displayName: $displayName, avatarUrl: $avatarUrl, bio: $bio, dateOfBirth: $dateOfBirth, gender: $gender, heightCm: $heightCm, weightKg: $weightKg, fitnessLevel: $fitnessLevel, fitnessGoals: $fitnessGoals, activityLevel: $activityLevel, preferredUnits: $preferredUnits, timezone: $timezone, isPublic: $isPublic, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.heightCm, heightCm) ||
                other.heightCm == heightCm) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.fitnessLevel, fitnessLevel) ||
                other.fitnessLevel == fitnessLevel) &&
            const DeepCollectionEquality().equals(
              other._fitnessGoals,
              _fitnessGoals,
            ) &&
            (identical(other.activityLevel, activityLevel) ||
                other.activityLevel == activityLevel) &&
            (identical(other.preferredUnits, preferredUnits) ||
                other.preferredUnits == preferredUnits) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
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
    userId,
    displayName,
    avatarUrl,
    bio,
    dateOfBirth,
    gender,
    heightCm,
    weightKg,
    fitnessLevel,
    const DeepCollectionEquality().hash(_fitnessGoals),
    activityLevel,
    preferredUnits,
    timezone,
    isPublic,
    createdAt,
    updatedAt,
  );

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(this);
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile({
    required final String id,
    required final String userId,
    final String? displayName,
    final String? avatarUrl,
    final String? bio,
    final DateTime? dateOfBirth,
    final String? gender,
    final int? heightCm,
    final double? weightKg,
    final String fitnessLevel,
    final List<String> fitnessGoals,
    final String activityLevel,
    final String preferredUnits,
    final String timezone,
    final bool isPublic,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get displayName;
  @override
  String? get avatarUrl;
  @override
  String? get bio;
  @override
  DateTime? get dateOfBirth;
  @override
  String? get gender;
  @override
  int? get heightCm;
  @override
  double? get weightKg;
  @override
  String get fitnessLevel;
  @override
  List<String> get fitnessGoals;
  @override
  String get activityLevel;
  @override
  String get preferredUnits;
  @override
  String get timezone;
  @override
  bool get isPublic;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserProgress _$UserProgressFromJson(Map<String, dynamic> json) {
  return _UserProgress.fromJson(json);
}

/// @nodoc
mixin _$UserProgress {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get metricType => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  DateTime get measuredAt => throw _privateConstructorUsedError;
  String? get measurementMethod => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this UserProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProgressCopyWith<UserProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProgressCopyWith<$Res> {
  factory $UserProgressCopyWith(
    UserProgress value,
    $Res Function(UserProgress) then,
  ) = _$UserProgressCopyWithImpl<$Res, UserProgress>;
  @useResult
  $Res call({
    String id,
    String userId,
    String metricType,
    double value,
    String unit,
    DateTime measuredAt,
    String? measurementMethod,
    String? notes,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$UserProgressCopyWithImpl<$Res, $Val extends UserProgress>
    implements $UserProgressCopyWith<$Res> {
  _$UserProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? metricType = null,
    Object? value = null,
    Object? unit = null,
    Object? measuredAt = null,
    Object? measurementMethod = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            metricType: null == metricType
                ? _value.metricType
                : metricType // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as double,
            unit: null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String,
            measuredAt: null == measuredAt
                ? _value.measuredAt
                : measuredAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            measurementMethod: freezed == measurementMethod
                ? _value.measurementMethod
                : measurementMethod // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
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
abstract class _$$UserProgressImplCopyWith<$Res>
    implements $UserProgressCopyWith<$Res> {
  factory _$$UserProgressImplCopyWith(
    _$UserProgressImpl value,
    $Res Function(_$UserProgressImpl) then,
  ) = __$$UserProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String metricType,
    double value,
    String unit,
    DateTime measuredAt,
    String? measurementMethod,
    String? notes,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$UserProgressImplCopyWithImpl<$Res>
    extends _$UserProgressCopyWithImpl<$Res, _$UserProgressImpl>
    implements _$$UserProgressImplCopyWith<$Res> {
  __$$UserProgressImplCopyWithImpl(
    _$UserProgressImpl _value,
    $Res Function(_$UserProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? metricType = null,
    Object? value = null,
    Object? unit = null,
    Object? measuredAt = null,
    Object? measurementMethod = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$UserProgressImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        metricType: null == metricType
            ? _value.metricType
            : metricType // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
        unit: null == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
        measuredAt: null == measuredAt
            ? _value.measuredAt
            : measuredAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        measurementMethod: freezed == measurementMethod
            ? _value.measurementMethod
            : measurementMethod // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
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
class _$UserProgressImpl implements _UserProgress {
  const _$UserProgressImpl({
    required this.id,
    required this.userId,
    required this.metricType,
    required this.value,
    required this.unit,
    required this.measuredAt,
    this.measurementMethod,
    this.notes,
    this.createdAt,
  });

  factory _$UserProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProgressImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String metricType;
  @override
  final double value;
  @override
  final String unit;
  @override
  final DateTime measuredAt;
  @override
  final String? measurementMethod;
  @override
  final String? notes;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'UserProgress(id: $id, userId: $userId, metricType: $metricType, value: $value, unit: $unit, measuredAt: $measuredAt, measurementMethod: $measurementMethod, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProgressImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.metricType, metricType) ||
                other.metricType == metricType) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.measuredAt, measuredAt) ||
                other.measuredAt == measuredAt) &&
            (identical(other.measurementMethod, measurementMethod) ||
                other.measurementMethod == measurementMethod) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    metricType,
    value,
    unit,
    measuredAt,
    measurementMethod,
    notes,
    createdAt,
  );

  /// Create a copy of UserProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProgressImplCopyWith<_$UserProgressImpl> get copyWith =>
      __$$UserProgressImplCopyWithImpl<_$UserProgressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProgressImplToJson(this);
  }
}

abstract class _UserProgress implements UserProgress {
  const factory _UserProgress({
    required final String id,
    required final String userId,
    required final String metricType,
    required final double value,
    required final String unit,
    required final DateTime measuredAt,
    final String? measurementMethod,
    final String? notes,
    final DateTime? createdAt,
  }) = _$UserProgressImpl;

  factory _UserProgress.fromJson(Map<String, dynamic> json) =
      _$UserProgressImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get metricType;
  @override
  double get value;
  @override
  String get unit;
  @override
  DateTime get measuredAt;
  @override
  String? get measurementMethod;
  @override
  String? get notes;
  @override
  DateTime? get createdAt;

  /// Create a copy of UserProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProgressImplCopyWith<_$UserProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
