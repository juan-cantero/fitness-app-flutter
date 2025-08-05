// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Workout _$WorkoutFromJson(Map<String, dynamic> json) {
  return _Workout.fromJson(json);
}

/// @nodoc
mixin _$Workout {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  bool get isPublic => throw _privateConstructorUsedError;
  String get difficultyLevel => throw _privateConstructorUsedError;
  int? get estimatedDurationMinutes => throw _privateConstructorUsedError;
  int? get actualDurationMinutes => throw _privateConstructorUsedError;
  String get workoutType => throw _privateConstructorUsedError;
  List<String> get targetMuscleGroups => throw _privateConstructorUsedError;
  List<String> get equipmentNeeded => throw _privateConstructorUsedError;
  String get spaceRequirement => throw _privateConstructorUsedError;
  String get intensityLevel => throw _privateConstructorUsedError;
  int get restBetweenExercises => throw _privateConstructorUsedError;
  int get restBetweenSets => throw _privateConstructorUsedError;
  int get warmupDurationMinutes => throw _privateConstructorUsedError;
  int get cooldownDurationMinutes => throw _privateConstructorUsedError;
  int? get caloriesEstimate => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  bool get isTemplate => throw _privateConstructorUsedError;
  String? get templateCategory => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError; // Related data
  List<WorkoutExercise> get exercises => throw _privateConstructorUsedError;

  /// Serializes this Workout to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Workout
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutCopyWith<Workout> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutCopyWith<$Res> {
  factory $WorkoutCopyWith(Workout value, $Res Function(Workout) then) =
      _$WorkoutCopyWithImpl<$Res, Workout>;
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    String? createdBy,
    bool isPublic,
    String difficultyLevel,
    int? estimatedDurationMinutes,
    int? actualDurationMinutes,
    String workoutType,
    List<String> targetMuscleGroups,
    List<String> equipmentNeeded,
    String spaceRequirement,
    String intensityLevel,
    int restBetweenExercises,
    int restBetweenSets,
    int warmupDurationMinutes,
    int cooldownDurationMinutes,
    int? caloriesEstimate,
    List<String> tags,
    String? notes,
    bool isTemplate,
    String? templateCategory,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<WorkoutExercise> exercises,
  });
}

