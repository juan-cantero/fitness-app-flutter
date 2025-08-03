class AppConfig {
  static const String appName = 'Fitness App';
  static const String appVersion = '1.0.0';
  
  // Supabase Configuration
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'YOUR_SUPABASE_URL_HERE',
  );
  
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'YOUR_SUPABASE_ANON_KEY_HERE',
  );
  
  // LLM Configuration
  static const String openaiApiKey = String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue: '',
  );
  
  static const String anthropicApiKey = String.fromEnvironment(
    'ANTHROPIC_API_KEY',
    defaultValue: '',
  );
  
  // App Configuration
  static const bool debugMode = bool.fromEnvironment('DEBUG', defaultValue: false);
  static const bool enableAnalytics = bool.fromEnvironment('ENABLE_ANALYTICS', defaultValue: true);
  
  // Network Configuration
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration cacheTimeout = Duration(minutes: 5);
  
  // Database Configuration
  static const String localDatabaseName = 'fitness_app.db';
  static const int localDatabaseVersion = 1;
  
  // Validation Constants
  static const int maxWorkoutNameLength = 50;
  static const int maxExerciseNameLength = 100;
  static const int maxWorkoutDescriptionLength = 500;
  static const int minPasswordLength = 8;
  
  // Workout Limits
  static const int maxExercisesPerWorkout = 20;
  static const int maxSetsPerExercise = 10;
  static const int maxRepsPerSet = 1000;
  static const int maxWeightKg = 1000;
  static const int maxDurationMinutes = 480; // 8 hours
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}