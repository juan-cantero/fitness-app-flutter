// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'equipment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Equipment _$EquipmentFromJson(Map<String, dynamic> json) {
  return _Equipment.fromJson(json);
}

/// @nodoc
mixin _$Equipment {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String? get subCategory => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  List<String> get muscleGroupsPrimary => throw _privateConstructorUsedError;
  List<String> get muscleGroupsSecondary => throw _privateConstructorUsedError;
  String get spaceRequirement => throw _privateConstructorUsedError;
  String get difficultyLevel => throw _privateConstructorUsedError;
  bool get isHomeGym => throw _privateConstructorUsedError;
  bool get isCommercialGym => throw _privateConstructorUsedError;
  String get costCategory => throw _privateConstructorUsedError;
  List<String> get alternatives => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Equipment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Equipment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EquipmentCopyWith<Equipment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EquipmentCopyWith<$Res> {
  factory $EquipmentCopyWith(Equipment value, $Res Function(Equipment) then) =
      _$EquipmentCopyWithImpl<$Res, Equipment>;
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    String category,
    String? subCategory,
    String? imageUrl,
    List<String> muscleGroupsPrimary,
    List<String> muscleGroupsSecondary,
    String spaceRequirement,
    String difficultyLevel,
    bool isHomeGym,
    bool isCommercialGym,
    String costCategory,
    List<String> alternatives,
    List<String> tags,
    bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$EquipmentCopyWithImpl<$Res, $Val extends Equipment>
    implements $EquipmentCopyWith<$Res> {
  _$EquipmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Equipment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? category = null,
    Object? subCategory = freezed,
    Object? imageUrl = freezed,
    Object? muscleGroupsPrimary = null,
    Object? muscleGroupsSecondary = null,
    Object? spaceRequirement = null,
    Object? difficultyLevel = null,
    Object? isHomeGym = null,
    Object? isCommercialGym = null,
    Object? costCategory = null,
    Object? alternatives = null,
    Object? tags = null,
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
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            subCategory: freezed == subCategory
                ? _value.subCategory
                : subCategory // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            muscleGroupsPrimary: null == muscleGroupsPrimary
                ? _value.muscleGroupsPrimary
                : muscleGroupsPrimary // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            muscleGroupsSecondary: null == muscleGroupsSecondary
                ? _value.muscleGroupsSecondary
                : muscleGroupsSecondary // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            spaceRequirement: null == spaceRequirement
                ? _value.spaceRequirement
                : spaceRequirement // ignore: cast_nullable_to_non_nullable
                      as String,
            difficultyLevel: null == difficultyLevel
                ? _value.difficultyLevel
                : difficultyLevel // ignore: cast_nullable_to_non_nullable
                      as String,
            isHomeGym: null == isHomeGym
                ? _value.isHomeGym
                : isHomeGym // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCommercialGym: null == isCommercialGym
                ? _value.isCommercialGym
                : isCommercialGym // ignore: cast_nullable_to_non_nullable
                      as bool,
            costCategory: null == costCategory
                ? _value.costCategory
                : costCategory // ignore: cast_nullable_to_non_nullable
                      as String,
            alternatives: null == alternatives
                ? _value.alternatives
                : alternatives // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
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
abstract class _$$EquipmentImplCopyWith<$Res>
    implements $EquipmentCopyWith<$Res> {
  factory _$$EquipmentImplCopyWith(
    _$EquipmentImpl value,
    $Res Function(_$EquipmentImpl) then,
  ) = __$$EquipmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    String category,
    String? subCategory,
    String? imageUrl,
    List<String> muscleGroupsPrimary,
    List<String> muscleGroupsSecondary,
    String spaceRequirement,
    String difficultyLevel,
    bool isHomeGym,
    bool isCommercialGym,
    String costCategory,
    List<String> alternatives,
    List<String> tags,
    bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$EquipmentImplCopyWithImpl<$Res>
    extends _$EquipmentCopyWithImpl<$Res, _$EquipmentImpl>
    implements _$$EquipmentImplCopyWith<$Res> {
  __$$EquipmentImplCopyWithImpl(
    _$EquipmentImpl _value,
    $Res Function(_$EquipmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Equipment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? category = null,
    Object? subCategory = freezed,
    Object? imageUrl = freezed,
    Object? muscleGroupsPrimary = null,
    Object? muscleGroupsSecondary = null,
    Object? spaceRequirement = null,
    Object? difficultyLevel = null,
    Object? isHomeGym = null,
    Object? isCommercialGym = null,
    Object? costCategory = null,
    Object? alternatives = null,
    Object? tags = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$EquipmentImpl(
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
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        subCategory: freezed == subCategory
            ? _value.subCategory
            : subCategory // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        muscleGroupsPrimary: null == muscleGroupsPrimary
            ? _value._muscleGroupsPrimary
            : muscleGroupsPrimary // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        muscleGroupsSecondary: null == muscleGroupsSecondary
            ? _value._muscleGroupsSecondary
            : muscleGroupsSecondary // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        spaceRequirement: null == spaceRequirement
            ? _value.spaceRequirement
            : spaceRequirement // ignore: cast_nullable_to_non_nullable
                  as String,
        difficultyLevel: null == difficultyLevel
            ? _value.difficultyLevel
            : difficultyLevel // ignore: cast_nullable_to_non_nullable
                  as String,
        isHomeGym: null == isHomeGym
            ? _value.isHomeGym
            : isHomeGym // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCommercialGym: null == isCommercialGym
            ? _value.isCommercialGym
            : isCommercialGym // ignore: cast_nullable_to_non_nullable
                  as bool,
        costCategory: null == costCategory
            ? _value.costCategory
            : costCategory // ignore: cast_nullable_to_non_nullable
                  as String,
        alternatives: null == alternatives
            ? _value._alternatives
            : alternatives // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
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
class _$EquipmentImpl implements _Equipment {
  const _$EquipmentImpl({
    required this.id,
    required this.name,
    this.description,
    this.category = 'strength',
    this.subCategory,
    this.imageUrl,
    final List<String> muscleGroupsPrimary = const [],
    final List<String> muscleGroupsSecondary = const [],
    this.spaceRequirement = 'minimal',
    this.difficultyLevel = 'beginner',
    this.isHomeGym = true,
    this.isCommercialGym = true,
    this.costCategory = 'medium',
    final List<String> alternatives = const [],
    final List<String> tags = const [],
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  }) : _muscleGroupsPrimary = muscleGroupsPrimary,
       _muscleGroupsSecondary = muscleGroupsSecondary,
       _alternatives = alternatives,
       _tags = tags;

  factory _$EquipmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$EquipmentImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey()
  final String category;
  @override
  final String? subCategory;
  @override
  final String? imageUrl;
  final List<String> _muscleGroupsPrimary;
  @override
  @JsonKey()
  List<String> get muscleGroupsPrimary {
    if (_muscleGroupsPrimary is EqualUnmodifiableListView)
      return _muscleGroupsPrimary;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_muscleGroupsPrimary);
  }

  final List<String> _muscleGroupsSecondary;
  @override
  @JsonKey()
  List<String> get muscleGroupsSecondary {
    if (_muscleGroupsSecondary is EqualUnmodifiableListView)
      return _muscleGroupsSecondary;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_muscleGroupsSecondary);
  }

  @override
  @JsonKey()
  final String spaceRequirement;
  @override
  @JsonKey()
  final String difficultyLevel;
  @override
  @JsonKey()
  final bool isHomeGym;
  @override
  @JsonKey()
  final bool isCommercialGym;
  @override
  @JsonKey()
  final String costCategory;
  final List<String> _alternatives;
  @override
  @JsonKey()
  List<String> get alternatives {
    if (_alternatives is EqualUnmodifiableListView) return _alternatives;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alternatives);
  }

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
  final bool isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Equipment(id: $id, name: $name, description: $description, category: $category, subCategory: $subCategory, imageUrl: $imageUrl, muscleGroupsPrimary: $muscleGroupsPrimary, muscleGroupsSecondary: $muscleGroupsSecondary, spaceRequirement: $spaceRequirement, difficultyLevel: $difficultyLevel, isHomeGym: $isHomeGym, isCommercialGym: $isCommercialGym, costCategory: $costCategory, alternatives: $alternatives, tags: $tags, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EquipmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.subCategory, subCategory) ||
                other.subCategory == subCategory) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(
              other._muscleGroupsPrimary,
              _muscleGroupsPrimary,
            ) &&
            const DeepCollectionEquality().equals(
              other._muscleGroupsSecondary,
              _muscleGroupsSecondary,
            ) &&
            (identical(other.spaceRequirement, spaceRequirement) ||
                other.spaceRequirement == spaceRequirement) &&
            (identical(other.difficultyLevel, difficultyLevel) ||
                other.difficultyLevel == difficultyLevel) &&
            (identical(other.isHomeGym, isHomeGym) ||
                other.isHomeGym == isHomeGym) &&
            (identical(other.isCommercialGym, isCommercialGym) ||
                other.isCommercialGym == isCommercialGym) &&
            (identical(other.costCategory, costCategory) ||
                other.costCategory == costCategory) &&
            const DeepCollectionEquality().equals(
              other._alternatives,
              _alternatives,
            ) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
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
    category,
    subCategory,
    imageUrl,
    const DeepCollectionEquality().hash(_muscleGroupsPrimary),
    const DeepCollectionEquality().hash(_muscleGroupsSecondary),
    spaceRequirement,
    difficultyLevel,
    isHomeGym,
    isCommercialGym,
    costCategory,
    const DeepCollectionEquality().hash(_alternatives),
    const DeepCollectionEquality().hash(_tags),
    isActive,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Equipment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EquipmentImplCopyWith<_$EquipmentImpl> get copyWith =>
      __$$EquipmentImplCopyWithImpl<_$EquipmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EquipmentImplToJson(this);
  }
}

abstract class _Equipment implements Equipment {
  const factory _Equipment({
    required final String id,
    required final String name,
    final String? description,
    final String category,
    final String? subCategory,
    final String? imageUrl,
    final List<String> muscleGroupsPrimary,
    final List<String> muscleGroupsSecondary,
    final String spaceRequirement,
    final String difficultyLevel,
    final bool isHomeGym,
    final bool isCommercialGym,
    final String costCategory,
    final List<String> alternatives,
    final List<String> tags,
    final bool isActive,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$EquipmentImpl;

  factory _Equipment.fromJson(Map<String, dynamic> json) =
      _$EquipmentImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String get category;
  @override
  String? get subCategory;
  @override
  String? get imageUrl;
  @override
  List<String> get muscleGroupsPrimary;
  @override
  List<String> get muscleGroupsSecondary;
  @override
  String get spaceRequirement;
  @override
  String get difficultyLevel;
  @override
  bool get isHomeGym;
  @override
  bool get isCommercialGym;
  @override
  String get costCategory;
  @override
  List<String> get alternatives;
  @override
  List<String> get tags;
  @override
  bool get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Equipment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EquipmentImplCopyWith<_$EquipmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserEquipment _$UserEquipmentFromJson(Map<String, dynamic> json) {
  return _UserEquipment.fromJson(json);
}

/// @nodoc
mixin _$UserEquipment {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get equipmentId => throw _privateConstructorUsedError;
  String get accessType => throw _privateConstructorUsedError;
  int? get conditionRating => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get acquiredDate => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Joined equipment details
  Equipment? get equipment => throw _privateConstructorUsedError;

  /// Serializes this UserEquipment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserEquipment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserEquipmentCopyWith<UserEquipment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserEquipmentCopyWith<$Res> {
  factory $UserEquipmentCopyWith(
    UserEquipment value,
    $Res Function(UserEquipment) then,
  ) = _$UserEquipmentCopyWithImpl<$Res, UserEquipment>;
  @useResult
  $Res call({
    String id,
    String userId,
    String equipmentId,
    String accessType,
    int? conditionRating,
    String? notes,
    DateTime? acquiredDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    Equipment? equipment,
  });

  $EquipmentCopyWith<$Res>? get equipment;
}

/// @nodoc
class _$UserEquipmentCopyWithImpl<$Res, $Val extends UserEquipment>
    implements $UserEquipmentCopyWith<$Res> {
  _$UserEquipmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserEquipment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? equipmentId = null,
    Object? accessType = null,
    Object? conditionRating = freezed,
    Object? notes = freezed,
    Object? acquiredDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? equipment = freezed,
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
            equipmentId: null == equipmentId
                ? _value.equipmentId
                : equipmentId // ignore: cast_nullable_to_non_nullable
                      as String,
            accessType: null == accessType
                ? _value.accessType
                : accessType // ignore: cast_nullable_to_non_nullable
                      as String,
            conditionRating: freezed == conditionRating
                ? _value.conditionRating
                : conditionRating // ignore: cast_nullable_to_non_nullable
                      as int?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            acquiredDate: freezed == acquiredDate
                ? _value.acquiredDate
                : acquiredDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            equipment: freezed == equipment
                ? _value.equipment
                : equipment // ignore: cast_nullable_to_non_nullable
                      as Equipment?,
          )
          as $Val,
    );
  }

  /// Create a copy of UserEquipment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EquipmentCopyWith<$Res>? get equipment {
    if (_value.equipment == null) {
      return null;
    }

    return $EquipmentCopyWith<$Res>(_value.equipment!, (value) {
      return _then(_value.copyWith(equipment: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserEquipmentImplCopyWith<$Res>
    implements $UserEquipmentCopyWith<$Res> {
  factory _$$UserEquipmentImplCopyWith(
    _$UserEquipmentImpl value,
    $Res Function(_$UserEquipmentImpl) then,
  ) = __$$UserEquipmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String equipmentId,
    String accessType,
    int? conditionRating,
    String? notes,
    DateTime? acquiredDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    Equipment? equipment,
  });

  @override
  $EquipmentCopyWith<$Res>? get equipment;
}

/// @nodoc
class __$$UserEquipmentImplCopyWithImpl<$Res>
    extends _$UserEquipmentCopyWithImpl<$Res, _$UserEquipmentImpl>
    implements _$$UserEquipmentImplCopyWith<$Res> {
  __$$UserEquipmentImplCopyWithImpl(
    _$UserEquipmentImpl _value,
    $Res Function(_$UserEquipmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserEquipment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? equipmentId = null,
    Object? accessType = null,
    Object? conditionRating = freezed,
    Object? notes = freezed,
    Object? acquiredDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? equipment = freezed,
  }) {
    return _then(
      _$UserEquipmentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        equipmentId: null == equipmentId
            ? _value.equipmentId
            : equipmentId // ignore: cast_nullable_to_non_nullable
                  as String,
        accessType: null == accessType
            ? _value.accessType
            : accessType // ignore: cast_nullable_to_non_nullable
                  as String,
        conditionRating: freezed == conditionRating
            ? _value.conditionRating
            : conditionRating // ignore: cast_nullable_to_non_nullable
                  as int?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        acquiredDate: freezed == acquiredDate
            ? _value.acquiredDate
            : acquiredDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        equipment: freezed == equipment
            ? _value.equipment
            : equipment // ignore: cast_nullable_to_non_nullable
                  as Equipment?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserEquipmentImpl implements _UserEquipment {
  const _$UserEquipmentImpl({
    required this.id,
    required this.userId,
    required this.equipmentId,
    this.accessType = 'owned',
    this.conditionRating,
    this.notes,
    this.acquiredDate,
    this.createdAt,
    this.updatedAt,
    this.equipment,
  });

  factory _$UserEquipmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserEquipmentImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String equipmentId;
  @override
  @JsonKey()
  final String accessType;
  @override
  final int? conditionRating;
  @override
  final String? notes;
  @override
  final DateTime? acquiredDate;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  // Joined equipment details
  @override
  final Equipment? equipment;

  @override
  String toString() {
    return 'UserEquipment(id: $id, userId: $userId, equipmentId: $equipmentId, accessType: $accessType, conditionRating: $conditionRating, notes: $notes, acquiredDate: $acquiredDate, createdAt: $createdAt, updatedAt: $updatedAt, equipment: $equipment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserEquipmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.equipmentId, equipmentId) ||
                other.equipmentId == equipmentId) &&
            (identical(other.accessType, accessType) ||
                other.accessType == accessType) &&
            (identical(other.conditionRating, conditionRating) ||
                other.conditionRating == conditionRating) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.acquiredDate, acquiredDate) ||
                other.acquiredDate == acquiredDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.equipment, equipment) ||
                other.equipment == equipment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    equipmentId,
    accessType,
    conditionRating,
    notes,
    acquiredDate,
    createdAt,
    updatedAt,
    equipment,
  );

  /// Create a copy of UserEquipment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserEquipmentImplCopyWith<_$UserEquipmentImpl> get copyWith =>
      __$$UserEquipmentImplCopyWithImpl<_$UserEquipmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserEquipmentImplToJson(this);
  }
}

abstract class _UserEquipment implements UserEquipment {
  const factory _UserEquipment({
    required final String id,
    required final String userId,
    required final String equipmentId,
    final String accessType,
    final int? conditionRating,
    final String? notes,
    final DateTime? acquiredDate,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final Equipment? equipment,
  }) = _$UserEquipmentImpl;

  factory _UserEquipment.fromJson(Map<String, dynamic> json) =
      _$UserEquipmentImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get equipmentId;
  @override
  String get accessType;
  @override
  int? get conditionRating;
  @override
  String? get notes;
  @override
  DateTime? get acquiredDate;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt; // Joined equipment details
  @override
  Equipment? get equipment;

  /// Create a copy of UserEquipment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserEquipmentImplCopyWith<_$UserEquipmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