/// @nodoc
class _$WorkoutCopyWithImpl<$Res, $Val extends Workout>
    implements $WorkoutCopyWith<$Res> {
  _$WorkoutCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Workout
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? createdBy = freezed,
    Object? isPublic = null,
    Object? difficultyLevel = null,
    Object? estimatedDurationMinutes = freezed,
    Object? actualDurationMinutes = freezed,
    Object? workoutType = null,
    Object? targetMuscleGroups = null,
    Object? equipmentNeeded = null,
    Object? spaceRequirement = null,
    Object? intensityLevel = null,
    Object? restBetweenExercises = null,
    Object? restBetweenSets = null,
    Object? warmupDurationMinutes = null,
    Object? cooldownDurationMinutes = null,
    Object? caloriesEstimate = freezed,
    Object? tags = null,
    Object? notes = freezed,
    Object? isTemplate = null,
    Object? templateCategory = freezed,
    Object? imageUrl = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? exercises = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdBy: freezed == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            isPublic: null == isPublic
                ? _value.isPublic
                : isPublic // ignore: cast_nullable_to_non_nullable
                      as bool,
            difficultyLevel: null == difficultyLevel
                ? _value.difficultyLevel
                : difficultyLevel // ignore: cast_nullable_to_non_nullable
                      as String,
            estimatedDurationMinutes: freezed == estimatedDurationMinutes
                ? _value.estimatedDurationMinutes
                : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            actualDurationMinutes: freezed == actualDurationMinutes
                ? _value.actualDurationMinutes
                : actualDurationMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            workoutType: null == workoutType
                ? _value.workoutType
                : workoutType // ignore: cast_nullable_to_non_nullable
                      as String,
            targetMuscleGroups: null == targetMuscleGroups
                ? _value.targetMuscleGroups
                : targetMuscleGroups // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            equipmentNeeded: null == equipmentNeeded
                ? _value.equipmentNeeded
                : equipmentNeeded // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            spaceRequirement: null == spaceRequirement
                ? _value.spaceRequirement
                : spaceRequirement // ignore: cast_nullable_to_non_nullable
                      as String,
            intensityLevel: null == intensityLevel
                ? _value.intensityLevel
                : intensityLevel // ignore: cast_nullable_to_non_nullable
                      as String,
            restBetweenExercises: null == restBetweenExercises
                ? _value.restBetweenExercises
                : restBetweenExercises // ignore: cast_nullable_to_non_nullable
                      as int,
            restBetweenSets: null == restBetweenSets
                ? _value.restBetweenSets
                : restBetweenSets // ignore: cast_nullable_to_non_nullable
                      as int,
            warmupDurationMinutes: null == warmupDurationMinutes
                ? _value.warmupDurationMinutes
                : warmupDurationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            cooldownDurationMinutes: null == cooldownDurationMinutes
                ? _value.cooldownDurationMinutes
                : cooldownDurationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            caloriesEstimate: freezed == caloriesEstimate
                ? _value.caloriesEstimate
                : caloriesEstimate // ignore: cast_nullable_to_non_nullable
                      as int?,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            isTemplate: null == isTemplate
                ? _value.isTemplate
                : isTemplate // ignore: cast_nullable_to_non_nullable
                      as bool,
            templateCategory: freezed == templateCategory
                ? _value.templateCategory
                : templateCategory // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            exercises: null == exercises
                ? _value.exercises
                : exercises // ignore: cast_nullable_to_non_nullable
                      as List<WorkoutExercise>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkoutImplCopyWith<$Res> implements $WorkoutCopyWith<$Res> {
  factory _$$WorkoutImplCopyWith(
    _$WorkoutImpl value,
    $Res Function(_$WorkoutImpl) then,
  ) = __$$WorkoutImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    String? createdBy,
    bool isPublic,
    String difficultyLevel,
    int? estimatedDurationMinutes,
    int? actualDurationMinutes,
    String workoutType,
    List<String> targetMuscleGroups,
    List<String> equipmentNeeded,
    String spaceRequirement,
    String intensityLevel,
    int restBetweenExercises,
    int restBetweenSets,
    int warmupDurationMinutes,
    int cooldownDurationMinutes,
    int? caloriesEstimate,
    List<String> tags,
    String? notes,
    bool isTemplate,
    String? templateCategory,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<WorkoutExercise> exercises,
  });
}

