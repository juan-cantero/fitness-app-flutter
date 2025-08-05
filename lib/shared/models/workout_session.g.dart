// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutSessionImpl _$$WorkoutSessionImplFromJson(Map<String, dynamic> json) =>
    _$WorkoutSessionImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      workoutId: json['workoutId'] as String?,
      name: json['name'] as String?,
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      endedAt: json['endedAt'] == null
          ? null
          : DateTime.parse(json['endedAt'] as String),
      durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
      status: json['status'] as String? ?? 'planned',
      location: json['location'] as String?,
      weatherConditions: json['weatherConditions'] as String?,
      energyLevelStart: (json['energyLevelStart'] as num?)?.toInt(),
      energyLevelEnd: (json['energyLevelEnd'] as num?)?.toInt(),
      perceivedExertion: (json['perceivedExertion'] as num?)?.toInt(),
      moodBefore: json['moodBefore'] as String?,
      moodAfter: json['moodAfter'] as String?,
      caloriesBurned: (json['caloriesBurned'] as num?)?.toInt(),
      heartRateAvg: (json['heartRateAvg'] as num?)?.toInt(),
      heartRateMax: (json['heartRateMax'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      workoutRating: (json['workoutRating'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      workout: json['workout'] == null
          ? null
          : Workout.fromJson(json['workout'] as Map<String, dynamic>),
      exerciseLogs:
          (json['exerciseLogs'] as List<dynamic>?)
              ?.map((e) => ExerciseLog.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$WorkoutSessionImplToJson(
  _$WorkoutSessionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'workoutId': instance.workoutId,
  'name': instance.name,
  'startedAt': instance.startedAt.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'endedAt': instance.endedAt?.toIso8601String(),
  'durationMinutes': instance.durationMinutes,
  'status': instance.status,
  'location': instance.location,
  'weatherConditions': instance.weatherConditions,
  'energyLevelStart': instance.energyLevelStart,
  'energyLevelEnd': instance.energyLevelEnd,
  'perceivedExertion': instance.perceivedExertion,
  'moodBefore': instance.moodBefore,
  'moodAfter': instance.moodAfter,
  'caloriesBurned': instance.caloriesBurned,
  'heartRateAvg': instance.heartRateAvg,
  'heartRateMax': instance.heartRateMax,
  'notes': instance.notes,
  'workoutRating': instance.workoutRating,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'workout': instance.workout,
  'exerciseLogs': instance.exerciseLogs,
};

_$ExerciseLogImpl _$$ExerciseLogImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseLogImpl(
      id: json['id'] as String,
      workoutSessionId: json['workoutSessionId'] as String,
      exerciseId: json['exerciseId'] as String,
      workoutExerciseId: json['workoutExerciseId'] as String?,
      orderIndex: (json['orderIndex'] as num).toInt(),
      setsCompleted: (json['setsCompleted'] as num?)?.toInt() ?? 0,
      setsPlanned: (json['setsPlanned'] as num?)?.toInt() ?? 1,
      repsCompleted: (json['repsCompleted'] as num?)?.toInt(),
      repsPlanned: (json['repsPlanned'] as num?)?.toInt(),
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
      distanceMeters: (json['distanceMeters'] as num?)?.toDouble(),
      restTimeSeconds: (json['restTimeSeconds'] as num?)?.toInt(),
      intensityPercentage: (json['intensityPercentage'] as num?)?.toDouble(),
      rpe: (json['rpe'] as num?)?.toInt(),
      formRating: (json['formRating'] as num?)?.toInt(),
      equipmentUsed:
          (json['equipmentUsed'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      notes: json['notes'] as String?,
      isPersonalRecord: json['isPersonalRecord'] as bool? ?? false,
      isCompleted: json['isCompleted'] as bool? ?? false,
      previousBestWeight: (json['previousBestWeight'] as num?)?.toDouble(),
      previousBestReps: (json['previousBestReps'] as num?)?.toInt(),
      previousBestDuration: (json['previousBestDuration'] as num?)?.toInt(),
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

Map<String, dynamic> _$$ExerciseLogImplToJson(_$ExerciseLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workoutSessionId': instance.workoutSessionId,
      'exerciseId': instance.exerciseId,
      'workoutExerciseId': instance.workoutExerciseId,
      'orderIndex': instance.orderIndex,
      'setsCompleted': instance.setsCompleted,
      'setsPlanned': instance.setsPlanned,
      'repsCompleted': instance.repsCompleted,
      'repsPlanned': instance.repsPlanned,
      'weightKg': instance.weightKg,
      'durationSeconds': instance.durationSeconds,
      'distanceMeters': instance.distanceMeters,
      'restTimeSeconds': instance.restTimeSeconds,
      'intensityPercentage': instance.intensityPercentage,
      'rpe': instance.rpe,
      'formRating': instance.formRating,
      'equipmentUsed': instance.equipmentUsed,
      'notes': instance.notes,
      'isPersonalRecord': instance.isPersonalRecord,
      'isCompleted': instance.isCompleted,
      'previousBestWeight': instance.previousBestWeight,
      'previousBestReps': instance.previousBestReps,
      'previousBestDuration': instance.previousBestDuration,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'exercise': instance.exercise,
    };

_$PersonalRecordImpl _$$PersonalRecordImplFromJson(Map<String, dynamic> json) =>
    _$PersonalRecordImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      exerciseId: json['exerciseId'] as String,
      recordType: json['recordType'] as String,
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
      secondaryValue: (json['secondaryValue'] as num?)?.toDouble(),
      secondaryUnit: json['secondaryUnit'] as String?,
      achievedAt: DateTime.parse(json['achievedAt'] as String),
      workoutSessionId: json['workoutSessionId'] as String?,
      exerciseLogId: json['exerciseLogId'] as String?,
      previousRecordValue: (json['previousRecordValue'] as num?)?.toDouble(),
      improvementPercentage: (json['improvementPercentage'] as num?)
          ?.toDouble(),
      notes: json['notes'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      exercise: json['exercise'] == null
          ? null
          : Exercise.fromJson(json['exercise'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PersonalRecordImplToJson(
  _$PersonalRecordImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'exerciseId': instance.exerciseId,
  'recordType': instance.recordType,
  'value': instance.value,
  'unit': instance.unit,
  'secondaryValue': instance.secondaryValue,
  'secondaryUnit': instance.secondaryUnit,
  'achievedAt': instance.achievedAt.toIso8601String(),
  'workoutSessionId': instance.workoutSessionId,
  'exerciseLogId': instance.exerciseLogId,
  'previousRecordValue': instance.previousRecordValue,
  'improvementPercentage': instance.improvementPercentage,
  'notes': instance.notes,
  'isVerified': instance.isVerified,
  'createdAt': instance.createdAt?.toIso8601String(),
  'exercise': instance.exercise,
};
