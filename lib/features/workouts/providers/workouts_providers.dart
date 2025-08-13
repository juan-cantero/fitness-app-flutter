import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/models.dart';
import '../../../core/database/database_manager.dart';
import '../../../core/database/web_database_manager.dart';
import '../../../shared/repositories/interfaces/repository_interfaces.dart';
import '../../../shared/repositories/local/local_workout_repository.dart';
import '../../../shared/repositories/local/web_workout_repository.dart';

/// Workout view mode enum
enum WorkoutViewMode {
  grid,
  list,
}

/// Workout filter state
@immutable
class WorkoutFilterState {
  final List<String> selectedMuscleGroups;
  final List<String> selectedEquipment;
  final String? selectedDifficulty;
  final String? selectedWorkoutType;
  final String? selectedIntensity;
  final bool showTemplatesOnly;
  final bool showPublicOnly;

  const WorkoutFilterState({
    this.selectedMuscleGroups = const [],
    this.selectedEquipment = const [],
    this.selectedDifficulty,
    this.selectedWorkoutType,
    this.selectedIntensity,
    this.showTemplatesOnly = false,
    this.showPublicOnly = false,
  });

  WorkoutFilterState copyWith({
    List<String>? selectedMuscleGroups,
    List<String>? selectedEquipment,
    String? selectedDifficulty,
    String? selectedWorkoutType,
    String? selectedIntensity,
    bool? showTemplatesOnly,
    bool? showPublicOnly,
  }) {
    return WorkoutFilterState(
      selectedMuscleGroups: selectedMuscleGroups ?? this.selectedMuscleGroups,
      selectedEquipment: selectedEquipment ?? this.selectedEquipment,
      selectedDifficulty: selectedDifficulty ?? this.selectedDifficulty,
      selectedWorkoutType: selectedWorkoutType ?? this.selectedWorkoutType,
      selectedIntensity: selectedIntensity ?? this.selectedIntensity,
      showTemplatesOnly: showTemplatesOnly ?? this.showTemplatesOnly,
      showPublicOnly: showPublicOnly ?? this.showPublicOnly,
    );
  }

  bool get hasActiveFilters =>
      selectedMuscleGroups.isNotEmpty ||
      selectedEquipment.isNotEmpty ||
      selectedDifficulty != null ||
      selectedWorkoutType != null ||
      selectedIntensity != null ||
      showTemplatesOnly ||
      showPublicOnly;

