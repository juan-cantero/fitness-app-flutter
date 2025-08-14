import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../exercises/providers/exercises_providers.dart';
import '../../providers/workout_creation_providers.dart';
import '../../providers/workout_edit_providers.dart';
import '../../models/workout_form_mode.dart';
import '../../../../shared/widgets/cached_network_image_widget.dart';
import '../../../../shared/models/exercise.dart';

class ExerciseSelectionDialog extends ConsumerStatefulWidget {
  final WorkoutFormMode mode;
  
  const ExerciseSelectionDialog({
    super.key,
    this.mode = WorkoutFormMode.creation,
  });

  @override
  ConsumerState<ExerciseSelectionDialog> createState() => _ExerciseSelectionDialogState();
}

class _ExerciseSelectionDialogState extends ConsumerState<ExerciseSelectionDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercises = ref.watch(exercisesProvider);

    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Text(
                  'Select Exercise',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search bar
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search exercises',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 16),

            // Exercise list
            Expanded(
              child: exercises.when(
                data: (exerciseList) {
                  final filteredExercises = _searchQuery.isEmpty
                      ? exerciseList
                      : exerciseList.where((exercise) {
                          return exercise.name.toLowerCase().contains(_searchQuery) ||
                                 exercise.primaryMuscleGroups.any((muscle) => muscle.toLowerCase().contains(_searchQuery)) ||
                                 exercise.secondaryMuscleGroups.any((muscle) => 
                                   muscle.toLowerCase().contains(_searchQuery));
                        }).toList();

                  if (filteredExercises.isEmpty) {
                    return const Center(
                      child: Text('No exercises found'),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = filteredExercises[index];
                      return _buildExerciseCard(exercise);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('Error loading exercises: $error'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    return Card(
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
            imageId: exercise.imageUrl,
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
        title: Text(exercise.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(exercise.primaryMuscleGroups.join(', ')),
            if (exercise.equipmentRequired.isNotEmpty)
              Text(
                'Equipment: ${exercise.equipmentRequired.join(', ')}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        trailing: const Icon(Icons.add),
        onTap: () => _selectExercise(exercise),
      ),
    );
  }

  void _selectExercise(Exercise exercise) {
    // Add exercise with default configuration
    final sets = 3;
    final reps = exercise.name.toLowerCase().contains('plank') || 
                 exercise.name.toLowerCase().contains('hold') ? null : 12;
    final durationSeconds = exercise.name.toLowerCase().contains('plank') || 
                           exercise.name.toLowerCase().contains('hold') ? 30 : null;
    final restTimeSeconds = 60;
    
    if (widget.mode == WorkoutFormMode.creation) {
      ref.read(workoutCreationProvider.notifier).addExercise(
        exercise,
        sets: sets,
        reps: reps,
        durationSeconds: durationSeconds,
        restTimeSeconds: restTimeSeconds,
      );
    } else {
      ref.read(workoutEditProvider.notifier).addExercise(
        exercise,
        sets: sets,
        reps: reps,
        durationSeconds: durationSeconds,
        restTimeSeconds: restTimeSeconds,
      );
    }

    Navigator.of(context).pop();

    // Show snackbar confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${exercise.name} added to workout'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}