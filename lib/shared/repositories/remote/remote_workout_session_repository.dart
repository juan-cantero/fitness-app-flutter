import '../../models/models.dart';
import '../interfaces/repository_interfaces.dart';
import 'remote_base_repository.dart';

/// Remote Supabase implementation of the Workout Session repository
class RemoteWorkoutSessionRepository extends RemoteBaseRepository<WorkoutSession> implements IWorkoutSessionRepository {
  RemoteWorkoutSessionRepository() : super('workout_sessions');

  @override
  WorkoutSession fromSupabaseJson(Map<String, dynamic> json) {
    throw UnimplementedError('Supabase JSON conversion not implemented');
  }

  @override
  Map<String, dynamic> toSupabaseJson(WorkoutSession model) {
    throw UnimplementedError('Supabase JSON conversion not implemented');
  }

  @override
  String getId(WorkoutSession model) => model.id;

  @override
  Future<List<WorkoutSession>> findByUser(String userId, {DateTime? startDate, DateTime? endDate, int? limit, int? offset}) async {
    throw UnimplementedError('Remote workout session repository not yet implemented');
  }

  @override
  Future<List<WorkoutSession>> findByWorkout(String workoutId, {String? userId, int? limit}) async {
    throw UnimplementedError('Remote workout session repository not yet implemented');
  }

  @override
  Future<WorkoutSession?> getActiveSession(String userId) async {
    throw UnimplementedError('Remote workout session repository not yet implemented');
  }

  @override
  Future<WorkoutSession> startSession(String workoutId, String userId) async {
    throw UnimplementedError('Remote workout session repository not yet implemented');
  }

  @override
  Future<WorkoutSession> completeSession(String sessionId) async {
    throw UnimplementedError('Remote workout session repository not yet implemented');
  }

  @override
  Future<void> cancelSession(String sessionId) async {
    throw UnimplementedError('Remote workout session repository not yet implemented');
  }

  @override
  Future<void> addExerciseLog(String sessionId, ExerciseLog exerciseLog) async {
    throw UnimplementedError('Remote workout session repository not yet implemented');
  }

  @override
  Future<void> updateExerciseLog(ExerciseLog exerciseLog) async {
    throw UnimplementedError('Remote workout session repository not yet implemented');
  }

  @override
  Future<List<ExerciseLog>> getSessionExerciseLogs(String sessionId) async {
    throw UnimplementedError('Remote workout session repository not yet implemented');
  }

  @override
  Future<SessionStats> getSessionStats(String sessionId) async {
    throw UnimplementedError('Remote workout session repository not yet implemented');
  }

  @override
  Future<UserWorkoutStats> getUserStats(String userId, {DateTime? startDate, DateTime? endDate}) async {
    throw UnimplementedError('Remote workout session repository not yet implemented');
  }
}