import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/exercises_providers.dart';
import '../widgets/exercise_card.dart';
import '../widgets/exercise_search_delegate.dart';
import '../widgets/exercise_filters_bottom_sheet.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/repositories/interfaces/repository_interfaces.dart';

class ExercisesScreen extends ConsumerStatefulWidget {
  const ExercisesScreen({super.key});

  @override
  ConsumerState<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends ConsumerState<ExercisesScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Hide/show FAB based on scroll direction
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_showFab) setState(() => _showFab = false);
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_showFab) setState(() => _showFab = true);
    }

    // Load more exercises when approaching the bottom
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(exercisesProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(exercisesProvider);
    final viewMode = ref.watch(exerciseViewModeProvider);
    final filters = ref.watch(exerciseFiltersProvider);
    final pagination = ref.watch(exercisePaginationProvider);
    final stats = ref.watch(exerciseStatsProvider);

    return Scaffold(
      appBar: _buildAppBar(context, filters),
      body: Column(
        children: [
          // Stats bar
          stats.when(
            data: (statsData) => _buildStatsBar(statsData),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          
          // Filter chips
          if (filters.hasActiveFilters) _buildActiveFiltersChips(filters),
          
          // Main content
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(exercisesProvider.notifier).refresh(),
              child: exercisesAsync.when(
                data: (exercises) => _buildExercisesList(exercises, viewMode, pagination),
                loading: () => _buildLoadingState(),
                error: (error, stackTrace) => _buildErrorState(error),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _showFab
          ? FloatingActionButton(
              onPressed: _showCreateExerciseDialog,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ExerciseFilterState filters) {
    final viewMode = ref.watch(exerciseViewModeProvider);
    
    return AppBar(
      title: const Text('Exercises'),
      actions: [
        // Search
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: ExerciseSearchDelegate(ref),
            );
          },
        ),
        
        // View mode toggle
        IconButton(
          icon: Icon(
            viewMode == ExerciseViewMode.grid 
                ? Icons.view_list 
                : Icons.grid_view,
          ),
          onPressed: () {
            ref.read(exerciseViewModeProvider.notifier).state = 
                viewMode == ExerciseViewMode.grid 
                    ? ExerciseViewMode.list 
                    : ExerciseViewMode.grid;
          },
        ),
        
        // Filters
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.filter_list),
              if (filters.hasActiveFilters)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          onPressed: () => showExerciseFiltersBottomSheet(context),
        ),
        
        // Sort menu
        PopupMenuButton<ExerciseSortBy>(
          icon: const Icon(Icons.sort),
          onSelected: (sortBy) {
            ref.read(exercisesProvider.notifier).updateSort(sortBy);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: ExerciseSortBy.name,
              child: Text('Name'),
            ),
            const PopupMenuItem(
              value: ExerciseSortBy.difficulty,
              child: Text('Difficulty'),
            ),
            const PopupMenuItem(
              value: ExerciseSortBy.muscleGroups,
              child: Text('Muscle Groups'),
            ),
            const PopupMenuItem(
              value: ExerciseSortBy.popularity,
              child: Text('Popularity'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsBar(Map<String, int> stats) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          _buildStatItem('Total', stats['total'] ?? 0),
          const SizedBox(width: 16),
          _buildStatItem('Strength', stats['strength'] ?? 0),
          const SizedBox(width: 16),
          _buildStatItem('Cardio', stats['cardio'] ?? 0),
          const Spacer(),
          Text(
            '${stats['total'] ?? 0} exercises available',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count.toString(),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveFiltersChips(ExerciseFilterState filters) {
    final activeFilters = <String>[];
    
    if (filters.selectedDifficulty != null) {
      activeFilters.add('Difficulty: ${filters.selectedDifficulty!}');
    }
    if (filters.selectedExerciseType != null) {
      activeFilters.add('Type: ${filters.selectedExerciseType!}');
    }
    if (filters.selectedMuscleGroups.isNotEmpty) {
      activeFilters.add('Muscles: ${filters.selectedMuscleGroups.length}');
    }
    if (filters.selectedEquipment.isNotEmpty) {
      activeFilters.add('Equipment: ${filters.selectedEquipment.length}');
    }
    if (filters.showPublicOnly) {
      activeFilters.add('Public only');
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: activeFilters.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return Chip(
                    label: Text(
                      activeFilters[index],
                      style: const TextStyle(fontSize: 12),
                    ),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {
                      // Clear specific filter (simplified implementation)
                      ref.read(exercisesProvider.notifier).clearFilters();
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                },
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(exercisesProvider.notifier).clearFilters();
              ref.read(exerciseFiltersProvider.notifier).state = const ExerciseFilterState();
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  Widget _buildExercisesList(
    List<Exercise> exercises, 
    ExerciseViewMode viewMode,
    ExercisePaginationState pagination,
  ) {
    if (exercises.isEmpty) {
      return _buildEmptyState();
    }

    if (viewMode == ExerciseViewMode.grid) {
      return _buildGridView(exercises, pagination);
    } else {
      return _buildListView(exercises, pagination);
    }
  }

  Widget _buildGridView(List<Exercise> exercises, ExercisePaginationState pagination) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: exercises.length + (pagination.isLoading ? 2 : 0),
      itemBuilder: (context, index) {
        if (index >= exercises.length) {
          return _buildLoadingCard();
        }
        return ExerciseCard(exercise: exercises[index]);
      },
    );
  }

  Widget _buildListView(List<Exercise> exercises, ExercisePaginationState pagination) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: exercises.length + (pagination.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= exercises.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return ExerciseListItem(exercise: exercises[index]);
      },
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading exercises...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
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
            'Failed to load exercises',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(exercisesProvider.notifier).refresh();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_gymnastics,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No exercises found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(exercisesProvider.notifier).clearFilters();
              ref.read(exerciseFiltersProvider.notifier).state = const ExerciseFilterState();
            },
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  void _showCreateExerciseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Exercise'),
        content: const Text(
          'Exercise creation will be implemented in a future update. '
          'For now, you can explore the existing exercise library.',
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
}