/// @nodoc
class __$$WorkoutImplCopyWithImpl<$Res>
    extends _$WorkoutCopyWithImpl<$Res, _$WorkoutImpl>
    implements _$$WorkoutImplCopyWith<$Res> {
  __$$WorkoutImplCopyWithImpl(
    _$WorkoutImpl _value,
    $Res Function(_$WorkoutImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Workout
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? createdBy = freezed,
    Object? isPublic = null,
    Object? difficultyLevel = null,
    Object? estimatedDurationMinutes = freezed,
    Object? actualDurationMinutes = freezed,
    Object? workoutType = null,
    Object? targetMuscleGroups = null,
    Object? equipmentNeeded = null,
    Object? spaceRequirement = null,
    Object? intensityLevel = null,
    Object? restBetweenExercises = null,
    Object? restBetweenSets = null,
    Object? warmupDurationMinutes = null,
    Object? cooldownDurationMinutes = null,
    Object? caloriesEstimate = freezed,
    Object? tags = null,
    Object? notes = freezed,
    Object? isTemplate = null,
    Object? templateCategory = freezed,
    Object? imageUrl = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? exercises = null,
  }) {
    return _then(
      _$WorkoutImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdBy: freezed == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        isPublic: null == isPublic
            ? _value.isPublic
            : isPublic // ignore: cast_nullable_to_non_nullable
                  as bool,
        difficultyLevel: null == difficultyLevel
            ? _value.difficultyLevel
            : difficultyLevel // ignore: cast_nullable_to_non_nullable
                  as String,
        estimatedDurationMinutes: freezed == estimatedDurationMinutes
            ? _value.estimatedDurationMinutes
            : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        actualDurationMinutes: freezed == actualDurationMinutes
            ? _value.actualDurationMinutes
            : actualDurationMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        workoutType: null == workoutType
            ? _value.workoutType
            : workoutType // ignore: cast_nullable_to_non_nullable
                  as String,
        targetMuscleGroups: null == targetMuscleGroups
            ? _value._targetMuscleGroups
            : targetMuscleGroups // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        equipmentNeeded: null == equipmentNeeded
            ? _value._equipmentNeeded
            : equipmentNeeded // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        spaceRequirement: null == spaceRequirement
            ? _value.spaceRequirement
            : spaceRequirement // ignore: cast_nullable_to_non_nullable
                  as String,
        intensityLevel: null == intensityLevel
            ? _value.intensityLevel
            : intensityLevel // ignore: cast_nullable_to_non_nullable
                  as String,
        restBetweenExercises: null == restBetweenExercises
            ? _value.restBetweenExercises
            : restBetweenExercises // ignore: cast_nullable_to_non_nullable
                  as int,
        restBetweenSets: null == restBetweenSets
            ? _value.restBetweenSets
            : restBetweenSets // ignore: cast_nullable_to_non_nullable
                  as int,
        warmupDurationMinutes: null == warmupDurationMinutes
            ? _value.warmupDurationMinutes
            : warmupDurationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        cooldownDurationMinutes: null == cooldownDurationMinutes
            ? _value.cooldownDurationMinutes
            : cooldownDurationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        caloriesEstimate: freezed == caloriesEstimate
            ? _value.caloriesEstimate
            : caloriesEstimate // ignore: cast_nullable_to_non_nullable
                  as int?,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        isTemplate: null == isTemplate
            ? _value.isTemplate
            : isTemplate // ignore: cast_nullable_to_non_nullable
                  as bool,
        templateCategory: freezed == templateCategory
            ? _value.templateCategory
            : templateCategory // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        exercises: null == exercises
            ? _value._exercises
            : exercises // ignore: cast_nullable_to_non_nullable
                  as List<WorkoutExercise>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutImpl implements _Workout {
  const _$WorkoutImpl({
    required this.id,
    required this.name,
    this.description,
    this.createdBy,
    this.isPublic = false,
    this.difficultyLevel = 'beginner',
    this.estimatedDurationMinutes,
    this.actualDurationMinutes,
    this.workoutType = 'strength',
    final List<String> targetMuscleGroups = const [],
    final List<String> equipmentNeeded = const [],
    this.spaceRequirement = 'small',
    this.intensityLevel = 'moderate',
    this.restBetweenExercises = 60,
    this.restBetweenSets = 60,
    this.warmupDurationMinutes = 5,
    this.cooldownDurationMinutes = 5,
    this.caloriesEstimate,
    final List<String> tags = const [],
    this.notes,
    this.isTemplate = false,
    this.templateCategory,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
    final List<WorkoutExercise> exercises = const [],
  }) : _targetMuscleGroups = targetMuscleGroups,
       _equipmentNeeded = equipmentNeeded,
       _tags = tags,
       _exercises = exercises;

  factory _$WorkoutImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? createdBy;
  @override
  @JsonKey()
  final bool isPublic;
  @override
  @JsonKey()
  final String difficultyLevel;
  @override
  final int? estimatedDurationMinutes;
  @override
  final int? actualDurationMinutes;
  @override
  @JsonKey()
  final String workoutType;
  final List<String> _targetMuscleGroups;
  @override
  @JsonKey()
  List<String> get targetMuscleGroups {
    if (_targetMuscleGroups is EqualUnmodifiableListView)
      return _targetMuscleGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_targetMuscleGroups);
  }

  final List<String> _equipmentNeeded;
  @override
  @JsonKey()
  List<String> get equipmentNeeded {
    if (_equipmentNeeded is EqualUnmodifiableListView) return _equipmentNeeded;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_equipmentNeeded);
  }

  @override
  @JsonKey()
  final String spaceRequirement;
  @override
  @JsonKey()
  final String intensityLevel;
  @override
  @JsonKey()
  final int restBetweenExercises;
  @override
  @JsonKey()
  final int restBetweenSets;
  @override
  @JsonKey()
  final int warmupDurationMinutes;
  @override
  @JsonKey()
  final int cooldownDurationMinutes;
  @override
  final int? caloriesEstimate;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String? notes;
  @override
  @JsonKey()
  final bool isTemplate;
  @override
  final String? templateCategory;
  @override
  final String? imageUrl;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  // Related data
  final List<WorkoutExercise> _exercises;
  // Related data
  @override
  @JsonKey()
  List<WorkoutExercise> get exercises {
    if (_exercises is EqualUnmodifiableListView) return _exercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exercises);
  }

  @override
  String toString() {
    return 'Workout(id: $id, name: $name, description: $description, createdBy: $createdBy, isPublic: $isPublic, difficultyLevel: $difficultyLevel, estimatedDurationMinutes: $estimatedDurationMinutes, actualDurationMinutes: $actualDurationMinutes, workoutType: $workoutType, targetMuscleGroups: $targetMuscleGroups, equipmentNeeded: $equipmentNeeded, spaceRequirement: $spaceRequirement, intensityLevel: $intensityLevel, restBetweenExercises: $restBetweenExercises, restBetweenSets: $restBetweenSets, warmupDurationMinutes: $warmupDurationMinutes, cooldownDurationMinutes: $cooldownDurationMinutes, caloriesEstimate: $caloriesEstimate, tags: $tags, notes: $notes, isTemplate: $isTemplate, templateCategory: $templateCategory, imageUrl: $imageUrl, createdAt: $createdAt, updatedAt: $updatedAt, exercises: $exercises)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.difficultyLevel, difficultyLevel) ||
                other.difficultyLevel == difficultyLevel) &&
            (identical(
                  other.estimatedDurationMinutes,
                  estimatedDurationMinutes,
                ) ||
                other.estimatedDurationMinutes == estimatedDurationMinutes) &&
            (identical(other.actualDurationMinutes, actualDurationMinutes) ||
                other.actualDurationMinutes == actualDurationMinutes) &&
            (identical(other.workoutType, workoutType) ||
                other.workoutType == workoutType) &&
            const DeepCollectionEquality().equals(
              other._targetMuscleGroups,
              _targetMuscleGroups,
            ) &&
            const DeepCollectionEquality().equals(
              other._equipmentNeeded,
              _equipmentNeeded,
            ) &&
            (identical(other.spaceRequirement, spaceRequirement) ||
                other.spaceRequirement == spaceRequirement) &&
            (identical(other.intensityLevel, intensityLevel) ||
                other.intensityLevel == intensityLevel) &&
            (identical(other.restBetweenExercises, restBetweenExercises) ||
                other.restBetweenExercises == restBetweenExercises) &&
            (identical(other.restBetweenSets, restBetweenSets) ||
                other.restBetweenSets == restBetweenSets) &&
            (identical(other.warmupDurationMinutes, warmupDurationMinutes) ||
                other.warmupDurationMinutes == warmupDurationMinutes) &&
            (identical(
                  other.cooldownDurationMinutes,
                  cooldownDurationMinutes,
                ) ||
                other.cooldownDurationMinutes == cooldownDurationMinutes) &&
            (identical(other.caloriesEstimate, caloriesEstimate) ||
                other.caloriesEstimate == caloriesEstimate) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isTemplate, isTemplate) ||
                other.isTemplate == isTemplate) &&
            (identical(other.templateCategory, templateCategory) ||
                other.templateCategory == templateCategory) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(
              other._exercises,
              _exercises,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    description,
    createdBy,
    isPublic,
    difficultyLevel,
    estimatedDurationMinutes,
    actualDurationMinutes,
    workoutType,
    const DeepCollectionEquality().hash(_targetMuscleGroups),
    const DeepCollectionEquality().hash(_equipmentNeeded),
    spaceRequirement,
    intensityLevel,
    restBetweenExercises,
    restBetweenSets,
    warmupDurationMinutes,
    cooldownDurationMinutes,
    caloriesEstimate,
    const DeepCollectionEquality().hash(_tags),
    notes,
    isTemplate,
    templateCategory,
    imageUrl,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_exercises),
  ]);

  /// Create a copy of Workout
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutImplCopyWith<_$WorkoutImpl> get copyWith =>
      __$$WorkoutImplCopyWithImpl<_$WorkoutImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutImplToJson(this);
  }
}

