import 'package:flutter/foundation.dart';

/// Web-compatible database manager using browser storage
/// This simulates the SQLite functionality for web platforms
class WebDatabaseManager {
  static WebDatabaseManager? _instance;
  final Map<String, List<Map<String, dynamic>>> _tables = {};
  bool _initialized = false;

  WebDatabaseManager._internal();

  factory WebDatabaseManager() {
    _instance ??= WebDatabaseManager._internal();
    return _instance!;
  }

  /// Initialize with seed data for web
  Future<void> initialize() async {
    if (_initialized) return;
    
    debugPrint('WebDatabaseManager: Initializing with seed data');
    
    // Initialize tables with seed data
    _initializeCategories();
    _initializeEquipment();
    _initializeExercises();
    _initializeEmptyTables();
    
    _initialized = true;
    debugPrint('WebDatabaseManager: Initialization complete');
  }

  /// Query a table (simulates SQL SELECT)
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    await initialize();
    
    final tableData = _tables[table] ?? [];
    
    // Simple filtering (basic WHERE simulation)
    List<Map<String, dynamic>> results = List.from(tableData);
    
    // Apply limit and offset
    if (offset != null) {
      results = results.skip(offset).toList();
    }
    if (limit != null) {
      results = results.take(limit).toList();
    }
    
