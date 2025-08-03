import '../config/app_config.dart';
import '../constants/app_constants.dart';

class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.requiredFieldMessage;
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return AppConstants.invalidEmailMessage;
    }
    
    return null;
  }
  
  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.requiredFieldMessage;
    }
    
    if (value.length < AppConfig.minPasswordLength) {
      return AppConstants.weakPasswordMessage;
    }
    
    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    
    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    
    // Check for at least one digit
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    
    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    
    return null;
  }
  
  // Confirm password validation
  static String? validateConfirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return AppConstants.requiredFieldMessage;
    }
    
    if (value != originalPassword) {
      return AppConstants.passwordMismatchMessage;
    }
    
    return null;
  }
  
  // Required field validation
  static String? validateRequired(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null 
          ? '$fieldName is required'
          : AppConstants.requiredFieldMessage;
    }
    return null;
  }
  
  // Workout name validation
  static String? validateWorkoutName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Workout name is required';
    }
    
    if (value.length > AppConfig.maxWorkoutNameLength) {
      return 'Workout name must be ${AppConfig.maxWorkoutNameLength} characters or less';
    }
    
    return null;
  }
  
  // Exercise name validation
  static String? validateExerciseName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Exercise name is required';
    }
    
    if (value.length > AppConfig.maxExerciseNameLength) {
      return 'Exercise name must be ${AppConfig.maxExerciseNameLength} characters or less';
    }
    
    return null;
  }
  
  // Description validation
  static String? validateDescription(String? value) {
    if (value != null && value.length > AppConfig.maxWorkoutDescriptionLength) {
      return 'Description must be ${AppConfig.maxWorkoutDescriptionLength} characters or less';
    }
    return null;
  }
  
  // Number validation
  static String? validateNumber(String? value, {
    required String fieldName,
    int? min,
    int? max,
    bool required = true,
  }) {
    if (value == null || value.trim().isEmpty) {
      return required ? '$fieldName is required' : null;
    }
    
    final number = int.tryParse(value);
    if (number == null) {
      return '$fieldName must be a valid number';
    }
    
    if (min != null && number < min) {
      return '$fieldName must be at least $min';
    }
    
    if (max != null && number > max) {
      return '$fieldName must be at most $max';
    }
    
    return null;
  }
  
  // Sets validation
  static String? validateSets(String? value) {
    return validateNumber(
      value,
      fieldName: 'Sets',
      min: 1,
      max: AppConfig.maxSetsPerExercise,
    );
  }
  
  // Reps validation
  static String? validateReps(String? value) {
    return validateNumber(
      value,
      fieldName: 'Reps',
      min: 1,
      max: AppConfig.maxRepsPerSet,
    );
  }
  
  // Weight validation
  static String? validateWeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Weight is optional
    }
    
    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Weight must be a valid number';
    }
    
    if (weight < 0) {
      return 'Weight cannot be negative';
    }
    
    if (weight > AppConfig.maxWeightKg) {
      return 'Weight must be ${AppConfig.maxWeightKg}kg or less';
    }
    
    return null;
  }
  
  // Duration validation (in minutes)
  static String? validateDuration(String? value) {
    return validateNumber(
      value,
      fieldName: 'Duration',
      min: 1,
      max: AppConfig.maxDurationMinutes,
    );
  }
  
  // Rest time validation (in seconds)
  static String? validateRestTime(String? value) {
    return validateNumber(
      value,
      fieldName: 'Rest time',
      min: 0,
      max: 600, // 10 minutes max rest
      required: false,
    );
  }
  
  // Phone number validation
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }
    
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }
  
  // Age validation
  static String? validateAge(String? value) {
    return validateNumber(
      value,
      fieldName: 'Age',
      min: 13,
      max: 120,
      required: false,
    );
  }
  
  // Height validation (in cm)
  static String? validateHeight(String? value) {
    return validateNumber(
      value,
      fieldName: 'Height',
      min: 100,
      max: 250,
      required: false,
    );
  }
  
  // Weight validation for profile (in kg)
  static String? validateBodyWeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Weight is optional
    }
    
    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Weight must be a valid number';
    }
    
    if (weight < 30 || weight > 300) {
      return 'Please enter a valid weight between 30kg and 300kg';
    }
    
    return null;
  }
}