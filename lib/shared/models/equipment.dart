import 'package:freezed_annotation/freezed_annotation.dart';

part 'equipment.freezed.dart';
part 'equipment.g.dart';

@freezed
class Equipment with _$Equipment {
  const factory Equipment({
    required String id,
    required String name,
    String? description,
    @Default('strength') String category,
    String? subCategory,
    String? imageUrl,
    @Default([]) List<String> muscleGroupsPrimary,
    @Default([]) List<String> muscleGroupsSecondary,
    @Default('minimal') String spaceRequirement,
    @Default('beginner') String difficultyLevel,
    @Default(true) bool isHomeGym,
    @Default(true) bool isCommercialGym,
    @Default('medium') String costCategory,
    @Default([]) List<String> alternatives,
    @Default([]) List<String> tags,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Equipment;

  factory Equipment.fromJson(Map<String, dynamic> json) =>
      _$EquipmentFromJson(json);

  factory Equipment.fromDatabase(Map<String, dynamic> map) {
    return Equipment(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      category: map['category'] as String? ?? 'strength',
      subCategory: map['sub_category'] as String?,
      imageUrl: map['image_url'] as String?,
      muscleGroupsPrimary: _parseJsonList(map['muscle_groups_primary']),
      muscleGroupsSecondary: _parseJsonList(map['muscle_groups_secondary']),
      spaceRequirement: map['space_requirement'] as String? ?? 'minimal',
      difficultyLevel: map['difficulty_level'] as String? ?? 'beginner',
      isHomeGym: (map['is_home_gym'] as int?) != 0,
      isCommercialGym: (map['is_commercial_gym'] as int?) != 0,
      costCategory: map['cost_category'] as String? ?? 'medium',
      alternatives: _parseJsonList(map['alternatives']),
      tags: _parseJsonList(map['tags']),
      isActive: (map['is_active'] as int?) != 0,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
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
class UserEquipment with _$UserEquipment {
  const factory UserEquipment({
    required String id,
    required String userId,
    required String equipmentId,
    @Default('owned') String accessType,
    int? conditionRating,
    String? notes,
    DateTime? acquiredDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    // Joined equipment details
    Equipment? equipment,
  }) = _UserEquipment;

  factory UserEquipment.fromJson(Map<String, dynamic> json) =>
      _$UserEquipmentFromJson(json);

  factory UserEquipment.fromDatabase(Map<String, dynamic> map) {
    return UserEquipment(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      equipmentId: map['equipment_id'] as String,
      accessType: map['access_type'] as String? ?? 'owned',
      conditionRating: map['condition_rating'] as int?,
      notes: map['notes'] as String?,
      acquiredDate: map['acquired_date'] != null
          ? DateTime.parse(map['acquired_date'] as String)
          : null,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
      // Equipment details will be joined separately
      equipment: null,
    );
  }

}

extension EquipmentDatabase on Equipment {
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'sub_category': subCategory,
      'image_url': imageUrl,
      'muscle_groups_primary': muscleGroupsPrimary.join(','),
      'muscle_groups_secondary': muscleGroupsSecondary.join(','),
      'space_requirement': spaceRequirement,
      'difficulty_level': difficultyLevel,
      'is_home_gym': isHomeGym ? 1 : 0,
      'is_commercial_gym': isCommercialGym ? 1 : 0,
      'cost_category': costCategory,
      'alternatives': alternatives.join(','),
      'tags': tags.join(','),
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

extension UserEquipmentDatabase on UserEquipment {
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'user_id': userId,
      'equipment_id': equipmentId,
      'access_type': accessType,
      'condition_rating': conditionRating,
      'notes': notes,
      'acquired_date': acquiredDate?.toIso8601String().split('T')[0],
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}