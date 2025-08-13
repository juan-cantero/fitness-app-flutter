import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/models.dart';

/// Action bar for exercise detail screen with common exercise actions
class ExerciseActionsBar extends ConsumerWidget {
  final Exercise exercise;
  
  const ExerciseActionsBar({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Start Workout button
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () => _startWorkout(context, exercise),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Workout'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Action buttons row
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    context,
                    icon: Icons.favorite_outline,
                    filledIcon: Icons.favorite,
                    isActive: false, // TODO: Connect to favorites state
                    onPressed: () => _toggleFavorite(context, exercise),
                    tooltip: 'Add to Favorites',
                  ),
                  _buildActionButton(
                    context,
                    icon: Icons.playlist_add_outlined,
                    filledIcon: Icons.playlist_add_check,
                    isActive: false, // TODO: Connect to workout state
                    onPressed: () => _addToWorkout(context, exercise),
                    tooltip: 'Add to Workout',
                  ),
                  _buildActionButton(
                    context,
                    icon: Icons.share_outlined,
                    filledIcon: Icons.share,
                    isActive: false,
                    onPressed: () => _shareExercise(context, exercise),
                    tooltip: 'Share Exercise',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required IconData filledIcon,
    required bool isActive,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive 
                ? Theme.of(context).colorScheme.primaryContainer
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Icon(
            isActive ? filledIcon : icon,
            size: 20,
            color: isActive 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  void _startWorkout(BuildContext context, Exercise exercise) {
    // TODO: Implement start workout functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Workout'),
        content: Text(
          'Starting a workout with "${exercise.name}" will be implemented in a future update.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(BuildContext context, Exercise exercise) {
    // TODO: Implement favorite functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "${exercise.name}" to favorites'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            // TODO: Implement undo favorite
          },
        ),
      ),
    );
  }

  void _addToWorkout(BuildContext context, Exercise exercise) {
    // TODO: Implement add to workout functionality
    _showWorkoutSelectionDialog(context, exercise);
  }

  void _shareExercise(BuildContext context, Exercise exercise) {
    // TODO: Implement proper sharing
    final exerciseText = '''
${exercise.name}

${exercise.description ?? ''}

Instructions:
${exercise.instructions ?? 'No instructions available'}

Difficulty: ${exercise.difficultyLevel}
Type: ${exercise.exerciseType}
Primary Muscles: ${exercise.primaryMuscleGroups.join(', ')}
Equipment: ${exercise.equipmentRequired.isEmpty ? 'None' : exercise.equipmentRequired.join(', ')}
''';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Exercise'),
        content: SingleChildScrollView(
          child: Text(exerciseText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exercise details copied to clipboard')),
              );
            },
            child: const Text('Copy'),
          ),
        ],
      ),
    );
  }

  void _showWorkoutSelectionDialog(BuildContext context, Exercise exercise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => _WorkoutSelectionSheet(
          exercise: exercise,
          scrollController: scrollController,
        ),
      ),
    );
  }
}

/// Bottom sheet for selecting or creating workouts to add the exercise to
class _WorkoutSelectionSheet extends StatefulWidget {
  final Exercise exercise;
  final ScrollController scrollController;
  
  const _WorkoutSelectionSheet({
    required this.exercise,
    required this.scrollController,
  });

  @override
  State<_WorkoutSelectionSheet> createState() => _WorkoutSelectionSheetState();
}

class _WorkoutSelectionSheetState extends State<_WorkoutSelectionSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Header
          Text(
            'Add to Workout',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Choose a workout to add "${widget.exercise.name}" to:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Create new workout button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _createNewWorkout(),
              icon: const Icon(Icons.add),
              label: const Text('Create New Workout'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Divider
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'or select existing',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Existing workouts list
          Expanded(
            child: ListView(
              controller: widget.scrollController,
              children: [
                // TODO: Load actual workouts from database
                _buildWorkoutTile(
                  title: 'Upper Body Strength',
                  subtitle: '6 exercises • 45 min',
                  exerciseCount: 6,
                  onTap: () => _addToExistingWorkout('workout_1'),
                ),
                _buildWorkoutTile(
                  title: 'Full Body HIIT',
                  subtitle: '8 exercises • 30 min',
                  exerciseCount: 8,
                  onTap: () => _addToExistingWorkout('workout_2'),
                ),
                _buildWorkoutTile(
                  title: 'Leg Day',
                  subtitle: '5 exercises • 60 min',
                  exerciseCount: 5,
                  onTap: () => _addToExistingWorkout('workout_3'),
                ),
                
                // Empty state if no workouts (TODO: Implement when workout loading is added)
                /*
                Container(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.fitness_center_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No workouts yet',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create your first workout to get started',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                */
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutTile({
    required String title,
    required String subtitle,
    required int exerciseCount,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            exerciseCount.toString(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.add),
        onTap: onTap,
      ),
    );
  }

  void _createNewWorkout() {
    Navigator.of(context).pop();
    // TODO: Navigate to workout creation with pre-added exercise
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Creating new workout with "${widget.exercise.name}"'),
      ),
    );
  }

  void _addToExistingWorkout(String workoutId) {
    Navigator.of(context).pop();
    // TODO: Add exercise to existing workout
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "${widget.exercise.name}" to workout'),
      ),
    );
  }
}