  WorkoutFilter toRepositoryFilter() {
    return WorkoutFilter(
      targetMuscleGroups: selectedMuscleGroups.isEmpty ? null : selectedMuscleGroups,
      equipmentNeeded: selectedEquipment.isEmpty ? null : selectedEquipment,
      difficultyLevel: selectedDifficulty,
      workoutType: selectedWorkoutType,
      intensityLevel: selectedIntensity,
      isTemplate: showTemplatesOnly ? true : null,
      isPublic: showPublicOnly ? true : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutFilterState &&
          runtimeType == other.runtimeType &&
          listEquals(selectedMuscleGroups, other.selectedMuscleGroups) &&
          listEquals(selectedEquipment, other.selectedEquipment) &&
          selectedDifficulty == other.selectedDifficulty &&
          selectedWorkoutType == other.selectedWorkoutType &&
          selectedIntensity == other.selectedIntensity &&
          showTemplatesOnly == other.showTemplatesOnly &&
          showPublicOnly == other.showPublicOnly;

  @override
  int get hashCode =>
      Object.hash(
        Object.hashAll(selectedMuscleGroups),
        Object.hashAll(selectedEquipment),
        selectedDifficulty,
        selectedWorkoutType,
        selectedIntensity,
        showTemplatesOnly,
        showPublicOnly,
      );
}

/// Workout pagination state
@immutable
class WorkoutPaginationState {
  final int page;
  final int pageSize;
  final bool hasMore;
  final bool isLoading;

  const WorkoutPaginationState({
    this.page = 0,
    this.pageSize = 20,
    this.hasMore = true,
    this.isLoading = false,
  });

  WorkoutPaginationState copyWith({
    int? page,
    int? pageSize,
    bool? hasMore,
    bool? isLoading,
  }) {
    return WorkoutPaginationState(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutPaginationState &&
          runtimeType == other.runtimeType &&
          page == other.page &&
          pageSize == other.pageSize &&
          hasMore == other.hasMore &&
          isLoading == other.isLoading;

  @override
  int get hashCode => Object.hash(page, pageSize, hasMore, isLoading);
}

/// Workout search and listing state notifier
class WorkoutsNotifier extends StateNotifier<AsyncValue<List<Workout>>> {
  final IWorkoutRepository _repository;
  String _currentQuery = '';
  WorkoutFilterState _currentFilters = const WorkoutFilterState();
  WorkoutSortBy _sortBy = WorkoutSortBy.name;
  bool _ascending = true;
  WorkoutPaginationState _pagination = const WorkoutPaginationState();
  List<Workout> _allWorkouts = [];
  Timer? _debounceTimer;

  WorkoutsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadInitialWorkouts();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  // Getters
  String get currentQuery => _currentQuery;
  WorkoutFilterState get currentFilters => _currentFilters;
  WorkoutSortBy get sortBy => _sortBy;
  bool get ascending => _ascending;
  WorkoutPaginationState get pagination => _pagination;
  List<Workout> get allWorkouts => _allWorkouts;

  /// Load initial workouts
  Future<void> _loadInitialWorkouts() async {
    try {
      final workouts = await _repository.searchWorkouts(
        null,
        limit: _pagination.pageSize,
        sortBy: _sortBy,
        ascending: _ascending,
      );
      _allWorkouts = workouts;
      _pagination = _pagination.copyWith(
        hasMore: workouts.length >= _pagination.pageSize,
        isLoading: false,
      );
      state = AsyncValue.data(workouts);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Search workouts with debouncing
  void search(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query);
    });
  }

  /// Perform the actual search
  Future<void> _performSearch(String query) async {
    if (_currentQuery == query) return;

    _currentQuery = query;
    _pagination = _pagination.copyWith(page: 0, isLoading: true, hasMore: true);
    
    await _loadWorkouts();
  }

  /// Apply filters
  void applyFilters(WorkoutFilterState filters) {
    if (_currentFilters == filters) return;

    _currentFilters = filters;
    _pagination = _pagination.copyWith(page: 0, hasMore: true);
    _loadWorkouts();
  }

  /// Clear all filters
  void clearFilters() {
    applyFilters(const WorkoutFilterState());
  }

  /// Update sorting
  void updateSort(WorkoutSortBy sortBy, {bool? ascending}) {
    if (_sortBy == sortBy && (ascending == null || _ascending == ascending)) {
      return;
    }

    _sortBy = sortBy;
    _ascending = ascending ?? true;
    _pagination = _pagination.copyWith(page: 0, hasMore: true);
    _loadWorkouts();
  }

  /// Load next page (for pagination)
  Future<void> loadNextPage() async {
    if (!_pagination.hasMore || _pagination.isLoading) return;

    _pagination = _pagination.copyWith(isLoading: true);

    try {
      final workouts = await _repository.searchWorkouts(
        _currentQuery.isEmpty ? null : _currentQuery,
        filter: _currentFilters.toRepositoryFilter(),
        sortBy: _sortBy,
        ascending: _ascending,
        limit: _pagination.pageSize,
        offset: (_pagination.page + 1) * _pagination.pageSize,
      );

      if (workouts.isNotEmpty) {
        _allWorkouts.addAll(workouts);
        _pagination = _pagination.copyWith(
          page: _pagination.page + 1,
          hasMore: workouts.length >= _pagination.pageSize,
          isLoading: false,
        );
        state = AsyncValue.data(_allWorkouts);
      } else {
        _pagination = _pagination.copyWith(hasMore: false, isLoading: false);
      }
    } catch (error, stackTrace) {
      _pagination = _pagination.copyWith(isLoading: false);
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Refresh workouts (pull to refresh)
  Future<void> refresh() async {
    _pagination = _pagination.copyWith(page: 0, hasMore: true, isLoading: true);
    _allWorkouts.clear();
    await _loadWorkouts();
  }

  /// Load workouts with current parameters
  Future<void> _loadWorkouts() async {
    if (mounted) {
      state = const AsyncValue.loading();
    }

    try {
      final workouts = await _repository.searchWorkouts(
        _currentQuery.isEmpty ? null : _currentQuery,
        filter: _currentFilters.toRepositoryFilter(),
        sortBy: _sortBy,
        ascending: _ascending,
        limit: _pagination.pageSize,
        offset: _pagination.page * _pagination.pageSize,
      );

      _allWorkouts = workouts;
      _pagination = _pagination.copyWith(
        hasMore: workouts.length >= _pagination.pageSize,
        isLoading: false,
      );

      if (mounted) {
        state = AsyncValue.data(workouts);
      }
    } catch (error, stackTrace) {
      _pagination = _pagination.copyWith(isLoading: false);
      if (mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }
}

/// Popular workouts notifier
class PopularWorkoutsNotifier extends StateNotifier<AsyncValue<List<Workout>>> {
  final IWorkoutRepository _repository;

  PopularWorkoutsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadPopularWorkouts();
  }

  Future<void> _loadPopularWorkouts() async {
    try {
      final workouts = await _repository.getPopularWorkouts(limit: 10);
      state = AsyncValue.data(workouts);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() => _loadPopularWorkouts();
}

// PROVIDERS

// Global cached repository to prevent multiple database manager creation
IWorkoutRepository? _globalWorkoutRepository;

/// Simple workout repository provider for local-first development
final workoutRepositoryProvider = Provider<IWorkoutRepository>((ref) {
  if (_globalWorkoutRepository != null) {
    return _globalWorkoutRepository!;
  }
  
  if (kIsWeb) {
    final webDatabaseManager = WebDatabaseManager();
    _globalWorkoutRepository = WebWorkoutRepository(webDatabaseManager);
  } else {
    final databaseManager = DatabaseManager();
    _globalWorkoutRepository = LocalWorkoutRepository(databaseManager);
  }
  
  return _globalWorkoutRepository!;
});

/// Helper method to refresh workout providers with targeted invalidations
void refreshWorkoutProviders(Ref ref, Workout updatedWorkout) {
  // Targeted invalidation - only refresh what actually changed
  ref.invalidate(workoutByIdProvider(updatedWorkout.id));
  
  // For lists and stats, invalidate entire provider  
  ref.invalidate(workoutsProvider);
  ref.invalidate(popularWorkoutsProvider);
  ref.invalidate(workoutStatsProvider);
}

/// Main workouts provider
final workoutsProvider = StateNotifierProvider<WorkoutsNotifier, AsyncValue<List<Workout>>>((ref) {
  return WorkoutsNotifier(ref.watch(workoutRepositoryProvider));
});

/// Workout view mode provider (grid/list toggle)
final workoutViewModeProvider = StateProvider<WorkoutViewMode>((ref) {
  return WorkoutViewMode.grid;
});

/// Workout filter state provider
final workoutFiltersProvider = StateProvider<WorkoutFilterState>((ref) {
  return const WorkoutFilterState();
});

/// Popular workouts provider
final popularWorkoutsProvider = StateNotifierProvider<PopularWorkoutsNotifier, AsyncValue<List<Workout>>>((ref) {
  return PopularWorkoutsNotifier(ref.watch(workoutRepositoryProvider));
});

/// Search query provider
final workoutSearchQueryProvider = StateProvider<String>((ref) => '');

/// Workout sort provider
final workoutSortProvider = StateProvider<WorkoutSortBy>((ref) => WorkoutSortBy.name);

/// Workout sort order provider
final workoutSortAscendingProvider = StateProvider<bool>((ref) => true);

/// Filtered workouts provider (computed from main provider + filters)
final filteredWorkoutsProvider = Provider<AsyncValue<List<Workout>>>((ref) {
  return ref.watch(workoutsProvider);
});

/// Workout pagination provider
final workoutPaginationProvider = Provider<WorkoutPaginationState>((ref) {
  final notifier = ref.watch(workoutsProvider.notifier);
  return notifier.pagination;
});

/// Workout statistics provider
final workoutStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  try {
    final repository = ref.watch(workoutRepositoryProvider);
    final totalCount = await repository.count();
    
    // Count by difficulty
    final beginnerCount = await repository.count('difficulty_level = ?', ['beginner']);
    final intermediateCount = await repository.count('difficulty_level = ?', ['intermediate']);
    final advancedCount = await repository.count('difficulty_level = ?', ['advanced']);
    
    // Count by type
    final strengthCount = await repository.count('workout_type = ?', ['strength']);
    final cardioCount = await repository.count('workout_type = ?', ['cardio']);
    final hiitCount = await repository.count('workout_type = ?', ['hiit']);
    
    return {
      'total': totalCount,
      'beginner': beginnerCount,
      'intermediate': intermediateCount,
      'advanced': advancedCount,
      'strength': strengthCount,
      'cardio': cardioCount,
      'hiit': hiitCount,
    };
  } catch (e) {
    return {
      'total': 0,
      'beginner': 0,
      'intermediate': 0,
      'advanced': 0,
      'strength': 0,
      'cardio': 0,
      'hiit': 0,
    };
  }
});

/// Individual workout provider by ID
final workoutByIdProvider = FutureProvider.family<Workout?, String>((ref, workoutId) async {
  final repository = ref.watch(workoutRepositoryProvider);
  return await repository.getById(workoutId);
});

/// Workout templates provider
final workoutTemplatesProvider = FutureProvider<List<Workout>>((ref) async {
  final repository = ref.watch(workoutRepositoryProvider);
  return await repository.getTemplates(limit: 20);
});