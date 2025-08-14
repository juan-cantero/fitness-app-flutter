import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/workout.dart';
import '../../../shared/models/exercise.dart';
import '../../../shared/services/image_storage_service.dart';
import '../../../shared/repositories/interfaces/repository_interfaces.dart';
import 'workout_creation_providers.dart'; // Reuse data classes
import 'workouts_providers.dart';

/// Workout edit state extending the creation state with loading capabilities
@immutable
class WorkoutEditState {
  final WorkoutFormData formData;
  final WorkoutImageUploadState imageState;
  final WorkoutFormValidationState validationState;
  final bool isLoading;
  final bool isSubmitting;
  final String? loadError;
  final String? submitError;
  final bool isSubmitted;
  final bool validationAttempted;
  final String? workoutId; // Track which workout we're editing

  const WorkoutEditState({
    this.formData = const WorkoutFormData(),
    this.imageState = const WorkoutImageUploadState(),
    this.validationState = const WorkoutFormValidationState(),
    this.isLoading = false,
    this.isSubmitting = false,
    this.loadError,
    this.submitError,
    this.isSubmitted = false,
    this.validationAttempted = false,
    this.workoutId,
  });

  WorkoutEditState copyWith({
    WorkoutFormData? formData,
    WorkoutImageUploadState? imageState,
    WorkoutFormValidationState? validationState,
    bool? isLoading,
    bool? isSubmitting,
    String? loadError,
    String? submitError,
    bool? isSubmitted,
    bool? validationAttempted,
    String? workoutId,
  }) {
    return WorkoutEditState(
      formData: formData ?? this.formData,
      imageState: imageState ?? this.imageState,
      validationState: validationState ?? this.validationState,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      loadError: loadError ?? this.loadError,
      submitError: submitError ?? this.submitError,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      validationAttempted: validationAttempted ?? this.validationAttempted,
      workoutId: workoutId ?? this.workoutId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutEditState &&
          runtimeType == other.runtimeType &&
          formData == other.formData &&
          imageState == other.imageState &&
          validationState == other.validationState &&
          isLoading == other.isLoading &&
          isSubmitting == other.isSubmitting &&
          loadError == other.loadError &&
          submitError == other.submitError &&
          isSubmitted == other.isSubmitted &&
          validationAttempted == other.validationAttempted &&
          workoutId == other.workoutId;

  @override
  int get hashCode => Object.hash(
        formData,
        imageState,
        validationState,
        isLoading,
        isSubmitting,
        loadError,
        submitError,
        isSubmitted,
        validationAttempted,
        workoutId,
      );
}

/// Workout edit notifier
class WorkoutEditNotifier extends StateNotifier<WorkoutEditState> {
  final IWorkoutRepository _workoutRepository;
  final ImageStorageService _imageStorageService;
  final Ref _ref;

  WorkoutEditNotifier(
    this._workoutRepository,
    this._imageStorageService,
    this._ref,
  ) : super(const WorkoutEditState());

  /// Load existing workout for editing
  Future<void> loadWorkout(String workoutId) async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      loadError: null,
      workoutId: workoutId,
    );

    try {
      final workout = await _workoutRepository.getById(workoutId);
      
      if (workout == null) {
        state = state.copyWith(
          isLoading: false,
          loadError: 'Workout not found',
        );
        return;
      }

      // Convert workout to form data
      final formData = WorkoutFormData(
        name: workout.name,
        description: workout.description ?? '',
        difficultyLevel: workout.difficultyLevel,
        workoutType: workout.workoutType,
        estimatedDurationMinutes: workout.estimatedDurationMinutes ?? 45,
        targetMuscleGroups: workout.targetMuscleGroups,
        equipmentNeeded: workout.equipmentNeeded,
        spaceRequirement: workout.spaceRequirement,
        intensityLevel: workout.intensityLevel,
        restBetweenExercises: workout.restBetweenExercises,
        restBetweenSets: workout.restBetweenSets,
        tags: workout.tags,
        notes: workout.notes ?? '',
        isTemplate: workout.isTemplate,
        isPublic: workout.isPublic,
        imageFit: workout.imageFit,
        exercises: await _convertWorkoutExercisesToConfig(workout.exercises),
      );

      // Load existing image if present
      WorkoutImageUploadState imageState = const WorkoutImageUploadState();
      if (workout.imageUrl != null) {
        try {
          final imageMetadata = await _imageStorageService.getImageMetadata(workout.imageUrl!);
          if (imageMetadata != null) {
            imageState = WorkoutImageUploadState(images: [imageMetadata]);
          }
        } catch (e) {
          debugPrint('Failed to load existing image: $e');
          // Continue without image - user can add a new one
        }
      }

      state = state.copyWith(
        isLoading: false,
        formData: formData,
        imageState: imageState,
        validationState: _validateForm(formData),
      );

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        loadError: e.toString(),
      );
    }
  }

  /// Convert WorkoutExercise objects to WorkoutExerciseConfig objects
  Future<List<WorkoutExerciseConfig>> _convertWorkoutExercisesToConfig(
    List<WorkoutExercise> workoutExercises,
  ) async {
    final configs = <WorkoutExerciseConfig>[];
    
    for (final workoutExercise in workoutExercises) {
      if (workoutExercise.exercise != null) {
        configs.add(WorkoutExerciseConfig(
          exerciseId: workoutExercise.exerciseId,
          exercise: workoutExercise.exercise!,
          sets: workoutExercise.sets,
          reps: workoutExercise.reps,
          weightKg: workoutExercise.weightKg,
          durationSeconds: workoutExercise.durationSeconds,
          restTimeSeconds: workoutExercise.restTimeSeconds,
          notes: workoutExercise.notes,
          workoutExerciseId: workoutExercise.id, // Preserve existing ID for edit mode
        ));
      }
    }
    
    return configs;
  }

  /// Update form field (same logic as creation)
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

  /// Add exercise to workout with configuration (same as creation)
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

  /// Update exercise configuration in workout (same as creation)
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

  /// Remove exercise from workout (same as creation)
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

  /// Reorder exercises in workout (same as creation)
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

  /// Add image cover (same as creation)
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

  /// Remove image cover (same as creation)
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

  /// Clear image error (same as creation)
  void clearImageError() {
    state = state.copyWith(
      imageState: state.imageState.copyWith(error: null),
    );
  }

  /// Update existing workout
  Future<bool> updateWorkout() async {
    if (state.isSubmitting || state.workoutId == null) return false;

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
      // Create updated workout with preserved creation date
      final originalWorkout = await _workoutRepository.getById(state.workoutId!);
      if (originalWorkout == null) {
        throw Exception('Original workout not found');
      }

      final updatedWorkout = state.formData.toWorkout(state.imageState.images);
      final workoutWithPreservedDates = updatedWorkout.copyWith(
        id: state.workoutId!, // Keep original ID
        createdAt: originalWorkout.createdAt, // Preserve creation date
        updatedAt: DateTime.now(), // Update modified date
      );
      
      await _workoutRepository.update(workoutWithPreservedDates);

      // Trigger targeted refresh of workout providers
      refreshWorkoutProviders(_ref, workoutWithPreservedDates);

      state = state.copyWith(
        isSubmitting: false,
        isSubmitted: true,
        submitError: null, // Clear any previous errors
      );

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
    state = const WorkoutEditState();
  }

  /// Clear submit state to allow further edits after successful save
  void clearSubmitState() {
    state = state.copyWith(
      isSubmitted: false,
      submitError: null,
    );
  }

  /// Validate form data (same as creation but allows empty exercises)
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

    // Exercises are optional - users can edit workouts without exercises

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

/// Workout edit state provider
final workoutEditProvider = StateNotifierProvider<WorkoutEditNotifier, WorkoutEditState>((ref) {
  return WorkoutEditNotifier(
    ref.watch(workoutRepositoryProvider),
    ref.watch(imageStorageServiceProvider),
    ref,
  );
});

/// Can submit provider for edit (computed)
final canUpdateWorkoutProvider = Provider<bool>((ref) {
  final state = ref.watch(workoutEditProvider);
  
  // Basic checks
  if (state.isSubmitting || state.isSubmitted || state.isLoading) {
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