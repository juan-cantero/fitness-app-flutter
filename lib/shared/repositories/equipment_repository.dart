import '../../core/database/database_manager.dart';
import '../models/models.dart';
import 'base_repository.dart';
import 'errors/repository_exceptions.dart';

/// Filter options for equipment queries
class EquipmentFilter {
  final List<String>? categories;
  final List<String>? spaceRequirements;
  final List<String>? difficultyLevels;
  final List<String>? costCategories;
  final bool? isHomeGym;
  final bool? isCommercialGym;
  final List<String>? muscleGroups;
  final List<String>? tags;

  const EquipmentFilter({
    this.categories,
    this.spaceRequirements,
    this.difficultyLevels,
    this.costCategories,
    this.isHomeGym,
    this.isCommercialGym,
    this.muscleGroups,
    this.tags,
  });
}

/// Sorting options for equipment
enum EquipmentSortBy {
  name,
  category,
  spaceRequirement,
  costCategory,
  popularity,
}

/// Repository for managing equipment catalog and user inventory
class EquipmentRepository extends BaseRepository<Equipment> {
  EquipmentRepository(DatabaseManager databaseManager)
      : super(databaseManager, 'equipment');

  @override
  Equipment fromDatabase(Map<String, dynamic> map) => Equipment.fromDatabase(map);

  @override
  Map<String, dynamic> toDatabase(Equipment model) => model.toDatabase();

  @override
  String getId(Equipment model) => model.id;

