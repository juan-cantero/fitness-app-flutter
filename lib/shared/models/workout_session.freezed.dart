// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WorkoutSession _$WorkoutSessionFromJson(Map<String, dynamic> json) {
  return _WorkoutSession.fromJson(json);
}

/// @nodoc
mixin _$WorkoutSession {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get workoutId => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime? get endedAt => throw _privateConstructorUsedError;
  int? get durationMinutes => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get weatherConditions => throw _privateConstructorUsedError;
  int? get energyLevelStart => throw _privateConstructorUsedError;
  int? get energyLevelEnd => throw _privateConstructorUsedError;
  int? get perceivedExertion => throw _privateConstructorUsedError;
  String? get moodBefore => throw _privateConstructorUsedError;
  String? get moodAfter => throw _privateConstructorUsedError;
  int? get caloriesBurned => throw _privateConstructorUsedError;
  int? get heartRateAvg => throw _privateConstructorUsedError;
  int? get heartRateMax => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  int? get workoutRating => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError; // Related data
  Workout? get workout => throw _privateConstructorUsedError;
  List<ExerciseLog> get exerciseLogs => throw _privateConstructorUsedError;

  /// Serializes this WorkoutSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutSessionCopyWith<WorkoutSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutSessionCopyWith<$Res> {
  factory $WorkoutSessionCopyWith(
    WorkoutSession value,
    $Res Function(WorkoutSession) then,
  ) = _$WorkoutSessionCopyWithImpl<$Res, WorkoutSession>;
  @useResult
  $Res call({
    String id,
    String userId,
    String? workoutId,
    String? name,
    DateTime startedAt,
    DateTime? completedAt,
    DateTime? endedAt,
    int? durationMinutes,
    String status,
    String? location,
    String? weatherConditions,
    int? energyLevelStart,
    int? energyLevelEnd,
    int? perceivedExertion,
    String? moodBefore,
    String? moodAfter,
    int? caloriesBurned,
    int? heartRateAvg,
    int? heartRateMax,
    String? notes,
    int? workoutRating,
    DateTime? createdAt,
    DateTime? updatedAt,
    Workout? workout,
    List<ExerciseLog> exerciseLogs,
  });

  $WorkoutCopyWith<$Res>? get workout;
}

