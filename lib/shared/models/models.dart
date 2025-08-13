// Model exports
export 'user_profile.dart';
export 'exercise.dart';
export 'equipment.dart';
export 'workout.dart';
export 'workout_session.dart';
export 'sync.dart';

// Filter and sorting classes for workouts
class WorkoutFilter {
  final List<String>? targetMuscleGroups;
  final List<String>? equipmentNeeded;
  final String? difficultyLevel;
  final String? workoutType;
  final String? intensityLevel;
  final bool? isTemplate;
  final bool? isPublic;

  const WorkoutFilter({
    this.targetMuscleGroups,
    this.equipmentNeeded,
    this.difficultyLevel,
    this.workoutType,
    this.intensityLevel,
    this.isTemplate,
    this.isPublic,
  });
}

enum WorkoutSortBy {
  name,
  difficulty,
  duration,
  createdAt,
}