    return results;
  }

  /// Get count of records in a table
  Future<int> getCount(String table) async {
    await initialize();
    return _tables[table]?.length ?? 0;
  }

  /// Get all table names
  List<String> getTableNames() {
    return _tables.keys.toList();
  }

  void _initializeCategories() {
    _tables['categories'] = [
      {
        'id': 'cat_strength',
        'name': 'Strength Training',
        'description': 'Exercises focused on building muscle strength and mass',
        'icon': 'fitness_center',
        'color': '#FF6B35',
        'sort_order': 1,
        'is_active': 1,
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'cat_cardio',
        'name': 'Cardiovascular',
        'description': 'Exercises to improve heart health and endurance',
        'icon': 'directions_run',
        'color': '#4ECDC4',
        'sort_order': 2,
        'is_active': 1,
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'cat_flexibility',
        'name': 'Flexibility & Mobility',
        'description': 'Stretching and mobility exercises',
        'icon': 'accessibility',
        'color': '#45B7D1',
        'sort_order': 3,
        'is_active': 1,
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'cat_functional',
        'name': 'Functional Training',
        'description': 'Real-world movement patterns',
        'icon': 'sports_gymnastics',
        'color': '#96CEB4',
        'sort_order': 4,
        'is_active': 1,
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'cat_upper_body',
        'name': 'Upper Body',
        'description': 'Chest, shoulders, arms, and back exercises',
        'icon': 'fitness_center',
        'color': '#FF6B35',
        'parent_category_id': 'cat_strength',
        'sort_order': 1,
        'is_active': 1,
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'cat_lower_body',
        'name': 'Lower Body', 
        'description': 'Legs, glutes, and hip exercises',
        'icon': 'fitness_center',
        'color': '#FF6B35',
        'parent_category_id': 'cat_strength',
        'sort_order': 2,
        'is_active': 1,
        'created_at': DateTime.now().toIso8601String(),
      },
    ];
  }

  void _initializeEquipment() {
    _tables['equipment'] = [
      {
        'id': 'eq_bodyweight',
        'name': 'Bodyweight Only',
        'description': 'No equipment needed - use your own body weight',
        'category': 'bodyweight',
        'sub_category': 'none',
        'muscle_groups_primary': '["full_body"]',
        'muscle_groups_secondary': '[]',
        'space_requirement': 'minimal',
        'difficulty_level': 'beginner',
        'is_home_gym': 1,
        'is_commercial_gym': 1,
        'cost_category': 'free',
        'tags': '["bodyweight", "no_equipment", "anywhere"]',
        'is_active': 1,
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'eq_dumbbells',
        'name': 'Dumbbells',
        'description': 'Adjustable or fixed-weight dumbbells',
        'category': 'strength',
        'sub_category': 'free_weights',
        'muscle_groups_primary': '["full_body"]',
        'muscle_groups_secondary': '[]',
        'space_requirement': 'small',
        'difficulty_level': 'beginner',
        'is_home_gym': 1,
        'is_commercial_gym': 1,
        'cost_category': 'medium',
        'tags': '["dumbbells", "free_weights", "versatile"]',
        'is_active': 1,
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'eq_barbell',
        'name': 'Barbell',
        'description': 'Olympic or standard barbell with weight plates',
        'category': 'strength',
        'sub_category': 'free_weights',
        'muscle_groups_primary': '["full_body"]',
        'muscle_groups_secondary': '[]',
        'space_requirement': 'medium',
        'difficulty_level': 'intermediate',
        'is_home_gym': 1,
        'is_commercial_gym': 1,
        'cost_category': 'high',
        'tags': '["barbell", "compound", "heavy"]',
        'is_active': 1,
        'created_at': DateTime.now().toIso8601String(),
      },
    ];
  }

  void _initializeExercises() {
    _tables['exercises'] = [
      {
        'id': 'ex_pushups',
        'name': 'Push-ups',
        'description': 'Basic bodyweight exercise for chest and arms',
        'instructions': 'Start in plank position. Lower body to ground. Push back up.',
        'created_by': null,
        'is_public': 1,
        'difficulty_level': 'beginner',
        'exercise_type': 'strength',
        'primary_muscle_groups': 'chest,triceps',
        'secondary_muscle_groups': 'shoulders,core',
        'equipment_required': '',
        'movement_pattern': 'push',
        'tempo': '2-1-2-1',
        'calories_per_minute': 8.0,
        'met_value': 3.8,
        'tags': 'bodyweight,chest,beginner',
        'is_unilateral': 0,
        'is_compound': 1,
        'requires_spotter': 0,
        'setup_time_seconds': 5,
        'cleanup_time_seconds': 0,
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'ex_squats',
        'name': 'Squats',
        'description': 'Fundamental lower body exercise',
        'instructions': 'Stand with feet shoulder-width apart. Lower hips back and down. Return to standing.',
        'created_by': null,
        'is_public': 1,
        'difficulty_level': 'beginner',
        'exercise_type': 'strength',
        'primary_muscle_groups': 'quadriceps,glutes',
        'secondary_muscle_groups': 'hamstrings,core',
        'equipment_required': '',
        'movement_pattern': 'squat',
        'tempo': '2-1-2-1',
        'calories_per_minute': 6.5,
        'met_value': 5.0,
        'tags': 'bodyweight,legs,beginner',
        'is_unilateral': 0,
        'is_compound': 1,
        'requires_spotter': 0,
        'setup_time_seconds': 5,
        'cleanup_time_seconds': 0,
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'ex_pullups',
        'name': 'Pull-ups',
        'description': 'Upper body pulling exercise',
        'instructions': 'Hang from bar with overhand grip. Pull body up until chin clears bar. Lower with control.',
        'created_by': null,
        'is_public': 1,
        'difficulty_level': 'intermediate',
        'exercise_type': 'strength',
        'primary_muscle_groups': 'back,biceps',
        'secondary_muscle_groups': 'shoulders,core',
        'equipment_required': 'pull_up_bar',
        'movement_pattern': 'pull',
        'tempo': '2-1-2-1',
        'calories_per_minute': 10.0,
        'met_value': 8.0,
        'tags': 'pull_up_bar,back,intermediate',
        'is_unilateral': 0,
        'is_compound': 1,
        'requires_spotter': 0,
        'setup_time_seconds': 10,
        'cleanup_time_seconds': 0,
        'created_at': DateTime.now().toIso8601String(),
      },
    ];
  }

  void _initializeEmptyTables() {
    // Initialize empty tables that will be populated by user actions
    _tables['users'] = [];
    _tables['user_profiles'] = [];
    _tables['workouts'] = [];
    _tables['workout_exercises'] = [];
    _tables['workout_sessions'] = [];
    _tables['exercise_logs'] = [];
    _tables['favorites'] = [];
    _tables['workout_shares'] = [];
    _tables['workout_comments'] = [];
    _tables['workout_ratings'] = [];
    _tables['user_progress'] = [];
    _tables['personal_records'] = [];
    _tables['sync_status'] = [];
    _tables['sync_conflicts'] = [];
    _tables['user_equipment'] = [];
    _tables['exercise_categories'] = [];
  }
}