/// @nodoc
class _$WorkoutSessionCopyWithImpl<$Res, $Val extends WorkoutSession>
    implements $WorkoutSessionCopyWith<$Res> {
  _$WorkoutSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? workoutId = freezed,
    Object? name = freezed,
    Object? startedAt = null,
    Object? completedAt = freezed,
    Object? endedAt = freezed,
    Object? durationMinutes = freezed,
    Object? status = null,
    Object? location = freezed,
    Object? weatherConditions = freezed,
    Object? energyLevelStart = freezed,
    Object? energyLevelEnd = freezed,
    Object? perceivedExertion = freezed,
    Object? moodBefore = freezed,
    Object? moodAfter = freezed,
    Object? caloriesBurned = freezed,
    Object? heartRateAvg = freezed,
    Object? heartRateMax = freezed,
    Object? notes = freezed,
    Object? workoutRating = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? workout = freezed,
    Object? exerciseLogs = null,
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
            workoutId: freezed == workoutId
                ? _value.workoutId
                : workoutId // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            startedAt: null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            endedAt: freezed == endedAt
                ? _value.endedAt
                : endedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            durationMinutes: freezed == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            weatherConditions: freezed == weatherConditions
                ? _value.weatherConditions
                : weatherConditions // ignore: cast_nullable_to_non_nullable
                      as String?,
            energyLevelStart: freezed == energyLevelStart
                ? _value.energyLevelStart
                : energyLevelStart // ignore: cast_nullable_to_non_nullable
                      as int?,
            energyLevelEnd: freezed == energyLevelEnd
                ? _value.energyLevelEnd
                : energyLevelEnd // ignore: cast_nullable_to_non_nullable
                      as int?,
            perceivedExertion: freezed == perceivedExertion
                ? _value.perceivedExertion
                : perceivedExertion // ignore: cast_nullable_to_non_nullable
                      as int?,
            moodBefore: freezed == moodBefore
                ? _value.moodBefore
                : moodBefore // ignore: cast_nullable_to_non_nullable
                      as String?,
            moodAfter: freezed == moodAfter
                ? _value.moodAfter
                : moodAfter // ignore: cast_nullable_to_non_nullable
                      as String?,
            caloriesBurned: freezed == caloriesBurned
                ? _value.caloriesBurned
                : caloriesBurned // ignore: cast_nullable_to_non_nullable
                      as int?,
            heartRateAvg: freezed == heartRateAvg
                ? _value.heartRateAvg
                : heartRateAvg // ignore: cast_nullable_to_non_nullable
                      as int?,
            heartRateMax: freezed == heartRateMax
                ? _value.heartRateMax
                : heartRateMax // ignore: cast_nullable_to_non_nullable
                      as int?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            workoutRating: freezed == workoutRating
                ? _value.workoutRating
                : workoutRating // ignore: cast_nullable_to_non_nullable
                      as int?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            workout: freezed == workout
                ? _value.workout
                : workout // ignore: cast_nullable_to_non_nullable
                      as Workout?,
            exerciseLogs: null == exerciseLogs
                ? _value.exerciseLogs
                : exerciseLogs // ignore: cast_nullable_to_non_nullable
                      as List<ExerciseLog>,
          )
          as $Val,
    );
  }

  /// Create a copy of WorkoutSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkoutCopyWith<$Res>? get workout {
    if (_value.workout == null) {
      return null;
    }

    return $WorkoutCopyWith<$Res>(_value.workout!, (value) {
      return _then(_value.copyWith(workout: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WorkoutSessionImplCopyWith<$Res>
    implements $WorkoutSessionCopyWith<$Res> {
  factory _$$WorkoutSessionImplCopyWith(
    _$WorkoutSessionImpl value,
    $Res Function(_$WorkoutSessionImpl) then,
  ) = __$$WorkoutSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String? workoutId,
    String? name,
    DateTime startedAt,
    DateTime? completedAt,
    DateTime? endedAt,
    int? durationMinutes,
    String status,
    String? location,
    String? weatherConditions,
    int? energyLevelStart,
    int? energyLevelEnd,
    int? perceivedExertion,
    String? moodBefore,
    String? moodAfter,
    int? caloriesBurned,
    int? heartRateAvg,
    int? heartRateMax,
    String? notes,
    int? workoutRating,
    DateTime? createdAt,
    DateTime? updatedAt,
    Workout? workout,
    List<ExerciseLog> exerciseLogs,
  });

  @override
  $WorkoutCopyWith<$Res>? get workout;
}

/// @nodoc
class __$$WorkoutSessionImplCopyWithImpl<$Res>
    extends _$WorkoutSessionCopyWithImpl<$Res, _$WorkoutSessionImpl>
    implements _$$WorkoutSessionImplCopyWith<$Res> {
  __$$WorkoutSessionImplCopyWithImpl(
    _$WorkoutSessionImpl _value,
    $Res Function(_$WorkoutSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkoutSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? workoutId = freezed,
    Object? name = freezed,
    Object? startedAt = null,
    Object? completedAt = freezed,
    Object? endedAt = freezed,
    Object? durationMinutes = freezed,
    Object? status = null,
    Object? location = freezed,
    Object? weatherConditions = freezed,
    Object? energyLevelStart = freezed,
    Object? energyLevelEnd = freezed,
    Object? perceivedExertion = freezed,
    Object? moodBefore = freezed,
    Object? moodAfter = freezed,
    Object? caloriesBurned = freezed,
    Object? heartRateAvg = freezed,
    Object? heartRateMax = freezed,
    Object? notes = freezed,
    Object? workoutRating = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? workout = freezed,
    Object? exerciseLogs = null,
  }) {
    return _then(
      _$WorkoutSessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        workoutId: freezed == workoutId
            ? _value.workoutId
            : workoutId // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        startedAt: null == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endedAt: freezed == endedAt
            ? _value.endedAt
            : endedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        durationMinutes: freezed == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        weatherConditions: freezed == weatherConditions
            ? _value.weatherConditions
            : weatherConditions // ignore: cast_nullable_to_non_nullable
                  as String?,
        energyLevelStart: freezed == energyLevelStart
            ? _value.energyLevelStart
            : energyLevelStart // ignore: cast_nullable_to_non_nullable
                  as int?,
        energyLevelEnd: freezed == energyLevelEnd
            ? _value.energyLevelEnd
            : energyLevelEnd // ignore: cast_nullable_to_non_nullable
                  as int?,
        perceivedExertion: freezed == perceivedExertion
            ? _value.perceivedExertion
            : perceivedExertion // ignore: cast_nullable_to_non_nullable
                  as int?,
        moodBefore: freezed == moodBefore
            ? _value.moodBefore
            : moodBefore // ignore: cast_nullable_to_non_nullable
                  as String?,
        moodAfter: freezed == moodAfter
            ? _value.moodAfter
            : moodAfter // ignore: cast_nullable_to_non_nullable
                  as String?,
        caloriesBurned: freezed == caloriesBurned
            ? _value.caloriesBurned
            : caloriesBurned // ignore: cast_nullable_to_non_nullable
                  as int?,
        heartRateAvg: freezed == heartRateAvg
            ? _value.heartRateAvg
            : heartRateAvg // ignore: cast_nullable_to_non_nullable
                  as int?,
        heartRateMax: freezed == heartRateMax
            ? _value.heartRateMax
            : heartRateMax // ignore: cast_nullable_to_non_nullable
                  as int?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        workoutRating: freezed == workoutRating
            ? _value.workoutRating
            : workoutRating // ignore: cast_nullable_to_non_nullable
                  as int?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        workout: freezed == workout
            ? _value.workout
            : workout // ignore: cast_nullable_to_non_nullable
                  as Workout?,
        exerciseLogs: null == exerciseLogs
            ? _value._exerciseLogs
            : exerciseLogs // ignore: cast_nullable_to_non_nullable
                  as List<ExerciseLog>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutSessionImpl implements _WorkoutSession {
  const _$WorkoutSessionImpl({
    required this.id,
    required this.userId,
    this.workoutId,
    this.name,
    required this.startedAt,
    this.completedAt,
    this.endedAt,
    this.durationMinutes,
    this.status = 'planned',
    this.location,
    this.weatherConditions,
    this.energyLevelStart,
    this.energyLevelEnd,
    this.perceivedExertion,
    this.moodBefore,
    this.moodAfter,
    this.caloriesBurned,
    this.heartRateAvg,
    this.heartRateMax,
    this.notes,
    this.workoutRating,
    this.createdAt,
    this.updatedAt,
    this.workout,
    final List<ExerciseLog> exerciseLogs = const [],
  }) : _exerciseLogs = exerciseLogs;

  factory _$WorkoutSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? workoutId;
  @override
  final String? name;
  @override
  final DateTime startedAt;
  @override
  final DateTime? completedAt;
  @override
  final DateTime? endedAt;
  @override
  final int? durationMinutes;
  @override
  @JsonKey()
  final String status;
  @override
  final String? location;
  @override
  final String? weatherConditions;
  @override
  final int? energyLevelStart;
  @override
  final int? energyLevelEnd;
  @override
  final int? perceivedExertion;
  @override
  final String? moodBefore;
  @override
  final String? moodAfter;
  @override
  final int? caloriesBurned;
  @override
  final int? heartRateAvg;
  @override
  final int? heartRateMax;
  @override
  final String? notes;
  @override
  final int? workoutRating;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  // Related data
  @override
  final Workout? workout;
  final List<ExerciseLog> _exerciseLogs;
  @override
  @JsonKey()
  List<ExerciseLog> get exerciseLogs {
    if (_exerciseLogs is EqualUnmodifiableListView) return _exerciseLogs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exerciseLogs);
  }

  @override
  String toString() {
    return 'WorkoutSession(id: $id, userId: $userId, workoutId: $workoutId, name: $name, startedAt: $startedAt, completedAt: $completedAt, endedAt: $endedAt, durationMinutes: $durationMinutes, status: $status, location: $location, weatherConditions: $weatherConditions, energyLevelStart: $energyLevelStart, energyLevelEnd: $energyLevelEnd, perceivedExertion: $perceivedExertion, moodBefore: $moodBefore, moodAfter: $moodAfter, caloriesBurned: $caloriesBurned, heartRateAvg: $heartRateAvg, heartRateMax: $heartRateMax, notes: $notes, workoutRating: $workoutRating, createdAt: $createdAt, updatedAt: $updatedAt, workout: $workout, exerciseLogs: $exerciseLogs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.workoutId, workoutId) ||
                other.workoutId == workoutId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.weatherConditions, weatherConditions) ||
                other.weatherConditions == weatherConditions) &&
            (identical(other.energyLevelStart, energyLevelStart) ||
                other.energyLevelStart == energyLevelStart) &&
            (identical(other.energyLevelEnd, energyLevelEnd) ||
                other.energyLevelEnd == energyLevelEnd) &&
            (identical(other.perceivedExertion, perceivedExertion) ||
                other.perceivedExertion == perceivedExertion) &&
            (identical(other.moodBefore, moodBefore) ||
                other.moodBefore == moodBefore) &&
            (identical(other.moodAfter, moodAfter) ||
                other.moodAfter == moodAfter) &&
            (identical(other.caloriesBurned, caloriesBurned) ||
                other.caloriesBurned == caloriesBurned) &&
            (identical(other.heartRateAvg, heartRateAvg) ||
                other.heartRateAvg == heartRateAvg) &&
            (identical(other.heartRateMax, heartRateMax) ||
                other.heartRateMax == heartRateMax) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.workoutRating, workoutRating) ||
                other.workoutRating == workoutRating) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.workout, workout) || other.workout == workout) &&
            const DeepCollectionEquality().equals(
              other._exerciseLogs,
              _exerciseLogs,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    userId,
    workoutId,
    name,
    startedAt,
    completedAt,
    endedAt,
    durationMinutes,
    status,
    location,
    weatherConditions,
    energyLevelStart,
    energyLevelEnd,
    perceivedExertion,
    moodBefore,
    moodAfter,
    caloriesBurned,
    heartRateAvg,
    heartRateMax,
    notes,
    workoutRating,
    createdAt,
    updatedAt,
    workout,
    const DeepCollectionEquality().hash(_exerciseLogs),
  ]);

  /// Create a copy of WorkoutSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutSessionImplCopyWith<_$WorkoutSessionImpl> get copyWith =>
      __$$WorkoutSessionImplCopyWithImpl<_$WorkoutSessionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutSessionImplToJson(this);
  }
}

