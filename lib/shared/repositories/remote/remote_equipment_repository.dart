import '../../models/models.dart';
import '../interfaces/repository_interfaces.dart';
import 'remote_base_repository.dart';

/// Remote Supabase implementation of the Equipment repository
class RemoteEquipmentRepository extends RemoteBaseRepository<Equipment> implements IEquipmentRepository {
  RemoteEquipmentRepository() : super('equipment');

  @override
  Equipment fromSupabaseJson(Map<String, dynamic> json) {
    throw UnimplementedError('Supabase JSON conversion not implemented');
  }

  @override
  Map<String, dynamic> toSupabaseJson(Equipment model) {
    throw UnimplementedError('Supabase JSON conversion not implemented');
  }

  @override
  String getId(Equipment model) => model.id;

  @override
  Future<List<Equipment>> findByCategory(String category, {int? limit}) async {
    throw UnimplementedError('Remote equipment repository not yet implemented');
  }

  @override
  Future<List<Equipment>> searchEquipment(String query, {int? limit}) async {
    throw UnimplementedError('Remote equipment repository not yet implemented');
  }

  @override
  Future<List<Equipment>> findByAvailability(bool isAvailable, {int? limit}) async {
    throw UnimplementedError('Remote equipment repository not yet implemented');
  }

  @override
  Future<List<Equipment>> getUserEquipment(String userId) async {
    throw UnimplementedError('Remote equipment repository not yet implemented');
  }

  @override
  Future<void> addToUser(String userId, String equipmentId) async {
    throw UnimplementedError('Remote equipment repository not yet implemented');
  }

  @override
  Future<void> removeFromUser(String userId, String equipmentId) async {
    throw UnimplementedError('Remote equipment repository not yet implemented');
  }

  @override
  Future<Map<String, int>> getUsageStats({DateTime? startDate, DateTime? endDate}) async {
    throw UnimplementedError('Remote equipment repository not yet implemented');
  }
}