import 'package:freezed_annotation/freezed_annotation.dart';
import 'workout.dart';
import 'exercise.dart';

part 'workout_session.freezed.dart';
part 'workout_session.g.dart';

@freezed
class WorkoutSession with _$WorkoutSession {
  const factory WorkoutSession({
    required String id,
    required String userId,
    String? workoutId,
    String? name,
    required DateTime startedAt,
    DateTime? completedAt,
    DateTime? endedAt,
    int? durationMinutes,
    @Default('planned') String status,
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
    // Related data
    Workout? workout,
    @Default([]) List<ExerciseLog> exerciseLogs,
  }) = _WorkoutSession;

  factory WorkoutSession.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSessionFromJson(json);

  factory WorkoutSession.fromDatabase(Map<String, dynamic> map) {
    return WorkoutSession(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      workoutId: map['workout_id'] as String?,
      name: map['name'] as String?,
      startedAt: DateTime.parse(map['started_at'] as String),
      completedAt: map['completed_at'] != null
          ? DateTime.parse(map['completed_at'] as String)
          : null,
      endedAt: map['ended_at'] != null
          ? DateTime.parse(map['ended_at'] as String)
          : null,
      durationMinutes: map['duration_minutes'] as int?,
      status: map['status'] as String? ?? 'planned',
      location: map['location'] as String?,
      weatherConditions: map['weather_conditions'] as String?,
      energyLevelStart: map['energy_level_start'] as int?,
      energyLevelEnd: map['energy_level_end'] as int?,
      perceivedExertion: map['perceived_exertion'] as int?,
      moodBefore: map['mood_before'] as String?,
      moodAfter: map['mood_after'] as String?,
      caloriesBurned: map['calories_burned'] as int?,
      heartRateAvg: map['heart_rate_avg'] as int?,
      heartRateMax: map['heart_rate_max'] as int?,
      notes: map['notes'] as String?,
      workoutRating: map['workout_rating'] as int?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
      workout: null, // Will be loaded separately
      exerciseLogs: [], // Will be loaded separately
    );
  }



}

@freezed
class ExerciseLog with _$ExerciseLog {
  const factory ExerciseLog({
    required String id,
    required String workoutSessionId,
    required String exerciseId,
    String? workoutExerciseId,
    required int orderIndex,
    @Default(0) int setsCompleted,
    @Default(1) int setsPlanned,
    int? repsCompleted,
    int? repsPlanned,
    double? weightKg,
    int? durationSeconds,
    double? distanceMeters,
    int? restTimeSeconds,
    double? intensityPercentage,
    int? rpe,
    int? formRating,
    @Default([]) List<String> equipmentUsed,
    String? notes,
    @Default(false) bool isPersonalRecord,
    @Default(false) bool isCompleted,
    double? previousBestWeight,
    int? previousBestReps,
    int? previousBestDuration,
    DateTime? createdAt,
    DateTime? updatedAt,
    // Related data
    Exercise? exercise,
  }) = _ExerciseLog;

  factory ExerciseLog.fromJson(Map<String, dynamic> json) =>
      _$ExerciseLogFromJson(json);