abstract class _Workout implements Workout {
  const factory _Workout({
    required final String id,
    required final String name,
    final String? description,
    final String? createdBy,
    final bool isPublic,
    final String difficultyLevel,
    final int? estimatedDurationMinutes,
    final int? actualDurationMinutes,
    final String workoutType,
    final List<String> targetMuscleGroups,
    final List<String> equipmentNeeded,
    final String spaceRequirement,
    final String intensityLevel,
    final int restBetweenExercises,
    final int restBetweenSets,
    final int warmupDurationMinutes,
    final int cooldownDurationMinutes,
    final int? caloriesEstimate,
    final List<String> tags,
    final String? notes,
    final bool isTemplate,
    final String? templateCategory,
    final String? imageUrl,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final List<WorkoutExercise> exercises,
  }) = _$WorkoutImpl;

  factory _Workout.fromJson(Map<String, dynamic> json) = _$WorkoutImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get createdBy;
  @override
  bool get isPublic;
  @override
  String get difficultyLevel;
  @override
  int? get estimatedDurationMinutes;
  @override
  int? get actualDurationMinutes;
  @override
  String get workoutType;
  @override
  List<String> get targetMuscleGroups;
  @override
  List<String> get equipmentNeeded;
  @override
  String get spaceRequirement;
  @override
  String get intensityLevel;
  @override
  int get restBetweenExercises;
  @override
  int get restBetweenSets;
  @override
  int get warmupDurationMinutes;
  @override
  int get cooldownDurationMinutes;
  @override
  int? get caloriesEstimate;
  @override
  List<String> get tags;
  @override
  String? get notes;
  @override
  bool get isTemplate;
  @override
  String? get templateCategory;
  @override
  String? get imageUrl;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt; // Related data
  @override
  List<WorkoutExercise> get exercises;

