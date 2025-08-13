import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/workouts_providers.dart';
import '../../../../shared/widgets/cached_network_image_widget.dart';
import '../../../../shared/models/workout.dart';

class WorkoutDetailScreen extends ConsumerWidget {
  final String workoutId;

  const WorkoutDetailScreen({
    super.key,
    required this.workoutId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutAsync = ref.watch(workoutByIdProvider(workoutId));

    return Scaffold(
      body: workoutAsync.when(
        data: (workout) => workout != null 
            ? _buildWorkoutDetail(context, ref, workout)
            : _buildNotFound(context),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildError(context, error.toString()),
      ),
    );
  }

  Widget _buildWorkoutDetail(BuildContext context, WidgetRef ref, Workout workout) {
    return CustomScrollView(
      slivers: [
        // App Bar with cover image
        SliverAppBar(
          expandedHeight: 250,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              workout.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 3,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                workout.imageUrl != null
                    ? CachedNetworkImageWidget(
                        imageId: workout.imageUrl!,
                        fit: BoxFit.cover,
                        imageFitString: workout.imageFit,
                        errorWidget: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.primaryContainer,
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.fitness_center,
                            size: 64,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.primaryContainer,
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.fitness_center,
                          size: 64,
                          color: Colors.white,
                        ),
                      ),
                // Gradient overlay
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) async {
                switch (value) {
                  case 'edit':
                    // TODO: Implement edit functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit functionality will be implemented soon')),
                    );
                    break;
                  case 'clone':
                    // TODO: Clone workout
                    break;
                  case 'share':
                    // TODO: Share workout
                    break;
                  case 'delete':
                    final confirmed = await _showDeleteConfirmationDialog(context);
                    if (confirmed == true && context.mounted) {
                      await _deleteWorkout(context, ref, workout);
                    }
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit Workout'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'clone',
                  child: ListTile(
                    leading: Icon(Icons.copy),
                    title: Text('Clone Workout'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'share',
                  child: ListTile(
                    leading: Icon(Icons.share),
                    title: Text('Share'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Delete Workout', style: TextStyle(color: Colors.red)),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Workout Information
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Basic Info Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        context,
                        Icons.schedule,
                        '${workout.estimatedDurationMinutes ?? 0} min',
                        'Duration',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoCard(
                        context,
                        Icons.trending_up,
                        workout.difficultyLevel.toUpperCase(),
                        'Difficulty',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoCard(
                        context,
                        Icons.fitness_center,
                        workout.workoutType.toUpperCase(),
                        'Type',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Intensity and Space
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        context,
                        Icons.local_fire_department,
                        workout.intensityLevel.toUpperCase(),
                        'Intensity',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoCard(
                        context,
                        Icons.home,
                        workout.spaceRequirement.toUpperCase(),
                        'Space',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoCard(
                        context,
                        Icons.fitness_center_outlined,
                        '${workout.exercises.length}',
                        'Exercises',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Description
                if (workout.description?.isNotEmpty == true) ...[
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    workout.description!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                ],

                // Target Muscle Groups
                if (workout.targetMuscleGroups.isNotEmpty) ...[
                  Text(
                    'Target Muscle Groups',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: workout.targetMuscleGroups.map((muscle) {
                      return Chip(
                        label: Text(muscle),
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],

                // Equipment Needed
                if (workout.equipmentNeeded.isNotEmpty) ...[
                  Text(
                    'Equipment Needed',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: workout.equipmentNeeded.map((equipment) {
                      return Chip(
                        label: Text(equipment),
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],

                // Exercise List
                Text(
                  'Exercises',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),

        // Exercise List
        if (workout.exercises.isNotEmpty)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final exercise = workout.exercises[index];
                return _buildExerciseCard(context, exercise, index + 1);
              },
              childCount: workout.exercises.length,
            ),
          )
        else
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'No exercises added to this workout yet.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),

        // Bottom spacing
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, IconData icon, String value, String label) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, WorkoutExercise workoutExercise, int position) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            position.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          workoutExercise.exercise?.name ?? 'Unknown Exercise',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_buildExerciseConfigText(workoutExercise)),
            if (workoutExercise.notes?.isNotEmpty == true) ...[
              const SizedBox(height: 4),
              Text(
                workoutExercise.notes!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          ],
        ),
        trailing: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.surfaceContainer,
          ),
          child: CachedNetworkImageWidget(
            imageId: workoutExercise.exercise?.imageUrl,
            fit: BoxFit.cover,
            width: 56,
            height: 56,
            borderRadius: BorderRadius.circular(8),
            errorWidget: const Icon(Icons.fitness_center),
          ),
        ),
      ),
    );
  }

  String _buildExerciseConfigText(WorkoutExercise workoutExercise) {
    final parts = <String>[];
    
    parts.add('${workoutExercise.sets} sets');
    
    if (workoutExercise.reps != null) {
      parts.add('${workoutExercise.reps} reps');
    }
    
    if (workoutExercise.weightKg != null) {
      parts.add('${workoutExercise.weightKg}kg');
    }
    
    if (workoutExercise.durationSeconds != null) {
      final minutes = workoutExercise.durationSeconds! ~/ 60;
      final seconds = workoutExercise.durationSeconds! % 60;
      if (minutes > 0) {
        parts.add('${minutes}m ${seconds}s');
      } else {
        parts.add('${seconds}s');
      }
    }
    
    if (workoutExercise.restTimeSeconds != 60) {
      parts.add('${workoutExercise.restTimeSeconds}s rest');
    }
    
    return parts.join(' • ');
  }

  Widget _buildNotFound(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Not Found'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Workout not found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'The workout you are looking for does not exist.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String error) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Error loading workout',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Workout'),
        content: const Text(
          'Are you sure you want to delete this workout? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteWorkout(BuildContext context, WidgetRef ref, Workout workout) async {
    try {
      // Show loading indicator
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 16),
                Text('Deleting workout...'),
              ],
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }

      // Delete the workout
      await ref.read(workoutRepositoryProvider).delete(workout.id);

      // Refresh the workouts list
      ref.invalidate(workoutsProvider);

      if (context.mounted) {
        // Hide loading snackbar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Workout deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to the workouts list
        context.pop();
      }
    } catch (e) {
      if (context.mounted) {
        // Hide loading snackbar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting workout: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}