  /// Search equipment with comprehensive filtering
  Future<List<Equipment>> searchEquipment(
    String? query, {
    EquipmentFilter? filter,
    EquipmentSortBy sortBy = EquipmentSortBy.name,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    final db = await database;

    try {
      // Build the WHERE clause
      final whereConditions = ['is_active = 1'];
      final whereArgs = <Object?>[];

      // Text search
      if (query != null && query.trim().isNotEmpty) {
        whereConditions.add('''
          (LOWER(name) LIKE ? OR 
           LOWER(description) LIKE ? OR 
           LOWER(category) LIKE ? OR 
           LOWER(sub_category) LIKE ? OR
           LOWER(tags) LIKE ?)
        ''');
        final searchTerm = '%${query.toLowerCase()}%';
        whereArgs.addAll([searchTerm, searchTerm, searchTerm, searchTerm, searchTerm]);
      }

      // Apply filters
      if (filter != null) {
        _applyFilter(filter, whereConditions, whereArgs);
      }

      // Build ORDER BY clause
      final orderBy = _buildOrderBy(sortBy, ascending);

      final whereClause = whereConditions.join(' AND ');

      final results = await db.query(
        tableName,
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );

      return results.map((map) => fromDatabase(map)).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to search equipment: $e');
    }
  }

  /// Get equipment by category
  Future<List<Equipment>> getByCategory(
    String category, {
    String? subCategory,
    int? limit,
  }) async {
    final conditions = ['category = ?', 'is_active = 1'];
    final args = <Object?>[category];

    if (subCategory != null) {
      conditions.add('sub_category = ?');
      args.add(subCategory);
    }

    return findWhere(
      conditions.join(' AND '),
      args,
      orderBy: 'name ASC',
      limit: limit,
    );
  }

  /// Get equipment by muscle groups
  Future<List<Equipment>> getByMuscleGroups(
    List<String> muscleGroups, {
    bool requireAll = false,
    int? limit,
  }) async {
    if (muscleGroups.isEmpty) return [];

    final conditions = ['is_active = 1'];
    final args = <Object?>[];

    if (requireAll) {
      // All muscle groups must be targeted
      for (final muscle in muscleGroups) {
        conditions.add('(LOWER(muscle_groups_primary) LIKE ? OR LOWER(muscle_groups_secondary) LIKE ?)');
        args.add('%${muscle.toLowerCase()}%');
        args.add('%${muscle.toLowerCase()}%');
      }
    } else {
      // Any muscle group can be targeted
      final muscleConditions = muscleGroups
          .map((_) => '(LOWER(muscle_groups_primary) LIKE ? OR LOWER(muscle_groups_secondary) LIKE ?)')
          .join(' OR ');
      conditions.add('($muscleConditions)');
      for (final muscle in muscleGroups) {
        args.add('%${muscle.toLowerCase()}%');
        args.add('%${muscle.toLowerCase()}%');
      }
    }

    return findWhere(
      conditions.join(' AND '),
      args,
      orderBy: 'name ASC',
      limit: limit,
    );
  }

  /// Get equipment suitable for home gym
  Future<List<Equipment>> getHomeGymEquipment({
    String? spaceRequirement,
    String? costCategory,
    int? limit,
  }) async {
    final conditions = ['is_home_gym = 1', 'is_active = 1'];
    final args = <Object?>[];

    if (spaceRequirement != null) {
      conditions.add('space_requirement = ?');
      args.add(spaceRequirement);
    }

    if (costCategory != null) {
      conditions.add('cost_category = ?');
      args.add(costCategory);
    }

    return findWhere(
      conditions.join(' AND '),
      args,
      orderBy: 'cost_category ASC, name ASC',
      limit: limit,
    );
  }

  /// Get equipment alternatives
  Future<List<Equipment>> getAlternatives(String equipmentId) async {
    final equipment = await getById(equipmentId);
    if (equipment == null || equipment.alternatives.isEmpty) {
      return [];
    }

    final db = await database;

    try {
      final placeholders = equipment.alternatives.map((_) => '?').join(',');
      final results = await db.query(
        tableName,
        where: 'id IN ($placeholders) AND is_active = 1',
        whereArgs: equipment.alternatives,
        orderBy: 'name ASC',
      );

      return results.map((map) => fromDatabase(map)).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to get equipment alternatives: $e');
    }
  }

  /// Get equipment by tags
  Future<List<Equipment>> getByTags(
    List<String> tags, {
    bool matchAll = false,
    int? limit,
  }) async {
    if (tags.isEmpty) return [];

    final conditions = ['is_active = 1'];
    final args = <Object?>[];

    if (matchAll) {
      // All tags must be present
      for (final tag in tags) {
        conditions.add('LOWER(tags) LIKE ?');
        args.add('%${tag.toLowerCase()}%');
      }
    } else {
      // Any tag can be present
      final tagConditions = tags.map((_) => 'LOWER(tags) LIKE ?').join(' OR ');
      conditions.add('($tagConditions)');
      args.addAll(tags.map((tag) => '%${tag.toLowerCase()}%'));
    }

    return findWhere(
      conditions.join(' AND '),
      args,
      orderBy: 'name ASC',
      limit: limit,
    );
  }

  /// Get popular equipment (based on usage in exercises)
  Future<List<Equipment>> getPopularEquipment({int limit = 20}) async {
    final db = await database;

    try {
      final results = await db.rawQuery('''
        SELECT eq.*, 
               COUNT(CASE WHEN e.equipment_required LIKE '%' || eq.id || '%' THEN 1 END) as primary_usage,
               COUNT(CASE WHEN e.equipment_alternatives LIKE '%' || eq.id || '%' THEN 1 END) as alternative_usage,
               (COUNT(CASE WHEN e.equipment_required LIKE '%' || eq.id || '%' THEN 1 END) * 2 +
                COUNT(CASE WHEN e.equipment_alternatives LIKE '%' || eq.id || '%' THEN 1 END)) as total_score
        FROM equipment eq
        LEFT JOIN exercises e ON (e.equipment_required LIKE '%' || eq.id || '%' OR 
                                 e.equipment_alternatives LIKE '%' || eq.id || '%')
        WHERE eq.is_active = 1
        GROUP BY eq.id
        ORDER BY total_score DESC, eq.name ASC
        LIMIT ?
      ''', [limit]);

      return results.map((map) => fromDatabase(map)).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to get popular equipment: $e');
    }
  }

  /// Get all categories
  Future<List<String>> getCategories() async {
    final db = await database;

    try {
      final results = await db.rawQuery('''
        SELECT DISTINCT category
        FROM equipment
        WHERE is_active = 1
        ORDER BY category ASC
      ''');

      return results.map((row) => row['category'] as String).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to get categories: $e');
    }
  }

  /// Get subcategories for a category
  Future<List<String>> getSubCategories(String category) async {
    final db = await database;

    try {
      final results = await db.rawQuery('''
        SELECT DISTINCT sub_category
        FROM equipment
        WHERE category = ? AND sub_category IS NOT NULL AND is_active = 1
        ORDER BY sub_category ASC
      ''', [category]);

      return results.map((row) => row['sub_category'] as String).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to get subcategories: $e');
    }
  }

  /// Helper method to apply filters
  void _applyFilter(
    EquipmentFilter filter,
    List<String> whereConditions,
    List<Object?> whereArgs,
  ) {
    if (filter.categories != null && filter.categories!.isNotEmpty) {
      whereConditions.add('category IN (${filter.categories!.map((_) => '?').join(', ')})');
      whereArgs.addAll(filter.categories!);
    }

    if (filter.spaceRequirements != null && filter.spaceRequirements!.isNotEmpty) {
      whereConditions.add('space_requirement IN (${filter.spaceRequirements!.map((_) => '?').join(', ')})');
      whereArgs.addAll(filter.spaceRequirements!);
    }

    if (filter.difficultyLevels != null && filter.difficultyLevels!.isNotEmpty) {
      whereConditions.add('difficulty_level IN (${filter.difficultyLevels!.map((_) => '?').join(', ')})');
      whereArgs.addAll(filter.difficultyLevels!);
    }

    if (filter.costCategories != null && filter.costCategories!.isNotEmpty) {
      whereConditions.add('cost_category IN (${filter.costCategories!.map((_) => '?').join(', ')})');
      whereArgs.addAll(filter.costCategories!);
    }

    if (filter.isHomeGym != null) {
      whereConditions.add('is_home_gym = ?');
      whereArgs.add(filter.isHomeGym! ? 1 : 0);
    }

    if (filter.isCommercialGym != null) {
      whereConditions.add('is_commercial_gym = ?');
      whereArgs.add(filter.isCommercialGym! ? 1 : 0);
    }

    if (filter.muscleGroups != null && filter.muscleGroups!.isNotEmpty) {
      final muscleConditions = filter.muscleGroups!
          .map((_) => '(LOWER(muscle_groups_primary) LIKE ? OR LOWER(muscle_groups_secondary) LIKE ?)')
          .join(' OR ');
      whereConditions.add('($muscleConditions)');
      for (final muscle in filter.muscleGroups!) {
        whereArgs.add('%${muscle.toLowerCase()}%');
        whereArgs.add('%${muscle.toLowerCase()}%');
      }
    }

    if (filter.tags != null && filter.tags!.isNotEmpty) {
      final tagConditions = filter.tags!
          .map((_) => 'LOWER(tags) LIKE ?')
          .join(' OR ');
      whereConditions.add('($tagConditions)');
      whereArgs.addAll(filter.tags!.map((tag) => '%${tag.toLowerCase()}%'));
    }
  }

  /// Helper method to build ORDER BY clause
  String _buildOrderBy(EquipmentSortBy sortBy, bool ascending) {
    final direction = ascending ? 'ASC' : 'DESC';

    switch (sortBy) {
      case EquipmentSortBy.name:
        return 'name $direction';
      case EquipmentSortBy.category:
        return 'category $direction, name ASC';
      case EquipmentSortBy.spaceRequirement:
        return '''
          CASE space_requirement 
            WHEN 'minimal' THEN 1 
            WHEN 'small' THEN 2 
            WHEN 'medium' THEN 3 
            WHEN 'large' THEN 4 
            ELSE 5 
          END $direction, name ASC
        ''';
      case EquipmentSortBy.costCategory:
        return '''
          CASE cost_category 
            WHEN 'free' THEN 1 
            WHEN 'low' THEN 2 
            WHEN 'medium' THEN 3 
            WHEN 'high' THEN 4 
            ELSE 5 
          END $direction, name ASC
        ''';
      case EquipmentSortBy.popularity:
        // This would require complex joins, simplified for now
        return 'name $direction';
    }
  }
}

/// Repository for managing user equipment inventory
class UserEquipmentRepository extends BaseRepository<UserEquipment> {
  UserEquipmentRepository(DatabaseManager databaseManager)
      : super(databaseManager, 'user_equipment');

