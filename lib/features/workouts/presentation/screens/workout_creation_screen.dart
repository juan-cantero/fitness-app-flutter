import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/workout_form_widget.dart';
import '../widgets/workout_exercise_list_widget.dart';
import '../widgets/workout_cover_image_widget.dart';
import '../../providers/workout_creation_providers.dart';
import '../../models/workout_form_mode.dart';

class WorkoutCreationScreen extends ConsumerStatefulWidget {
  const WorkoutCreationScreen({super.key});

  @override
  ConsumerState<WorkoutCreationScreen> createState() => _WorkoutCreationScreenState();
}

class _WorkoutCreationScreenState extends ConsumerState<WorkoutCreationScreen> {
  @override
  void initState() {
    super.initState();
    // Reset form when entering the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(workoutCreationProvider.notifier).resetForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(workoutCreationProvider);
    final canSubmit = ref.watch(canSubmitWorkoutProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Workout'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cover Image Section
                    const WorkoutCoverImageWidget(mode: WorkoutFormMode.creation),
                    const SizedBox(height: 24),

                    // Basic Information Form
                    const WorkoutFormWidget(mode: WorkoutFormMode.creation),
                    const SizedBox(height: 24),

                    // Exercise Selection and Configuration
                    Text(
                      'Exercises',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const WorkoutExerciseListWidget(mode: WorkoutFormMode.creation),
                    const SizedBox(height: 16),

                    // Error Display
                    if (state.submitError != null)
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
                                state.submitError!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            // Bottom action buttons in safe area
            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: FilledButton(
                        onPressed: canSubmit
                            ? () async {
                                final success = await ref
                                    .read(workoutCreationProvider.notifier)
                                    .submitWorkout();
                                if (success && context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              }
                            : null,
                        child: state.isSubmitting
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Save Workout'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}