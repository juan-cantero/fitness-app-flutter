import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/workout_creation_providers.dart';
import '../../providers/workout_edit_providers.dart';
import '../../models/workout_form_mode.dart';

class WorkoutFormWidget extends ConsumerWidget {
  final WorkoutFormMode mode;
  
  const WorkoutFormWidget({
    super.key,
    this.mode = WorkoutFormMode.creation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get typed state and notifiers
    WorkoutFormData formData;
    WorkoutFormValidationState validation;
    
    if (mode == WorkoutFormMode.creation) {
      final state = ref.watch(workoutCreationProvider);
      formData = state.formData;
      validation = ref.watch(workoutFormValidationProvider);
    } else {
      final state = ref.watch(workoutEditProvider);
      formData = state.formData;
      validation = state.validationState;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Workout Name
            TextFormField(
              initialValue: formData.name,
              decoration: InputDecoration(
                labelText: 'Workout Name *',
                hintText: 'Enter workout name',
                errorText: validation.getError('name'),
              ),
              onChanged: (value) => _updateField(ref, 'name', value),
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              initialValue: formData.description,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your workout',
                errorText: validation.getError('description'),
              ),
              maxLines: 3,
              onChanged: (value) => _updateField(ref, 'description', value),
            ),
            const SizedBox(height: 16),

            // Difficulty and Type Row
            Row(
              children: [
                Expanded(
                  child: Consumer(
                    builder: (context, ref, child) {
                      final options = ref.watch(difficultyLevelOptionsProvider);
                      return DropdownButtonFormField<String>(
                        value: formData.difficultyLevel,
                        decoration: const InputDecoration(
                          labelText: 'Difficulty',
                        ),
                        items: options.map((level) {
                          return DropdownMenuItem(
                            value: level,
                            child: Text(level.toUpperCase()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            _updateField(ref, 'difficultyLevel', value);
                          }
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Consumer(
                    builder: (context, ref, child) {
                      final options = ref.watch(workoutTypeOptionsProvider);
                      return DropdownButtonFormField<String>(
                        value: formData.workoutType,
                        decoration: const InputDecoration(
                          labelText: 'Type',
                        ),
                        items: options.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type.toUpperCase()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            _updateField(ref, 'workoutType', value);
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Duration and Intensity Row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: formData.estimatedDurationMinutes.toString(),
                    decoration: InputDecoration(
                      labelText: 'Duration (minutes)',
                      errorText: validation.getError('estimatedDurationMinutes'),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final duration = int.tryParse(value) ?? 45;
                      _updateField(ref, 'estimatedDurationMinutes', duration);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Consumer(
                    builder: (context, ref, child) {
                      final options = ref.watch(intensityLevelOptionsProvider);
                      return DropdownButtonFormField<String>(
                        value: formData.intensityLevel,
                        decoration: const InputDecoration(
                          labelText: 'Intensity',
                        ),
                        items: options.map((intensity) {
                          return DropdownMenuItem(
                            value: intensity,
                            child: Text(intensity.toUpperCase()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            _updateField(ref, 'intensityLevel', value);
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Space Requirement
            Consumer(
              builder: (context, ref, child) {
                final options = ref.watch(spaceRequirementOptionsProvider);
                return DropdownButtonFormField<String>(
                  value: formData.spaceRequirement,
                  decoration: const InputDecoration(
                    labelText: 'Space Required',
                  ),
                  items: options.map((space) {
                    return DropdownMenuItem(
                      value: space,
                      child: Text(space.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _updateField(ref, 'spaceRequirement', value);
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 16),

            // Target Muscle Groups
            _buildMuscleGroupsSelector(context, ref, formData),
            const SizedBox(height: 16),

            // Equipment Needed
            _buildEquipmentSelector(context, ref, formData),
            const SizedBox(height: 16),

            // Rest Times Row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: formData.restBetweenExercises.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Rest Between Exercises (s)',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final rest = int.tryParse(value) ?? 60;
                      _updateField(ref, 'restBetweenExercises', rest);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: formData.restBetweenSets.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Rest Between Sets (s)',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final rest = int.tryParse(value) ?? 60;
                      _updateField(ref, 'restBetweenSets', rest);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Notes
            TextFormField(
              initialValue: formData.notes,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Additional notes about the workout',
              ),
              maxLines: 2,
              onChanged: (value) => _updateField(ref, 'notes', value),
            ),
            const SizedBox(height: 16),

            // Template and Public toggles
            Column(
              children: [
                CheckboxListTile(
                  title: Row(
                    children: [
                      const Text('Save as Template'),
                      const SizedBox(width: 8),
                      Tooltip(
                        message: 'Templates can be reused to create similar workouts quickly. They appear in your template library.',
                        child: Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  value: formData.isTemplate,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (value) {
                    if (value != null) {
                      _updateField(ref, 'isTemplate', value);
                    }
                  },
                ),
                CheckboxListTile(
                  title: Row(
                    children: [
                      const Text('Make Public'),
                      const SizedBox(width: 8),
                      Tooltip(
                        message: 'Public workouts can be discovered and used by other users in the community.',
                        child: Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  value: formData.isPublic,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (value) {
                    if (value != null) {
                      _updateField(ref, 'isPublic', value);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateField(WidgetRef ref, String field, dynamic value) {
    if (mode == WorkoutFormMode.creation) {
      ref.read(workoutCreationProvider.notifier).updateField(field, value);
    } else {
      ref.read(workoutEditProvider.notifier).updateField(field, value);
    }
  }

  Widget _buildMuscleGroupsSelector(
    BuildContext context,
    WidgetRef ref,
    WorkoutFormData formData,
  ) {
    // Using static muscle groups for now
    // final muscleGroups = ref.watch(exerciseCategoriesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Target Muscle Groups',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            'chest', 'back', 'shoulders', 'arms', 'legs', 'core', 'cardio'
          ].map((group) {
            final isSelected = formData.targetMuscleGroups.contains(group);
            return FilterChip(
              label: Text(group.toUpperCase()),
              selected: isSelected,
              onSelected: (selected) {
                final updatedGroups = List<String>.from(formData.targetMuscleGroups);
                if (selected) {
                  updatedGroups.add(group);
                } else {
                  updatedGroups.remove(group);
                }
                _updateField(ref, 'targetMuscleGroups', updatedGroups);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEquipmentSelector(
    BuildContext context,
    WidgetRef ref,
    WorkoutFormData formData,
  ) {
    // Using static equipment list for now  
    // final equipment = ref.watch(exerciseEquipmentProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Equipment Needed',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            'bodyweight', 'dumbbells', 'barbell', 'kettlebells', 'resistance bands', 'pull-up bar', 'bench', 'mat'
          ].map((item) {
            final isSelected = formData.equipmentNeeded.contains(item);
            return FilterChip(
              label: Text(item.toUpperCase()),
              selected: isSelected,
              onSelected: (selected) {
                final updatedEquipment = List<String>.from(formData.equipmentNeeded);
                if (selected) {
                  updatedEquipment.add(item);
                } else {
                  updatedEquipment.remove(item);
                }
                _updateField(ref, 'equipmentNeeded', updatedEquipment);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}