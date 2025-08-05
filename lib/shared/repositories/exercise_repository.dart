import '../../core/database/database_manager.dart';
import '../models/models.dart';
import 'base_repository.dart';
import 'errors/repository_exceptions.dart';

/// Filter options for exercise queries
class ExerciseFilter {
  final List<String>? muscleGroups;
  final List<String>? equipmentIds;
  final String? difficultyLevel;
  final String? exerciseType;
  final String? movementPattern;
  final bool? isCompound;
  final bool? requiresSpotter;
  final bool? isUnilateral;
  final List<String>? tags;
  final bool? isPublic;
  final String? createdBy;
  final int? maxSetupTime;
  final int? maxCleanupTime;

  const ExerciseFilter({
    this.muscleGroups,
    this.equipmentIds,
    this.difficultyLevel,
    this.exerciseType,
    this.movementPattern,
    this.isCompound,
    this.requiresSpotter,
    this.isUnilateral,
    this.tags,
    this.isPublic,
    this.createdBy,
    this.maxSetupTime,
    this.maxCleanupTime,
  });
}

/// Sorting options for exercises
enum ExerciseSortBy {
  name,
  difficulty,
  createdAt,
  popularity,
  setupTime,
  muscleGroups,
}

/// Repository for managing exercises with advanced filtering and search
class ExerciseRepository extends BaseRepository<Exercise> {
  ExerciseRepository(DatabaseManager databaseManager)
      : super(databaseManager, 'exercises');

  @override
  Exercise fromDatabase(Map<String, dynamic> map) => Exercise.fromDatabase(map);

  @override
  Map<String, dynamic> toDatabase(Exercise model) => model.toDatabase();

  @override
  String getId(Exercise model) => model.id;