  /// Create a copy of Workout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutImplCopyWith<_$WorkoutImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkoutExercise _$WorkoutExerciseFromJson(Map<String, dynamic> json) {
  return _WorkoutExercise.fromJson(json);
}

/// @nodoc
mixin _$WorkoutExercise {
  String get id => throw _privateConstructorUsedError;
  String get workoutId => throw _privateConstructorUsedError;
  String get exerciseId => throw _privateConstructorUsedError;
  int get orderIndex => throw _privateConstructorUsedError;
  int get sets => throw _privateConstructorUsedError;
  int? get reps => throw _privateConstructorUsedError;
  double? get weightKg => throw _privateConstructorUsedError;
  int? get durationSeconds => throw _privateConstructorUsedError;
  double? get distanceMeters => throw _privateConstructorUsedError;
  int get restTimeSeconds => throw _privateConstructorUsedError;
  double? get intensityPercentage => throw _privateConstructorUsedError;
  String? get tempo => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  bool get isSuperset => throw _privateConstructorUsedError;
  String? get supersetGroupId => throw _privateConstructorUsedError;
  bool get isDropset => throw _privateConstructorUsedError;
  bool get isWarmup => throw _privateConstructorUsedError;
  bool get isCooldown => throw _privateConstructorUsedError;
  int? get targetRpe => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError; // Related data
  Exercise? get exercise => throw _privateConstructorUsedError;

  /// Serializes this WorkoutExercise to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutExercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutExerciseCopyWith<WorkoutExercise> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutExerciseCopyWith<$Res> {
  factory $WorkoutExerciseCopyWith(
    WorkoutExercise value,
    $Res Function(WorkoutExercise) then,
  ) = _$WorkoutExerciseCopyWithImpl<$Res, WorkoutExercise>;
  @useResult
  $Res call({
    String id,
    String workoutId,
    String exerciseId,
    int orderIndex,
    int sets,
    int? reps,
    double? weightKg,
    int? durationSeconds,
    double? distanceMeters,
    int restTimeSeconds,
    double? intensityPercentage,
    String? tempo,
    String? notes,
    bool isSuperset,
    String? supersetGroupId,
    bool isDropset,
    bool isWarmup,
    bool isCooldown,
    int? targetRpe,
    DateTime? createdAt,
    DateTime? updatedAt,
    Exercise? exercise,
  });

  $ExerciseCopyWith<$Res>? get exercise;
}

