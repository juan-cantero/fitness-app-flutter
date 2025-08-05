import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String userId,
    String? displayName,
    String? avatarUrl,
    String? bio,
    DateTime? dateOfBirth,
    String? gender,
    int? heightCm,
    double? weightKg,
    @Default('beginner') String fitnessLevel,
    @Default([]) List<String> fitnessGoals,
    @Default('moderately_active') String activityLevel,
    @Default('metric') String preferredUnits,
    @Default('UTC') String timezone,
    @Default(false) bool isPublic,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  factory UserProfile.fromDatabase(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      displayName: map['display_name'] as String?,
      avatarUrl: map['avatar_url'] as String?,
      bio: map['bio'] as String?,
      dateOfBirth: map['date_of_birth'] != null
          ? DateTime.parse(map['date_of_birth'] as String)
          : null,
      gender: map['gender'] as String?,
      heightCm: map['height_cm'] as int?,
      weightKg: (map['weight_kg'] as num?)?.toDouble(),
      fitnessLevel: map['fitness_level'] as String? ?? 'beginner',
      fitnessGoals: map['fitness_goals'] != null
          ? List<String>.from(
              (map['fitness_goals'] as String).split(',').where((g) => g.isNotEmpty))
          : [],
      activityLevel: map['activity_level'] as String? ?? 'moderately_active',
      preferredUnits: map['preferred_units'] as String? ?? 'metric',
      timezone: map['timezone'] as String? ?? 'UTC',
      isPublic: (map['is_public'] as int?) == 1,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

}

@freezed
class UserProgress with _$UserProgress {
  const factory UserProgress({
    required String id,
    required String userId,
    required String metricType,
    required double value,
    required String unit,
    required DateTime measuredAt,
    String? measurementMethod,
    String? notes,
    DateTime? createdAt,
  }) = _UserProgress;

  factory UserProgress.fromJson(Map<String, dynamic> json) =>
      _$UserProgressFromJson(json);

  factory UserProgress.fromDatabase(Map<String, dynamic> map) {
    return UserProgress(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      metricType: map['metric_type'] as String,
      value: (map['value'] as num).toDouble(),
      unit: map['unit'] as String,
      measuredAt: DateTime.parse(map['measured_at'] as String),
      measurementMethod: map['measurement_method'] as String?,
      notes: map['notes'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
    );
  }

}

extension UserProfileDatabase on UserProfile {
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'user_id': userId,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'bio': bio,
      'date_of_birth': dateOfBirth?.toIso8601String().split('T')[0],
      'gender': gender,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'fitness_level': fitnessLevel,
      'fitness_goals': fitnessGoals.join(','),
      'activity_level': activityLevel,
      'preferred_units': preferredUnits,
      'timezone': timezone,
      'is_public': isPublic ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

extension UserProgressDatabase on UserProgress {
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'user_id': userId,
      'metric_type': metricType,
      'value': value,
      'unit': unit,
      'measured_at': measuredAt.toIso8601String(),
      'measurement_method': measurementMethod,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}