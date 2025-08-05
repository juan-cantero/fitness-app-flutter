// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExerciseImpl _$$ExerciseImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      instructions: json['instructions'] as String?,
      createdBy: json['createdBy'] as String?,
      isPublic: json['isPublic'] as bool? ?? false,
      difficultyLevel: json['difficultyLevel'] as String? ?? 'beginner',
      exerciseType: json['exerciseType'] as String? ?? 'strength',
      primaryMuscleGroups:
          (json['primaryMuscleGroups'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      secondaryMuscleGroups:
          (json['secondaryMuscleGroups'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      equipmentRequired:
          (json['equipmentRequired'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      equipmentAlternatives:
          (json['equipmentAlternatives'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      movementPattern: json['movementPattern'] as String?,
      tempo: json['tempo'] as String?,
      rangeOfMotion: json['rangeOfMotion'] as String?,
      breathingPattern: json['breathingPattern'] as String?,
      commonMistakes:
          (json['commonMistakes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      progressions:
          (json['progressions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      regressions:
          (json['regressions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      safetyNotes: json['safetyNotes'] as String?,
      imageUrl: json['imageUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      demonstrationImages:
          (json['demonstrationImages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      caloriesPerMinute: (json['caloriesPerMinute'] as num?)?.toDouble(),
      metValue: (json['metValue'] as num?)?.toDouble(),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      isUnilateral: json['isUnilateral'] as bool? ?? false,
      isCompound: json['isCompound'] as bool? ?? true,
      requiresSpotter: json['requiresSpotter'] as bool? ?? false,
      setupTimeSeconds: (json['setupTimeSeconds'] as num?)?.toInt() ?? 30,
      cleanupTimeSeconds: (json['cleanupTimeSeconds'] as num?)?.toInt() ?? 15,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ExerciseImplToJson(_$ExerciseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'instructions': instance.instructions,
      'createdBy': instance.createdBy,
      'isPublic': instance.isPublic,
      'difficultyLevel': instance.difficultyLevel,
      'exerciseType': instance.exerciseType,
      'primaryMuscleGroups': instance.primaryMuscleGroups,
      'secondaryMuscleGroups': instance.secondaryMuscleGroups,
      'equipmentRequired': instance.equipmentRequired,
      'equipmentAlternatives': instance.equipmentAlternatives,
      'movementPattern': instance.movementPattern,
      'tempo': instance.tempo,
      'rangeOfMotion': instance.rangeOfMotion,
      'breathingPattern': instance.breathingPattern,
      'commonMistakes': instance.commonMistakes,
      'progressions': instance.progressions,
      'regressions': instance.regressions,
      'safetyNotes': instance.safetyNotes,
      'imageUrl': instance.imageUrl,
      'videoUrl': instance.videoUrl,
      'demonstrationImages': instance.demonstrationImages,
      'caloriesPerMinute': instance.caloriesPerMinute,
      'metValue': instance.metValue,
      'tags': instance.tags,
      'isUnilateral': instance.isUnilateral,
      'isCompound': instance.isCompound,
      'requiresSpotter': instance.requiresSpotter,
      'setupTimeSeconds': instance.setupTimeSeconds,
      'cleanupTimeSeconds': instance.cleanupTimeSeconds,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$ExerciseCategoryImpl _$$ExerciseCategoryImplFromJson(
  Map<String, dynamic> json,
) => _$ExerciseCategoryImpl(
  id: json['id'] as String,
  exerciseId: json['exerciseId'] as String,
  categoryId: json['categoryId'] as String,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$ExerciseCategoryImplToJson(
  _$ExerciseCategoryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'exerciseId': instance.exerciseId,
  'categoryId': instance.categoryId,
  'createdAt': instance.createdAt?.toIso8601String(),
};

_$CategoryImpl _$$CategoryImplFromJson(Map<String, dynamic> json) =>
    _$CategoryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      parentCategoryId: json['parentCategoryId'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$CategoryImplToJson(_$CategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'color': instance.color,
      'parentCategoryId': instance.parentCategoryId,
      'sortOrder': instance.sortOrder,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
