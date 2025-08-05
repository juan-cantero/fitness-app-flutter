import '../../models/models.dart';
import '../interfaces/repository_interfaces.dart';
import 'remote_base_repository.dart';

/// Remote Supabase implementation of the User Profile repository
class RemoteUserProfileRepository extends RemoteBaseRepository<UserProfile> implements IUserProfileRepository {
  RemoteUserProfileRepository() : super('user_profiles');

  @override
  UserProfile fromSupabaseJson(Map<String, dynamic> json) {
    throw UnimplementedError('Supabase JSON conversion not implemented');
  }

  @override
  Map<String, dynamic> toSupabaseJson(UserProfile model) {
    throw UnimplementedError('Supabase JSON conversion not implemented');
  }

  @override
  String getId(UserProfile model) => model.id;

  @override
  Future<UserProfile?> getUserProfile(String userId) async {
    throw UnimplementedError('Remote user profile repository not yet implemented');
  }

  @override
  Future<UserProfile> upsertUserProfile(UserProfile profile) async {
    throw UnimplementedError('Remote user profile repository not yet implemented');
  }

  @override
  Future<void> updatePreferences(String userId, Map<String, dynamic> preferences) async {
    throw UnimplementedError('Remote user profile repository not yet implemented');
  }

  @override
  Future<Map<String, dynamic>?> getUserPreferences(String userId) async {
    throw UnimplementedError('Remote user profile repository not yet implemented');
  }

  @override
  Future<void> updateGoals(String userId, List<Goal> goals) async {
    throw UnimplementedError('Remote user profile repository not yet implemented');
  }

  @override
  Future<List<Goal>> getUserGoals(String userId) async {
    throw UnimplementedError('Remote user profile repository not yet implemented');
  }

  @override
  Future<void> addMeasurement(String userId, Measurement measurement) async {
    throw UnimplementedError('Remote user profile repository not yet implemented');
  }

  @override
  Future<List<Measurement>> getUserMeasurements(String userId, {String? type, DateTime? startDate, DateTime? endDate}) async {
    throw UnimplementedError('Remote user profile repository not yet implemented');
  }

  @override
  Future<Measurement?> getLatestMeasurement(String userId, String type) async {
    throw UnimplementedError('Remote user profile repository not yet implemented');
  }
}