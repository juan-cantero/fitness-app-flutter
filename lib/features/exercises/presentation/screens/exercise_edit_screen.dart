import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/exercises_providers.dart';
import '../../providers/exercise_creation_providers.dart';
import '../../../../shared/models/models.dart';
import '../widgets/exercise_image_picker.dart';

class ExerciseEditScreen extends ConsumerStatefulWidget {
  final String exerciseId;
  
  const ExerciseEditScreen({
    super.key,
    required this.exerciseId,
  });

  @override
  ConsumerState<ExerciseEditScreen> createState() => _ExerciseEditScreenState();
}

class _ExerciseEditScreenState extends ConsumerState<ExerciseEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _movementPatternController = TextEditingController();
  final _durationController = TextEditingController();
  
  bool _isInitialized = false;

  // Removed listener approach - using direct navigation instead for reliability

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _instructionsController.dispose();
    _movementPatternController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _initializeForm(Exercise exercise) {
    if (_isInitialized) return;
    
    _nameController.text = exercise.name;
    _descriptionController.text = exercise.description ?? '';
    _instructionsController.text = exercise.instructions ?? '';
    _movementPatternController.text = exercise.movementPattern ?? '';
    _durationController.text = '';
    
    // Initialize form data with existing exercise data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(exerciseCreationProvider.notifier);
      notifier.resetForm(); // Clear any existing data
      
      // Set form data
      notifier.updateField('name', exercise.name);
      notifier.updateField('description', exercise.description ?? '');
      notifier.updateField('instructions', exercise.instructions ?? '');
      notifier.updateField('difficultyLevel', exercise.difficultyLevel);
      notifier.updateField('exerciseType', exercise.exerciseType);
      notifier.updateField('primaryMuscleGroups', exercise.primaryMuscleGroups);
      notifier.updateField('secondaryMuscleGroups', exercise.secondaryMuscleGroups);
      notifier.updateField('equipmentRequired', exercise.equipmentRequired);
      notifier.updateField('movementPattern', exercise.movementPattern);
      notifier.updateField('tags', exercise.tags);
      notifier.updateField('isPublic', exercise.isPublic);
      
      // TODO: Load existing images into the image state
      _loadExistingImages(exercise);
    });
    
    _isInitialized = true;
  }

  Future<void> _loadExistingImages(Exercise exercise) async {
    // Initialize the notifier for editing this exercise
    await ref.read(exerciseCreationProvider.notifier).initializeForEditing(widget.exerciseId);
  }

  @override
  Widget build(BuildContext context) {
    final exerciseAsync = ref.watch(exerciseByIdProvider(widget.exerciseId));
    final creationState = ref.watch(exerciseCreationProvider);
    final canSubmit = ref.watch(canSubmitExerciseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Exercise'),
        actions: [
          TextButton(
            onPressed: canSubmit ? _saveChanges : null,
            child: creationState.isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: exerciseAsync.when(
        data: (exercise) {
          if (exercise == null) {
            return const Center(
              child: Text('Exercise not found'),
            );
          }
          
          _initializeForm(exercise);
          
          return _buildEditForm(context, exercise);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error loading exercise: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditForm(BuildContext context, Exercise exercise) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Information Section
            _buildSectionHeader('Basic Information'),
            const SizedBox(height: 16),
            
            _buildNameField(),
            const SizedBox(height: 16),
            
            _buildDescriptionField(),
            const SizedBox(height: 16),
            
            _buildInstructionsField(),
            const SizedBox(height: 24),
            
            // Exercise Details Section
            _buildSectionHeader('Exercise Details'),
            const SizedBox(height: 16),
            
            _buildDifficultyLevelDropdown(),
            const SizedBox(height: 16),
            
            _buildExerciseTypeDropdown(),
            const SizedBox(height: 16),
            
            _buildMovementPatternField(),
            const SizedBox(height: 16),
            
            _buildDurationField(),
            const SizedBox(height: 24),
            
            // Muscle Groups Section
            _buildSectionHeader('Muscle Groups'),
            const SizedBox(height: 16),
            
            _buildPrimaryMuscleGroupsField(),
            const SizedBox(height: 16),
            
            _buildSecondaryMuscleGroupsField(),
            const SizedBox(height: 16),
            
            _buildEquipmentField(),
            const SizedBox(height: 24),
            
            // Images Section
            _buildSectionHeader('Exercise Images'),
            const SizedBox(height: 16),
            
            _buildImagesSection(),
            const SizedBox(height: 24),
            
            // Tags and Settings Section
            _buildSectionHeader('Additional Settings'),
            const SizedBox(height: 16),
            
            _buildTagsField(),
            const SizedBox(height: 16),
            
            _buildPublicToggle(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Exercise Name *',
        hintText: 'Enter exercise name',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Exercise name is required';
        }
        if (value.trim().length < 2) {
          return 'Exercise name must be at least 2 characters';
        }
        return null;
      },
      onChanged: (value) {
        ref.read(exerciseCreationProvider.notifier).updateField('name', value);
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description',
        hintText: 'Brief description of the exercise',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
      onChanged: (value) {
        ref.read(exerciseCreationProvider.notifier).updateField('description', value);
      },
    );
  }

  Widget _buildInstructionsField() {
    return TextFormField(
      controller: _instructionsController,
      decoration: const InputDecoration(
        labelText: 'Instructions *',
        hintText: 'Step-by-step instructions for performing this exercise',
        border: OutlineInputBorder(),
      ),
      maxLines: 5,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Instructions are required';
        }
        if (value.trim().length < 10) {
          return 'Instructions must be at least 10 characters';
        }
        return null;
      },
      onChanged: (value) {
        ref.read(exerciseCreationProvider.notifier).updateField('instructions', value);
      },
    );
  }

  Widget _buildDifficultyLevelDropdown() {
    final difficultyOptions = ref.watch(difficultyLevelOptionsProvider);
    final currentLevel = ref.watch(exerciseCreationProvider.select((state) => state.formData.difficultyLevel));
    
    return DropdownButtonFormField<String>(
      value: currentLevel,
      decoration: const InputDecoration(
        labelText: 'Difficulty Level',
        border: OutlineInputBorder(),
      ),
      items: difficultyOptions.map((level) {
        return DropdownMenuItem(
          value: level,
          child: Text(level.toUpperCase()),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          ref.read(exerciseCreationProvider.notifier).updateField('difficultyLevel', value);
        }
      },
    );
  }

  Widget _buildExerciseTypeDropdown() {
    final typeOptions = ref.watch(exerciseTypeOptionsProvider);
    final currentType = ref.watch(exerciseCreationProvider.select((state) => state.formData.exerciseType));
    
    return DropdownButtonFormField<String>(
      value: currentType,
      decoration: const InputDecoration(
        labelText: 'Exercise Type',
        border: OutlineInputBorder(),
      ),
      items: typeOptions.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type.toUpperCase()),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          ref.read(exerciseCreationProvider.notifier).updateField('exerciseType', value);
        }
      },
    );
  }

  Widget _buildMovementPatternField() {
    return TextFormField(
      controller: _movementPatternController,
      decoration: const InputDecoration(
        labelText: 'Movement Pattern',
        hintText: 'e.g., Push, Pull, Squat, Hinge',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        ref.read(exerciseCreationProvider.notifier).updateField('movementPattern', value);
      },
    );
  }

  Widget _buildDurationField() {
    return TextFormField(
      controller: _durationController,
      decoration: const InputDecoration(
        labelText: 'Estimated Duration (minutes)',
        hintText: 'How long does this exercise take?',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        final duration = int.tryParse(value);
        ref.read(exerciseCreationProvider.notifier).updateField('estimatedDurationMinutes', duration);
      },
    );
  }

  Widget _buildPrimaryMuscleGroupsField() {
    final creationState = ref.watch(exerciseCreationProvider);
    final options = ref.watch(muscleGroupOptionsProvider);
    final validation = ref.watch(exerciseFormValidationProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.fitness_center_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Primary Muscle Groups *',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        if (validation.hasError('primaryMuscleGroups')) ...[
          const SizedBox(height: 4),
          Text(
            validation.getError('primaryMuscleGroups')!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: options.map((muscle) {
            final isSelected = creationState.formData.primaryMuscleGroups.contains(muscle);
            return FilterChip(
              label: Text(muscle),
              selected: isSelected,
              onSelected: (selected) {
                final current = List<String>.from(creationState.formData.primaryMuscleGroups);
                if (selected) {
                  current.add(muscle);
                } else {
                  current.remove(muscle);
                }
                ref.read(exerciseCreationProvider.notifier).updateField('primaryMuscleGroups', current);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSecondaryMuscleGroupsField() {
    final creationState = ref.watch(exerciseCreationProvider);
    final options = ref.watch(muscleGroupOptionsProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.fitness_center,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Secondary Muscle Groups',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: options
              .where((muscle) => !creationState.formData.primaryMuscleGroups.contains(muscle))
              .map((muscle) {
            final isSelected = creationState.formData.secondaryMuscleGroups.contains(muscle);
            return FilterChip(
              label: Text(muscle),
              selected: isSelected,
              onSelected: (selected) {
                final current = List<String>.from(creationState.formData.secondaryMuscleGroups);
                if (selected) {
                  current.add(muscle);
                } else {
                  current.remove(muscle);
                }
                ref.read(exerciseCreationProvider.notifier).updateField('secondaryMuscleGroups', current);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEquipmentField() {
    final creationState = ref.watch(exerciseCreationProvider);
    final equipmentAsync = ref.watch(exerciseEquipmentProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.sports_gymnastics_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Equipment Required',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        equipmentAsync.when(
          data: (equipment) => Wrap(
            spacing: 8,
            runSpacing: 4,
            children: equipment.map((eq) {
              final isSelected = creationState.formData.equipmentRequired.contains(eq.name);
              return FilterChip(
                label: Text(eq.name),
                selected: isSelected,
                onSelected: (selected) {
                  final current = List<String>.from(creationState.formData.equipmentRequired);
                  if (selected) {
                    current.add(eq.name);
                  } else {
                    current.remove(eq.name);
                  }
                  ref.read(exerciseCreationProvider.notifier).updateField('equipmentRequired', current);
                },
              );
            }).toList(),
          ),
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Error loading equipment: $error'),
        ),
      ],
    );
  }

  Widget _buildImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Exercise Images',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Add or remove exercise demonstration images',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 16),
        const ExerciseImagePicker(),
      ],
    );
  }

  Widget _buildTagsField() {
    final creationState = ref.watch(exerciseCreationProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.tag,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Tags',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Enter tags separated by commas (e.g., strength, arms, beginner)',
            border: OutlineInputBorder(),
          ),
          initialValue: creationState.formData.tags.join(', '),
          onChanged: (value) {
            final tags = value.split(',')
                .map((tag) => tag.trim())
                .where((tag) => tag.isNotEmpty)
                .toList();
            ref.read(exerciseCreationProvider.notifier).updateField('tags', tags);
          },
        ),
        const SizedBox(height: 8),
        if (creationState.formData.tags.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: creationState.formData.tags.map((tag) {
              return Chip(
                label: Text(tag),
                onDeleted: () {
                  final current = List<String>.from(creationState.formData.tags);
                  current.remove(tag);
                  ref.read(exerciseCreationProvider.notifier).updateField('tags', current);
                },
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildPublicToggle() {
    final isPublic = ref.watch(exerciseCreationProvider.select((state) => state.formData.isPublic));
    
    return SwitchListTile(
      title: const Text('Make Exercise Public'),
      subtitle: const Text('Allow other users to discover and use this exercise'),
      value: isPublic,
      onChanged: (value) {
        ref.read(exerciseCreationProvider.notifier).updateField('isPublic', value);
      },
    );
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await ref.read(exerciseCreationProvider.notifier).updateExercise();
    
    if (!mounted) return;
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Exercise updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop(); // Navigate back to detail screen
    } else {
      final error = ref.read(exerciseCreationProvider).submitError ?? 'Unknown error';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update exercise: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}