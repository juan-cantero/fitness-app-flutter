// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      displayName: json['displayName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as String?,
      heightCm: (json['heightCm'] as num?)?.toInt(),
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      fitnessLevel: json['fitnessLevel'] as String? ?? 'beginner',
      fitnessGoals:
          (json['fitnessGoals'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      activityLevel: json['activityLevel'] as String? ?? 'moderately_active',
      preferredUnits: json['preferredUnits'] as String? ?? 'metric',
      timezone: json['timezone'] as String? ?? 'UTC',
      isPublic: json['isPublic'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
      'bio': instance.bio,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'gender': instance.gender,
      'heightCm': instance.heightCm,
      'weightKg': instance.weightKg,
      'fitnessLevel': instance.fitnessLevel,
      'fitnessGoals': instance.fitnessGoals,
      'activityLevel': instance.activityLevel,
      'preferredUnits': instance.preferredUnits,
      'timezone': instance.timezone,
      'isPublic': instance.isPublic,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$UserProgressImpl _$$UserProgressImplFromJson(Map<String, dynamic> json) =>
    _$UserProgressImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      metricType: json['metricType'] as String,
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
      measuredAt: DateTime.parse(json['measuredAt'] as String),
      measurementMethod: json['measurementMethod'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$UserProgressImplToJson(_$UserProgressImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'metricType': instance.metricType,
      'value': instance.value,
      'unit': instance.unit,
      'measuredAt': instance.measuredAt.toIso8601String(),
      'measurementMethod': instance.measurementMethod,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