abstract class _WorkoutSession implements WorkoutSession {
  const factory _WorkoutSession({
    required final String id,
    required final String userId,
    final String? workoutId,
    final String? name,
    required final DateTime startedAt,
    final DateTime? completedAt,
    final DateTime? endedAt,
    final int? durationMinutes,
    final String status,
    final String? location,
    final String? weatherConditions,
    final int? energyLevelStart,
    final int? energyLevelEnd,
    final int? perceivedExertion,
    final String? moodBefore,
    final String? moodAfter,
    final int? caloriesBurned,
    final int? heartRateAvg,
    final int? heartRateMax,
    final String? notes,
    final int? workoutRating,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final Workout? workout,
    final List<ExerciseLog> exerciseLogs,
  }) = _$WorkoutSessionImpl;

  factory _WorkoutSession.fromJson(Map<String, dynamic> json) =
      _$WorkoutSessionImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get workoutId;
  @override
  String? get name;
  @override
  DateTime get startedAt;
  @override
  DateTime? get completedAt;
  @override
  DateTime? get endedAt;
  @override
  int? get durationMinutes;
  @override
  String get status;
  @override
  String? get location;
  @override
  String? get weatherConditions;
  @override
  int? get energyLevelStart;
  @override
  int? get energyLevelEnd;
  @override
  int? get perceivedExertion;
  @override
  String? get moodBefore;
  @override
  String? get moodAfter;
  @override
  int? get caloriesBurned;
  @override
  int? get heartRateAvg;
  @override
  int? get heartRateMax;
  @override
  String? get notes;
  @override
  int? get workoutRating;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt; // Related data
  @override
  Workout? get workout;
  @override
  List<ExerciseLog> get exerciseLogs;

  /// Create a copy of WorkoutSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutSessionImplCopyWith<_$WorkoutSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExerciseLog _$ExerciseLogFromJson(Map<String, dynamic> json) {
  return _ExerciseLog.fromJson(json);
}

/// @nodoc
mixin _$ExerciseLog {
  String get id => throw _privateConstructorUsedError;
  String get workoutSessionId => throw _privateConstructorUsedError;
  String get exerciseId => throw _privateConstructorUsedError;
  String? get workoutExerciseId => throw _privateConstructorUsedError;
  int get orderIndex => throw _privateConstructorUsedError;
  int get setsCompleted => throw _privateConstructorUsedError;
  int get setsPlanned => throw _privateConstructorUsedError;
  int? get repsCompleted => throw _privateConstructorUsedError;
  int? get repsPlanned => throw _privateConstructorUsedError;
  double? get weightKg => throw _privateConstructorUsedError;
  int? get durationSeconds => throw _privateConstructorUsedError;
  double? get distanceMeters => throw _privateConstructorUsedError;
  int? get restTimeSeconds => throw _privateConstructorUsedError;
  double? get intensityPercentage => throw _privateConstructorUsedError;
  int? get rpe => throw _privateConstructorUsedError;
  int? get formRating => throw _privateConstructorUsedError;
  List<String> get equipmentUsed => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  bool get isPersonalRecord => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  double? get previousBestWeight => throw _privateConstructorUsedError;
  int? get previousBestReps => throw _privateConstructorUsedError;
  int? get previousBestDuration => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError; // Related data
  Exercise? get exercise => throw _privateConstructorUsedError;

  /// Serializes this ExerciseLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExerciseLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExerciseLogCopyWith<ExerciseLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseLogCopyWith<$Res> {
  factory $ExerciseLogCopyWith(
    ExerciseLog value,
    $Res Function(ExerciseLog) then,
  ) = _$ExerciseLogCopyWithImpl<$Res, ExerciseLog>;
  @useResult
  $Res call({
    String id,
    String workoutSessionId,
    String exerciseId,
    String? workoutExerciseId,
    int orderIndex,
    int setsCompleted,
    int setsPlanned,
    int? repsCompleted,
    int? repsPlanned,
    double? weightKg,
    int? durationSeconds,
    double? distanceMeters,
    int? restTimeSeconds,
    double? intensityPercentage,
    int? rpe,
    int? formRating,
    List<String> equipmentUsed,
    String? notes,
    bool isPersonalRecord,
    bool isCompleted,
    double? previousBestWeight,
    int? previousBestReps,
    int? previousBestDuration,
    DateTime? createdAt,
    DateTime? updatedAt,
    Exercise? exercise,
  });

  $ExerciseCopyWith<$Res>? get exercise;
}

