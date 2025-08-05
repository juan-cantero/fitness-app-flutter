import '../../models/models.dart';
import '../interfaces/repository_interfaces.dart';
import 'remote_base_repository.dart';

/// Remote Supabase implementation of the Exercise Log repository
class RemoteExerciseLogRepository extends RemoteBaseRepository<ExerciseLog> implements IExerciseLogRepository {
  RemoteExerciseLogRepository() : super('exercise_logs');

  @override
  ExerciseLog fromSupabaseJson(Map<String, dynamic> json) {
    throw UnimplementedError('Supabase JSON conversion not implemented');
  }

  @override
  Map<String, dynamic> toSupabaseJson(ExerciseLog model) {
    throw UnimplementedError('Supabase JSON conversion not implemented');
  }

  @override
  String getId(ExerciseLog model) => model.id;

  @override
  Future<List<ExerciseLog>> findByUser(String userId, {DateTime? startDate, DateTime? endDate, int? limit}) async {
    throw UnimplementedError('Remote exercise log repository not yet implemented');
  }

  @override
  Future<List<ExerciseLog>> findByExercise(String exerciseId, {String? userId, int? limit}) async {
    throw UnimplementedError('Remote exercise log repository not yet implemented');
  }

  @override
  Future<List<ExerciseLog>> findBySession(String sessionId) async {
    throw UnimplementedError('Remote exercise log repository not yet implemented');
  }

  @override
  Future<List<PersonalRecord>> getPersonalRecords(String userId, {String? exerciseId, String? recordType}) async {
    throw UnimplementedError('Remote exercise log repository not yet implemented');
  }

  @override
  Future<List<ProgressPoint>> getProgressData(String userId, String exerciseId, {DateTime? startDate, DateTime? endDate, String? metric}) async {
    throw UnimplementedError('Remote exercise log repository not yet implemented');
  }

  @override
  Future<ExerciseStats> getExerciseStats(String userId, String exerciseId, {DateTime? startDate, DateTime? endDate}) async {
    throw UnimplementedError('Remote exercise log repository not yet implemented');
  }

  @override
  Future<List<VolumePoint>> getVolumeData(String userId, {DateTime? startDate, DateTime? endDate, String? groupBy}) async {
    throw UnimplementedError('Remote exercise log repository not yet implemented');
  }
}