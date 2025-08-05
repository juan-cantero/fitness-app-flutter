import '../../core/database/database_manager.dart';
import '../models/models.dart';
import 'base_repository.dart';
import 'errors/repository_exceptions.dart';

/// Repository for managing user profiles with preferences and settings
class UserProfileRepository extends BaseRepository<UserProfile> {
  UserProfileRepository(DatabaseManager databaseManager)
      : super(databaseManager, 'user_profiles');

  @override
  UserProfile fromDatabase(Map<String, dynamic> map) => UserProfile.fromDatabase(map);

  @override
  Map<String, dynamic> toDatabase(UserProfile model) => model.toDatabase();

  @override
  String getId(UserProfile model) => model.id;

  /// Get user profile by user ID
  Future<UserProfile?> getByUserId(String userId) async {
    final results = await findWhere('user_id = ?', [userId], limit: 1);
    return results.isEmpty ? null : results.first;
  }

  /// Create or update user profile
  Future<UserProfile> createOrUpdate(UserProfile profile) async {
    final existing = await getByUserId(profile.userId);
    
    if (existing != null) {
      final updatedProfile = profile.copyWith(
        id: existing.id,
        updatedAt: DateTime.now(),
      );
      return update(updatedProfile);
    } else {
      final newProfile = profile.copyWith(
        id: profile.id.isEmpty ? generateId() : profile.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      return create(newProfile);
    }
  }

  /// Update user fitness goals
  Future<UserProfile> updateFitnessGoals(
    String userId,
    List<String> fitnessGoals,
  ) async {
    final profile = await getByUserId(userId);
    if (profile == null) {
      throw GenericRepositoryException('User profile not found: $userId');
    }

    final updatedProfile = profile.copyWith(
      fitnessGoals: fitnessGoals,
      updatedAt: DateTime.now(),
    );

    return update(updatedProfile);
  }

  /// Update user physical measurements
  Future<UserProfile> updatePhysicalMeasurements(
    String userId, {
    int? heightCm,
    double? weightKg,
    DateTime? dateOfBirth,
    String? gender,
  }) async {
    final profile = await getByUserId(userId);
    if (profile == null) {
      throw GenericRepositoryException('User profile not found: $userId');
    }

    final updatedProfile = profile.copyWith(
      heightCm: heightCm ?? profile.heightCm,
      weightKg: weightKg ?? profile.weightKg,
      dateOfBirth: dateOfBirth ?? profile.dateOfBirth,
      gender: gender ?? profile.gender,
      updatedAt: DateTime.now(),
    );

    return update(updatedProfile);
  }

  /// Update user preferences
  Future<UserProfile> updatePreferences(
    String userId, {
    String? preferredUnits,
    String? timezone,
    String? activityLevel,
    String? fitnessLevel,
  }) async {
    final profile = await getByUserId(userId);
    if (profile == null) {
      throw GenericRepositoryException('User profile not found: $userId');
    }

    final updatedProfile = profile.copyWith(
      preferredUnits: preferredUnits ?? profile.preferredUnits,
      timezone: timezone ?? profile.timezone,
      activityLevel: activityLevel ?? profile.activityLevel,
      fitnessLevel: fitnessLevel ?? profile.fitnessLevel,
      updatedAt: DateTime.now(),
    );

    return update(updatedProfile);
  }

  /// Update profile visibility
  Future<UserProfile> updateVisibility(String userId, bool isPublic) async {
    final profile = await getByUserId(userId);
    if (profile == null) {
      throw GenericRepositoryException('User profile not found: $userId');
    }

    final updatedProfile = profile.copyWith(
      isPublic: isPublic,
      updatedAt: DateTime.now(),
    );

    return update(updatedProfile);
  }

  /// Get public profiles for discovery
  Future<List<UserProfile>> getPublicProfiles({
    String? fitnessLevel,
    List<String>? fitnessGoals,
    int? limit,
    int? offset,
  }) async {
    final conditions = ['is_public = 1'];
    final args = <Object?>[];

    if (fitnessLevel != null) {
      conditions.add('fitness_level = ?');
      args.add(fitnessLevel);
    }

    if (fitnessGoals != null && fitnessGoals.isNotEmpty) {
      final goalConditions = fitnessGoals
          .map((_) => 'fitness_goals LIKE ?')
          .join(' OR ');
      conditions.add('($goalConditions)');
      args.addAll(fitnessGoals.map((goal) => '%$goal%'));
    }

    return findWhere(
      conditions.join(' AND '),
      args,
      orderBy: 'display_name ASC',
      limit: limit,
      offset: offset,
    );
  }

  /// Calculate user's BMI
  double? calculateBMI(UserProfile profile) {
    if (profile.heightCm == null || profile.weightKg == null) {
      return null;
    }

    final heightM = profile.heightCm! / 100.0;
    return profile.weightKg! / (heightM * heightM);
  }

  /// Calculate user's age
  int? calculateAge(UserProfile profile) {
    if (profile.dateOfBirth == null) return null;

    final now = DateTime.now();
    final birthDate = profile.dateOfBirth!;
    
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    
    return age;
  }

  /// Get profile with calculated metrics
  Future<Map<String, dynamic>?> getProfileWithMetrics(String userId) async {
    final profile = await getByUserId(userId);
    if (profile == null) return null;

    return {
      'profile': profile,
      'bmi': calculateBMI(profile),
      'age': calculateAge(profile),
      'bmi_category': _getBMICategory(calculateBMI(profile)),
      'fitness_level_numeric': _getFitnessLevelNumeric(profile.fitnessLevel),
      'activity_level_numeric': _getActivityLevelNumeric(profile.activityLevel),
    };
  }

  /// Get BMI category
  String? _getBMICategory(double? bmi) {
    if (bmi == null) return null;
    
    if (bmi < 18.5) return 'underweight';
    if (bmi < 25.0) return 'normal';
    if (bmi < 30.0) return 'overweight';
    return 'obese';
  }

  /// Convert fitness level to numeric value
  int _getFitnessLevelNumeric(String fitnessLevel) {
    switch (fitnessLevel) {
      case 'beginner': return 1;
      case 'intermediate': return 2;
      case 'advanced': return 3;
      default: return 1;
    }
  }

  /// Convert activity level to numeric value
  int _getActivityLevelNumeric(String activityLevel) {
    switch (activityLevel) {
      case 'sedentary': return 1;
      case 'lightly_active': return 2;
      case 'moderately_active': return 3;
      case 'very_active': return 4;
      case 'extremely_active': return 5;
      default: return 3;
    }
  }
}

/// Repository for managing user progress tracking
class UserProgressRepository extends BaseRepository<UserProgress> {
  UserProgressRepository(DatabaseManager databaseManager)
      : super(databaseManager, 'user_progress');