/// @nodoc
class _$ExerciseLogCopyWithImpl<$Res, $Val extends ExerciseLog>
    implements $ExerciseLogCopyWith<$Res> {
  _$ExerciseLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExerciseLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workoutSessionId = null,
    Object? exerciseId = null,
    Object? workoutExerciseId = freezed,
    Object? orderIndex = null,
    Object? setsCompleted = null,
    Object? setsPlanned = null,
    Object? repsCompleted = freezed,
    Object? repsPlanned = freezed,
    Object? weightKg = freezed,
    Object? durationSeconds = freezed,
    Object? distanceMeters = freezed,
    Object? restTimeSeconds = freezed,
    Object? intensityPercentage = freezed,
    Object? rpe = freezed,
    Object? formRating = freezed,
    Object? equipmentUsed = null,
    Object? notes = freezed,
    Object? isPersonalRecord = null,
    Object? isCompleted = null,
    Object? previousBestWeight = freezed,
    Object? previousBestReps = freezed,
    Object? previousBestDuration = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? exercise = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            workoutSessionId: null == workoutSessionId
                ? _value.workoutSessionId
                : workoutSessionId // ignore: cast_nullable_to_non_nullable
                      as String,
            exerciseId: null == exerciseId
                ? _value.exerciseId
                : exerciseId // ignore: cast_nullable_to_non_nullable
                      as String,
            workoutExerciseId: freezed == workoutExerciseId
                ? _value.workoutExerciseId
                : workoutExerciseId // ignore: cast_nullable_to_non_nullable
                      as String?,
            orderIndex: null == orderIndex
                ? _value.orderIndex
                : orderIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            setsCompleted: null == setsCompleted
                ? _value.setsCompleted
                : setsCompleted // ignore: cast_nullable_to_non_nullable
                      as int,
            setsPlanned: null == setsPlanned
                ? _value.setsPlanned
                : setsPlanned // ignore: cast_nullable_to_non_nullable
                      as int,
            repsCompleted: freezed == repsCompleted
                ? _value.repsCompleted
                : repsCompleted // ignore: cast_nullable_to_non_nullable
                      as int?,
            repsPlanned: freezed == repsPlanned
                ? _value.repsPlanned
                : repsPlanned // ignore: cast_nullable_to_non_nullable
                      as int?,
            weightKg: freezed == weightKg
                ? _value.weightKg
                : weightKg // ignore: cast_nullable_to_non_nullable
                      as double?,
            durationSeconds: freezed == durationSeconds
                ? _value.durationSeconds
                : durationSeconds // ignore: cast_nullable_to_non_nullable
                      as int?,
            distanceMeters: freezed == distanceMeters
                ? _value.distanceMeters
                : distanceMeters // ignore: cast_nullable_to_non_nullable
                      as double?,
            restTimeSeconds: freezed == restTimeSeconds
                ? _value.restTimeSeconds
                : restTimeSeconds // ignore: cast_nullable_to_non_nullable
                      as int?,
            intensityPercentage: freezed == intensityPercentage
                ? _value.intensityPercentage
                : intensityPercentage // ignore: cast_nullable_to_non_nullable
                      as double?,
            rpe: freezed == rpe
                ? _value.rpe
                : rpe // ignore: cast_nullable_to_non_nullable
                      as int?,
            formRating: freezed == formRating
                ? _value.formRating
                : formRating // ignore: cast_nullable_to_non_nullable
                      as int?,
            equipmentUsed: null == equipmentUsed
                ? _value.equipmentUsed
                : equipmentUsed // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            isPersonalRecord: null == isPersonalRecord
                ? _value.isPersonalRecord
                : isPersonalRecord // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            previousBestWeight: freezed == previousBestWeight
                ? _value.previousBestWeight
                : previousBestWeight // ignore: cast_nullable_to_non_nullable
                      as double?,
            previousBestReps: freezed == previousBestReps
                ? _value.previousBestReps
                : previousBestReps // ignore: cast_nullable_to_non_nullable
                      as int?,
            previousBestDuration: freezed == previousBestDuration
                ? _value.previousBestDuration
                : previousBestDuration // ignore: cast_nullable_to_non_nullable
                      as int?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            exercise: freezed == exercise
                ? _value.exercise
                : exercise // ignore: cast_nullable_to_non_nullable
                      as Exercise?,
          )
          as $Val,
    );
  }

  /// Create a copy of ExerciseLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExerciseCopyWith<$Res>? get exercise {
    if (_value.exercise == null) {
      return null;
    }

    return $ExerciseCopyWith<$Res>(_value.exercise!, (value) {
      return _then(_value.copyWith(exercise: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ExerciseLogImplCopyWith<$Res>
    implements $ExerciseLogCopyWith<$Res> {
  factory _$$ExerciseLogImplCopyWith(
    _$ExerciseLogImpl value,
    $Res Function(_$ExerciseLogImpl) then,
  ) = __$$ExerciseLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String workoutSessionId,
    String exerciseId,
    String? workoutExerciseId,
    int orderIndex,
    int setsCompleted,
    int setsPlanned,
    int? repsCompleted,
    int? repsPlanned,
    double? weightKg,
    int? durationSeconds,
    double? distanceMeters,
    int? restTimeSeconds,
    double? intensityPercentage,
    int? rpe,
    int? formRating,
    List<String> equipmentUsed,
    String? notes,
    bool isPersonalRecord,
    bool isCompleted,
    double? previousBestWeight,
    int? previousBestReps,
    int? previousBestDuration,
    DateTime? createdAt,
    DateTime? updatedAt,
    Exercise? exercise,
  });

  @override
  $ExerciseCopyWith<$Res>? get exercise;
}

/// @nodoc
class __$$ExerciseLogImplCopyWithImpl<$Res>
    extends _$ExerciseLogCopyWithImpl<$Res, _$ExerciseLogImpl>
    implements _$$ExerciseLogImplCopyWith<$Res> {
  __$$ExerciseLogImplCopyWithImpl(
    _$ExerciseLogImpl _value,
    $Res Function(_$ExerciseLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExerciseLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workoutSessionId = null,
    Object? exerciseId = null,
    Object? workoutExerciseId = freezed,
    Object? orderIndex = null,
    Object? setsCompleted = null,
    Object? setsPlanned = null,
    Object? repsCompleted = freezed,
    Object? repsPlanned = freezed,
    Object? weightKg = freezed,
    Object? durationSeconds = freezed,
    Object? distanceMeters = freezed,
    Object? restTimeSeconds = freezed,
    Object? intensityPercentage = freezed,
    Object? rpe = freezed,
    Object? formRating = freezed,
    Object? equipmentUsed = null,
    Object? notes = freezed,
    Object? isPersonalRecord = null,
    Object? isCompleted = null,
    Object? previousBestWeight = freezed,
    Object? previousBestReps = freezed,
    Object? previousBestDuration = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? exercise = freezed,
  }) {
    return _then(
      _$ExerciseLogImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        workoutSessionId: null == workoutSessionId
            ? _value.workoutSessionId
            : workoutSessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        exerciseId: null == exerciseId
            ? _value.exerciseId
            : exerciseId // ignore: cast_nullable_to_non_nullable
                  as String,
        workoutExerciseId: freezed == workoutExerciseId
            ? _value.workoutExerciseId
            : workoutExerciseId // ignore: cast_nullable_to_non_nullable
                  as String?,
        orderIndex: null == orderIndex
            ? _value.orderIndex
            : orderIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        setsCompleted: null == setsCompleted
            ? _value.setsCompleted
            : setsCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
        setsPlanned: null == setsPlanned
            ? _value.setsPlanned
            : setsPlanned // ignore: cast_nullable_to_non_nullable
                  as int,
        repsCompleted: freezed == repsCompleted
            ? _value.repsCompleted
            : repsCompleted // ignore: cast_nullable_to_non_nullable
                  as int?,
        repsPlanned: freezed == repsPlanned
            ? _value.repsPlanned
            : repsPlanned // ignore: cast_nullable_to_non_nullable
                  as int?,
        weightKg: freezed == weightKg
            ? _value.weightKg
            : weightKg // ignore: cast_nullable_to_non_nullable
                  as double?,
        durationSeconds: freezed == durationSeconds
            ? _value.durationSeconds
            : durationSeconds // ignore: cast_nullable_to_non_nullable
                  as int?,
        distanceMeters: freezed == distanceMeters
            ? _value.distanceMeters
            : distanceMeters // ignore: cast_nullable_to_non_nullable
                  as double?,
        restTimeSeconds: freezed == restTimeSeconds
            ? _value.restTimeSeconds
            : restTimeSeconds // ignore: cast_nullable_to_non_nullable
                  as int?,
        intensityPercentage: freezed == intensityPercentage
            ? _value.intensityPercentage
            : intensityPercentage // ignore: cast_nullable_to_non_nullable
                  as double?,
        rpe: freezed == rpe
            ? _value.rpe
            : rpe // ignore: cast_nullable_to_non_nullable
                  as int?,
        formRating: freezed == formRating
            ? _value.formRating
            : formRating // ignore: cast_nullable_to_non_nullable
                  as int?,
        equipmentUsed: null == equipmentUsed
            ? _value._equipmentUsed
            : equipmentUsed // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        isPersonalRecord: null == isPersonalRecord
            ? _value.isPersonalRecord
            : isPersonalRecord // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        previousBestWeight: freezed == previousBestWeight
            ? _value.previousBestWeight
            : previousBestWeight // ignore: cast_nullable_to_non_nullable
                  as double?,
        previousBestReps: freezed == previousBestReps
            ? _value.previousBestReps
            : previousBestReps // ignore: cast_nullable_to_non_nullable
                  as int?,
        previousBestDuration: freezed == previousBestDuration
            ? _value.previousBestDuration
            : previousBestDuration // ignore: cast_nullable_to_non_nullable
                  as int?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        exercise: freezed == exercise
            ? _value.exercise
            : exercise // ignore: cast_nullable_to_non_nullable
                  as Exercise?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExerciseLogImpl implements _ExerciseLog {
  const _$ExerciseLogImpl({
    required this.id,
    required this.workoutSessionId,
    required this.exerciseId,
    this.workoutExerciseId,
    required this.orderIndex,
    this.setsCompleted = 0,
    this.setsPlanned = 1,
    this.repsCompleted,
    this.repsPlanned,
    this.weightKg,
    this.durationSeconds,
    this.distanceMeters,
    this.restTimeSeconds,
    this.intensityPercentage,
    this.rpe,
    this.formRating,
    final List<String> equipmentUsed = const [],
    this.notes,
    this.isPersonalRecord = false,
    this.isCompleted = false,
    this.previousBestWeight,
    this.previousBestReps,
    this.previousBestDuration,
    this.createdAt,
    this.updatedAt,
    this.exercise,
  }) : _equipmentUsed = equipmentUsed;

  factory _$ExerciseLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExerciseLogImplFromJson(json);

  @override
  final String id;
  @override
  final String workoutSessionId;
  @override
  final String exerciseId;
  @override
  final String? workoutExerciseId;
  @override
  final int orderIndex;
  @override
  @JsonKey()
  final int setsCompleted;
  @override
  @JsonKey()
  final int setsPlanned;
  @override
  final int? repsCompleted;
  @override
  final int? repsPlanned;
  @override
  final double? weightKg;
  @override
  final int? durationSeconds;
  @override
  final double? distanceMeters;
  @override
  final int? restTimeSeconds;
  @override
  final double? intensityPercentage;
  @override
  final int? rpe;
  @override
  final int? formRating;
  final List<String> _equipmentUsed;
  @override
  @JsonKey()
  List<String> get equipmentUsed {
    if (_equipmentUsed is EqualUnmodifiableListView) return _equipmentUsed;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_equipmentUsed);
  }

  @override
  final String? notes;
  @override
  @JsonKey()
  final bool isPersonalRecord;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  final double? previousBestWeight;
  @override
  final int? previousBestReps;
  @override
  final int? previousBestDuration;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  // Related data
  @override
  final Exercise? exercise;

  @override
  String toString() {
    return 'ExerciseLog(id: $id, workoutSessionId: $workoutSessionId, exerciseId: $exerciseId, workoutExerciseId: $workoutExerciseId, orderIndex: $orderIndex, setsCompleted: $setsCompleted, setsPlanned: $setsPlanned, repsCompleted: $repsCompleted, repsPlanned: $repsPlanned, weightKg: $weightKg, durationSeconds: $durationSeconds, distanceMeters: $distanceMeters, restTimeSeconds: $restTimeSeconds, intensityPercentage: $intensityPercentage, rpe: $rpe, formRating: $formRating, equipmentUsed: $equipmentUsed, notes: $notes, isPersonalRecord: $isPersonalRecord, isCompleted: $isCompleted, previousBestWeight: $previousBestWeight, previousBestReps: $previousBestReps, previousBestDuration: $previousBestDuration, createdAt: $createdAt, updatedAt: $updatedAt, exercise: $exercise)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workoutSessionId, workoutSessionId) ||
                other.workoutSessionId == workoutSessionId) &&
            (identical(other.exerciseId, exerciseId) ||
                other.exerciseId == exerciseId) &&
            (identical(other.workoutExerciseId, workoutExerciseId) ||
                other.workoutExerciseId == workoutExerciseId) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            (identical(other.setsCompleted, setsCompleted) ||
                other.setsCompleted == setsCompleted) &&
            (identical(other.setsPlanned, setsPlanned) ||
                other.setsPlanned == setsPlanned) &&
            (identical(other.repsCompleted, repsCompleted) ||
                other.repsCompleted == repsCompleted) &&
            (identical(other.repsPlanned, repsPlanned) ||
                other.repsPlanned == repsPlanned) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            (identical(other.distanceMeters, distanceMeters) ||
                other.distanceMeters == distanceMeters) &&
            (identical(other.restTimeSeconds, restTimeSeconds) ||
                other.restTimeSeconds == restTimeSeconds) &&
            (identical(other.intensityPercentage, intensityPercentage) ||
                other.intensityPercentage == intensityPercentage) &&
            (identical(other.rpe, rpe) || other.rpe == rpe) &&
            (identical(other.formRating, formRating) ||
                other.formRating == formRating) &&
            const DeepCollectionEquality().equals(
              other._equipmentUsed,
              _equipmentUsed,
            ) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isPersonalRecord, isPersonalRecord) ||
                other.isPersonalRecord == isPersonalRecord) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.previousBestWeight, previousBestWeight) ||
                other.previousBestWeight == previousBestWeight) &&
            (identical(other.previousBestReps, previousBestReps) ||
                other.previousBestReps == previousBestReps) &&
            (identical(other.previousBestDuration, previousBestDuration) ||
                other.previousBestDuration == previousBestDuration) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.exercise, exercise) ||
                other.exercise == exercise));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    workoutSessionId,
    exerciseId,
    workoutExerciseId,
    orderIndex,
    setsCompleted,
    setsPlanned,
    repsCompleted,
    repsPlanned,
    weightKg,
    durationSeconds,
    distanceMeters,
    restTimeSeconds,
    intensityPercentage,
    rpe,
    formRating,
    const DeepCollectionEquality().hash(_equipmentUsed),
    notes,
    isPersonalRecord,
    isCompleted,
    previousBestWeight,
    previousBestReps,
    previousBestDuration,
    createdAt,
    updatedAt,
    exercise,
  ]);

  /// Create a copy of ExerciseLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseLogImplCopyWith<_$ExerciseLogImpl> get copyWith =>
      __$$ExerciseLogImplCopyWithImpl<_$ExerciseLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseLogImplToJson(this);
  }
}