/// @nodoc
class _$WorkoutExerciseCopyWithImpl<$Res, $Val extends WorkoutExercise>
    implements $WorkoutExerciseCopyWith<$Res> {
  _$WorkoutExerciseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutExercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workoutId = null,
    Object? exerciseId = null,
    Object? orderIndex = null,
    Object? sets = null,
    Object? reps = freezed,
    Object? weightKg = freezed,
    Object? durationSeconds = freezed,
    Object? distanceMeters = freezed,
    Object? restTimeSeconds = null,
    Object? intensityPercentage = freezed,
    Object? tempo = freezed,
    Object? notes = freezed,
    Object? isSuperset = null,
    Object? supersetGroupId = freezed,
    Object? isDropset = null,
    Object? isWarmup = null,
    Object? isCooldown = null,
    Object? targetRpe = freezed,
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
            workoutId: null == workoutId
                ? _value.workoutId
                : workoutId // ignore: cast_nullable_to_non_nullable
                      as String,
            exerciseId: null == exerciseId
                ? _value.exerciseId
                : exerciseId // ignore: cast_nullable_to_non_nullable
                      as String,
            orderIndex: null == orderIndex
                ? _value.orderIndex
                : orderIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            sets: null == sets
                ? _value.sets
                : sets // ignore: cast_nullable_to_non_nullable
                      as int,
            reps: freezed == reps
                ? _value.reps
                : reps // ignore: cast_nullable_to_non_nullable
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
            restTimeSeconds: null == restTimeSeconds
                ? _value.restTimeSeconds
                : restTimeSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            intensityPercentage: freezed == intensityPercentage
                ? _value.intensityPercentage
                : intensityPercentage // ignore: cast_nullable_to_non_nullable
                      as double?,
            tempo: freezed == tempo
                ? _value.tempo
                : tempo // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            isSuperset: null == isSuperset
                ? _value.isSuperset
                : isSuperset // ignore: cast_nullable_to_non_nullable
                      as bool,
            supersetGroupId: freezed == supersetGroupId
                ? _value.supersetGroupId
                : supersetGroupId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isDropset: null == isDropset
                ? _value.isDropset
                : isDropset // ignore: cast_nullable_to_non_nullable
                      as bool,
            isWarmup: null == isWarmup
                ? _value.isWarmup
                : isWarmup // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCooldown: null == isCooldown
                ? _value.isCooldown
                : isCooldown // ignore: cast_nullable_to_non_nullable
                      as bool,
            targetRpe: freezed == targetRpe
                ? _value.targetRpe
                : targetRpe // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of WorkoutExercise
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
abstract class _$$WorkoutExerciseImplCopyWith<$Res>
    implements $WorkoutExerciseCopyWith<$Res> {
  factory _$$WorkoutExerciseImplCopyWith(
    _$WorkoutExerciseImpl value,
    $Res Function(_$WorkoutExerciseImpl) then,
  ) = __$$WorkoutExerciseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String workoutId,
    String exerciseId,
    int orderIndex,
    int sets,
    int? reps,
    double? weightKg,
    int? durationSeconds,
    double? distanceMeters,
    int restTimeSeconds,
    double? intensityPercentage,
    String? tempo,
    String? notes,
    bool isSuperset,
    String? supersetGroupId,
    bool isDropset,
    bool isWarmup,
    bool isCooldown,
    int? targetRpe,
    DateTime? createdAt,
    DateTime? updatedAt,
    Exercise? exercise,
  });

  @override
  $ExerciseCopyWith<$Res>? get exercise;
}

