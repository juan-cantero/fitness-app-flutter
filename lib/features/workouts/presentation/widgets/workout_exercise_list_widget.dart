import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/workout_creation_providers.dart';
import '../../providers/workout_edit_providers.dart';
import '../../models/workout_form_mode.dart';
import '../dialogs/exercise_selection_dialog.dart';
import '../dialogs/exercise_configuration_dialog.dart';
import '../../../../shared/widgets/cached_network_image_widget.dart';

class WorkoutExerciseListWidget extends ConsumerWidget {
  final WorkoutFormMode mode;
  
  const WorkoutExerciseListWidget({
    super.key,
    this.mode = WorkoutFormMode.creation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get typed data based on mode
    List<WorkoutExerciseConfig> exercises;
    bool validationAttempted;
    WorkoutFormValidationState validation;
    
    if (mode == WorkoutFormMode.creation) {
      final state = ref.watch(workoutCreationProvider);
      exercises = state.formData.exercises;
      validationAttempted = state.validationAttempted;
      validation = ref.watch(workoutFormValidationProvider);
    } else {
      final state = ref.watch(workoutEditProvider);
      exercises = state.formData.exercises;
      validationAttempted = state.validationAttempted;
      validation = state.validationState;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Exercise List',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                FilledButton.icon(
                  onPressed: () => _showExerciseSelectionDialog(context, ref),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Exercise'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (exercises.isEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.fitness_center_outlined,
                      size: 48,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No exercises added yet',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add exercises to create your workout',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ] else ...[
              ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: exercises.length,
                onReorder: (oldIndex, newIndex) {
                  _reorderExercises(ref, oldIndex, newIndex);
                },
                itemBuilder: (context, index) {
                  final exerciseConfig = exercises[index];
                  return _buildExerciseCard(
                    context,
                    ref,
                    exerciseConfig,
                    index,
                  );
                },
              ),
            ],

            // Error display for exercises (only show if validation was attempted)
            if (validation.hasError('exercises') && validationAttempted) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        validation.getError('exercises')!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _reorderExercises(WidgetRef ref, int oldIndex, int newIndex) {
    if (mode == WorkoutFormMode.creation) {
      ref.read(workoutCreationProvider.notifier).reorderExercises(oldIndex, newIndex);
    } else {
      ref.read(workoutEditProvider.notifier).reorderExercises(oldIndex, newIndex);
    }
  }
  
  void _removeExercise(WidgetRef ref, int index) {
    if (mode == WorkoutFormMode.creation) {
      ref.read(workoutCreationProvider.notifier).removeExercise(index);
    } else {
      ref.read(workoutEditProvider.notifier).removeExercise(index);
    }
  }
  
  void _updateExerciseConfig(WidgetRef ref, int index, WorkoutExerciseConfig updatedConfig) {
    if (mode == WorkoutFormMode.creation) {
      ref.read(workoutCreationProvider.notifier).updateExerciseConfig(index, updatedConfig);
    } else {
      ref.read(workoutEditProvider.notifier).updateExerciseConfig(index, updatedConfig);
    }
  }

  Widget _buildExerciseCard(
    BuildContext context,
    WidgetRef ref,
    WorkoutExerciseConfig exerciseConfig,
    int index,
  ) {
    return Card(
      key: ValueKey(exerciseConfig.exerciseId),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.surfaceContainer,
          ),
          child: CachedNetworkImageWidget(
            imageId: exerciseConfig.exercise.imageUrl,
            fit: BoxFit.cover,
            width: 56,
            height: 56,
            borderRadius: BorderRadius.circular(8),
            errorWidget: Icon(
              Icons.fitness_center,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        title: Text(exerciseConfig.exercise.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_buildExerciseConfigText(exerciseConfig)),
            if (exerciseConfig.notes?.isNotEmpty == true) ...[
              const SizedBox(height: 4),
              Text(
                exerciseConfig.notes!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${index + 1}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.drag_handle,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            PopupMenuButton<String>(
              onSelected: (action) {
                switch (action) {
                  case 'edit':
                    _showExerciseConfigurationDialog(
                      context,
                      ref,
                      exerciseConfig,
                      index,
                    );
                    break;
                  case 'remove':
                    _removeExercise(ref, index);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit Configuration'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'remove',
                  child: ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Remove'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () => _showExerciseConfigurationDialog(
          context,
          ref,
          exerciseConfig,
          index,
        ),
      ),
    );
  }

  String _buildExerciseConfigText(WorkoutExerciseConfig config) {
    final parts = <String>[];
    
    parts.add('${config.sets} sets');
    
    if (config.reps != null) {
      parts.add('${config.reps} reps');
    }
    
    if (config.weightKg != null) {
      parts.add('${config.weightKg}kg');
    }
    
    if (config.durationSeconds != null) {
      final minutes = config.durationSeconds! ~/ 60;
      final seconds = config.durationSeconds! % 60;
      if (minutes > 0) {
        parts.add('${minutes}m ${seconds}s');
      } else {
        parts.add('${seconds}s');
      }
    }
    
    if (config.restTimeSeconds != 60) {
      parts.add('${config.restTimeSeconds}s rest');
    }
    
    return parts.join(' • ');
  }

  Future<void> _showExerciseSelectionDialog(BuildContext context, WidgetRef ref) async {
    await showDialog<void>(
      context: context,
      builder: (context) => ExerciseSelectionDialog(mode: mode),
    );
  }

  Future<void> _showExerciseConfigurationDialog(
    BuildContext context,
    WidgetRef ref,
    WorkoutExerciseConfig config,
    int index,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) => ExerciseConfigurationDialog(
        exerciseConfig: config,
        onConfigurationUpdated: (updatedConfig) {
          _updateExerciseConfig(ref, index, updatedConfig);
        },
      ),
    );
  }
}