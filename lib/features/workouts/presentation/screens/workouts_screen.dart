import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/workouts_providers.dart';
import '../../../../shared/widgets/cached_network_image_widget.dart';
import 'workout_creation_screen.dart';
import 'workout_detail_screen.dart';

class WorkoutsScreen extends ConsumerWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(workoutsProvider);
    final viewMode = ref.watch(workoutViewModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        actions: [
          // View mode toggle
          IconButton(
            icon: Icon(
              viewMode == WorkoutViewMode.grid
                  ? Icons.view_list
                  : Icons.grid_view,
            ),
            onPressed: () {
              final newMode = viewMode == WorkoutViewMode.grid
                  ? WorkoutViewMode.list
                  : WorkoutViewMode.grid;
              ref.read(workoutViewModeProvider.notifier).state = newMode;
            },
          ),
          // Search
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: workouts.when(
        data: (workoutList) {
          if (workoutList.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(workoutsProvider.notifier).refresh();
            },
            child: viewMode == WorkoutViewMode.grid
                ? _buildGridView(context, workoutList)
                : _buildListView(context, workoutList),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading workouts: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(workoutsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.fitness_center_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No Workouts Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first workout to get started',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const WorkoutCreationScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Workout'),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(BuildContext context, List workoutList) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: workoutList.length,
      itemBuilder: (context, index) {
        final workout = workoutList[index];
        return _buildWorkoutCard(context, workout, isGrid: true);
      },
    );
  }

  Widget _buildListView(BuildContext context, List workoutList) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: workoutList.length,
      itemBuilder: (context, index) {
        final workout = workoutList[index];
        return _buildWorkoutCard(context, workout, isGrid: false);
      },
    );
  }

  Widget _buildWorkoutCard(BuildContext context, workout, {required bool isGrid}) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WorkoutDetailScreen(workoutId: workout.id),
            ),
          );
        },
        child: isGrid ? _buildGridCard(context, workout) : _buildListCard(context, workout),
      ),
    );
  }

  Widget _buildGridCard(BuildContext context, workout) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cover Image
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
            ),
            child: CachedNetworkImageWidget(
              imageId: workout.imageUrl,
              fit: BoxFit.cover,
              imageFitString: workout.imageFit,
              errorWidget: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                      Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        // Content
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    workout.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 2),
                Flexible(
                  child: Text(
                    '${workout.exercises.length} exercises • ${workout.estimatedDurationMinutes ?? 0} min',
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        workout.difficultyLevel.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (workout.isTemplate)
                      const Icon(
                        Icons.bookmark,
                        size: 14,
                        color: Colors.orange,
                      ),
                    if (workout.isPublic)
                      const Icon(
                        Icons.public,
                        size: 14,
                        color: Colors.green,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListCard(BuildContext context, workout) {
    return ListTile(
      contentPadding: const EdgeInsets.all(12),
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.surfaceContainer,
        ),
        child: CachedNetworkImageWidget(
          imageId: workout.imageUrl,
          fit: BoxFit.cover,
          imageFitString: workout.imageFit,
          width: 56,
          height: 56,
          borderRadius: BorderRadius.circular(8),
          errorWidget: Icon(
            Icons.fitness_center,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      title: Text(
        workout.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${workout.exercises.length} exercises • ${workout.estimatedDurationMinutes ?? 0} min'),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  workout.difficultyLevel.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  workout.workoutType.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (workout.isTemplate)
            const Icon(
              Icons.bookmark,
              size: 16,
              color: Colors.orange,
            ),
          if (workout.isPublic)
            const Icon(
              Icons.public,
              size: 16,
              color: Colors.green,
            ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}