/// @nodoc
class __$$WorkoutExerciseImplCopyWithImpl<$Res>
    extends _$WorkoutExerciseCopyWithImpl<$Res, _$WorkoutExerciseImpl>
    implements _$$WorkoutExerciseImplCopyWith<$Res> {
  __$$WorkoutExerciseImplCopyWithImpl(
    _$WorkoutExerciseImpl _value,
    $Res Function(_$WorkoutExerciseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkoutExercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workoutId = null,
    Object? exerciseId = null,
    Object? orderIndex = null,
    Object? sets = null,
    Object? reps = freezed,
    Object? weightKg = freezed,
    Object? durationSeconds = freezed,
    Object? distanceMeters = freezed,
    Object? restTimeSeconds = null,
    Object? intensityPercentage = freezed,
    Object? tempo = freezed,
    Object? notes = freezed,
    Object? isSuperset = null,
    Object? supersetGroupId = freezed,
    Object? isDropset = null,
    Object? isWarmup = null,
    Object? isCooldown = null,
    Object? targetRpe = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? exercise = freezed,
  }) {
    return _then(
      _$WorkoutExerciseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        workoutId: null == workoutId
            ? _value.workoutId
            : workoutId // ignore: cast_nullable_to_non_nullable
                  as String,
        exerciseId: null == exerciseId
            ? _value.exerciseId
            : exerciseId // ignore: cast_nullable_to_non_nullable
                  as String,
        orderIndex: null == orderIndex
            ? _value.orderIndex
            : orderIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        sets: null == sets
            ? _value.sets
            : sets // ignore: cast_nullable_to_non_nullable
                  as int,
        reps: freezed == reps
            ? _value.reps
            : reps // ignore: cast_nullable_to_non_nullable
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
        restTimeSeconds: null == restTimeSeconds
            ? _value.restTimeSeconds
            : restTimeSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        intensityPercentage: freezed == intensityPercentage
            ? _value.intensityPercentage
            : intensityPercentage // ignore: cast_nullable_to_non_nullable
                  as double?,
        tempo: freezed == tempo
            ? _value.tempo
            : tempo // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        isSuperset: null == isSuperset
            ? _value.isSuperset
            : isSuperset // ignore: cast_nullable_to_non_nullable
                  as bool,
        supersetGroupId: freezed == supersetGroupId
            ? _value.supersetGroupId
            : supersetGroupId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isDropset: null == isDropset
            ? _value.isDropset
            : isDropset // ignore: cast_nullable_to_non_nullable
                  as bool,
        isWarmup: null == isWarmup
            ? _value.isWarmup
            : isWarmup // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCooldown: null == isCooldown
            ? _value.isCooldown
            : isCooldown // ignore: cast_nullable_to_non_nullable
                  as bool,
        targetRpe: freezed == targetRpe
            ? _value.targetRpe
            : targetRpe // ignore: cast_nullable_to_non_nullable
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
class _$WorkoutExerciseImpl implements _WorkoutExercise {
  const _$WorkoutExerciseImpl({
    required this.id,
    required this.workoutId,
    required this.exerciseId,
    required this.orderIndex,
    this.sets = 1,
    this.reps,
    this.weightKg,
    this.durationSeconds,
    this.distanceMeters,
    this.restTimeSeconds = 60,
    this.intensityPercentage,
    this.tempo,
    this.notes,
    this.isSuperset = false,
    this.supersetGroupId,
    this.isDropset = false,
    this.isWarmup = false,
    this.isCooldown = false,
    this.targetRpe,
    this.createdAt,
    this.updatedAt,
    this.exercise,
  });

  factory _$WorkoutExerciseImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutExerciseImplFromJson(json);

  @override
  final String id;
  @override
  final String workoutId;
  @override
  final String exerciseId;
  @override
  final int orderIndex;
  @override
  @JsonKey()
  final int sets;
  @override
  final int? reps;
  @override
  final double? weightKg;
  @override
  final int? durationSeconds;
  @override
  final double? distanceMeters;
  @override
  @JsonKey()
  final int restTimeSeconds;
  @override
  final double? intensityPercentage;
  @override
  final String? tempo;
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool isSuperset;
  @override
  final String? supersetGroupId;
  @override
  @JsonKey()
  final bool isDropset;
  @override
  @JsonKey()
  final bool isWarmup;
  @override
  @JsonKey()
  final bool isCooldown;
  @override
  final int? targetRpe;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  // Related data
  @override
  final Exercise? exercise;

  @override
  String toString() {
    return 'WorkoutExercise(id: $id, workoutId: $workoutId, exerciseId: $exerciseId, orderIndex: $orderIndex, sets: $sets, reps: $reps, weightKg: $weightKg, durationSeconds: $durationSeconds, distanceMeters: $distanceMeters, restTimeSeconds: $restTimeSeconds, intensityPercentage: $intensityPercentage, tempo: $tempo, notes: $notes, isSuperset: $isSuperset, supersetGroupId: $supersetGroupId, isDropset: $isDropset, isWarmup: $isWarmup, isCooldown: $isCooldown, targetRpe: $targetRpe, createdAt: $createdAt, updatedAt: $updatedAt, exercise: $exercise)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutExerciseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workoutId, workoutId) ||
                other.workoutId == workoutId) &&
            (identical(other.exerciseId, exerciseId) ||
                other.exerciseId == exerciseId) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            (identical(other.sets, sets) || other.sets == sets) &&
            (identical(other.reps, reps) || other.reps == reps) &&
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
            (identical(other.tempo, tempo) || other.tempo == tempo) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isSuperset, isSuperset) ||
                other.isSuperset == isSuperset) &&
            (identical(other.supersetGroupId, supersetGroupId) ||
                other.supersetGroupId == supersetGroupId) &&
            (identical(other.isDropset, isDropset) ||
                other.isDropset == isDropset) &&
            (identical(other.isWarmup, isWarmup) ||
                other.isWarmup == isWarmup) &&
            (identical(other.isCooldown, isCooldown) ||
                other.isCooldown == isCooldown) &&
            (identical(other.targetRpe, targetRpe) ||
                other.targetRpe == targetRpe) &&
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
    workoutId,
    exerciseId,
    orderIndex,
    sets,
    reps,
    weightKg,
    durationSeconds,
    distanceMeters,
    restTimeSeconds,
    intensityPercentage,
    tempo,
    notes,
    isSuperset,
    supersetGroupId,
    isDropset,
    isWarmup,
    isCooldown,
    targetRpe,
    createdAt,
    updatedAt,
    exercise,
  ]);

  /// Create a copy of WorkoutExercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutExerciseImplCopyWith<_$WorkoutExerciseImpl> get copyWith =>
      __$$WorkoutExerciseImplCopyWithImpl<_$WorkoutExerciseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutExerciseImplToJson(this);
  }
}

