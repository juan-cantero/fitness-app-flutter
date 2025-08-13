class AppConstants {
  // Route Names
  static const String homeRoute = '/';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String exercisesRoute = '/exercises';
  static const String workoutsRoute = '/workouts';
  static const String profileRoute = '/profile';
  static const String createWorkoutRoute = '/create-workout';
  static const String createExerciseRoute = '/create-exercise';
  static const String workoutDetailRoute = '/workout/:id';
  static const String exerciseDetailRoute = '/exercise/:id';
  static const String editExerciseRoute = '/exercise/:id/edit';
  
  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String onboardingKey = 'onboarding_completed';
  static const String workoutFiltersKey = 'workout_filters';
  
  // Equipment Types
  static const List<String> equipmentTypes = [
    'bodyweight',
    'dumbbells',
    'barbell',
    'kettlebell',
    'resistance_bands',
    'pull_up_bar',
    'cable_machine',
    'smith_machine',
    'cardio_machine',
    'medicine_ball',
    'yoga_mat',
    'foam_roller',
  ];
  
  // Muscle Groups
  static const List<String> muscleGroups = [
    'chest',
    'back',
    'shoulders',
    'biceps',
    'triceps',
    'forearms',
    'abs',
    'obliques',
    'glutes',
    'quadriceps',
    'hamstrings',
    'calves',
    'cardio',
    'full_body',
  ];
  
  // Difficulty Levels
  static const List<String> difficultyLevels = [
    'beginner',
    'intermediate',
    'advanced',
    'expert',
  ];
  
  // Exercise Categories
  static const List<String> exerciseCategories = [
    'strength',
    'cardio',
    'flexibility',
    'mobility',
    'balance',
    'sports',
    'rehabilitation',
  ];
  
  // Workout Types
  static const List<String> workoutTypes = [
    'strength_training',
    'cardio',
    'hiit',
    'yoga',
    'pilates',
    'calisthenics',
    'powerlifting',
    'bodybuilding',
    'crossfit',
    'sports_specific',
    'rehabilitation',
    'warm_up',
    'cool_down',
  ];
  
  // Time Durations (in minutes)
  static const List<int> workoutDurations = [
    15, 20, 30, 45, 60, 75, 90, 120
  ];
  
  // Rest Times (in seconds)
  static const List<int> restTimes = [
    30, 45, 60, 90, 120, 180, 240, 300
  ];
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;
  
  // Error Messages
  static const String networkErrorMessage = 'Network connection error. Please check your internet connection.';
  static const String genericErrorMessage = 'An unexpected error occurred. Please try again.';
  static const String authErrorMessage = 'Authentication failed. Please check your credentials.';
  static const String permissionErrorMessage = 'Permission denied. Please grant the required permissions.';
  
  // Success Messages
  static const String workoutCreatedMessage = 'Workout created successfully!';
  static const String exerciseCreatedMessage = 'Exercise created successfully!';
  static const String profileUpdatedMessage = 'Profile updated successfully!';
  static const String passwordChangedMessage = 'Password changed successfully!';
  
  // Validation Messages
  static const String requiredFieldMessage = 'This field is required';
  static const String invalidEmailMessage = 'Please enter a valid email address';
  static const String weakPasswordMessage = 'Password must be at least 8 characters long';
  static const String passwordMismatchMessage = 'Passwords do not match';
  
  // LLM Prompts
  static const String workoutGenerationPrompt = '''
You are a certified personal trainer creating personalized workouts.
Create a balanced workout based on the user's preferences and constraints.
Ensure the workout is safe, effective, and appropriate for their fitness level.
''';
  
  // Default Values
  static const int defaultSets = 3;
  static const int defaultReps = 12;
  static const int defaultRestTime = 60; // seconds
  static const double defaultWeight = 0.0; // kg
}