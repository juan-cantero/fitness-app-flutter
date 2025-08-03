import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_config.dart';

class SupabaseConfig {
  static SupabaseClient get client => Supabase.instance.client;
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        autoRefreshToken: true,
        detectSessionInUri: true,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
        eventsPerSecond: 10,
      ),
    );
  }
  
  // Database table names
  static const String usersTable = 'users';
  static const String exercisesTable = 'exercises';
  static const String workoutsTable = 'workouts';
  static const String workoutExercisesTable = 'workout_exercises';
  static const String categoriesTable = 'categories';
  static const String exerciseCategoriesTable = 'exercise_categories';
  static const String userProfilesTable = 'user_profiles';
  static const String workoutSessionsTable = 'workout_sessions';
  static const String exerciseLogsTable = 'exercise_logs';
  static const String favoritesTable = 'favorites';
  static const String sharesTable = 'workout_shares';
  static const String commentsTable = 'workout_comments';
  static const String ratingsTable = 'workout_ratings';
  
  // Storage bucket names
  static const String exerciseImagesBucket = 'exercise-images';
  static const String profileImagesBucket = 'profile-images';
  static const String workoutVideosBucket = 'workout-videos';
  
  // RLS (Row Level Security) policies
  static const Map<String, List<String>> rlsPolicies = {
    usersTable: [
      'Users can view own profile',
      'Users can update own profile',
    ],
    exercisesTable: [
      'Public exercises are viewable by all',
      'Users can view own exercises',
      'Users can create exercises',
      'Users can update own exercises',
      'Users can delete own exercises',
    ],
    workoutsTable: [
      'Public workouts are viewable by all',
      'Users can view own workouts',
      'Users can view shared workouts',
      'Users can create workouts',
      'Users can update own workouts',
      'Users can delete own workouts',
    ],
    workoutExercisesTable: [
      'Users can manage exercises in own workouts',
    ],
    userProfilesTable: [
      'Users can view own profile',
      'Users can update own profile',
    ],
    workoutSessionsTable: [
      'Users can view own workout sessions',
      'Users can create workout sessions',
      'Users can update own workout sessions',
    ],
    exerciseLogsTable: [
      'Users can view own exercise logs',
      'Users can create exercise logs',
      'Users can update own exercise logs',
    ],
    favoritesTable: [
      'Users can view own favorites',
      'Users can manage own favorites',
    ],
    sharesTable: [
      'Users can view shares involving them',
      'Users can create shares for own workouts',
      'Users can delete own shares',
    ],
    commentsTable: [
      'Users can view comments on accessible workouts',
      'Users can create comments',
      'Users can update own comments',
      'Users can delete own comments',
    ],
    ratingsTable: [
      'Users can view ratings on accessible workouts',
      'Users can create one rating per workout',
      'Users can update own ratings',
    ],
  };
  
  // Realtime channels
  static const String workoutsChannel = 'workouts-channel';
  static const String exercisesChannel = 'exercises-channel';
  static const String userProfileChannel = 'user-profile-channel';
  
  // Helper methods for common queries
  static PostgrestFilterBuilder<List<Map<String, dynamic>>> getPublicExercises() {
    return client
        .from(exercisesTable)
        .select('*')
        .eq('is_public', true);
  }
  
  static PostgrestFilterBuilder<List<Map<String, dynamic>>> getUserExercises(String userId) {
    return client
        .from(exercisesTable)
        .select('*')
        .eq('created_by', userId);
  }
  
  static PostgrestFilterBuilder<List<Map<String, dynamic>>> getPublicWorkouts() {
    return client
        .from(workoutsTable)
        .select('*')
        .eq('is_public', true);
  }
  
  static PostgrestFilterBuilder<List<Map<String, dynamic>>> getUserWorkouts(String userId) {
    return client
        .from(workoutsTable)
        .select('*')
        .eq('created_by', userId);
  }
  
  static PostgrestTransformBuilder<PostgrestList> getWorkoutExercises(String workoutId) {
    return client
        .from(workoutExercisesTable)
        .select('''
          *,
          exercise:exercises(*)
        ''')
        .eq('workout_id', workoutId)
        .order('order_index');
  }
  
  static PostgrestTransformBuilder<PostgrestMap> getUserProfile(String userId) {
    return client
        .from(userProfilesTable)
        .select('*')
        .eq('user_id', userId)
        .single();
  }
  
  static PostgrestTransformBuilder<PostgrestList> getWorkoutSessions(String userId) {
    return client
        .from(workoutSessionsTable)
        .select('''
          *,
          workout:workouts(name, description)
        ''')
        .eq('user_id', userId)
        .order('started_at', ascending: false);
  }
  
  // Helper methods for storage
  static String getExerciseImageUrl(String fileName) {
    return client.storage
        .from(exerciseImagesBucket)
        .getPublicUrl(fileName);
  }
  
  static String getProfileImageUrl(String fileName) {
    return client.storage
        .from(profileImagesBucket)
        .getPublicUrl(fileName);
  }
  
  static String getWorkoutVideoUrl(String fileName) {
    return client.storage
        .from(workoutVideosBucket)
        .getPublicUrl(fileName);
  }
  
  // Authentication helpers
  static User? get currentUser => client.auth.currentUser;
  static String? get currentUserId => currentUser?.id;
  static bool get isAuthenticated => currentUser != null;
  
  // Realtime subscription helpers
  static RealtimeChannel subscribeToWorkouts(String userId) {
    return client
        .channel(workoutsChannel)
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: workoutsTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'created_by',
            value: userId,
          ),
          callback: (payload) {
            // Handle workout changes
          },
        );
  }
  
  static RealtimeChannel subscribeToPublicExercises() {
    return client
        .channel(exercisesChannel)
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: exercisesTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'is_public',
            value: true,
          ),
          callback: (payload) {
            // Handle exercise changes
          },
        );
  }
}