import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../shared/models/exercise.dart';
import '../../../shared/services/image_storage_service.dart';
import '../../../shared/repositories/interfaces/repository_interfaces.dart';
import 'exercises_providers.dart';

/// Form validation state
@immutable
class FormValidationState {
  final Map<String, String?> errors;
  final bool isValid;

  const FormValidationState({
    this.errors = const {},
    this.isValid = false,
  });

  FormValidationState copyWith({
    Map<String, String?>? errors,
    bool? isValid,
  }) {
    return FormValidationState(
      errors: errors ?? this.errors,
      isValid: isValid ?? this.isValid,
    );
  }

  FormValidationState addError(String field, String error) {
    final newErrors = Map<String, String?>.from(errors);
    newErrors[field] = error;
    return copyWith(errors: newErrors, isValid: false);
  }

  FormValidationState removeError(String field) {
    final newErrors = Map<String, String?>.from(errors);
    newErrors.remove(field);
    return copyWith(errors: newErrors, isValid: newErrors.isEmpty);
  }

  String? getError(String field) => errors[field];
  bool hasError(String field) => errors.containsKey(field);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormValidationState &&
          runtimeType == other.runtimeType &&
          mapEquals(errors, other.errors) &&
          isValid == other.isValid;

  @override
  int get hashCode => Object.hash(errors, isValid);
}

/// Image upload state
@immutable
class ImageUploadState {
  final List<ImageMetadata> images;
  final bool isUploading;
  final String? error;
  final double? uploadProgress;

  const ImageUploadState({
    this.images = const [],
    this.isUploading = false,
    this.error,
    this.uploadProgress,
  });

