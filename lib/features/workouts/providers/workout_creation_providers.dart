import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../shared/models/workout.dart';
import '../../../shared/models/exercise.dart';
import '../../../shared/services/image_storage_service.dart';
import '../../../shared/repositories/interfaces/repository_interfaces.dart';
import 'workouts_providers.dart';

/// Form validation state for workout creation
@immutable
class WorkoutFormValidationState {
  final Map<String, String?> errors;
  final bool isValid;

  const WorkoutFormValidationState({
    this.errors = const {},
    this.isValid = false,
  });

  WorkoutFormValidationState copyWith({
    Map<String, String?>? errors,
    bool? isValid,
  }) {
    return WorkoutFormValidationState(
      errors: errors ?? this.errors,
      isValid: isValid ?? this.isValid,
    );
  }

  WorkoutFormValidationState addError(String field, String error) {
    final newErrors = Map<String, String?>.from(errors);
    newErrors[field] = error;
    return copyWith(errors: newErrors, isValid: false);
  }

  WorkoutFormValidationState removeError(String field) {
    final newErrors = Map<String, String?>.from(errors);
    newErrors.remove(field);
    return copyWith(errors: newErrors, isValid: newErrors.isEmpty);
  }

  String? getError(String field) => errors[field];
  bool hasError(String field) => errors.containsKey(field);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutFormValidationState &&
          runtimeType == other.runtimeType &&
          mapEquals(errors, other.errors) &&
          isValid == other.isValid;

  @override
  int get hashCode => Object.hash(errors, isValid);
}

/// Image upload state for workout cover
@immutable
class WorkoutImageUploadState {
  final List<ImageMetadata> images;
  final bool isUploading;
  final String? error;
  final double? uploadProgress;

  const WorkoutImageUploadState({
    this.images = const [],
    this.isUploading = false,
    this.error,
    this.uploadProgress,
  });

