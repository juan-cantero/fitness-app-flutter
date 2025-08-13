import 'package:freezed_annotation/freezed_annotation.dart';
import 'exercise.dart';

part 'workout.freezed.dart';
part 'workout.g.dart';

@freezed
class Workout with _$Workout {
  const factory Workout({
    required String id,
    required String name,
    String? description,
    String? createdBy,
    @Default(false) bool isPublic,
    @Default('beginner') String difficultyLevel,
    int? estimatedDurationMinutes,
    int? actualDurationMinutes,
    @Default('strength') String workoutType,
    @Default([]) List<String> targetMuscleGroups,
    @Default([]) List<String> equipmentNeeded,
    @Default('small') String spaceRequirement,
    @Default('moderate') String intensityLevel,
    @Default(60) int restBetweenExercises,
    @Default(60) int restBetweenSets,
    @Default(5) int warmupDurationMinutes,
    @Default(5) int cooldownDurationMinutes,
    int? caloriesEstimate,
    @Default([]) List<String> tags,
    String? notes,
    @Default(false) bool isTemplate,
    String? templateCategory,
    String? imageUrl,
    @Default('cover') String imageFit, // 'cover', 'contain', 'fill'
    DateTime? createdAt,
    DateTime? updatedAt,
    // Related data
    @Default([]) List<WorkoutExercise> exercises,
  }) = _Workout;

  factory Workout.fromJson(Map<String, dynamic> json) =>
      _$WorkoutFromJson(json);

  factory Workout.fromDatabase(Map<String, dynamic> map) {
    return Workout(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      createdBy: map['created_by'] as String?,
      isPublic: (map['is_public'] as int?) == 1,
      difficultyLevel: map['difficulty_level'] as String? ?? 'beginner',
      estimatedDurationMinutes: map['estimated_duration_minutes'] as int?,
      actualDurationMinutes: map['actual_duration_minutes'] as int?,
      workoutType: map['workout_type'] as String? ?? 'strength',
      targetMuscleGroups: _parseJsonList(map['target_muscle_groups']),
      equipmentNeeded: _parseJsonList(map['equipment_needed']),
      spaceRequirement: map['space_requirement'] as String? ?? 'small',
      intensityLevel: map['intensity_level'] as String? ?? 'moderate',
      restBetweenExercises: map['rest_between_exercises'] as int? ?? 60,
      restBetweenSets: map['rest_between_sets'] as int? ?? 60,
      warmupDurationMinutes: map['warmup_duration_minutes'] as int? ?? 5,
      cooldownDurationMinutes: map['cooldown_duration_minutes'] as int? ?? 5,
      caloriesEstimate: map['calories_estimate'] as int?,
      tags: _parseJsonList(map['tags']),
      notes: map['notes'] as String?,
      isTemplate: (map['is_template'] as int?) == 1,
      templateCategory: map['template_category'] as String?,
      imageUrl: map['image_url'] as String?,
      imageFit: map['image_fit'] as String? ?? 'cover',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
      exercises: [], // Will be loaded separately
    );
  }



  static List<String> _parseJsonList(dynamic value) {
    if (value == null) return [];
    if (value is String) {
      if (value.isEmpty) return [];
      return List<String>.from(value.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty));
    }
    if (value is List) return List<String>.from(value);
    return [];
  }

}

@freezed
class WorkoutExercise with _$WorkoutExercise {
  const factory WorkoutExercise({
    required String id,
    required String workoutId,
    required String exerciseId,
    required int orderIndex,
    @Default(1) int sets,
    int? reps,
    double? weightKg,
    int? durationSeconds,
    double? distanceMeters,
    @Default(60) int restTimeSeconds,
    double? intensityPercentage,
    String? tempo,
    String? notes,
    @Default(false) bool isSuperset,
    String? supersetGroupId,
    @Default(false) bool isDropset,
    @Default(false) bool isWarmup,
    @Default(false) bool isCooldown,
    int? targetRpe,
    DateTime? createdAt,
    DateTime? updatedAt,
    // Related data
    Exercise? exercise,
  }) = _WorkoutExercise;

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) =>
      _$WorkoutExerciseFromJson(json);

  factory WorkoutExercise.fromDatabase(Map<String, dynamic> map) {
    return WorkoutExercise(
      id: map['id'] as String,
      workoutId: map['workout_id'] as String,
      exerciseId: map['exercise_id'] as String,
      orderIndex: map['order_index'] as int,
      sets: map['sets'] as int? ?? 1,
      reps: map['reps'] as int?,
      weightKg: (map['weight_kg'] as num?)?.toDouble(),
      durationSeconds: map['duration_seconds'] as int?,
      distanceMeters: (map['distance_meters'] as num?)?.toDouble(),
      restTimeSeconds: map['rest_time_seconds'] as int? ?? 60,
      intensityPercentage: (map['intensity_percentage'] as num?)?.toDouble(),
      tempo: map['tempo'] as String?,
      notes: map['notes'] as String?,
      isSuperset: (map['is_superset'] as int?) == 1,
      supersetGroupId: map['superset_group_id'] as String?,
      isDropset: (map['is_dropset'] as int?) == 1,
      isWarmup: (map['is_warmup'] as int?) == 1,
      isCooldown: (map['is_cooldown'] as int?) == 1,
      targetRpe: map['target_rpe'] as int?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
      exercise: null, // Will be loaded separately
    );
  }



}



extension WorkoutExtension on Workout {
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_by': createdBy,
      'is_public': isPublic ? 1 : 0,
      'difficulty_level': difficultyLevel,
      'estimated_duration_minutes': estimatedDurationMinutes,
      'actual_duration_minutes': actualDurationMinutes,
      'workout_type': workoutType,
      'target_muscle_groups': targetMuscleGroups.join(','),
      'equipment_needed': equipmentNeeded.join(','),
      'space_requirement': spaceRequirement,
      'intensity_level': intensityLevel,
      'rest_between_exercises': restBetweenExercises,
      'rest_between_sets': restBetweenSets,
      'warmup_duration_minutes': warmupDurationMinutes,
      'cooldown_duration_minutes': cooldownDurationMinutes,
      'calories_estimate': caloriesEstimate,
      'tags': tags.join(','),
      'notes': notes,
      'is_template': isTemplate ? 1 : 0,
      'template_category': templateCategory,
      'image_url': imageUrl,
      'image_fit': imageFit,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

extension WorkoutExerciseExtension on WorkoutExercise {
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'workout_id': workoutId,
      'exercise_id': exerciseId,
      'order_index': orderIndex,
      'sets': sets,
      'reps': reps,
      'weight_kg': weightKg,
      'duration_seconds': durationSeconds,
      'distance_meters': distanceMeters,
      'rest_time_seconds': restTimeSeconds,
      'intensity_percentage': intensityPercentage,
      'tempo': tempo,
      'notes': notes,
      'is_superset': isSuperset ? 1 : 0,
      'superset_group_id': supersetGroupId,
      'is_dropset': isDropset ? 1 : 0,
      'is_warmup': isWarmup ? 1 : 0,
      'is_cooldown': isCooldown ? 1 : 0,
      'target_rpe': targetRpe,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
