// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutImpl _$$WorkoutImplFromJson(
  Map<String, dynamic> json,
) => _$WorkoutImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  createdBy: json['createdBy'] as String?,
  isPublic: json['isPublic'] as bool? ?? false,
  difficultyLevel: json['difficultyLevel'] as String? ?? 'beginner',
  estimatedDurationMinutes: (json['estimatedDurationMinutes'] as num?)?.toInt(),
  actualDurationMinutes: (json['actualDurationMinutes'] as num?)?.toInt(),
  workoutType: json['workoutType'] as String? ?? 'strength',
  targetMuscleGroups:
      (json['targetMuscleGroups'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  equipmentNeeded:
      (json['equipmentNeeded'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  spaceRequirement: json['spaceRequirement'] as String? ?? 'small',
  intensityLevel: json['intensityLevel'] as String? ?? 'moderate',
  restBetweenExercises: (json['restBetweenExercises'] as num?)?.toInt() ?? 60,
  restBetweenSets: (json['restBetweenSets'] as num?)?.toInt() ?? 60,
  warmupDurationMinutes: (json['warmupDurationMinutes'] as num?)?.toInt() ?? 5,
  cooldownDurationMinutes:
      (json['cooldownDurationMinutes'] as num?)?.toInt() ?? 5,
  caloriesEstimate: (json['caloriesEstimate'] as num?)?.toInt(),
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  notes: json['notes'] as String?,
  isTemplate: json['isTemplate'] as bool? ?? false,
  templateCategory: json['templateCategory'] as String?,
  imageUrl: json['imageUrl'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  exercises:
      (json['exercises'] as List<dynamic>?)
          ?.map((e) => WorkoutExercise.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$WorkoutImplToJson(_$WorkoutImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'createdBy': instance.createdBy,
      'isPublic': instance.isPublic,
      'difficultyLevel': instance.difficultyLevel,
      'estimatedDurationMinutes': instance.estimatedDurationMinutes,
      'actualDurationMinutes': instance.actualDurationMinutes,
      'workoutType': instance.workoutType,
      'targetMuscleGroups': instance.targetMuscleGroups,
      'equipmentNeeded': instance.equipmentNeeded,
      'spaceRequirement': instance.spaceRequirement,
      'intensityLevel': instance.intensityLevel,
      'restBetweenExercises': instance.restBetweenExercises,
      'restBetweenSets': instance.restBetweenSets,
      'warmupDurationMinutes': instance.warmupDurationMinutes,
      'cooldownDurationMinutes': instance.cooldownDurationMinutes,
      'caloriesEstimate': instance.caloriesEstimate,
      'tags': instance.tags,
      'notes': instance.notes,
      'isTemplate': instance.isTemplate,
      'templateCategory': instance.templateCategory,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'exercises': instance.exercises,
    };

_$WorkoutExerciseImpl _$$WorkoutExerciseImplFromJson(
  Map<String, dynamic> json,
) => _$WorkoutExerciseImpl(
  id: json['id'] as String,
  workoutId: json['workoutId'] as String,
  exerciseId: json['exerciseId'] as String,
  orderIndex: (json['orderIndex'] as num).toInt(),
  sets: (json['sets'] as num?)?.toInt() ?? 1,
  reps: (json['reps'] as num?)?.toInt(),
  weightKg: (json['weightKg'] as num?)?.toDouble(),
  durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
  distanceMeters: (json['distanceMeters'] as num?)?.toDouble(),
  restTimeSeconds: (json['restTimeSeconds'] as num?)?.toInt() ?? 60,
  intensityPercentage: (json['intensityPercentage'] as num?)?.toDouble(),
  tempo: json['tempo'] as String?,
  notes: json['notes'] as String?,
  isSuperset: json['isSuperset'] as bool? ?? false,
  supersetGroupId: json['supersetGroupId'] as String?,
  isDropset: json['isDropset'] as bool? ?? false,
  isWarmup: json['isWarmup'] as bool? ?? false,
  isCooldown: json['isCooldown'] as bool? ?? false,
  targetRpe: (json['targetRpe'] as num?)?.toInt(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  exercise: json['exercise'] == null
      ? null
      : Exercise.fromJson(json['exercise'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$WorkoutExerciseImplToJson(
  _$WorkoutExerciseImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'workoutId': instance.workoutId,
  'exerciseId': instance.exerciseId,
  'orderIndex': instance.orderIndex,
  'sets': instance.sets,
  'reps': instance.reps,
  'weightKg': instance.weightKg,
  'durationSeconds': instance.durationSeconds,
  'distanceMeters': instance.distanceMeters,
  'restTimeSeconds': instance.restTimeSeconds,
  'intensityPercentage': instance.intensityPercentage,
  'tempo': instance.tempo,
  'notes': instance.notes,
  'isSuperset': instance.isSuperset,
  'supersetGroupId': instance.supersetGroupId,
  'isDropset': instance.isDropset,
  'isWarmup': instance.isWarmup,
  'isCooldown': instance.isCooldown,
  'targetRpe': instance.targetRpe,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'exercise': instance.exercise,
};