  factory ExerciseLog.fromDatabase(Map<String, dynamic> map) {
    return ExerciseLog(
      id: map['id'] as String,
      workoutSessionId: map['workout_session_id'] as String,
      exerciseId: map['exercise_id'] as String,
      workoutExerciseId: map['workout_exercise_id'] as String?,
      orderIndex: map['order_index'] as int,
      setsCompleted: map['sets_completed'] as int? ?? 0,
      setsPlanned: map['sets_planned'] as int? ?? 1,
      repsCompleted: map['reps_completed'] as int?,
      repsPlanned: map['reps_planned'] as int?,
      weightKg: (map['weight_kg'] as num?)?.toDouble(),
      durationSeconds: map['duration_seconds'] as int?,
      distanceMeters: (map['distance_meters'] as num?)?.toDouble(),
      restTimeSeconds: map['rest_time_seconds'] as int?,
      intensityPercentage: (map['intensity_percentage'] as num?)?.toDouble(),
      rpe: map['rpe'] as int?,
      formRating: map['form_rating'] as int?,
      equipmentUsed: _parseJsonList(map['equipment_used']),
      notes: map['notes'] as String?,
      isPersonalRecord: (map['is_personal_record'] as int?) == 1,
      isCompleted: (map['is_completed'] as int?) == 1,
      previousBestWeight: (map['previous_best_weight'] as num?)?.toDouble(),
      previousBestReps: map['previous_best_reps'] as int?,
      previousBestDuration: map['previous_best_duration'] as int?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
      exercise: null, // Will be loaded separately
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
class PersonalRecord with _$PersonalRecord {
  const factory PersonalRecord({
    required String id,
    required String userId,
    required String exerciseId,
    required String recordType,
    required double value,
    required String unit,
    double? secondaryValue,
    String? secondaryUnit,
    required DateTime achievedAt,
    String? workoutSessionId,
    String? exerciseLogId,
    double? previousRecordValue,
    double? improvementPercentage,
    String? notes,
    @Default(false) bool isVerified,
    DateTime? createdAt,
    // Related data
    Exercise? exercise,
  }) = _PersonalRecord;

  factory PersonalRecord.fromJson(Map<String, dynamic> json) =>
      _$PersonalRecordFromJson(json);

  factory PersonalRecord.fromDatabase(Map<String, dynamic> map) {
    return PersonalRecord(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      exerciseId: map['exercise_id'] as String,
      recordType: map['record_type'] as String,
      value: (map['value'] as num).toDouble(),
      unit: map['unit'] as String,
      secondaryValue: (map['secondary_value'] as num?)?.toDouble(),
      secondaryUnit: map['secondary_unit'] as String?,
      achievedAt: DateTime.parse(map['achieved_at'] as String),
      workoutSessionId: map['workout_session_id'] as String?,
      exerciseLogId: map['exercise_log_id'] as String?,
      previousRecordValue: (map['previous_record_value'] as num?)?.toDouble(),
      improvementPercentage: (map['improvement_percentage'] as num?)?.toDouble(),
      notes: map['notes'] as String?,
      isVerified: (map['is_verified'] as int?) == 1,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      exercise: null, // Will be loaded separately
    );
  }


}




extension WorkoutSessionExtension on WorkoutSession {
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'user_id': userId,
      'workout_id': workoutId,
      'name': name,
      'started_at': startedAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
      'duration_minutes': durationMinutes,
      'status': status,
      'location': location,
      'weather_conditions': weatherConditions,
      'energy_level_start': energyLevelStart,
      'energy_level_end': energyLevelEnd,
      'perceived_exertion': perceivedExertion,
      'mood_before': moodBefore,
      'mood_after': moodAfter,
      'calories_burned': caloriesBurned,
      'heart_rate_avg': heartRateAvg,
      'heart_rate_max': heartRateMax,
      'notes': notes,
      'workout_rating': workoutRating,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

extension ExerciseLogExtension on ExerciseLog {
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'workout_session_id': workoutSessionId,
      'exercise_id': exerciseId,
      'workout_exercise_id': workoutExerciseId,
      'order_index': orderIndex,
      'sets_completed': setsCompleted,
      'sets_planned': setsPlanned,
      'reps_completed': repsCompleted,
      'reps_planned': repsPlanned,
      'weight_kg': weightKg,
      'duration_seconds': durationSeconds,
      'distance_meters': distanceMeters,
      'rest_time_seconds': restTimeSeconds,
      'intensity_percentage': intensityPercentage,
      'rpe': rpe,
      'form_rating': formRating,
      'equipment_used': equipmentUsed.join(','),
      'notes': notes,
      'is_personal_record': isPersonalRecord ? 1 : 0,
      'is_completed': isCompleted ? 1 : 0,
      'previous_best_weight': previousBestWeight,
      'previous_best_reps': previousBestReps,
      'previous_best_duration': previousBestDuration,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
