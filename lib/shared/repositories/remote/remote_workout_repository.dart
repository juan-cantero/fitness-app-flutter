import '../../models/models.dart';
import '../interfaces/repository_interfaces.dart';
import 'remote_base_repository.dart';

/// Remote Supabase implementation of the Workout repository
/// Placeholder for future Supabase integration
class RemoteWorkoutRepository extends RemoteBaseRepository<Workout> implements IWorkoutRepository {
  RemoteWorkoutRepository() : super('workouts');

  @override
  Workout fromSupabaseJson(Map<String, dynamic> json) {
    // TODO: Implement proper JSON conversion from Supabase format
    throw UnimplementedError('Supabase JSON conversion not implemented');
  }

  @override
  Map<String, dynamic> toSupabaseJson(Workout model) {
    // TODO: Implement proper JSON conversion to Supabase format
    throw UnimplementedError('Supabase JSON conversion not implemented');
  }

  @override
  String getId(Workout model) => model.id;

  // Workout-specific methods
  @override
  Future<List<Workout>> findByUser(String userId, {int? limit, int? offset}) async {
    throw UnimplementedError('Remote workout repository not yet implemented');
  }

  @override
  Future<List<Workout>> findPublicWorkouts({
    String? query,
    List<String>? tags,
    String? difficultyLevel,
    int? maxDuration,
    int? limit,
    int? offset,
  }) async {
    throw UnimplementedError('Remote workout repository not yet implemented');
  }

  @override
  Future<List<Workout>> getTemplates({String? category, int? limit}) async {
    throw UnimplementedError('Remote workout repository not yet implemented');
  }

  @override
  Future<Workout> cloneWorkout(String workoutId, String newName) async {
    throw UnimplementedError('Remote workout repository not yet implemented');
  }

  @override
  Future<List<WorkoutExercise>> getWorkoutExercises(String workoutId) async {
    throw UnimplementedError('Remote workout repository not yet implemented');
  }

  @override
  Future<void> addExerciseToWorkout(
    String workoutId,
    String exerciseId, {
    int? sets,
    int? reps,
    double? weight,
    int? restSeconds,
    int? order,
  }) async {
    throw UnimplementedError('Remote workout repository not yet implemented');
  }

  @override
  Future<void> removeExerciseFromWorkout(String workoutId, String exerciseId) async {
    throw UnimplementedError('Remote workout repository not yet implemented');
  }

  @override
  Future<void> updateWorkoutExercise(WorkoutExercise workoutExercise) async {
    throw UnimplementedError('Remote workout repository not yet implemented');
  }

  @override
  Future<List<Workout>> getRecentWorkouts(String userId, {int limit = 10}) async {
    throw UnimplementedError('Remote workout repository not yet implemented');
  }

  @override
  Future<List<Workout>> searchWorkouts(
    String? query, {
    WorkoutSortBy sortBy = WorkoutSortBy.name,
    bool ascending = true,
    WorkoutFilter? filter,
    int? limit,
    int? offset,
  }) async {
    throw UnimplementedError('Remote workout repository not yet implemented');
  }

  @override
  Future<List<Workout>> getPopularWorkouts({int limit = 10}) async {
    throw UnimplementedError('Remote workout repository not yet implemented');
  }
}