  @override
  UserEquipment fromDatabase(Map<String, dynamic> map) => UserEquipment.fromDatabase(map);

  @override
  Map<String, dynamic> toDatabase(UserEquipment model) => model.toDatabase();

  @override
  String getId(UserEquipment model) => model.id;

  /// Get user's equipment with details
  Future<List<UserEquipment>> getUserEquipmentWithDetails(String userId) async {
    final db = await database;

    try {
      final results = await db.rawQuery('''
        SELECT 
          ue.*,
          e.name as equipment_name,
          e.description as equipment_description,
          e.category as equipment_category,
          e.sub_category as equipment_sub_category,
          e.image_url as equipment_image_url,
          e.space_requirement,
          e.cost_category,
          e.muscle_groups_primary,
          e.muscle_groups_secondary,
          e.tags as equipment_tags
        FROM user_equipment ue
        INNER JOIN equipment e ON ue.equipment_id = e.id
        WHERE ue.user_id = ?
        ORDER BY e.category ASC, e.name ASC
      ''', [userId]);

      return results.map((map) {
        final userEquipment = fromDatabase(map);
        
        // Create equipment object
        final equipment = Equipment(
          id: map['equipment_id'] as String,
          name: map['equipment_name'] as String,
          description: map['equipment_description'] as String?,
          category: map['equipment_category'] as String? ?? 'strength',
          subCategory: map['equipment_sub_category'] as String?,
          imageUrl: map['equipment_image_url'] as String?,
          spaceRequirement: map['space_requirement'] as String? ?? 'minimal',
          costCategory: map['cost_category'] as String? ?? 'medium',
          muscleGroupsPrimary: _parseJsonList(map['muscle_groups_primary']),
          muscleGroupsSecondary: _parseJsonList(map['muscle_groups_secondary']),
          tags: _parseJsonList(map['equipment_tags']),
        );

        return userEquipment.copyWith(equipment: equipment);
      }).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to get user equipment with details: $e');
    }
  }