abstract class _WorkoutExercise implements WorkoutExercise {
  const factory _WorkoutExercise({
    required final String id,
    required final String workoutId,
    required final String exerciseId,
    required final int orderIndex,
    final int sets,
    final int? reps,
    final double? weightKg,
    final int? durationSeconds,
    final double? distanceMeters,
    final int restTimeSeconds,
    final double? intensityPercentage,
    final String? tempo,
    final String? notes,
    final bool isSuperset,
    final String? supersetGroupId,
    final bool isDropset,
    final bool isWarmup,
    final bool isCooldown,
    final int? targetRpe,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final Exercise? exercise,
  }) = _$WorkoutExerciseImpl;

  factory _WorkoutExercise.fromJson(Map<String, dynamic> json) =
      _$WorkoutExerciseImpl.fromJson;

  @override
  String get id;
  @override
  String get workoutId;
  @override
  String get exerciseId;
  @override
  int get orderIndex;
  @override
  int get sets;
  @override
  int? get reps;
  @override
  double? get weightKg;
  @override
  int? get durationSeconds;
  @override
  double? get distanceMeters;
  @override
  int get restTimeSeconds;
  @override
  double? get intensityPercentage;
  @override
  String? get tempo;
  @override
  String? get notes;
  @override
  bool get isSuperset;
  @override
  String? get supersetGroupId;
  @override
  bool get isDropset;
  @override
  bool get isWarmup;
  @override
  bool get isCooldown;
  @override
  int? get targetRpe;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt; // Related data
  @override
  Exercise? get exercise;

  /// Create a copy of WorkoutExercise
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutExerciseImplCopyWith<_$WorkoutExerciseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