abstract class _ExerciseLog implements ExerciseLog {
  const factory _ExerciseLog({
    required final String id,
    required final String workoutSessionId,
    required final String exerciseId,
    final String? workoutExerciseId,
    required final int orderIndex,
    final int setsCompleted,
    final int setsPlanned,
    final int? repsCompleted,
    final int? repsPlanned,
    final double? weightKg,
    final int? durationSeconds,
    final double? distanceMeters,
    final int? restTimeSeconds,
    final double? intensityPercentage,
    final int? rpe,
    final int? formRating,
    final List<String> equipmentUsed,
    final String? notes,
    final bool isPersonalRecord,
    final bool isCompleted,
    final double? previousBestWeight,
    final int? previousBestReps,
    final int? previousBestDuration,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final Exercise? exercise,
  }) = _$ExerciseLogImpl;

  factory _ExerciseLog.fromJson(Map<String, dynamic> json) =
      _$ExerciseLogImpl.fromJson;

  @override
  String get id;
  @override
  String get workoutSessionId;
  @override
  String get exerciseId;
  @override
  String? get workoutExerciseId;
  @override
  int get orderIndex;
  @override
  int get setsCompleted;
  @override
  int get setsPlanned;
  @override
  int? get repsCompleted;
  @override
  int? get repsPlanned;
  @override
  double? get weightKg;
  @override
  int? get durationSeconds;
  @override
  double? get distanceMeters;
  @override
  int? get restTimeSeconds;
  @override
  double? get intensityPercentage;
  @override
  int? get rpe;
  @override
  int? get formRating;
  @override
  List<String> get equipmentUsed;
  @override
  String? get notes;
  @override
  bool get isPersonalRecord;
  @override
  bool get isCompleted;
  @override
  double? get previousBestWeight;
  @override
  int? get previousBestReps;
  @override
  int? get previousBestDuration;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt; // Related data
  @override
  Exercise? get exercise;