  ImageUploadState copyWith({
    List<ImageMetadata>? images,
    bool? isUploading,
    String? error,
    double? uploadProgress,
  }) {
    return ImageUploadState(
      images: images ?? this.images,
      isUploading: isUploading ?? this.isUploading,
      error: error ?? this.error,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageUploadState &&
          runtimeType == other.runtimeType &&
          listEquals(images, other.images) &&
          isUploading == other.isUploading &&
          error == other.error &&
          uploadProgress == other.uploadProgress;

  @override
  int get hashCode => Object.hash(images, isUploading, error, uploadProgress);
}

/// Exercise creation form data
@immutable
class ExerciseFormData {
  final String name;
  final String description;
  final String instructions;
  final String difficultyLevel;
  final String exerciseType;
  final List<String> primaryMuscleGroups;
  final List<String> secondaryMuscleGroups;
  final List<String> equipmentRequired;
  final String? movementPattern;
  final int? estimatedDurationMinutes;
  final List<String> tags;
  final bool isPublic;

  const ExerciseFormData({
    this.name = '',
    this.description = '',
    this.instructions = '',
    this.difficultyLevel = 'beginner',
    this.exerciseType = 'strength',
    this.primaryMuscleGroups = const [],
    this.secondaryMuscleGroups = const [],
    this.equipmentRequired = const [],
    this.movementPattern,
    this.estimatedDurationMinutes,
    this.tags = const [],
    this.isPublic = false,
  });

  ExerciseFormData copyWith({
    String? name,
    String? description,
    String? instructions,
    String? difficultyLevel,
    String? exerciseType,
    List<String>? primaryMuscleGroups,
    List<String>? secondaryMuscleGroups,
    List<String>? equipmentRequired,
    String? movementPattern,
    int? estimatedDurationMinutes,
    List<String>? tags,
    bool? isPublic,
  }) {
    return ExerciseFormData(
      name: name ?? this.name,
      description: description ?? this.description,
      instructions: instructions ?? this.instructions,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      exerciseType: exerciseType ?? this.exerciseType,
      primaryMuscleGroups: primaryMuscleGroups ?? this.primaryMuscleGroups,
      secondaryMuscleGroups: secondaryMuscleGroups ?? this.secondaryMuscleGroups,
      equipmentRequired: equipmentRequired ?? this.equipmentRequired,
      movementPattern: movementPattern ?? this.movementPattern,
      estimatedDurationMinutes: estimatedDurationMinutes ?? this.estimatedDurationMinutes,
      tags: tags ?? this.tags,
      isPublic: isPublic ?? this.isPublic,
    );
  }

  bool get isValid {
    return name.trim().isNotEmpty && 
           instructions.trim().isNotEmpty &&
           primaryMuscleGroups.isNotEmpty;
  }

  Exercise toExercise(List<ImageMetadata> images) {
    final now = DateTime.now();
    return Exercise(
      id: const Uuid().v4(),
      name: name.trim(),
      description: description.trim().isEmpty ? null : description.trim(),
      instructions: instructions.trim(),
      difficultyLevel: difficultyLevel,
      exerciseType: exerciseType,
      primaryMuscleGroups: primaryMuscleGroups,
      secondaryMuscleGroups: secondaryMuscleGroups,
      equipmentRequired: equipmentRequired,
      movementPattern: movementPattern?.trim().isEmpty == true ? null : movementPattern?.trim(),
      tags: tags,
      isPublic: isPublic,
      imageUrl: images.isNotEmpty ? images.first.filePath : null,
      demonstrationImages: images.map((img) => img.filePath).toList(),
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseFormData &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          description == other.description &&
          instructions == other.instructions &&
          difficultyLevel == other.difficultyLevel &&
          exerciseType == other.exerciseType &&
          listEquals(primaryMuscleGroups, other.primaryMuscleGroups) &&
          listEquals(secondaryMuscleGroups, other.secondaryMuscleGroups) &&
          listEquals(equipmentRequired, other.equipmentRequired) &&
          movementPattern == other.movementPattern &&
          estimatedDurationMinutes == other.estimatedDurationMinutes &&
          listEquals(tags, other.tags) &&
          isPublic == other.isPublic;

  @override
  int get hashCode => Object.hash(
        name,
        description,
        instructions,
        difficultyLevel,
        exerciseType,
        Object.hashAll(primaryMuscleGroups),
        Object.hashAll(secondaryMuscleGroups),
        Object.hashAll(equipmentRequired),
        movementPattern,
        estimatedDurationMinutes,
        Object.hashAll(tags),
        isPublic,
      );
}

/// Exercise creation state
@immutable
class ExerciseCreationState {
  final ExerciseFormData formData;
  final ImageUploadState imageState;
  final FormValidationState validationState;
  final bool isSubmitting;
  final String? submitError;
  final bool isSubmitted;

  const ExerciseCreationState({
    this.formData = const ExerciseFormData(),
    this.imageState = const ImageUploadState(),
    this.validationState = const FormValidationState(),
    this.isSubmitting = false,
    this.submitError,
    this.isSubmitted = false,
  });

  ExerciseCreationState copyWith({
    ExerciseFormData? formData,
    ImageUploadState? imageState,
    FormValidationState? validationState,
    bool? isSubmitting,
    String? submitError,
    bool? isSubmitted,
  }) {
    return ExerciseCreationState(
      formData: formData ?? this.formData,
      imageState: imageState ?? this.imageState,
      validationState: validationState ?? this.validationState,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: submitError ?? this.submitError,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseCreationState &&
          runtimeType == other.runtimeType &&
          formData == other.formData &&
          imageState == other.imageState &&
          validationState == other.validationState &&
          isSubmitting == other.isSubmitting &&
          submitError == other.submitError &&
          isSubmitted == other.isSubmitted;

  @override
  int get hashCode => Object.hash(
        formData,
        imageState,
        validationState,
        isSubmitting,
        submitError,
        isSubmitted,
      );
}

/// Exercise creation notifier
class ExerciseCreationNotifier extends StateNotifier<ExerciseCreationState> {
  final IExerciseRepository _exerciseRepository;
  final ImageStorageService _imageStorageService;

  ExerciseCreationNotifier(
    this._exerciseRepository,
    this._imageStorageService,
  ) : super(const ExerciseCreationState());

  /// Update form field
  void updateField(String field, dynamic value) {
    final currentData = state.formData;
    ExerciseFormData updatedData;

    switch (field) {
      case 'name':
        updatedData = currentData.copyWith(name: value as String);
        break;
      case 'description':
        updatedData = currentData.copyWith(description: value as String);
        break;
      case 'instructions':
        updatedData = currentData.copyWith(instructions: value as String);
        break;
      case 'difficultyLevel':
        updatedData = currentData.copyWith(difficultyLevel: value as String);
        break;
      case 'exerciseType':
        updatedData = currentData.copyWith(exerciseType: value as String);
        break;
      case 'primaryMuscleGroups':
        updatedData = currentData.copyWith(primaryMuscleGroups: value as List<String>);
        break;
      case 'secondaryMuscleGroups':
        updatedData = currentData.copyWith(secondaryMuscleGroups: value as List<String>);
        break;
      case 'equipmentRequired':
        updatedData = currentData.copyWith(equipmentRequired: value as List<String>);
        break;
      case 'movementPattern':
        updatedData = currentData.copyWith(movementPattern: value as String?);
        break;
      case 'estimatedDurationMinutes':
        updatedData = currentData.copyWith(estimatedDurationMinutes: value as int?);
        break;
      case 'tags':
        updatedData = currentData.copyWith(tags: value as List<String>);
        break;
      case 'isPublic':
        updatedData = currentData.copyWith(isPublic: value as bool);
        break;
      default:
        return;
    }

    state = state.copyWith(
      formData: updatedData,
      validationState: _validateForm(updatedData),
    );
  }

  /// Add image
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

      final updatedImages = List<ImageMetadata>.from(state.imageState.images)
        ..add(metadata);

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

  /// Remove image
  Future<void> removeImage(String imageId) async {
    try {
      await _imageStorageService.deleteImage(imageId);

      final updatedImages = state.imageState.images
          .where((img) => img.id != imageId)
          .toList();

      state = state.copyWith(
        imageState: state.imageState.copyWith(images: updatedImages),
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

  /// Submit exercise
  Future<bool> submitExercise() async {
    if (state.isSubmitting) return false;

    // Validate form
    final validationState = _validateForm(state.formData);
    if (!validationState.isValid) {
      state = state.copyWith(validationState: validationState);
      return false;
    }

    state = state.copyWith(
      isSubmitting: true,
      submitError: null,
    );

    try {
      final exercise = state.formData.toExercise(state.imageState.images);
      await _exerciseRepository.create(exercise);

      state = state.copyWith(
        isSubmitting: false,
        isSubmitted: true,
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

  /// Reset form
  void resetForm() {
    state = const ExerciseCreationState();
  }

  /// Validate form data
  FormValidationState _validateForm(ExerciseFormData data) {
    final errors = <String, String>{};

    // Required fields
    if (data.name.trim().isEmpty) {
      errors['name'] = 'Exercise name is required';
    } else if (data.name.trim().length < 2) {
      errors['name'] = 'Exercise name must be at least 2 characters';
    } else if (data.name.trim().length > 100) {
      errors['name'] = 'Exercise name cannot exceed 100 characters';
    }

    if (data.instructions.trim().isEmpty) {
      errors['instructions'] = 'Instructions are required';
    } else if (data.instructions.trim().length < 10) {
      errors['instructions'] = 'Instructions must be at least 10 characters';
    } else if (data.instructions.trim().length > 2000) {
      errors['instructions'] = 'Instructions cannot exceed 2000 characters';
    }

    if (data.primaryMuscleGroups.isEmpty) {
      errors['primaryMuscleGroups'] = 'At least one primary muscle group is required';
    }

    // Optional field validation
    if (data.description.trim().length > 500) {
      errors['description'] = 'Description cannot exceed 500 characters';
    }

    if (data.estimatedDurationMinutes != null &&
        (data.estimatedDurationMinutes! < 1 || data.estimatedDurationMinutes! > 300)) {
      errors['estimatedDurationMinutes'] = 'Duration must be between 1 and 300 minutes';
    }

    return FormValidationState(
      errors: errors,
      isValid: errors.isEmpty,
    );
  }
}

// PROVIDERS

/// Image storage service provider
final imageStorageServiceProvider = Provider<ImageStorageService>((ref) {
  return const ImageStorageService();
});

/// Exercise creation state provider
final exerciseCreationProvider = StateNotifierProvider<ExerciseCreationNotifier, ExerciseCreationState>((ref) {
  return ExerciseCreationNotifier(
    ref.watch(simpleExerciseRepositoryProvider),
    ref.watch(imageStorageServiceProvider),
  );
});

/// Muscle groups options provider
final muscleGroupOptionsProvider = Provider<List<String>>((ref) {
  return [
    'Chest',
    'Back',
    'Shoulders',
    'Arms',
    'Biceps',
    'Triceps',
    'Forearms',
    'Abs',
    'Core',
    'Obliques',
    'Quadriceps',
    'Hamstrings',
    'Glutes',
    'Calves',
    'Traps',
    'Lats',
    'Upper Back',
    'Lower Back',
    'Hip Flexors',
    'Adductors',
    'Abductors',
  ]..sort();
});

/// Exercise type options provider
final exerciseTypeOptionsProvider = Provider<List<String>>((ref) {
  return [
    'strength',
    'cardio',
    'flexibility',
    'balance',
    'plyometric',
    'isometric',
    'compound',
    'isolation',
  ];
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

/// Movement pattern options provider
final movementPatternOptionsProvider = Provider<List<String>>((ref) {
  return [
    'Push',
    'Pull',
    'Squat',
    'Hinge',
    'Lunge',
    'Carry',
    'Rotation',
    'Anti-Extension',
    'Anti-Flexion',
    'Anti-Rotation',
    'Gait',
  ]..sort();
});

/// Form validation provider (computed)
final exerciseFormValidationProvider = Provider<FormValidationState>((ref) {
  final state = ref.watch(exerciseCreationProvider);
  return state.validationState;
});

/// Can submit provider (computed)
final canSubmitExerciseProvider = Provider<bool>((ref) {
  final state = ref.watch(exerciseCreationProvider);
  return state.validationState.isValid && 
         !state.isSubmitting && 
         !state.isSubmitted;
});