  /// Search exercises with comprehensive filtering
  Future<List<Exercise>> searchExercises(
    String? query, {
    ExerciseFilter? filter,
    ExerciseSortBy sortBy = ExerciseSortBy.name,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    
    try {
      // Build the WHERE clause
      final whereConditions = <String>[];
      final whereArgs = <Object?>[];

      // Text search
      if (query != null && query.trim().isNotEmpty) {
        whereConditions.add('''
          (LOWER(name) LIKE ? OR 
           LOWER(description) LIKE ? OR 
           LOWER(instructions) LIKE ? OR 
           LOWER(primary_muscle_groups) LIKE ? OR 
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

      final whereClause = whereConditions.isEmpty 
          ? null 
          : whereConditions.join(' AND ');

      final results = await db.query(
        tableName,
        where: whereClause,
        whereArgs: whereArgs.isEmpty ? null : whereArgs,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );

      return results.map((map) => fromDatabase(map)).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to search exercises: $e');
    }
  }

  /// Find exercises by muscle groups
  Future<List<Exercise>> findByMuscleGroups(
    List<String> muscleGroups, {
    bool requireAll = false,
    int? limit,
  }) async {
    if (muscleGroups.isEmpty) return [];

    final db = await database;
    
    try {
      String whereClause;
      List<Object?> whereArgs;

      if (requireAll) {
        // All muscle groups must be present
        whereClause = muscleGroups
            .map((_) => '(LOWER(primary_muscle_groups) LIKE ? OR LOWER(secondary_muscle_groups) LIKE ?)')
            .join(' AND ');
        whereArgs = muscleGroups
            .expand((mg) => ['%${mg.toLowerCase()}%', '%${mg.toLowerCase()}%'])
            .toList();
      } else {
        // Any muscle group can be present
        whereClause = muscleGroups
            .map((_) => '(LOWER(primary_muscle_groups) LIKE ? OR LOWER(secondary_muscle_groups) LIKE ?)')
            .join(' OR ');
        whereArgs = muscleGroups
            .expand((mg) => ['%${mg.toLowerCase()}%', '%${mg.toLowerCase()}%'])
            .toList();
      }

      final results = await db.query(
        tableName,
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: 'name ASC',
        limit: limit,
      );

      return results.map((map) => fromDatabase(map)).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to find exercises by muscle groups: $e');
    }
  }

  /// Find exercises by equipment availability
  Future<List<Exercise>> findByEquipment(
    List<String> availableEquipmentIds, {
    bool requireExactMatch = false,
    int? limit,
  }) async {
    final db = await database;
    
    try {
      if (requireExactMatch) {
        // Find exercises that use only the available equipment
        final results = await db.rawQuery('''
          SELECT * FROM exercises 
          WHERE id NOT IN (
            SELECT DISTINCT e.id 
            FROM exercises e
            WHERE e.equipment_required != '' 
            AND EXISTS (
              SELECT 1 
              FROM (
                SELECT TRIM(value) as equipment_id 
                FROM json_each('[' || '"' || REPLACE(e.equipment_required, ',', '","') || '"' || ']')
                WHERE TRIM(value) != ''
              ) 
              WHERE equipment_id NOT IN (${availableEquipmentIds.map((_) => '?').join(',')})
            )
          )
          ORDER BY name ASC
          ${limit != null ? 'LIMIT ?' : ''}
        ''', [
          ...availableEquipmentIds,
          if (limit != null) limit,
        ]);

        return results.map((map) => fromDatabase(map)).toList();
      } else {
        // Find exercises that can be performed with available equipment or no equipment
        final whereClause = '''
          (equipment_required = '' OR equipment_required IS NULL OR ${
            availableEquipmentIds.map((_) => 'LOWER(equipment_required) LIKE ?').join(' OR ')
          })
        ''';
        
        final whereArgs = availableEquipmentIds
            .map((id) => '%${id.toLowerCase()}%')
            .toList();

        final results = await db.query(
          tableName,
          where: whereClause,
          whereArgs: whereArgs,
          orderBy: 'name ASC',
          limit: limit,
        );

        return results.map((map) => fromDatabase(map)).toList();
      }
    } catch (e) {
      throw GenericRepositoryException('Failed to find exercises by equipment: $e');
    }
  }

  /// Get exercises with similar movement patterns
  Future<List<Exercise>> findSimilarExercises(
    String exerciseId, {
    int limit = 10,
  }) async {
    final exercise = await getById(exerciseId);
    if (exercise == null) return [];

    final db = await database;
    
    try {
      // Find exercises with similar characteristics
      final results = await db.rawQuery('''
        SELECT *, 
        (
          CASE WHEN movement_pattern = ? THEN 3 ELSE 0 END +
          CASE WHEN exercise_type = ? THEN 2 ELSE 0 END +
          CASE WHEN difficulty_level = ? THEN 1 ELSE 0 END +
          CASE WHEN (
            SELECT COUNT(*) FROM (
              SELECT TRIM(value) as mg1 
              FROM json_each('[' || '"' || REPLACE(?, ',', '","') || '"' || ']')
            ) mg1
            INNER JOIN (
              SELECT TRIM(value) as mg2 
              FROM json_each('[' || '"' || REPLACE(primary_muscle_groups, ',', '","') || '"' || ']')
            ) mg2 ON LOWER(mg1.mg1) = LOWER(mg2.mg2)
          ) > 0 THEN 2 ELSE 0 END
        ) as similarity_score
        FROM exercises 
        WHERE id != ? 
        HAVING similarity_score > 0
        ORDER BY similarity_score DESC, name ASC
        LIMIT ?
      ''', [
        exercise.movementPattern ?? '',
        exercise.exerciseType,
        exercise.difficultyLevel,
        exercise.primaryMuscleGroups.join(','),
        exerciseId,
        limit,
      ]);

      return results.map((map) => fromDatabase(map)).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to find similar exercises: $e');
    }
  }

  /// Get exercise progressions
  Future<List<Exercise>> getProgressions(String exerciseId) async {
    final exercise = await getById(exerciseId);
    if (exercise == null || exercise.progressions.isEmpty) return [];

    return _getExercisesByIds(exercise.progressions);
  }

  /// Get exercise regressions
  Future<List<Exercise>> getRegressions(String exerciseId) async {
    final exercise = await getById(exerciseId);
    if (exercise == null || exercise.regressions.isEmpty) return [];

    return _getExercisesByIds(exercise.regressions);
  }

  /// Get exercises by category
  Future<List<Exercise>> findByCategory(
    String categoryId, {
    String? orderBy,
    int? limit,
  }) async {
    final db = await database;
    
    try {
      final results = await db.rawQuery('''
        SELECT e.* 
        FROM exercises e
        INNER JOIN exercise_categories ec ON e.id = ec.exercise_id
        WHERE ec.category_id = ?
        ORDER BY ${orderBy ?? 'e.name ASC'}
        ${limit != null ? 'LIMIT ?' : ''}
      ''', [
        categoryId,
        if (limit != null) limit,
      ]);

      return results.map((map) => fromDatabase(map)).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to find exercises by category: $e');
    }
  }

  /// Get popular exercises (based on usage in workouts)
  Future<List<Exercise>> getPopularExercises({
    int limit = 20,
    int? daysBack,
  }) async {
    final db = await database;
    
    try {
      String dateFilter = '';
      List<Object?> args = [];
      
      if (daysBack != null) {
        dateFilter = "AND w.created_at >= datetime('now', '-$daysBack days')";
      }

      final results = await db.rawQuery('''
        SELECT e.*, COUNT(we.exercise_id) as usage_count
        FROM exercises e
        LEFT JOIN workout_exercises we ON e.id = we.exercise_id
        LEFT JOIN workouts w ON we.workout_id = w.id
        WHERE 1=1 $dateFilter
        GROUP BY e.id
        ORDER BY usage_count DESC, e.name ASC
        LIMIT ?
      ''', [...args, limit]);

      return results.map((map) => fromDatabase(map)).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to get popular exercises: $e');
    }
  }

  /// Add exercise to category
  Future<void> addToCategory(String exerciseId, String categoryId) async {
    final db = await database;
    
    try {
      await db.insert('exercise_categories', {
        'id': generateId(),
        'exercise_id': exerciseId,
        'category_id': categoryId,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        // Already exists, ignore
        return;
      }
      throw GenericRepositoryException('Failed to add exercise to category: $e');
    }
  }

  /// Remove exercise from category
  Future<void> removeFromCategory(String exerciseId, String categoryId) async {
    final db = await database;
    
    try {
      await db.delete(
        'exercise_categories',
        where: 'exercise_id = ? AND category_id = ?',
        whereArgs: [exerciseId, categoryId],
      );
    } catch (e) {
      throw GenericRepositoryException('Failed to remove exercise from category: $e');
    }
  }

  /// Get exercise categories
  Future<List<Category>> getExerciseCategories(String exerciseId) async {
    final db = await database;
    
    try {
      final results = await db.rawQuery('''
        SELECT c.* 
        FROM categories c
        INNER JOIN exercise_categories ec ON c.id = ec.category_id
        WHERE ec.exercise_id = ?
        ORDER BY c.name ASC
      ''', [exerciseId]);

      return results.map((map) => Category.fromDatabase(map)).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to get exercise categories: $e');
    }
  }

  /// Helper method to apply filters
  void _applyFilter(
    ExerciseFilter filter,
    List<String> whereConditions,
    List<Object?> whereArgs,
  ) {
    if (filter.muscleGroups != null && filter.muscleGroups!.isNotEmpty) {
      final muscleGroupConditions = filter.muscleGroups!
          .map((_) => '(LOWER(primary_muscle_groups) LIKE ? OR LOWER(secondary_muscle_groups) LIKE ?)')
          .join(' OR ');
      whereConditions.add('($muscleGroupConditions)');
      whereArgs.addAll(filter.muscleGroups!
          .expand((mg) => ['%${mg.toLowerCase()}%', '%${mg.toLowerCase()}%']));
    }

    if (filter.equipmentIds != null && filter.equipmentIds!.isNotEmpty) {
      final equipmentConditions = filter.equipmentIds!
          .map((_) => 'LOWER(equipment_required) LIKE ?')
          .join(' OR ');
      whereConditions.add('(equipment_required = "" OR equipment_required IS NULL OR ($equipmentConditions))');
      whereArgs.addAll(filter.equipmentIds!.map((eq) => '%${eq.toLowerCase()}%'));
    }

    if (filter.difficultyLevel != null) {
      whereConditions.add('difficulty_level = ?');
      whereArgs.add(filter.difficultyLevel);
    }

    if (filter.exerciseType != null) {
      whereConditions.add('exercise_type = ?');
      whereArgs.add(filter.exerciseType);
    }

    if (filter.movementPattern != null) {
      whereConditions.add('movement_pattern = ?');
      whereArgs.add(filter.movementPattern);
    }

    if (filter.isCompound != null) {
      whereConditions.add('is_compound = ?');
      whereArgs.add(filter.isCompound! ? 1 : 0);
    }

    if (filter.requiresSpotter != null) {
      whereConditions.add('requires_spotter = ?');
      whereArgs.add(filter.requiresSpotter! ? 1 : 0);
    }

    if (filter.isUnilateral != null) {
      whereConditions.add('is_unilateral = ?');
      whereArgs.add(filter.isUnilateral! ? 1 : 0);
    }

    if (filter.tags != null && filter.tags!.isNotEmpty) {
      final tagConditions = filter.tags!
          .map((_) => 'LOWER(tags) LIKE ?')
          .join(' OR ');
      whereConditions.add('($tagConditions)');
      whereArgs.addAll(filter.tags!.map((tag) => '%${tag.toLowerCase()}%'));
    }

    if (filter.isPublic != null) {
      whereConditions.add('is_public = ?');
      whereArgs.add(filter.isPublic! ? 1 : 0);
    }

    if (filter.createdBy != null) {
      whereConditions.add('created_by = ?');
      whereArgs.add(filter.createdBy);
    }

    if (filter.maxSetupTime != null) {
      whereConditions.add('setup_time_seconds <= ?');
      whereArgs.add(filter.maxSetupTime);
    }

    if (filter.maxCleanupTime != null) {
      whereConditions.add('cleanup_time_seconds <= ?');
      whereArgs.add(filter.maxCleanupTime);
    }
  }

  /// Helper method to build ORDER BY clause
  String _buildOrderBy(ExerciseSortBy sortBy, bool ascending) {
    final direction = ascending ? 'ASC' : 'DESC';
    
    switch (sortBy) {
      case ExerciseSortBy.name:
        return 'name $direction';
      case ExerciseSortBy.difficulty:
        return '''
          CASE difficulty_level 
            WHEN 'beginner' THEN 1 
            WHEN 'intermediate' THEN 2 
            WHEN 'advanced' THEN 3 
            ELSE 0 
          END $direction, name ASC
        ''';
      case ExerciseSortBy.createdAt:
        return 'created_at $direction';
      case ExerciseSortBy.setupTime:
        return 'setup_time_seconds $direction, name ASC';
      case ExerciseSortBy.muscleGroups:
        return 'primary_muscle_groups $direction, name ASC';
      case ExerciseSortBy.popularity:
        // This would require a join with workout_exercises, simplified for now
        return 'name $direction';
    }
  }

  /// Helper method to get exercises by IDs
  Future<List<Exercise>> _getExercisesByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    final db = await database;
    
    try {
      final placeholders = ids.map((_) => '?').join(',');
      final results = await db.rawQuery(
        'SELECT * FROM exercises WHERE id IN ($placeholders) ORDER BY name ASC',
        ids,
      );

      return results.map((map) => fromDatabase(map)).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to get exercises by IDs: $e');
    }
  }
}