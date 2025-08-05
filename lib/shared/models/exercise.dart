import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise.freezed.dart';
part 'exercise.g.dart';

@freezed
class Exercise with _$Exercise {
  const factory Exercise({
    required String id,
    required String name,
    String? description,
    String? instructions,
    String? createdBy,
    @Default(false) bool isPublic,
    @Default('beginner') String difficultyLevel,
    @Default('strength') String exerciseType,
    @Default([]) List<String> primaryMuscleGroups,
    @Default([]) List<String> secondaryMuscleGroups,
    @Default([]) List<String> equipmentRequired,
    @Default([]) List<String> equipmentAlternatives,
    String? movementPattern,
    String? tempo,
    String? rangeOfMotion,
    String? breathingPattern,
    @Default([]) List<String> commonMistakes,
    @Default([]) List<String> progressions,
    @Default([]) List<String> regressions,
    String? safetyNotes,
    String? imageUrl,
    String? videoUrl,
    @Default([]) List<String> demonstrationImages,
    double? caloriesPerMinute,
    double? metValue,
    @Default([]) List<String> tags,
    @Default(false) bool isUnilateral,
    @Default(true) bool isCompound,
    @Default(false) bool requiresSpotter,
    @Default(30) int setupTimeSeconds,
    @Default(15) int cleanupTimeSeconds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);

  factory Exercise.fromDatabase(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      instructions: map['instructions'] as String?,
      createdBy: map['created_by'] as String?,
      isPublic: (map['is_public'] as int?) == 1,
      difficultyLevel: map['difficulty_level'] as String? ?? 'beginner',
      exerciseType: map['exercise_type'] as String? ?? 'strength',
      primaryMuscleGroups: _parseJsonList(map['primary_muscle_groups']),
      secondaryMuscleGroups: _parseJsonList(map['secondary_muscle_groups']),
      equipmentRequired: _parseJsonList(map['equipment_required']),
      equipmentAlternatives: _parseJsonList(map['equipment_alternatives']),
      movementPattern: map['movement_pattern'] as String?,
      tempo: map['tempo'] as String?,
      rangeOfMotion: map['range_of_motion'] as String?,
      breathingPattern: map['breathing_pattern'] as String?,
      commonMistakes: _parseJsonList(map['common_mistakes']),
      progressions: _parseJsonList(map['progressions']),
      regressions: _parseJsonList(map['regressions']),
      safetyNotes: map['safety_notes'] as String?,
      imageUrl: map['image_url'] as String?,
      videoUrl: map['video_url'] as String?,
      demonstrationImages: _parseJsonList(map['demonstration_images']),
      caloriesPerMinute: (map['calories_per_minute'] as num?)?.toDouble(),
      metValue: (map['met_value'] as num?)?.toDouble(),
      tags: _parseJsonList(map['tags']),
      isUnilateral: (map['is_unilateral'] as int?) == 1,
      isCompound: (map['is_compound'] as int?) != 0,
      requiresSpotter: (map['requires_spotter'] as int?) == 1,
      setupTimeSeconds: map['setup_time_seconds'] as int? ?? 30,
      cleanupTimeSeconds: map['cleanup_time_seconds'] as int? ?? 15,
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
      // Try to parse as JSON first, fallback to comma-separated
      try {
        return List<String>.from(value.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty));
      } catch (e) {
        return [];
      }
    }
    if (value is List) return List<String>.from(value);
    return [];
  }

}

@freezed
class ExerciseCategory with _$ExerciseCategory {
  const factory ExerciseCategory({
    required String id,
    required String exerciseId,
    required String categoryId,
    DateTime? createdAt,
  }) = _ExerciseCategory;

  factory ExerciseCategory.fromJson(Map<String, dynamic> json) =>
      _$ExerciseCategoryFromJson(json);

  factory ExerciseCategory.fromDatabase(Map<String, dynamic> map) {
    return ExerciseCategory(
      id: map['id'] as String,
      exerciseId: map['exercise_id'] as String,
      categoryId: map['category_id'] as String,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
    );
  }

}

@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    String? description,
    String? icon,
    String? color,
    String? parentCategoryId,
    @Default(0) int sortOrder,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  factory Category.fromDatabase(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      icon: map['icon'] as String?,
      color: map['color'] as String?,
      parentCategoryId: map['parent_category_id'] as String?,
      sortOrder: map['sort_order'] as int? ?? 0,
      isActive: (map['is_active'] as int?) != 0,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

}

extension ExerciseDatabase on Exercise {
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'instructions': instructions,
      'created_by': createdBy,
      'is_public': isPublic ? 1 : 0,
      'difficulty_level': difficultyLevel,
      'exercise_type': exerciseType,
      'primary_muscle_groups': primaryMuscleGroups.join(','),
      'secondary_muscle_groups': secondaryMuscleGroups.join(','),
      'equipment_required': equipmentRequired.join(','),
      'equipment_alternatives': equipmentAlternatives.join(','),
      'movement_pattern': movementPattern,
      'tempo': tempo,
      'range_of_motion': rangeOfMotion,
      'breathing_pattern': breathingPattern,
      'common_mistakes': commonMistakes.join(','),
      'progressions': progressions.join(','),
      'regressions': regressions.join(','),
      'safety_notes': safetyNotes,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'demonstration_images': demonstrationImages.join(','),
      'calories_per_minute': caloriesPerMinute,
      'met_value': metValue,
      'tags': tags.join(','),
      'is_unilateral': isUnilateral ? 1 : 0,
      'is_compound': isCompound ? 1 : 0,
      'requires_spotter': requiresSpotter ? 1 : 0,
      'setup_time_seconds': setupTimeSeconds,
      'cleanup_time_seconds': cleanupTimeSeconds,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

extension ExerciseCategoryDatabase on ExerciseCategory {
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'exercise_id': exerciseId,
      'category_id': categoryId,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

extension CategoryDatabase on Category {
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'parent_category_id': parentCategoryId,
      'sort_order': sortOrder,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}