  /// Create a copy of ExerciseLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExerciseLogImplCopyWith<_$ExerciseLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PersonalRecord _$PersonalRecordFromJson(Map<String, dynamic> json) {
  return _PersonalRecord.fromJson(json);
}

/// @nodoc
mixin _$PersonalRecord {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get exerciseId => throw _privateConstructorUsedError;
  String get recordType => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  double? get secondaryValue => throw _privateConstructorUsedError;
  String? get secondaryUnit => throw _privateConstructorUsedError;
  DateTime get achievedAt => throw _privateConstructorUsedError;
  String? get workoutSessionId => throw _privateConstructorUsedError;
  String? get exerciseLogId => throw _privateConstructorUsedError;
  double? get previousRecordValue => throw _privateConstructorUsedError;
  double? get improvementPercentage => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError; // Related data
  Exercise? get exercise => throw _privateConstructorUsedError;

  /// Serializes this PersonalRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PersonalRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PersonalRecordCopyWith<PersonalRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonalRecordCopyWith<$Res> {
  factory $PersonalRecordCopyWith(
    PersonalRecord value,
    $Res Function(PersonalRecord) then,
  ) = _$PersonalRecordCopyWithImpl<$Res, PersonalRecord>;
  @useResult
  $Res call({
    String id,
    String userId,
    String exerciseId,
    String recordType,
    double value,
    String unit,
    double? secondaryValue,
    String? secondaryUnit,
    DateTime achievedAt,
    String? workoutSessionId,
    String? exerciseLogId,
    double? previousRecordValue,
    double? improvementPercentage,
    String? notes,
    bool isVerified,
    DateTime? createdAt,
    Exercise? exercise,
  });

  $ExerciseCopyWith<$Res>? get exercise;
}

