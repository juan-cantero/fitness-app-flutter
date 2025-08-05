// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EquipmentImpl _$$EquipmentImplFromJson(Map<String, dynamic> json) =>
    _$EquipmentImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      category: json['category'] as String? ?? 'strength',
      subCategory: json['subCategory'] as String?,
      imageUrl: json['imageUrl'] as String?,
      muscleGroupsPrimary:
          (json['muscleGroupsPrimary'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      muscleGroupsSecondary:
          (json['muscleGroupsSecondary'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      spaceRequirement: json['spaceRequirement'] as String? ?? 'minimal',
      difficultyLevel: json['difficultyLevel'] as String? ?? 'beginner',
      isHomeGym: json['isHomeGym'] as bool? ?? true,
      isCommercialGym: json['isCommercialGym'] as bool? ?? true,
      costCategory: json['costCategory'] as String? ?? 'medium',
      alternatives:
          (json['alternatives'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$EquipmentImplToJson(_$EquipmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'subCategory': instance.subCategory,
      'imageUrl': instance.imageUrl,
      'muscleGroupsPrimary': instance.muscleGroupsPrimary,
      'muscleGroupsSecondary': instance.muscleGroupsSecondary,
      'spaceRequirement': instance.spaceRequirement,
      'difficultyLevel': instance.difficultyLevel,
      'isHomeGym': instance.isHomeGym,
      'isCommercialGym': instance.isCommercialGym,
      'costCategory': instance.costCategory,
      'alternatives': instance.alternatives,
      'tags': instance.tags,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$UserEquipmentImpl _$$UserEquipmentImplFromJson(Map<String, dynamic> json) =>
    _$UserEquipmentImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      equipmentId: json['equipmentId'] as String,
      accessType: json['accessType'] as String? ?? 'owned',
      conditionRating: (json['conditionRating'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      acquiredDate: json['acquiredDate'] == null
          ? null
          : DateTime.parse(json['acquiredDate'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      equipment: json['equipment'] == null
          ? null
          : Equipment.fromJson(json['equipment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserEquipmentImplToJson(_$UserEquipmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'equipmentId': instance.equipmentId,
      'accessType': instance.accessType,
      'conditionRating': instance.conditionRating,
      'notes': instance.notes,
      'acquiredDate': instance.acquiredDate?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'equipment': instance.equipment,
    };