  @override
  UserProgress fromDatabase(Map<String, dynamic> map) => UserProgress.fromDatabase(map);

  @override
  Map<String, dynamic> toDatabase(UserProgress model) => model.toDatabase();

  @override
  String getId(UserProgress model) => model.id;

  /// Add progress measurement
  Future<UserProgress> addProgress(UserProgress progress) async {
    final newProgress = progress.copyWith(
      id: progress.id.isEmpty ? generateId() : progress.id,
      createdAt: DateTime.now(),
    );

    return create(newProgress);
  }

  /// Get user progress by metric type
  Future<List<UserProgress>> getUserProgress(
    String userId,
    String metricType, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    final conditions = ['user_id = ?', 'metric_type = ?'];
    final args = <Object?>[userId, metricType];

    if (startDate != null) {
      conditions.add('measured_at >= ?');
      args.add(startDate.toIso8601String());
    }

    if (endDate != null) {
      conditions.add('measured_at <= ?');
      args.add(endDate.toIso8601String());
    }

    return findWhere(
      conditions.join(' AND '),
      args,
      orderBy: 'measured_at DESC',
      limit: limit,
    );
  }

  /// Get latest progress for each metric type
  Future<List<UserProgress>> getLatestProgress(String userId) async {
    final db = await database;

    try {
      final results = await db.rawQuery('''
        SELECT up1.*
        FROM user_progress up1
        INNER JOIN (
          SELECT metric_type, MAX(measured_at) as max_date
          FROM user_progress
          WHERE user_id = ?
          GROUP BY metric_type
        ) up2 ON up1.metric_type = up2.metric_type 
                 AND up1.measured_at = up2.max_date
        WHERE up1.user_id = ?
        ORDER BY up1.metric_type ASC
      ''', [userId, userId]);

      return results.map((map) => fromDatabase(map)).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to get latest progress: $e');
    }
  }

