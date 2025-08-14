import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/workout_form_widget.dart';
import '../widgets/workout_exercise_list_widget.dart';
import '../widgets/workout_cover_image_widget.dart';
import '../../providers/workout_edit_providers.dart';
import '../../models/workout_form_mode.dart';

class WorkoutEditScreen extends ConsumerStatefulWidget {
  final String workoutId;
  
  const WorkoutEditScreen({
    super.key,
    required this.workoutId,
  });

  @override
  ConsumerState<WorkoutEditScreen> createState() => _WorkoutEditScreenState();
}

class _WorkoutEditScreenState extends ConsumerState<WorkoutEditScreen> {
  @override
  void initState() {
    super.initState();
    // Load the workout data when entering the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(workoutEditProvider.notifier).loadWorkout(widget.workoutId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(workoutEditProvider);
    final canUpdate = ref.watch(canUpdateWorkoutProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Workout'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Main content
            Expanded(
              child: _buildContent(state, canUpdate),
            ),
            
            // Bottom action buttons in safe area
            if (!state.isLoading)
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
                          onPressed: canUpdate
                              ? () async {
                                  final success = await ref
                                      .read(workoutEditProvider.notifier)
                                      .updateWorkout();
                                  if (success && context.mounted) {
                                    // Clear submit state to allow further edits
                                    ref.read(workoutEditProvider.notifier).clearSubmitState();
                                    
                                    // Show success message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Workout updated successfully!'),
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                    
                                    // Navigate back
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
                              : const Text('Update Workout'),
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

  Widget _buildContent(WorkoutEditState state, bool canUpdate) {
    // Loading state
    if (state.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading workout...'),
          ],
        ),
      );
    }

    // Error state
    if (state.loadError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading workout',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              state.loadError!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                ref.read(workoutEditProvider.notifier).loadWorkout(widget.workoutId);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Main edit form
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover Image Section
          const WorkoutCoverImageWidget(mode: WorkoutFormMode.edit),
          const SizedBox(height: 24),

          // Basic Information Form
          const WorkoutFormWidget(mode: WorkoutFormMode.edit),
          const SizedBox(height: 24),

          // Exercise Selection and Configuration
          Text(
            'Exercises',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add exercises to your workout or leave empty to configure later',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          const WorkoutExerciseListWidget(mode: WorkoutFormMode.edit),
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
    );
  }
}