  WorkoutImageUploadState copyWith({
    List<ImageMetadata>? images,
    bool? isUploading,
    String? error,
    double? uploadProgress,
  }) {
    return WorkoutImageUploadState(
      images: images ?? this.images,
      isUploading: isUploading ?? this.isUploading,
      error: error ?? this.error,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutImageUploadState &&
          runtimeType == other.runtimeType &&
          listEquals(images, other.images) &&
          isUploading == other.isUploading &&
          error == other.error &&
          uploadProgress == other.uploadProgress;

  @override
  int get hashCode => Object.hash(images, isUploading, error, uploadProgress);
}

/// Workout exercise configuration when adding to workout
@immutable
class WorkoutExerciseConfig {
  final String exerciseId;
  final Exercise exercise;
  final int sets;
  final int? reps;
  final double? weightKg;
  final int? durationSeconds;
  final int restTimeSeconds;
  final String? notes;
  final String? workoutExerciseId; // For tracking existing workout exercises during edit

  const WorkoutExerciseConfig({
    required this.exerciseId,
    required this.exercise,
    this.sets = 3,
    this.reps,
    this.weightKg,
    this.durationSeconds,
    this.restTimeSeconds = 60,
    this.notes,
    this.workoutExerciseId, // Optional for edit mode
  });

  WorkoutExerciseConfig copyWith({
    String? exerciseId,
    Exercise? exercise,
    int? sets,
    int? reps,
    double? weightKg,
    int? durationSeconds,
    int? restTimeSeconds,
    String? notes,
    String? workoutExerciseId,
  }) {
    return WorkoutExerciseConfig(
      exerciseId: exerciseId ?? this.exerciseId,
      exercise: exercise ?? this.exercise,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      weightKg: weightKg ?? this.weightKg,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      restTimeSeconds: restTimeSeconds ?? this.restTimeSeconds,
      notes: notes ?? this.notes,
      workoutExerciseId: workoutExerciseId ?? this.workoutExerciseId,
    );
  }

  WorkoutExercise toWorkoutExercise(String workoutId, int orderIndex) {
    final now = DateTime.now();
    return WorkoutExercise(
      id: workoutExerciseId ?? const Uuid().v4(), // Use existing ID if available, otherwise create new
      workoutId: workoutId,
      exerciseId: exerciseId,
      orderIndex: orderIndex,
      sets: sets,
      reps: reps,
      weightKg: weightKg,
      durationSeconds: durationSeconds,
      restTimeSeconds: restTimeSeconds,
      notes: notes,
      exercise: exercise,
      createdAt: workoutExerciseId != null ? now : now, // If editing existing, preserve original dates
      updatedAt: now,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutExerciseConfig &&
          runtimeType == other.runtimeType &&
          exerciseId == other.exerciseId &&
          exercise == other.exercise &&
          sets == other.sets &&
          reps == other.reps &&
          weightKg == other.weightKg &&
          durationSeconds == other.durationSeconds &&
          restTimeSeconds == other.restTimeSeconds &&
          notes == other.notes &&
          workoutExerciseId == other.workoutExerciseId;

  @override
  int get hashCode => Object.hash(
        exerciseId,
        exercise,
        sets,
        reps,
        weightKg,
        durationSeconds,
        restTimeSeconds,
        notes,
        workoutExerciseId,
      );
}

/// Workout creation form data
@immutable
class WorkoutFormData {
  final String name;
  final String description;
  final String difficultyLevel;
  final String workoutType;
  final int estimatedDurationMinutes;
  final List<String> targetMuscleGroups;
  final List<String> equipmentNeeded;
  final String spaceRequirement;
  final String intensityLevel;
  final int restBetweenExercises;
  final int restBetweenSets;
  final List<String> tags;
  final String notes;
  final bool isTemplate;
  final bool isPublic;
  final String imageFit; // 'cover', 'contain', 'fill'
  final List<WorkoutExerciseConfig> exercises;

  const WorkoutFormData({
    this.name = '',
    this.description = '',
    this.difficultyLevel = 'beginner',
    this.workoutType = 'strength',
    this.estimatedDurationMinutes = 45,
    this.targetMuscleGroups = const [],
    this.equipmentNeeded = const [],
    this.spaceRequirement = 'small',
    this.intensityLevel = 'moderate',
    this.restBetweenExercises = 60,
    this.restBetweenSets = 60,
    this.tags = const [],
    this.notes = '',
    this.isTemplate = false,
    this.isPublic = false,
    this.imageFit = 'cover',
    this.exercises = const [],
  });

  WorkoutFormData copyWith({
    String? name,
    String? description,
    String? difficultyLevel,
    String? workoutType,
    int? estimatedDurationMinutes,
    List<String>? targetMuscleGroups,
    List<String>? equipmentNeeded,
    String? spaceRequirement,
    String? intensityLevel,
    int? restBetweenExercises,
    int? restBetweenSets,
    List<String>? tags,
    String? notes,
    bool? isTemplate,
    bool? isPublic,
    String? imageFit,
    List<WorkoutExerciseConfig>? exercises,
  }) {
    return WorkoutFormData(
      name: name ?? this.name,
      description: description ?? this.description,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      workoutType: workoutType ?? this.workoutType,
      estimatedDurationMinutes: estimatedDurationMinutes ?? this.estimatedDurationMinutes,
      targetMuscleGroups: targetMuscleGroups ?? this.targetMuscleGroups,
      equipmentNeeded: equipmentNeeded ?? this.equipmentNeeded,
      spaceRequirement: spaceRequirement ?? this.spaceRequirement,
      intensityLevel: intensityLevel ?? this.intensityLevel,
      restBetweenExercises: restBetweenExercises ?? this.restBetweenExercises,
      restBetweenSets: restBetweenSets ?? this.restBetweenSets,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      isTemplate: isTemplate ?? this.isTemplate,
      isPublic: isPublic ?? this.isPublic,
      imageFit: imageFit ?? this.imageFit,
      exercises: exercises ?? this.exercises,
    );
  }

  bool get isValid {
    return name.trim().isNotEmpty;
  }

  Workout toWorkout(List<ImageMetadata> images) {
    final now = DateTime.now();
    final workoutId = const Uuid().v4();
    
    return Workout(
      id: workoutId,
      name: name.trim(),
      description: description.trim().isEmpty ? null : description.trim(),
      difficultyLevel: difficultyLevel,
      estimatedDurationMinutes: estimatedDurationMinutes,
      workoutType: workoutType,
      targetMuscleGroups: targetMuscleGroups,
      equipmentNeeded: equipmentNeeded,
      spaceRequirement: spaceRequirement,
      intensityLevel: intensityLevel,
      restBetweenExercises: restBetweenExercises,
      restBetweenSets: restBetweenSets,
      tags: tags,
      notes: notes.trim().isEmpty ? null : notes.trim(),
      isTemplate: isTemplate,
      isPublic: isPublic,
      imageUrl: images.isNotEmpty ? images.first.id : null,
      imageFit: imageFit,
      createdAt: now,
      updatedAt: now,
      exercises: exercises.asMap().entries.map((entry) {
        final index = entry.key;
        final config = entry.value;
        return config.toWorkoutExercise(workoutId, index);
      }).toList(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutFormData &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          description == other.description &&
          difficultyLevel == other.difficultyLevel &&
          workoutType == other.workoutType &&
          estimatedDurationMinutes == other.estimatedDurationMinutes &&
          listEquals(targetMuscleGroups, other.targetMuscleGroups) &&
          listEquals(equipmentNeeded, other.equipmentNeeded) &&
          spaceRequirement == other.spaceRequirement &&
          intensityLevel == other.intensityLevel &&
          restBetweenExercises == other.restBetweenExercises &&
          restBetweenSets == other.restBetweenSets &&
          listEquals(tags, other.tags) &&
          notes == other.notes &&
          isTemplate == other.isTemplate &&
          isPublic == other.isPublic &&
          imageFit == other.imageFit &&
          listEquals(exercises, other.exercises);

  @override
  int get hashCode => Object.hash(
        name,
        description,
        difficultyLevel,
        workoutType,
        estimatedDurationMinutes,
        Object.hashAll(targetMuscleGroups),
        Object.hashAll(equipmentNeeded),
        spaceRequirement,
        intensityLevel,
        restBetweenExercises,
        restBetweenSets,
        Object.hashAll(tags),
        notes,
        isTemplate,
        isPublic,
        imageFit,
        Object.hashAll(exercises),
      );
}

/// Workout creation state
@immutable
class WorkoutCreationState {
  final WorkoutFormData formData;
  final WorkoutImageUploadState imageState;
  final WorkoutFormValidationState validationState;
  final bool isSubmitting;
  final String? submitError;
  final bool isSubmitted;
  final bool validationAttempted;

  const WorkoutCreationState({
    this.formData = const WorkoutFormData(),
    this.imageState = const WorkoutImageUploadState(),
    this.validationState = const WorkoutFormValidationState(),
    this.isSubmitting = false,
    this.submitError,
    this.isSubmitted = false,
    this.validationAttempted = false,
  });

  WorkoutCreationState copyWith({
    WorkoutFormData? formData,
    WorkoutImageUploadState? imageState,
    WorkoutFormValidationState? validationState,
    bool? isSubmitting,
    String? submitError,
    bool? isSubmitted,
    bool? validationAttempted,
  }) {
    return WorkoutCreationState(
      formData: formData ?? this.formData,
      imageState: imageState ?? this.imageState,
      validationState: validationState ?? this.validationState,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: submitError ?? this.submitError,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      validationAttempted: validationAttempted ?? this.validationAttempted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutCreationState &&
          runtimeType == other.runtimeType &&
          formData == other.formData &&
          imageState == other.imageState &&
          validationState == other.validationState &&
          isSubmitting == other.isSubmitting &&
          submitError == other.submitError &&
          isSubmitted == other.isSubmitted &&
          validationAttempted == other.validationAttempted;

  @override
  int get hashCode => Object.hash(
        formData,
        imageState,
        validationState,
        isSubmitting,
        submitError,
        isSubmitted,
        validationAttempted,
      );
}

/// Workout creation notifier
class WorkoutCreationNotifier extends StateNotifier<WorkoutCreationState> {
  final IWorkoutRepository _workoutRepository;
  final ImageStorageService _imageStorageService;
  final Ref _ref;
  // String? _editingWorkoutId; // TODO: Implement editing mode tracking

  WorkoutCreationNotifier(
    this._workoutRepository,
    this._imageStorageService,
    this._ref,
  ) : super(const WorkoutCreationState());

  /// Update form field
  void updateField(String field, dynamic value) {
    final currentData = state.formData;
    WorkoutFormData updatedData;

    switch (field) {
      case 'name':
        updatedData = currentData.copyWith(name: value as String);
        break;
      case 'description':
        updatedData = currentData.copyWith(description: value as String);
        break;
      case 'difficultyLevel':
        updatedData = currentData.copyWith(difficultyLevel: value as String);
        break;
      case 'workoutType':
        updatedData = currentData.copyWith(workoutType: value as String);
        break;
      case 'estimatedDurationMinutes':
        updatedData = currentData.copyWith(estimatedDurationMinutes: value as int);
        break;
      case 'targetMuscleGroups':
        updatedData = currentData.copyWith(targetMuscleGroups: value as List<String>);
        break;
      case 'equipmentNeeded':
        updatedData = currentData.copyWith(equipmentNeeded: value as List<String>);
        break;
      case 'spaceRequirement':
        updatedData = currentData.copyWith(spaceRequirement: value as String);
        break;
      case 'intensityLevel':
        updatedData = currentData.copyWith(intensityLevel: value as String);
        break;
      case 'restBetweenExercises':
        updatedData = currentData.copyWith(restBetweenExercises: value as int);
        break;
      case 'restBetweenSets':
        updatedData = currentData.copyWith(restBetweenSets: value as int);
        break;
      case 'tags':
        updatedData = currentData.copyWith(tags: value as List<String>);
        break;
      case 'notes':
        updatedData = currentData.copyWith(notes: value as String);
        break;
      case 'isTemplate':
        updatedData = currentData.copyWith(isTemplate: value as bool);
        break;
      case 'isPublic':
        updatedData = currentData.copyWith(isPublic: value as bool);
        break;
      case 'imageFit':
        updatedData = currentData.copyWith(imageFit: value as String);
        break;
      default:
        return;
    }

    state = state.copyWith(
      formData: updatedData,
      validationState: _validateForm(updatedData),
    );
  }

  /// Add exercise to workout with configuration
  void addExercise(Exercise exercise, {
    int sets = 3,
    int? reps,
    double? weightKg,
    int? durationSeconds,
    int restTimeSeconds = 60,
    String? notes,
  }) {
    final config = WorkoutExerciseConfig(
      exerciseId: exercise.id,
      exercise: exercise,
      sets: sets,
      reps: reps,
      weightKg: weightKg,
      durationSeconds: durationSeconds,
      restTimeSeconds: restTimeSeconds,
      notes: notes,
    );

    final updatedExercises = List<WorkoutExerciseConfig>.from(state.formData.exercises)
      ..add(config);

    final updatedData = state.formData.copyWith(exercises: updatedExercises);
    
    state = state.copyWith(
      formData: updatedData,
      validationState: _validateForm(updatedData),
    );
  }

  /// Update exercise configuration in workout
  void updateExerciseConfig(int index, WorkoutExerciseConfig updatedConfig) {
    if (index < 0 || index >= state.formData.exercises.length) return;

    final updatedExercises = List<WorkoutExerciseConfig>.from(state.formData.exercises);
    updatedExercises[index] = updatedConfig;

    final updatedData = state.formData.copyWith(exercises: updatedExercises);
    
    state = state.copyWith(
      formData: updatedData,
      validationState: _validateForm(updatedData),
    );
  }

  /// Remove exercise from workout
  void removeExercise(int index) {
    if (index < 0 || index >= state.formData.exercises.length) return;

    final updatedExercises = List<WorkoutExerciseConfig>.from(state.formData.exercises)
      ..removeAt(index);

    final updatedData = state.formData.copyWith(exercises: updatedExercises);
    
    state = state.copyWith(
      formData: updatedData,
      validationState: _validateForm(updatedData),
    );
  }

  /// Reorder exercises in workout
  void reorderExercises(int oldIndex, int newIndex) {
    final updatedExercises = List<WorkoutExerciseConfig>.from(state.formData.exercises);
    
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    
    final item = updatedExercises.removeAt(oldIndex);
    updatedExercises.insert(newIndex, item);

    final updatedData = state.formData.copyWith(exercises: updatedExercises);
    
    state = state.copyWith(formData: updatedData);
  }

  /// Add image cover
  Future<void> addImage(Uint8List imageData, String originalFileName) async {
    if (state.imageState.isUploading) return;

    state = state.copyWith(
      imageState: state.imageState.copyWith(
        isUploading: true,
        error: null,
        uploadProgress: 0.0,
      ),
    );

    try {
      final metadata = await _imageStorageService.storeImage(
        imageData,
        originalFileName,
      );

      // Only allow one cover image for workouts
      final updatedImages = [metadata];

      state = state.copyWith(
        imageState: state.imageState.copyWith(
          images: updatedImages,
          isUploading: false,
          uploadProgress: 1.0,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        imageState: state.imageState.copyWith(
          isUploading: false,
          error: e.toString(),
          uploadProgress: null,
        ),
      );
    }
  }

  /// Remove image cover
  Future<void> removeImage() async {
    if (state.imageState.images.isEmpty) return;

    try {
      await _imageStorageService.deleteImage(state.imageState.images.first.id);

      state = state.copyWith(
        imageState: state.imageState.copyWith(images: []),
      );
    } catch (e) {
      state = state.copyWith(
        imageState: state.imageState.copyWith(error: e.toString()),
      );
    }
  }


  /// Clear image error
  void clearImageError() {
    state = state.copyWith(
      imageState: state.imageState.copyWith(error: null),
    );
  }

  /// Submit workout
  Future<bool> submitWorkout() async {
    if (state.isSubmitting) return false;

    // Validate form
    final validationState = _validateForm(state.formData);
    if (!validationState.isValid) {
      state = state.copyWith(
        validationState: validationState,
        validationAttempted: true,
      );
      return false;
    }

    state = state.copyWith(
      isSubmitting: true,
      submitError: null,
    );

    try {
      final workout = state.formData.toWorkout(state.imageState.images);
      
      await _workoutRepository.create(workout);

      // Trigger targeted refresh of workout providers
      refreshWorkoutProviders(_ref, workout);

      // Reset form after successful submission
      resetForm();

      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        submitError: e.toString(),
      );
      return false;
    }
  }

  /// Validate form without submitting
  Future<bool> validateForm() async {
    final validationState = _validateForm(state.formData);
    state = state.copyWith(
      validationState: validationState,
      validationAttempted: true,
    );
    return validationState.isValid;
  }

  /// Reset validation state
  void resetValidation() {
    state = state.copyWith(
      validationState: const WorkoutFormValidationState(),
      validationAttempted: false,
    );
  }


  /// Reset form
  void resetForm() {
    state = const WorkoutCreationState();
    // _editingWorkoutId = null;
  }

  /// Validate form data
  WorkoutFormValidationState _validateForm(WorkoutFormData data) {
    final errors = <String, String>{};

    // Required fields
    if (data.name.trim().isEmpty) {
      errors['name'] = 'Workout name is required';
    } else if (data.name.trim().length < 2) {
      errors['name'] = 'Workout name must be at least 2 characters';
    } else if (data.name.trim().length > 100) {
      errors['name'] = 'Workout name cannot exceed 100 characters';
    }

    // Exercises are now optional - users can create empty workouts and add exercises later

    // Optional field validation
    if (data.description.trim().length > 500) {
      errors['description'] = 'Description cannot exceed 500 characters';
    }

    if (data.estimatedDurationMinutes <= 0) {
      errors['estimatedDurationMinutes'] = 'Duration must be greater than 0';
    }

    return WorkoutFormValidationState(
      errors: errors,
      isValid: errors.isEmpty,
    );
  }
}

// PROVIDERS

/// Image storage service provider (reused from exercises)
final imageStorageServiceProvider = Provider<ImageStorageService>((ref) {
  return const ImageStorageService();
});

/// Workout creation state provider
final workoutCreationProvider = StateNotifierProvider<WorkoutCreationNotifier, WorkoutCreationState>((ref) {
  return WorkoutCreationNotifier(
    ref.watch(workoutRepositoryProvider),
    ref.watch(imageStorageServiceProvider),
    ref,
  );
});

/// Difficulty level options provider
final difficultyLevelOptionsProvider = Provider<List<String>>((ref) {
  return [
    'beginner',
    'intermediate',
    'advanced',
    'expert',
  ];
});

/// Workout type options provider
final workoutTypeOptionsProvider = Provider<List<String>>((ref) {
  return [
    'strength',
    'cardio',
    'hiit',
    'flexibility',
    'balance',
    'endurance',
    'powerlifting',
    'bodybuilding',
    'crossfit',
    'yoga',
    'pilates',
  ];
});

/// Space requirement options provider
final spaceRequirementOptionsProvider = Provider<List<String>>((ref) {
  return [
    'minimal',
    'small',
    'medium',
    'large',
  ];
});

/// Intensity level options provider
final intensityLevelOptionsProvider = Provider<List<String>>((ref) {
  return [
    'low',
    'moderate',
    'high',
    'extreme',
  ];
});

/// Form validation provider (computed)
final workoutFormValidationProvider = Provider<WorkoutFormValidationState>((ref) {
  final state = ref.watch(workoutCreationProvider);
  return state.validationState;
});

/// Can submit provider (computed)
final canSubmitWorkoutProvider = Provider<bool>((ref) {
  final state = ref.watch(workoutCreationProvider);
  
  // Basic checks
  if (state.isSubmitting || state.isSubmitted) {
    return false;
  }
  
  // If validation was attempted and failed, return false
  if (state.validationAttempted && !state.validationState.isValid) {
    return false;
  }
  
  // If validation was not attempted yet, do basic content checks
  if (!state.validationAttempted) {
    return state.formData.name.trim().isNotEmpty;
  }
  
  // If validation was attempted and passed, return true
  return state.validationState.isValid;
});