  /// Get progress trends
  Future<Map<String, dynamic>> getProgressTrends(
    String userId,
    String metricType, {
    int daysBack = 90,
  }) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: daysBack));

    final progressList = await getUserProgress(
      userId,
      metricType,
      startDate: startDate,
      endDate: endDate,
    );

    if (progressList.length < 2) {
      return {
        'trend': 'insufficient_data',
        'change': 0.0,
        'change_percentage': 0.0,
        'measurements_count': progressList.length,
      };
    }

    // Sort by date (oldest first)
    progressList.sort((a, b) => a.measuredAt.compareTo(b.measuredAt));

    final firstValue = progressList.first.value;
    final lastValue = progressList.last.value;
    final change = lastValue - firstValue;
    final changePercentage = firstValue != 0 ? (change / firstValue) * 100 : 0.0;

    String trend;
    if (change > 0) {
      trend = 'increasing';
    } else if (change < 0) {
      trend = 'decreasing';
    } else {
      trend = 'stable';
    }

    return {
      'trend': trend,
      'change': change,
      'change_percentage': changePercentage,
      'measurements_count': progressList.length,
      'first_value': firstValue,
      'last_value': lastValue,
      'first_date': progressList.first.measuredAt.toIso8601String(),
      'last_date': progressList.last.measuredAt.toIso8601String(),
    };
  }

  /// Get progress statistics
  Future<Map<String, dynamic>> getProgressStats(
    String userId,
    String metricType, {
    int daysBack = 365,
  }) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: daysBack));

    final db = await database;

    try {
      final results = await db.rawQuery('''
        SELECT 
          COUNT(*) as measurement_count,
          MIN(value) as min_value,
          MAX(value) as max_value,
          AVG(value) as avg_value,
          MIN(measured_at) as first_measurement,
          MAX(measured_at) as last_measurement
        FROM user_progress
        WHERE user_id = ? AND metric_type = ?
          AND measured_at >= ? AND measured_at <= ?
      ''', [userId, metricType, startDate.toIso8601String(), endDate.toIso8601String()]);

      if (results.isEmpty) {
        return {
          'measurement_count': 0,
          'min_value': null,
          'max_value': null,
          'avg_value': null,
          'first_measurement': null,
          'last_measurement': null,
        };
      }

      return results.first;
    } catch (e) {
      throw GenericRepositoryException('Failed to get progress stats: $e');
    }
  }

  /// Delete old progress measurements (data retention)
  Future<int> deleteOldProgress(String userId, int daysToKeep) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));

    final db = await database;

    try {
      return await db.delete(
        tableName,
        where: 'user_id = ? AND measured_at < ?',
        whereArgs: [userId, cutoffDate.toIso8601String()],
      );
    } catch (e) {
      throw GenericRepositoryException('Failed to delete old progress: $e');
    }
  }

  /// Get all metric types for user
  Future<List<String>> getUserMetricTypes(String userId) async {
    final db = await database;

    try {
      final results = await db.rawQuery('''
        SELECT DISTINCT metric_type
        FROM user_progress
        WHERE user_id = ?
        ORDER BY metric_type ASC
      ''', [userId]);

      return results.map((row) => row['metric_type'] as String).toList();
    } catch (e) {
      throw GenericRepositoryException('Failed to get user metric types: $e');
    }
  }
}