/// @nodoc
class _$PersonalRecordCopyWithImpl<$Res, $Val extends PersonalRecord>
    implements $PersonalRecordCopyWith<$Res> {
  _$PersonalRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PersonalRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? exerciseId = null,
    Object? recordType = null,
    Object? value = null,
    Object? unit = null,
    Object? secondaryValue = freezed,
    Object? secondaryUnit = freezed,
    Object? achievedAt = null,
    Object? workoutSessionId = freezed,
    Object? exerciseLogId = freezed,
    Object? previousRecordValue = freezed,
    Object? improvementPercentage = freezed,
    Object? notes = freezed,
    Object? isVerified = null,
    Object? createdAt = freezed,
    Object? exercise = freezed,
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
            exerciseId: null == exerciseId
                ? _value.exerciseId
                : exerciseId // ignore: cast_nullable_to_non_nullable
                      as String,
            recordType: null == recordType
                ? _value.recordType
                : recordType // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as double,
            unit: null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String,
            secondaryValue: freezed == secondaryValue
                ? _value.secondaryValue
                : secondaryValue // ignore: cast_nullable_to_non_nullable
                      as double?,
            secondaryUnit: freezed == secondaryUnit
                ? _value.secondaryUnit
                : secondaryUnit // ignore: cast_nullable_to_non_nullable
                      as String?,
            achievedAt: null == achievedAt
                ? _value.achievedAt
                : achievedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            workoutSessionId: freezed == workoutSessionId
                ? _value.workoutSessionId
                : workoutSessionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            exerciseLogId: freezed == exerciseLogId
                ? _value.exerciseLogId
                : exerciseLogId // ignore: cast_nullable_to_non_nullable
                      as String?,
            previousRecordValue: freezed == previousRecordValue
                ? _value.previousRecordValue
                : previousRecordValue // ignore: cast_nullable_to_non_nullable
                      as double?,
            improvementPercentage: freezed == improvementPercentage
                ? _value.improvementPercentage
                : improvementPercentage // ignore: cast_nullable_to_non_nullable
                      as double?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            isVerified: null == isVerified
                ? _value.isVerified
                : isVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            exercise: freezed == exercise
                ? _value.exercise
                : exercise // ignore: cast_nullable_to_non_nullable
                      as Exercise?,
          )
          as $Val,
    );
  }

  /// Create a copy of PersonalRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExerciseCopyWith<$Res>? get exercise {
    if (_value.exercise == null) {
      return null;
    }

    return $ExerciseCopyWith<$Res>(_value.exercise!, (value) {
      return _then(_value.copyWith(exercise: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PersonalRecordImplCopyWith<$Res>
    implements $PersonalRecordCopyWith<$Res> {
  factory _$$PersonalRecordImplCopyWith(
    _$PersonalRecordImpl value,
    $Res Function(_$PersonalRecordImpl) then,
  ) = __$$PersonalRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String exerciseId,
    String recordType,
    double value,
    String unit,
    double? secondaryValue,
    String? secondaryUnit,
    DateTime achievedAt,
    String? workoutSessionId,
    String? exerciseLogId,
    double? previousRecordValue,
    double? improvementPercentage,
    String? notes,
    bool isVerified,
    DateTime? createdAt,
    Exercise? exercise,
  });

  @override
  $ExerciseCopyWith<$Res>? get exercise;
}

/// @nodoc
class __$$PersonalRecordImplCopyWithImpl<$Res>
    extends _$PersonalRecordCopyWithImpl<$Res, _$PersonalRecordImpl>
    implements _$$PersonalRecordImplCopyWith<$Res> {
  __$$PersonalRecordImplCopyWithImpl(
    _$PersonalRecordImpl _value,
    $Res Function(_$PersonalRecordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PersonalRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? exerciseId = null,
    Object? recordType = null,
    Object? value = null,
    Object? unit = null,
    Object? secondaryValue = freezed,
    Object? secondaryUnit = freezed,
    Object? achievedAt = null,
    Object? workoutSessionId = freezed,
    Object? exerciseLogId = freezed,
    Object? previousRecordValue = freezed,
    Object? improvementPercentage = freezed,
    Object? notes = freezed,
    Object? isVerified = null,
    Object? createdAt = freezed,
    Object? exercise = freezed,
  }) {
    return _then(
      _$PersonalRecordImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        exerciseId: null == exerciseId
            ? _value.exerciseId
            : exerciseId // ignore: cast_nullable_to_non_nullable
                  as String,
        recordType: null == recordType
            ? _value.recordType
            : recordType // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
        unit: null == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
        secondaryValue: freezed == secondaryValue
            ? _value.secondaryValue
            : secondaryValue // ignore: cast_nullable_to_non_nullable
                  as double?,
        secondaryUnit: freezed == secondaryUnit
            ? _value.secondaryUnit
            : secondaryUnit // ignore: cast_nullable_to_non_nullable
                  as String?,
        achievedAt: null == achievedAt
            ? _value.achievedAt
            : achievedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        workoutSessionId: freezed == workoutSessionId
            ? _value.workoutSessionId
            : workoutSessionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        exerciseLogId: freezed == exerciseLogId
            ? _value.exerciseLogId
            : exerciseLogId // ignore: cast_nullable_to_non_nullable
                  as String?,
        previousRecordValue: freezed == previousRecordValue
            ? _value.previousRecordValue
            : previousRecordValue // ignore: cast_nullable_to_non_nullable
                  as double?,
        improvementPercentage: freezed == improvementPercentage
            ? _value.improvementPercentage
            : improvementPercentage // ignore: cast_nullable_to_non_nullable
                  as double?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        isVerified: null == isVerified
            ? _value.isVerified
            : isVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        exercise: freezed == exercise
            ? _value.exercise
            : exercise // ignore: cast_nullable_to_non_nullable
                  as Exercise?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PersonalRecordImpl implements _PersonalRecord {
  const _$PersonalRecordImpl({
    required this.id,
    required this.userId,
    required this.exerciseId,
    required this.recordType,
    required this.value,
    required this.unit,
    this.secondaryValue,
    this.secondaryUnit,
    required this.achievedAt,
    this.workoutSessionId,
    this.exerciseLogId,
    this.previousRecordValue,
    this.improvementPercentage,
    this.notes,
    this.isVerified = false,
    this.createdAt,
    this.exercise,
  });

  factory _$PersonalRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$PersonalRecordImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String exerciseId;
  @override
  final String recordType;
  @override
  final double value;
  @override
  final String unit;
  @override
  final double? secondaryValue;
  @override
  final String? secondaryUnit;
  @override
  final DateTime achievedAt;
  @override
  final String? workoutSessionId;
  @override
  final String? exerciseLogId;
  @override
  final double? previousRecordValue;
  @override
  final double? improvementPercentage;
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool isVerified;
  @override
  final DateTime? createdAt;
  // Related data
  @override
  final Exercise? exercise;

  @override
  String toString() {
    return 'PersonalRecord(id: $id, userId: $userId, exerciseId: $exerciseId, recordType: $recordType, value: $value, unit: $unit, secondaryValue: $secondaryValue, secondaryUnit: $secondaryUnit, achievedAt: $achievedAt, workoutSessionId: $workoutSessionId, exerciseLogId: $exerciseLogId, previousRecordValue: $previousRecordValue, improvementPercentage: $improvementPercentage, notes: $notes, isVerified: $isVerified, createdAt: $createdAt, exercise: $exercise)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonalRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.exerciseId, exerciseId) ||
                other.exerciseId == exerciseId) &&
            (identical(other.recordType, recordType) ||
                other.recordType == recordType) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.secondaryValue, secondaryValue) ||
                other.secondaryValue == secondaryValue) &&
            (identical(other.secondaryUnit, secondaryUnit) ||
                other.secondaryUnit == secondaryUnit) &&
            (identical(other.achievedAt, achievedAt) ||
                other.achievedAt == achievedAt) &&
            (identical(other.workoutSessionId, workoutSessionId) ||
                other.workoutSessionId == workoutSessionId) &&
            (identical(other.exerciseLogId, exerciseLogId) ||
                other.exerciseLogId == exerciseLogId) &&
            (identical(other.previousRecordValue, previousRecordValue) ||
                other.previousRecordValue == previousRecordValue) &&
            (identical(other.improvementPercentage, improvementPercentage) ||
                other.improvementPercentage == improvementPercentage) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.exercise, exercise) ||
                other.exercise == exercise));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    exerciseId,
    recordType,
    value,
    unit,
    secondaryValue,
    secondaryUnit,
    achievedAt,
    workoutSessionId,
    exerciseLogId,
    previousRecordValue,
    improvementPercentage,
    notes,
    isVerified,
    createdAt,
    exercise,
  );

  /// Create a copy of PersonalRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonalRecordImplCopyWith<_$PersonalRecordImpl> get copyWith =>
      __$$PersonalRecordImplCopyWithImpl<_$PersonalRecordImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PersonalRecordImplToJson(this);
  }
}

