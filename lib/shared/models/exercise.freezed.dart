// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Exercise _$ExerciseFromJson(Map<String, dynamic> json) {
  return _Exercise.fromJson(json);
}

/// @nodoc
mixin _$Exercise {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get instructions => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  bool get isPublic => throw _privateConstructorUsedError;
  String get difficultyLevel => throw _privateConstructorUsedError;
  String get exerciseType => throw _privateConstructorUsedError;
  List<String> get primaryMuscleGroups => throw _privateConstructorUsedError;
  List<String> get secondaryMuscleGroups => throw _privateConstructorUsedError;
  List<String> get equipmentRequired => throw _privateConstructorUsedError;
  List<String> get equipmentAlternatives => throw _privateConstructorUsedError;
  String? get movementPattern => throw _privateConstructorUsedError;
  String? get tempo => throw _privateConstructorUsedError;
  String? get rangeOfMotion => throw _privateConstructorUsedError;
  String? get breathingPattern => throw _privateConstructorUsedError;
  List<String> get commonMistakes => throw _privateConstructorUsedError;
  List<String> get progressions => throw _privateConstructorUsedError;
  List<String> get regressions => throw _privateConstructorUsedError;
  String? get safetyNotes => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get videoUrl => throw _privateConstructorUsedError;
  List<String> get demonstrationImages => throw _privateConstructorUsedError;
  double? get caloriesPerMinute => throw _privateConstructorUsedError;
  double? get metValue => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  bool get isUnilateral => throw _privateConstructorUsedError;
  bool get isCompound => throw _privateConstructorUsedError;
  bool get requiresSpotter => throw _privateConstructorUsedError;
  int get setupTimeSeconds => throw _privateConstructorUsedError;
  int get cleanupTimeSeconds => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Exercise to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExerciseCopyWith<Exercise> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseCopyWith<$Res> {
  factory $ExerciseCopyWith(Exercise value, $Res Function(Exercise) then) =
      _$ExerciseCopyWithImpl<$Res, Exercise>;
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    String? instructions,
    String? createdBy,
    bool isPublic,
    String difficultyLevel,
    String exerciseType,
    List<String> primaryMuscleGroups,
    List<String> secondaryMuscleGroups,
    List<String> equipmentRequired,
    List<String> equipmentAlternatives,
    String? movementPattern,
    String? tempo,
    String? rangeOfMotion,
    String? breathingPattern,
    List<String> commonMistakes,
    List<String> progressions,
    List<String> regressions,
    String? safetyNotes,
    String? imageUrl,
    String? videoUrl,
    List<String> demonstrationImages,
    double? caloriesPerMinute,
    double? metValue,
    List<String> tags,
    bool isUnilateral,
    bool isCompound,
    bool requiresSpotter,
    int setupTimeSeconds,
    int cleanupTimeSeconds,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$ExerciseCopyWithImpl<$Res, $Val extends Exercise>
    implements $ExerciseCopyWith<$Res> {
  _$ExerciseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? instructions = freezed,
    Object? createdBy = freezed,
    Object? isPublic = null,
    Object? difficultyLevel = null,
    Object? exerciseType = null,
    Object? primaryMuscleGroups = null,
    Object? secondaryMuscleGroups = null,
    Object? equipmentRequired = null,
    Object? equipmentAlternatives = null,
    Object? movementPattern = freezed,
    Object? tempo = freezed,
    Object? rangeOfMotion = freezed,
    Object? breathingPattern = freezed,
    Object? commonMistakes = null,
    Object? progressions = null,
    Object? regressions = null,
    Object? safetyNotes = freezed,
    Object? imageUrl = freezed,
    Object? videoUrl = freezed,
    Object? demonstrationImages = null,
    Object? caloriesPerMinute = freezed,
    Object? metValue = freezed,
    Object? tags = null,
    Object? isUnilateral = null,
    Object? isCompound = null,
    Object? requiresSpotter = null,
    Object? setupTimeSeconds = null,
    Object? cleanupTimeSeconds = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
            instructions: freezed == instructions
                ? _value.instructions
                : instructions // ignore: cast_nullable_to_non_nullable
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
            exerciseType: null == exerciseType
                ? _value.exerciseType
                : exerciseType // ignore: cast_nullable_to_non_nullable
                      as String,
            primaryMuscleGroups: null == primaryMuscleGroups
                ? _value.primaryMuscleGroups
                : primaryMuscleGroups // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            secondaryMuscleGroups: null == secondaryMuscleGroups
                ? _value.secondaryMuscleGroups
                : secondaryMuscleGroups // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            equipmentRequired: null == equipmentRequired
                ? _value.equipmentRequired
                : equipmentRequired // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            equipmentAlternatives: null == equipmentAlternatives
                ? _value.equipmentAlternatives
                : equipmentAlternatives // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            movementPattern: freezed == movementPattern
                ? _value.movementPattern
                : movementPattern // ignore: cast_nullable_to_non_nullable
                      as String?,
            tempo: freezed == tempo
                ? _value.tempo
                : tempo // ignore: cast_nullable_to_non_nullable
                      as String?,
            rangeOfMotion: freezed == rangeOfMotion
                ? _value.rangeOfMotion
                : rangeOfMotion // ignore: cast_nullable_to_non_nullable
                      as String?,
            breathingPattern: freezed == breathingPattern
                ? _value.breathingPattern
                : breathingPattern // ignore: cast_nullable_to_non_nullable
                      as String?,
            commonMistakes: null == commonMistakes
                ? _value.commonMistakes
                : commonMistakes // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            progressions: null == progressions
                ? _value.progressions
                : progressions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            regressions: null == regressions
                ? _value.regressions
                : regressions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            safetyNotes: freezed == safetyNotes
                ? _value.safetyNotes
                : safetyNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            videoUrl: freezed == videoUrl
                ? _value.videoUrl
                : videoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            demonstrationImages: null == demonstrationImages
                ? _value.demonstrationImages
                : demonstrationImages // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            caloriesPerMinute: freezed == caloriesPerMinute
                ? _value.caloriesPerMinute
                : caloriesPerMinute // ignore: cast_nullable_to_non_nullable
                      as double?,
            metValue: freezed == metValue
                ? _value.metValue
                : metValue // ignore: cast_nullable_to_non_nullable
                      as double?,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isUnilateral: null == isUnilateral
                ? _value.isUnilateral
                : isUnilateral // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCompound: null == isCompound
                ? _value.isCompound
                : isCompound // ignore: cast_nullable_to_non_nullable
                      as bool,
            requiresSpotter: null == requiresSpotter
                ? _value.requiresSpotter
                : requiresSpotter // ignore: cast_nullable_to_non_nullable
                      as bool,
            setupTimeSeconds: null == setupTimeSeconds
                ? _value.setupTimeSeconds
                : setupTimeSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            cleanupTimeSeconds: null == cleanupTimeSeconds
                ? _value.cleanupTimeSeconds
                : cleanupTimeSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
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
abstract class _$$ExerciseImplCopyWith<$Res>
    implements $ExerciseCopyWith<$Res> {
  factory _$$ExerciseImplCopyWith(
    _$ExerciseImpl value,
    $Res Function(_$ExerciseImpl) then,
  ) = __$$ExerciseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    String? instructions,
    String? createdBy,
    bool isPublic,
    String difficultyLevel,
    String exerciseType,
    List<String> primaryMuscleGroups,
    List<String> secondaryMuscleGroups,
    List<String> equipmentRequired,
    List<String> equipmentAlternatives,
    String? movementPattern,
    String? tempo,
    String? rangeOfMotion,
    String? breathingPattern,
    List<String> commonMistakes,
    List<String> progressions,
    List<String> regressions,
    String? safetyNotes,
    String? imageUrl,
    String? videoUrl,
    List<String> demonstrationImages,
    double? caloriesPerMinute,
    double? metValue,
    List<String> tags,
    bool isUnilateral,
    bool isCompound,
    bool requiresSpotter,
    int setupTimeSeconds,
    int cleanupTimeSeconds,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$ExerciseImplCopyWithImpl<$Res>
    extends _$ExerciseCopyWithImpl<$Res, _$ExerciseImpl>
    implements _$$ExerciseImplCopyWith<$Res> {
  __$$ExerciseImplCopyWithImpl(
    _$ExerciseImpl _value,
    $Res Function(_$ExerciseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? instructions = freezed,
    Object? createdBy = freezed,
    Object? isPublic = null,
    Object? difficultyLevel = null,
    Object? exerciseType = null,
    Object? primaryMuscleGroups = null,
    Object? secondaryMuscleGroups = null,
    Object? equipmentRequired = null,
    Object? equipmentAlternatives = null,
    Object? movementPattern = freezed,
    Object? tempo = freezed,
    Object? rangeOfMotion = freezed,
    Object? breathingPattern = freezed,
    Object? commonMistakes = null,
    Object? progressions = null,
    Object? regressions = null,
    Object? safetyNotes = freezed,
    Object? imageUrl = freezed,
    Object? videoUrl = freezed,
    Object? demonstrationImages = null,
    Object? caloriesPerMinute = freezed,
    Object? metValue = freezed,
    Object? tags = null,
    Object? isUnilateral = null,
    Object? isCompound = null,
    Object? requiresSpotter = null,
    Object? setupTimeSeconds = null,
    Object? cleanupTimeSeconds = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ExerciseImpl(
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
        instructions: freezed == instructions
            ? _value.instructions
            : instructions // ignore: cast_nullable_to_non_nullable
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
        exerciseType: null == exerciseType
            ? _value.exerciseType
            : exerciseType // ignore: cast_nullable_to_non_nullable
                  as String,
        primaryMuscleGroups: null == primaryMuscleGroups
            ? _value._primaryMuscleGroups
            : primaryMuscleGroups // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        secondaryMuscleGroups: null == secondaryMuscleGroups
            ? _value._secondaryMuscleGroups
            : secondaryMuscleGroups // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        equipmentRequired: null == equipmentRequired
            ? _value._equipmentRequired
            : equipmentRequired // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        equipmentAlternatives: null == equipmentAlternatives
            ? _value._equipmentAlternatives
            : equipmentAlternatives // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        movementPattern: freezed == movementPattern
            ? _value.movementPattern
            : movementPattern // ignore: cast_nullable_to_non_nullable
                  as String?,
        tempo: freezed == tempo
            ? _value.tempo
            : tempo // ignore: cast_nullable_to_non_nullable
                  as String?,
        rangeOfMotion: freezed == rangeOfMotion
            ? _value.rangeOfMotion
            : rangeOfMotion // ignore: cast_nullable_to_non_nullable
                  as String?,
        breathingPattern: freezed == breathingPattern
            ? _value.breathingPattern
            : breathingPattern // ignore: cast_nullable_to_non_nullable
                  as String?,
        commonMistakes: null == commonMistakes
            ? _value._commonMistakes
            : commonMistakes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        progressions: null == progressions
            ? _value._progressions
            : progressions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        regressions: null == regressions
            ? _value._regressions
            : regressions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        safetyNotes: freezed == safetyNotes
            ? _value.safetyNotes
            : safetyNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        videoUrl: freezed == videoUrl
            ? _value.videoUrl
            : videoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        demonstrationImages: null == demonstrationImages
            ? _value._demonstrationImages
            : demonstrationImages // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        caloriesPerMinute: freezed == caloriesPerMinute
            ? _value.caloriesPerMinute
            : caloriesPerMinute // ignore: cast_nullable_to_non_nullable
                  as double?,
        metValue: freezed == metValue
            ? _value.metValue
            : metValue // ignore: cast_nullable_to_non_nullable
                  as double?,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isUnilateral: null == isUnilateral
            ? _value.isUnilateral
            : isUnilateral // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCompound: null == isCompound
            ? _value.isCompound
            : isCompound // ignore: cast_nullable_to_non_nullable
                  as bool,
        requiresSpotter: null == requiresSpotter
            ? _value.requiresSpotter
            : requiresSpotter // ignore: cast_nullable_to_non_nullable
                  as bool,
        setupTimeSeconds: null == setupTimeSeconds
            ? _value.setupTimeSeconds
            : setupTimeSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        cleanupTimeSeconds: null == cleanupTimeSeconds
            ? _value.cleanupTimeSeconds
            : cleanupTimeSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
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
class _$ExerciseImpl implements _Exercise {
  const _$ExerciseImpl({
    required this.id,
    required this.name,
    this.description,
    this.instructions,
    this.createdBy,
    this.isPublic = false,
    this.difficultyLevel = 'beginner',
    this.exerciseType = 'strength',
    final List<String> primaryMuscleGroups = const [],
    final List<String> secondaryMuscleGroups = const [],
    final List<String> equipmentRequired = const [],
    final List<String> equipmentAlternatives = const [],
    this.movementPattern,
    this.tempo,
    this.rangeOfMotion,
    this.breathingPattern,
    final List<String> commonMistakes = const [],
    final List<String> progressions = const [],
    final List<String> regressions = const [],
    this.safetyNotes,
    this.imageUrl,
    this.videoUrl,
    final List<String> demonstrationImages = const [],
    this.caloriesPerMinute,
    this.metValue,
    final List<String> tags = const [],
    this.isUnilateral = false,
    this.isCompound = true,
    this.requiresSpotter = false,
    this.setupTimeSeconds = 30,
    this.cleanupTimeSeconds = 15,
    this.createdAt,
    this.updatedAt,
  }) : _primaryMuscleGroups = primaryMuscleGroups,
       _secondaryMuscleGroups = secondaryMuscleGroups,
       _equipmentRequired = equipmentRequired,
       _equipmentAlternatives = equipmentAlternatives,
       _commonMistakes = commonMistakes,
       _progressions = progressions,
       _regressions = regressions,
       _demonstrationImages = demonstrationImages,
       _tags = tags;

  factory _$ExerciseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExerciseImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? instructions;
  @override
  final String? createdBy;
  @override
  @JsonKey()
  final bool isPublic;
  @override
  @JsonKey()
  final String difficultyLevel;
  @override
  @JsonKey()
  final String exerciseType;
  final List<String> _primaryMuscleGroups;
  @override
  @JsonKey()
  List<String> get primaryMuscleGroups {
    if (_primaryMuscleGroups is EqualUnmodifiableListView)
      return _primaryMuscleGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_primaryMuscleGroups);
  }

  final List<String> _secondaryMuscleGroups;
  @override
  @JsonKey()
  List<String> get secondaryMuscleGroups {
    if (_secondaryMuscleGroups is EqualUnmodifiableListView)
      return _secondaryMuscleGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_secondaryMuscleGroups);
  }

  final List<String> _equipmentRequired;
  @override
  @JsonKey()
  List<String> get equipmentRequired {
    if (_equipmentRequired is EqualUnmodifiableListView)
      return _equipmentRequired;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_equipmentRequired);
  }

  final List<String> _equipmentAlternatives;
  @override
  @JsonKey()
  List<String> get equipmentAlternatives {
    if (_equipmentAlternatives is EqualUnmodifiableListView)
      return _equipmentAlternatives;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_equipmentAlternatives);
  }

  @override
  final String? movementPattern;
  @override
  final String? tempo;
  @override
  final String? rangeOfMotion;
  @override
  final String? breathingPattern;
  final List<String> _commonMistakes;
  @override
  @JsonKey()
  List<String> get commonMistakes {
    if (_commonMistakes is EqualUnmodifiableListView) return _commonMistakes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_commonMistakes);
  }

  final List<String> _progressions;
  @override
  @JsonKey()
  List<String> get progressions {
    if (_progressions is EqualUnmodifiableListView) return _progressions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_progressions);
  }

  final List<String> _regressions;
  @override
  @JsonKey()
  List<String> get regressions {
    if (_regressions is EqualUnmodifiableListView) return _regressions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_regressions);
  }

  @override
  final String? safetyNotes;
  @override
  final String? imageUrl;
  @override
  final String? videoUrl;
  final List<String> _demonstrationImages;
  @override
  @JsonKey()
  List<String> get demonstrationImages {
    if (_demonstrationImages is EqualUnmodifiableListView)
      return _demonstrationImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_demonstrationImages);
  }

  @override
  final double? caloriesPerMinute;
  @override
  final double? metValue;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final bool isUnilateral;
  @override
  @JsonKey()
  final bool isCompound;
  @override
  @JsonKey()
  final bool requiresSpotter;
  @override
  @JsonKey()
  final int setupTimeSeconds;
  @override
  @JsonKey()
  final int cleanupTimeSeconds;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Exercise(id: $id, name: $name, description: $description, instructions: $instructions, createdBy: $createdBy, isPublic: $isPublic, difficultyLevel: $difficultyLevel, exerciseType: $exerciseType, primaryMuscleGroups: $primaryMuscleGroups, secondaryMuscleGroups: $secondaryMuscleGroups, equipmentRequired: $equipmentRequired, equipmentAlternatives: $equipmentAlternatives, movementPattern: $movementPattern, tempo: $tempo, rangeOfMotion: $rangeOfMotion, breathingPattern: $breathingPattern, commonMistakes: $commonMistakes, progressions: $progressions, regressions: $regressions, safetyNotes: $safetyNotes, imageUrl: $imageUrl, videoUrl: $videoUrl, demonstrationImages: $demonstrationImages, caloriesPerMinute: $caloriesPerMinute, metValue: $metValue, tags: $tags, isUnilateral: $isUnilateral, isCompound: $isCompound, requiresSpotter: $requiresSpotter, setupTimeSeconds: $setupTimeSeconds, cleanupTimeSeconds: $cleanupTimeSeconds, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.instructions, instructions) ||
                other.instructions == instructions) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.difficultyLevel, difficultyLevel) ||
                other.difficultyLevel == difficultyLevel) &&
            (identical(other.exerciseType, exerciseType) ||
                other.exerciseType == exerciseType) &&
            const DeepCollectionEquality().equals(
              other._primaryMuscleGroups,
              _primaryMuscleGroups,
            ) &&
            const DeepCollectionEquality().equals(
              other._secondaryMuscleGroups,
              _secondaryMuscleGroups,
            ) &&
            const DeepCollectionEquality().equals(
              other._equipmentRequired,
              _equipmentRequired,
            ) &&
            const DeepCollectionEquality().equals(
              other._equipmentAlternatives,
              _equipmentAlternatives,
            ) &&
            (identical(other.movementPattern, movementPattern) ||
                other.movementPattern == movementPattern) &&
            (identical(other.tempo, tempo) || other.tempo == tempo) &&
            (identical(other.rangeOfMotion, rangeOfMotion) ||
                other.rangeOfMotion == rangeOfMotion) &&
            (identical(other.breathingPattern, breathingPattern) ||
                other.breathingPattern == breathingPattern) &&
            const DeepCollectionEquality().equals(
              other._commonMistakes,
              _commonMistakes,
            ) &&
            const DeepCollectionEquality().equals(
              other._progressions,
              _progressions,
            ) &&
            const DeepCollectionEquality().equals(
              other._regressions,
              _regressions,
            ) &&
            (identical(other.safetyNotes, safetyNotes) ||
                other.safetyNotes == safetyNotes) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            const DeepCollectionEquality().equals(
              other._demonstrationImages,
              _demonstrationImages,
            ) &&
            (identical(other.caloriesPerMinute, caloriesPerMinute) ||
                other.caloriesPerMinute == caloriesPerMinute) &&
            (identical(other.metValue, metValue) ||
                other.metValue == metValue) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isUnilateral, isUnilateral) ||
                other.isUnilateral == isUnilateral) &&
            (identical(other.isCompound, isCompound) ||
                other.isCompound == isCompound) &&
            (identical(other.requiresSpotter, requiresSpotter) ||
                other.requiresSpotter == requiresSpotter) &&
            (identical(other.setupTimeSeconds, setupTimeSeconds) ||
                other.setupTimeSeconds == setupTimeSeconds) &&
            (identical(other.cleanupTimeSeconds, cleanupTimeSeconds) ||
                other.cleanupTimeSeconds == cleanupTimeSeconds) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    description,
    instructions,
    createdBy,
    isPublic,
    difficultyLevel,
    exerciseType,
    const DeepCollectionEquality().hash(_primaryMuscleGroups),
    const DeepCollectionEquality().hash(_secondaryMuscleGroups),
    const DeepCollectionEquality().hash(_equipmentRequired),
    const DeepCollectionEquality().hash(_equipmentAlternatives),
    movementPattern,
    tempo,
    rangeOfMotion,
    breathingPattern,
    const DeepCollectionEquality().hash(_commonMistakes),
    const DeepCollectionEquality().hash(_progressions),
    const DeepCollectionEquality().hash(_regressions),
    safetyNotes,
    imageUrl,
    videoUrl,
    const DeepCollectionEquality().hash(_demonstrationImages),
    caloriesPerMinute,
    metValue,
    const DeepCollectionEquality().hash(_tags),
    isUnilateral,
    isCompound,
    requiresSpotter,
    setupTimeSeconds,
    cleanupTimeSeconds,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseImplCopyWith<_$ExerciseImpl> get copyWith =>
      __$$ExerciseImplCopyWithImpl<_$ExerciseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseImplToJson(this);
  }
}

