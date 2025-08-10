import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/exercise_creation_providers.dart';
import '../../providers/exercises_providers.dart';
import '../widgets/exercise_image_picker.dart';

class ExerciseCreationScreen extends ConsumerStatefulWidget {
  const ExerciseCreationScreen({super.key});

  @override
  ConsumerState<ExerciseCreationScreen> createState() => _ExerciseCreationScreenState();
}

class _ExerciseCreationScreenState extends ConsumerState<ExerciseCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _movementPatternController = TextEditingController();
  final _durationController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Reset form when screen is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(exerciseCreationProvider.notifier).resetForm();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _instructionsController.dispose();
    _movementPatternController.dispose();
    _durationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final creationState = ref.watch(exerciseCreationProvider);
    final canSubmit = ref.watch(canSubmitExerciseProvider);

    // Handle successful submission
    ref.listen<ExerciseCreationState>(exerciseCreationProvider, (previous, current) {
      if (current.isSubmitted && !current.isSubmitting) {
        Navigator.of(context).pop(true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exercise created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (current.submitError != null && previous?.submitError != current.submitError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create exercise: ${current.submitError}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Exercise'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _handleBackPress(context),
        ),
        actions: [
          TextButton(
            onPressed: canSubmit ? _submitForm : null,
            child: creationState.isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Create'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information Section
              _buildSectionCard(
                title: 'Basic Information',
                icon: Icons.info_outline,
                children: [
                  _buildNameField(),
                  const SizedBox(height: 16),
                  _buildDescriptionField(),
                  const SizedBox(height: 16),
                  _buildInstructionsField(),
                ],
              ),

              const SizedBox(height: 16),

              // Exercise Properties Section
              _buildSectionCard(
                title: 'Exercise Properties',
                icon: Icons.settings_outlined,
                children: [
                  _buildDifficultyField(),
                  const SizedBox(height: 16),
                  _buildExerciseTypeField(),
                  const SizedBox(height: 16),
                  _buildMovementPatternField(),
                  const SizedBox(height: 16),
                  _buildDurationField(),
                ],
              ),

              const SizedBox(height: 16),

              // Muscle Groups Section
              _buildSectionCard(
                title: 'Muscle Groups',
                icon: Icons.accessibility_outlined,
                children: [
                  _buildPrimaryMuscleGroupsField(),
                  const SizedBox(height: 16),
                  _buildSecondaryMuscleGroupsField(),
                ],
              ),

              const SizedBox(height: 16),

              // Equipment Section
              _buildSectionCard(
                title: 'Equipment',
                icon: Icons.fitness_center_outlined,
                children: [
                  _buildEquipmentField(),
                ],
              ),

              const SizedBox(height: 16),

              // Image Upload Section
              const ExerciseImagePicker(),

              const SizedBox(height: 16),

              // Privacy Section
              _buildSectionCard(
                title: 'Privacy',
                icon: Icons.visibility_outlined,
                children: [
                  _buildPublicToggle(),
                ],
              ),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: canSubmit ? _submitForm : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: creationState.isSubmitting
                      ? const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 12),
                            Text('Creating Exercise...'),
                          ],
                        )
                      : const Text(
                          'Create Exercise',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    final validation = ref.watch(exerciseFormValidationProvider);
    
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Exercise Name *',
        hintText: 'e.g., Push-ups, Squats, Bench Press',
        errorText: validation.getError('name'),
        prefixIcon: const Icon(Icons.fitness_center),
      ),
      textCapitalization: TextCapitalization.words,
      maxLength: 100,
      onChanged: (value) => ref.read(exerciseCreationProvider.notifier).updateField('name', value),
      validator: (value) => validation.getError('name'),
    );
  }

  Widget _buildDescriptionField() {
    final validation = ref.watch(exerciseFormValidationProvider);
    
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: 'Description',
        hintText: 'Brief description of the exercise (optional)',
        errorText: validation.getError('description'),
        prefixIcon: const Icon(Icons.description_outlined),
      ),
      maxLines: 2,
      maxLength: 500,
      textCapitalization: TextCapitalization.sentences,
      onChanged: (value) => ref.read(exerciseCreationProvider.notifier).updateField('description', value),
    );
  }

  Widget _buildInstructionsField() {
    final validation = ref.watch(exerciseFormValidationProvider);
    
    return TextFormField(
      controller: _instructionsController,
      decoration: InputDecoration(
        labelText: 'Instructions *',
        hintText: 'Step-by-step instructions on how to perform the exercise',
        errorText: validation.getError('instructions'),
        prefixIcon: const Icon(Icons.list_alt_outlined),
        alignLabelWithHint: true,
      ),
      maxLines: 4,
      maxLength: 2000,
      textCapitalization: TextCapitalization.sentences,
      onChanged: (value) => ref.read(exerciseCreationProvider.notifier).updateField('instructions', value),
      validator: (value) => validation.getError('instructions'),
    );
  }

  Widget _buildDifficultyField() {
    final creationState = ref.watch(exerciseCreationProvider);
    final options = ref.watch(difficultyLevelOptionsProvider);
    
    return DropdownButtonFormField<String>(
      value: creationState.formData.difficultyLevel,
      decoration: const InputDecoration(
        labelText: 'Difficulty Level *',
        prefixIcon: Icon(Icons.bar_chart_outlined),
      ),
      items: options.map((difficulty) => DropdownMenuItem(
        value: difficulty,
        child: Text(difficulty[0].toUpperCase() + difficulty.substring(1)),
      )).toList(),
      onChanged: (value) {
        if (value != null) {
          ref.read(exerciseCreationProvider.notifier).updateField('difficultyLevel', value);
        }
      },
    );
  }

  Widget _buildExerciseTypeField() {
    final creationState = ref.watch(exerciseCreationProvider);
    final options = ref.watch(exerciseTypeOptionsProvider);
    
    return DropdownButtonFormField<String>(
      value: creationState.formData.exerciseType,
      decoration: const InputDecoration(
        labelText: 'Exercise Type *',
        prefixIcon: Icon(Icons.category_outlined),
      ),
      items: options.map((type) => DropdownMenuItem(
        value: type,
        child: Text(type[0].toUpperCase() + type.substring(1)),
      )).toList(),
      onChanged: (value) {
        if (value != null) {
          ref.read(exerciseCreationProvider.notifier).updateField('exerciseType', value);
        }
      },
    );
  }

  Widget _buildMovementPatternField() {
    final creationState = ref.watch(exerciseCreationProvider);
    final options = ref.watch(movementPatternOptionsProvider);
    
    return DropdownButtonFormField<String>(
      value: creationState.formData.movementPattern,
      decoration: const InputDecoration(
        labelText: 'Movement Pattern',
        prefixIcon: Icon(Icons.trending_up_outlined),
      ),
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('Not specified'),
        ),
        ...options.map((pattern) => DropdownMenuItem(
          value: pattern,
          child: Text(pattern),
        )),
      ],
      onChanged: (value) => ref.read(exerciseCreationProvider.notifier).updateField('movementPattern', value),
    );
  }

  Widget _buildDurationField() {
    final validation = ref.watch(exerciseFormValidationProvider);
    
    return TextFormField(
      controller: _durationController,
      decoration: InputDecoration(
        labelText: 'Estimated Duration (minutes)',
        hintText: 'e.g., 5',
        errorText: validation.getError('estimatedDurationMinutes'),
        prefixIcon: const Icon(Icons.timer_outlined),
        suffixText: 'min',
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (value) {
        final duration = int.tryParse(value);
        ref.read(exerciseCreationProvider.notifier).updateField('estimatedDurationMinutes', duration);
      },
    );
  }

  Widget _buildPrimaryMuscleGroupsField() {
    final creationState = ref.watch(exerciseCreationProvider);
    final validation = ref.watch(exerciseFormValidationProvider);
    final options = ref.watch(muscleGroupOptionsProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.accessibility_new_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Primary Muscle Groups *',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
              Icons.accessibility_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Secondary Muscle Groups',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
              Icons.fitness_center_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Required Equipment',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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

  Widget _buildPublicToggle() {
    final creationState = ref.watch(exerciseCreationProvider);
    
    return SwitchListTile(
      title: const Text('Make this exercise public'),
      subtitle: const Text('Other users will be able to see and use this exercise'),
      value: creationState.formData.isPublic,
      onChanged: (value) => ref.read(exerciseCreationProvider.notifier).updateField('isPublic', value),
      secondary: const Icon(Icons.public_outlined),
    );
  }

  void _handleBackPress(BuildContext context) {
    final creationState = ref.read(exerciseCreationProvider);
    
    // Check if form has unsaved changes
    if (creationState.formData.name.isNotEmpty ||
        creationState.formData.instructions.isNotEmpty ||
        creationState.imageState.images.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discard Changes?'),
          content: const Text(
            'You have unsaved changes. Are you sure you want to discard them?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Discard'),
            ),
          ],
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      // Scroll to first error
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }

    final success = await ref.read(exerciseCreationProvider.notifier).submitExercise();
    if (success) {
      // Refresh exercises list to show new exercise
      ref.read(exercisesProvider.notifier).refresh();
    }
  }
}