abstract class _PersonalRecord implements PersonalRecord {
  const factory _PersonalRecord({
    required final String id,
    required final String userId,
    required final String exerciseId,
    required final String recordType,
    required final double value,
    required final String unit,
    final double? secondaryValue,
    final String? secondaryUnit,
    required final DateTime achievedAt,
    final String? workoutSessionId,
    final String? exerciseLogId,
    final double? previousRecordValue,
    final double? improvementPercentage,
    final String? notes,
    final bool isVerified,
    final DateTime? createdAt,
    final Exercise? exercise,
  }) = _$PersonalRecordImpl;

  factory _PersonalRecord.fromJson(Map<String, dynamic> json) =
      _$PersonalRecordImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get exerciseId;
  @override
  String get recordType;
  @override
  double get value;
  @override
  String get unit;
  @override
  double? get secondaryValue;
  @override
  String? get secondaryUnit;
  @override
  DateTime get achievedAt;
  @override
  String? get workoutSessionId;
  @override
  String? get exerciseLogId;
  @override
  double? get previousRecordValue;
  @override
  double? get improvementPercentage;
  @override
  String? get notes;
  @override
  bool get isVerified;
  @override
  DateTime? get createdAt; // Related data
  @override
  Exercise? get exercise;

  /// Create a copy of PersonalRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersonalRecordImplCopyWith<_$PersonalRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