abstract class _Exercise implements Exercise {
  const factory _Exercise({
    required final String id,
    required final String name,
    final String? description,
    final String? instructions,
    final String? createdBy,
    final bool isPublic,
    final String difficultyLevel,
    final String exerciseType,
    final List<String> primaryMuscleGroups,
    final List<String> secondaryMuscleGroups,
    final List<String> equipmentRequired,
    final List<String> equipmentAlternatives,
    final String? movementPattern,
    final String? tempo,
    final String? rangeOfMotion,
    final String? breathingPattern,
    final List<String> commonMistakes,
    final List<String> progressions,
    final List<String> regressions,
    final String? safetyNotes,
    final String? imageUrl,
    final String? videoUrl,
    final List<String> demonstrationImages,
    final double? caloriesPerMinute,
    final double? metValue,
    final List<String> tags,
    final bool isUnilateral,
    final bool isCompound,
    final bool requiresSpotter,
    final int setupTimeSeconds,
    final int cleanupTimeSeconds,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$ExerciseImpl;

  factory _Exercise.fromJson(Map<String, dynamic> json) =
      _$ExerciseImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get instructions;
  @override
  String? get createdBy;
  @override
  bool get isPublic;
  @override
  String get difficultyLevel;
  @override
  String get exerciseType;
  @override
  List<String> get primaryMuscleGroups;
  @override
  List<String> get secondaryMuscleGroups;
  @override
  List<String> get equipmentRequired;
  @override
  List<String> get equipmentAlternatives;
  @override
  String? get movementPattern;
  @override
  String? get tempo;
  @override
  String? get rangeOfMotion;
  @override
  String? get breathingPattern;
  @override
  List<String> get commonMistakes;
  @override
  List<String> get progressions;
  @override
  List<String> get regressions;
  @override
  String? get safetyNotes;
  @override
  String? get imageUrl;
  @override
  String? get videoUrl;
  @override
  List<String> get demonstrationImages;
  @override
  double? get caloriesPerMinute;
  @override
  double? get metValue;
  @override
  List<String> get tags;
  @override
  bool get isUnilateral;
  @override
  bool get isCompound;
  @override
  bool get requiresSpotter;
  @override
  int get setupTimeSeconds;
  @override
  int get cleanupTimeSeconds;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExerciseImplCopyWith<_$ExerciseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExerciseCategory _$ExerciseCategoryFromJson(Map<String, dynamic> json) {
  return _ExerciseCategory.fromJson(json);
}

/// @nodoc
mixin _$ExerciseCategory {
  String get id => throw _privateConstructorUsedError;
  String get exerciseId => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ExerciseCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExerciseCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExerciseCategoryCopyWith<ExerciseCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseCategoryCopyWith<$Res> {
  factory $ExerciseCategoryCopyWith(
    ExerciseCategory value,
    $Res Function(ExerciseCategory) then,
  ) = _$ExerciseCategoryCopyWithImpl<$Res, ExerciseCategory>;
  @useResult
  $Res call({
    String id,
    String exerciseId,
    String categoryId,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$ExerciseCategoryCopyWithImpl<$Res, $Val extends ExerciseCategory>
    implements $ExerciseCategoryCopyWith<$Res> {
  _$ExerciseCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExerciseCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? exerciseId = null,
    Object? categoryId = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            exerciseId: null == exerciseId
                ? _value.exerciseId
                : exerciseId // ignore: cast_nullable_to_non_nullable
                      as String,
            categoryId: null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$ExerciseCategoryImplCopyWith<$Res>
    implements $ExerciseCategoryCopyWith<$Res> {
  factory _$$ExerciseCategoryImplCopyWith(
    _$ExerciseCategoryImpl value,
    $Res Function(_$ExerciseCategoryImpl) then,
  ) = __$$ExerciseCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String exerciseId,
    String categoryId,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$ExerciseCategoryImplCopyWithImpl<$Res>
    extends _$ExerciseCategoryCopyWithImpl<$Res, _$ExerciseCategoryImpl>
    implements _$$ExerciseCategoryImplCopyWith<$Res> {
  __$$ExerciseCategoryImplCopyWithImpl(
    _$ExerciseCategoryImpl _value,
    $Res Function(_$ExerciseCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExerciseCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? exerciseId = null,
    Object? categoryId = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$ExerciseCategoryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        exerciseId: null == exerciseId
            ? _value.exerciseId
            : exerciseId // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$ExerciseCategoryImpl implements _ExerciseCategory {
  const _$ExerciseCategoryImpl({
    required this.id,
    required this.exerciseId,
    required this.categoryId,
    this.createdAt,
  });

  factory _$ExerciseCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExerciseCategoryImplFromJson(json);

  @override
  final String id;
  @override
  final String exerciseId;
  @override
  final String categoryId;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ExerciseCategory(id: $id, exerciseId: $exerciseId, categoryId: $categoryId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.exerciseId, exerciseId) ||
                other.exerciseId == exerciseId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, exerciseId, categoryId, createdAt);

  /// Create a copy of ExerciseCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseCategoryImplCopyWith<_$ExerciseCategoryImpl> get copyWith =>
      __$$ExerciseCategoryImplCopyWithImpl<_$ExerciseCategoryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseCategoryImplToJson(this);
  }
}

abstract class _ExerciseCategory implements ExerciseCategory {
  const factory _ExerciseCategory({
    required final String id,
    required final String exerciseId,
    required final String categoryId,
    final DateTime? createdAt,
  }) = _$ExerciseCategoryImpl;

  factory _ExerciseCategory.fromJson(Map<String, dynamic> json) =
      _$ExerciseCategoryImpl.fromJson;

  @override
  String get id;
  @override
  String get exerciseId;
  @override
  String get categoryId;
  @override
  DateTime? get createdAt;

  /// Create a copy of ExerciseCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExerciseCategoryImplCopyWith<_$ExerciseCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return _Category.fromJson(json);
}

/// @nodoc
mixin _$Category {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  String? get parentCategoryId => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Category to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryCopyWith<Category> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryCopyWith<$Res> {
  factory $CategoryCopyWith(Category value, $Res Function(Category) then) =
      _$CategoryCopyWithImpl<$Res, Category>;
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    String? icon,
    String? color,
    String? parentCategoryId,
    int sortOrder,
    bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$CategoryCopyWithImpl<$Res, $Val extends Category>
    implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? icon = freezed,
    Object? color = freezed,
    Object? parentCategoryId = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
            icon: freezed == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String?,
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
            parentCategoryId: freezed == parentCategoryId
                ? _value.parentCategoryId
                : parentCategoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
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
abstract class _$$CategoryImplCopyWith<$Res>
    implements $CategoryCopyWith<$Res> {
  factory _$$CategoryImplCopyWith(
    _$CategoryImpl value,
    $Res Function(_$CategoryImpl) then,
  ) = __$$CategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    String? icon,
    String? color,
    String? parentCategoryId,
    int sortOrder,
    bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$CategoryImplCopyWithImpl<$Res>
    extends _$CategoryCopyWithImpl<$Res, _$CategoryImpl>
    implements _$$CategoryImplCopyWith<$Res> {
  __$$CategoryImplCopyWithImpl(
    _$CategoryImpl _value,
    $Res Function(_$CategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? icon = freezed,
    Object? color = freezed,
    Object? parentCategoryId = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$CategoryImpl(
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
        icon: freezed == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String?,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
        parentCategoryId: freezed == parentCategoryId
            ? _value.parentCategoryId
            : parentCategoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
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
class _$CategoryImpl implements _Category {
  const _$CategoryImpl({
    required this.id,
    required this.name,
    this.description,
    this.icon,
    this.color,
    this.parentCategoryId,
    this.sortOrder = 0,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory _$CategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? icon;
  @override
  final String? color;
  @override
  final String? parentCategoryId;
  @override
  @JsonKey()
  final int sortOrder;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Category(id: $id, name: $name, description: $description, icon: $icon, color: $color, parentCategoryId: $parentCategoryId, sortOrder: $sortOrder, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.parentCategoryId, parentCategoryId) ||
                other.parentCategoryId == parentCategoryId) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
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
    name,
    description,
    icon,
    color,
    parentCategoryId,
    sortOrder,
    isActive,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryImplCopyWith<_$CategoryImpl> get copyWith =>
      __$$CategoryImplCopyWithImpl<_$CategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryImplToJson(this);
  }
}

abstract class _Category implements Category {
  const factory _Category({
    required final String id,
    required final String name,
    final String? description,
    final String? icon,
    final String? color,
    final String? parentCategoryId,
    final int sortOrder,
    final bool isActive,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$CategoryImpl;

  factory _Category.fromJson(Map<String, dynamic> json) =
      _$CategoryImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get icon;
  @override
  String? get color;
  @override
  String? get parentCategoryId;
  @override
  int get sortOrder;
  @override
  bool get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryImplCopyWith<_$CategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