  /// Add equipment to user's inventory
  Future<UserEquipment> addEquipment(
    String userId,
    String equipmentId, {
    String accessType = 'owned',
    int? conditionRating,
    String? notes,
    DateTime? acquiredDate,
  }) async {
    // Check if already exists
    final existing = await findWhere(
      'user_id = ? AND equipment_id = ?',
      [userId, equipmentId],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      throw GenericRepositoryException('Equipment already in user inventory');
    }

    final userEquipment = UserEquipment(
      id: generateId(),
      userId: userId,
      equipmentId: equipmentId,
      accessType: accessType,
      conditionRating: conditionRating,
      notes: notes,
      acquiredDate: acquiredDate,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return create(userEquipment);
  }

  /// Update user equipment
  Future<UserEquipment> updateEquipment(
    String userId,
    String equipmentId, {
    String? accessType,
    int? conditionRating,
    String? notes,
    DateTime? acquiredDate,
  }) async {
    final existing = await findWhere(
      'user_id = ? AND equipment_id = ?',
      [userId, equipmentId],
      limit: 1,
    );

    if (existing.isEmpty) {
      throw GenericRepositoryException('Equipment not found in user inventory');
    }

    final current = existing.first;
    final updated = current.copyWith(
      accessType: accessType ?? current.accessType,
      conditionRating: conditionRating ?? current.conditionRating,
      notes: notes ?? current.notes,
      acquiredDate: acquiredDate ?? current.acquiredDate,
      updatedAt: DateTime.now(),
    );

    return update(updated);
  }

  /// Remove equipment from user's inventory
  Future<void> removeEquipment(String userId, String equipmentId) async {
    final db = await database;

    try {
      final count = await db.delete(
        tableName,
        where: 'user_id = ? AND equipment_id = ?',
        whereArgs: [userId, equipmentId],
      );

      if (count == 0) {
        throw GenericRepositoryException('Equipment not found in user inventory');
      }
    } catch (e) {
      throw GenericRepositoryException('Failed to remove equipment: $e');
    }
  }

  /// Get user's equipment by category
  Future<List<UserEquipment>> getUserEquipmentByCategory(
    String userId,
    String category,
  ) async {
    final db = await database;

    try {
      final results = await db.rawQuery('''
        SELECT ue.*
        FROM user_equipment ue
        INNER JOIN equipment e ON ue.equipment_id = e.id
        WHERE ue.user_id = ? AND e.category = ?
        ORDER BY e.name ASC
      ''', [userId, category]);

      return results.map((map) => fromDatabase(map)).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to get user equipment by category: $e');
    }
  }

  /// Get user's equipment by access type
  Future<List<UserEquipment>> getUserEquipmentByAccessType(
    String userId,
    String accessType,
  ) async {
    return findWhere(
      'user_id = ? AND access_type = ?',
      [userId, accessType],
      orderBy: 'created_at DESC',
    );
  }

  /// Check if user has equipment
  Future<bool> hasEquipment(String userId, String equipmentId) async {
    final results = await findWhere(
      'user_id = ? AND equipment_id = ?',
      [userId, equipmentId],
      limit: 1,
    );

    return results.isNotEmpty;
  }

  /// Get user's available equipment IDs
  Future<List<String>> getUserEquipmentIds(String userId) async {
    final db = await database;

    try {
      final results = await db.query(
        tableName,
        columns: ['equipment_id'],
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      return results.map((row) => row['equipment_id'] as String).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to get user equipment IDs: $e');
    }
  }

  /// Get equipment statistics for user
  Future<Map<String, dynamic>> getUserEquipmentStats(String userId) async {
    final db = await database;

    try {
      final results = await db.rawQuery('''
        SELECT 
          COUNT(*) as total_equipment,
          COUNT(CASE WHEN access_type = 'owned' THEN 1 END) as owned_count,
          COUNT(CASE WHEN access_type = 'gym_access' THEN 1 END) as gym_access_count,
          COUNT(CASE WHEN access_type = 'occasional' THEN 1 END) as occasional_count,
          AVG(condition_rating) as avg_condition_rating
        FROM user_equipment ue
        WHERE ue.user_id = ?
      ''', [userId]);

      if (results.isEmpty) {
        return {
          'total_equipment': 0,
          'owned_count': 0,
          'gym_access_count': 0,
          'occasional_count': 0,
          'avg_condition_rating': null,
        };
      }

      return results.first;
    } catch (e) {
      throw GenericRepositoryException('Failed to get user equipment stats: $e');
    }
  }

  /// Helper method to parse JSON lists
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