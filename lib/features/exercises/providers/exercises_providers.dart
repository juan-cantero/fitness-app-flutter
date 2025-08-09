import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/models.dart';
import '../../../shared/models/exercise.dart' as models;
import '../../../shared/repositories/providers/repository_providers.dart';
import '../../../core/database/database_manager.dart';
import '../../../core/database/web_database_manager.dart';
import '../../../shared/repositories/interfaces/repository_interfaces.dart';
import '../../../shared/repositories/local/local_exercise_repository.dart';
import '../../../shared/repositories/local/web_exercise_repository.dart';

/// Exercise view mode enum
enum ExerciseViewMode {
  grid,
  list,
}

/// Exercise filter state
@immutable
class ExerciseFilterState {
  final List<String> selectedMuscleGroups;
  final List<String> selectedEquipment;
  final String? selectedDifficulty;
  final String? selectedExerciseType;
  final List<String> selectedCategories;
  final bool showPublicOnly;

  const ExerciseFilterState({
    this.selectedMuscleGroups = const [],
    this.selectedEquipment = const [],
    this.selectedDifficulty,
    this.selectedExerciseType,
    this.selectedCategories = const [],
    this.showPublicOnly = false,
  });

  ExerciseFilterState copyWith({
    List<String>? selectedMuscleGroups,
    List<String>? selectedEquipment,
    String? selectedDifficulty,
    String? selectedExerciseType,
    List<String>? selectedCategories,
    bool? showPublicOnly,
  }) {
    return ExerciseFilterState(
      selectedMuscleGroups: selectedMuscleGroups ?? this.selectedMuscleGroups,
      selectedEquipment: selectedEquipment ?? this.selectedEquipment,
      selectedDifficulty: selectedDifficulty ?? this.selectedDifficulty,
      selectedExerciseType: selectedExerciseType ?? this.selectedExerciseType,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      showPublicOnly: showPublicOnly ?? this.showPublicOnly,
    );
  }

  bool get hasActiveFilters =>
      selectedMuscleGroups.isNotEmpty ||
      selectedEquipment.isNotEmpty ||
      selectedDifficulty != null ||
      selectedExerciseType != null ||
      selectedCategories.isNotEmpty ||
      showPublicOnly;

  ExerciseFilter toRepositoryFilter() {
    return ExerciseFilter(
      muscleGroups: selectedMuscleGroups.isEmpty ? null : selectedMuscleGroups,
      equipmentIds: selectedEquipment.isEmpty ? null : selectedEquipment,
      difficultyLevel: selectedDifficulty,
      exerciseType: selectedExerciseType,
      isPublic: showPublicOnly ? true : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseFilterState &&
          runtimeType == other.runtimeType &&
          listEquals(selectedMuscleGroups, other.selectedMuscleGroups) &&
          listEquals(selectedEquipment, other.selectedEquipment) &&
          selectedDifficulty == other.selectedDifficulty &&
          selectedExerciseType == other.selectedExerciseType &&
          listEquals(selectedCategories, other.selectedCategories) &&
          showPublicOnly == other.showPublicOnly;

  @override
  int get hashCode =>
      Object.hash(
        Object.hashAll(selectedMuscleGroups),
        Object.hashAll(selectedEquipment),
        selectedDifficulty,
        selectedExerciseType,
        Object.hashAll(selectedCategories),
        showPublicOnly,
      );
}

/// Exercise pagination state
@immutable
class ExercisePaginationState {
  final int page;
  final int pageSize;
  final bool hasMore;
  final bool isLoading;

  const ExercisePaginationState({
    this.page = 0,
    this.pageSize = 20,
    this.hasMore = true,
    this.isLoading = false,
  });

  ExercisePaginationState copyWith({
    int? page,
    int? pageSize,
    bool? hasMore,
    bool? isLoading,
  }) {
    return ExercisePaginationState(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExercisePaginationState &&
          runtimeType == other.runtimeType &&
          page == other.page &&
          pageSize == other.pageSize &&
          hasMore == other.hasMore &&
          isLoading == other.isLoading;

  @override
  int get hashCode => Object.hash(page, pageSize, hasMore, isLoading);
}

/// Exercise search and listing state notifier
class ExercisesNotifier extends StateNotifier<AsyncValue<List<Exercise>>> {
  final IExerciseRepository _repository;
  String _currentQuery = '';
  ExerciseFilterState _currentFilters = const ExerciseFilterState();
  ExerciseSortBy _sortBy = ExerciseSortBy.name;
  bool _ascending = true;
  ExercisePaginationState _pagination = const ExercisePaginationState();
  List<Exercise> _allExercises = [];
  Timer? _debounceTimer;

  ExercisesNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadInitialExercises();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  // Getters
  String get currentQuery => _currentQuery;
  ExerciseFilterState get currentFilters => _currentFilters;
  ExerciseSortBy get sortBy => _sortBy;
  bool get ascending => _ascending;
  ExercisePaginationState get pagination => _pagination;
  List<Exercise> get allExercises => _allExercises;

  /// Load initial exercises
  Future<void> _loadInitialExercises() async {
    try {
      final exercises = await _repository.searchExercises(
        null,
        limit: _pagination.pageSize,
        sortBy: _sortBy,
        ascending: _ascending,
      );
      _allExercises = exercises;
      _pagination = _pagination.copyWith(
        hasMore: exercises.length >= _pagination.pageSize,
        isLoading: false,
      );
      state = AsyncValue.data(exercises);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Search exercises with debouncing
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
    
    await _loadExercises();
  }

  /// Apply filters
  void applyFilters(ExerciseFilterState filters) {
    if (_currentFilters == filters) return;

    _currentFilters = filters;
    _pagination = _pagination.copyWith(page: 0, hasMore: true);
    _loadExercises();
  }

  /// Clear all filters
  void clearFilters() {
    applyFilters(const ExerciseFilterState());
  }

  /// Update sorting
  void updateSort(ExerciseSortBy sortBy, {bool? ascending}) {
    if (_sortBy == sortBy && (ascending == null || _ascending == ascending)) {
      return;
    }

    _sortBy = sortBy;
    _ascending = ascending ?? true;
    _pagination = _pagination.copyWith(page: 0, hasMore: true);
    _loadExercises();
  }

  /// Load next page (for pagination)
  Future<void> loadNextPage() async {
    if (!_pagination.hasMore || _pagination.isLoading) return;

    _pagination = _pagination.copyWith(isLoading: true);

    try {
      final exercises = await _repository.searchExercises(
        _currentQuery.isEmpty ? null : _currentQuery,
        filter: _currentFilters.toRepositoryFilter(),
        sortBy: _sortBy,
        ascending: _ascending,
        limit: _pagination.pageSize,
        offset: (_pagination.page + 1) * _pagination.pageSize,
      );

      if (exercises.isNotEmpty) {
        _allExercises.addAll(exercises);
        _pagination = _pagination.copyWith(
          page: _pagination.page + 1,
          hasMore: exercises.length >= _pagination.pageSize,
          isLoading: false,
        );
        state = AsyncValue.data(_allExercises);
      } else {
        _pagination = _pagination.copyWith(hasMore: false, isLoading: false);
      }
    } catch (error, stackTrace) {
      _pagination = _pagination.copyWith(isLoading: false);
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Refresh exercises (pull to refresh)
  Future<void> refresh() async {
    _pagination = _pagination.copyWith(page: 0, hasMore: true, isLoading: true);
    _allExercises.clear();
    await _loadExercises();
  }

  /// Load exercises with current parameters
  Future<void> _loadExercises() async {
    if (mounted) {
      state = const AsyncValue.loading();
    }

    try {
      final exercises = await _repository.searchExercises(
        _currentQuery.isEmpty ? null : _currentQuery,
        filter: _currentFilters.toRepositoryFilter(),
        sortBy: _sortBy,
        ascending: _ascending,
        limit: _pagination.pageSize,
        offset: _pagination.page * _pagination.pageSize,
      );

      _allExercises = exercises;
      _pagination = _pagination.copyWith(
        hasMore: exercises.length >= _pagination.pageSize,
        isLoading: false,
      );

      if (mounted) {
        state = AsyncValue.data(exercises);
      }
    } catch (error, stackTrace) {
      _pagination = _pagination.copyWith(isLoading: false);
      if (mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }
}

/// Categories notifier for exercise filtering
class ExerciseCategoriesNotifier extends StateNotifier<AsyncValue<List<models.Category>>> {
  final IExerciseRepository _repository;

  ExerciseCategoriesNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      // Get all exercises first to extract unique categories
      final exercises = await _repository.getAll();
      final categoryNames = <String>{};
      
      for (final exercise in exercises) {
        categoryNames.addAll(exercise.primaryMuscleGroups);
        categoryNames.add(exercise.exerciseType);
        if (exercise.movementPattern != null) {
          categoryNames.add(exercise.movementPattern!);
        }
      }

      // Create category objects from unique names
      final categories = categoryNames.map((name) => models.Category(
        id: name.toLowerCase().replaceAll(' ', '_'),
        name: name,
        isActive: true,
        createdAt: DateTime.now(),
      )).toList();

      categories.sort((a, b) => a.name.compareTo(b.name));

      state = AsyncValue.data(categories);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() => _loadCategories();
}

/// Equipment options notifier
class ExerciseEquipmentNotifier extends StateNotifier<AsyncValue<List<Equipment>>> {
  final IEquipmentRepository _equipmentRepository;

  ExerciseEquipmentNotifier(this._equipmentRepository) : super(const AsyncValue.loading()) {
    _loadEquipment();
  }

  Future<void> _loadEquipment() async {
    try {
      final equipment = await _equipmentRepository.getAll(orderBy: 'name ASC');
      state = AsyncValue.data(equipment);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() => _loadEquipment();
}

/// Popular exercises provider
class PopularExercisesNotifier extends StateNotifier<AsyncValue<List<Exercise>>> {
  final IExerciseRepository _repository;

  PopularExercisesNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadPopularExercises();
  }

  Future<void> _loadPopularExercises() async {
    try {
      final exercises = await _repository.getPopularExercises(limit: 10);
      state = AsyncValue.data(exercises);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() => _loadPopularExercises();
}

// PROVIDERS

/// Simple exercise repository provider for local-first development
/// This bypasses the complex repository configuration system and works cross-platform
final simpleExerciseRepositoryProvider = Provider<IExerciseRepository>((ref) {
  if (kIsWeb) {
    final webDatabaseManager = WebDatabaseManager();
    return WebExerciseRepository(webDatabaseManager);
  } else {
    final databaseManager = DatabaseManager();
    return LocalExerciseRepository(databaseManager);
  }
});

/// Main exercises provider
final exercisesProvider = StateNotifierProvider<ExercisesNotifier, AsyncValue<List<Exercise>>>((ref) {
  return ExercisesNotifier(ref.watch(simpleExerciseRepositoryProvider));
});

/// Exercise view mode provider (grid/list toggle)
final exerciseViewModeProvider = StateProvider<ExerciseViewMode>((ref) {
  return ExerciseViewMode.grid;
});

/// Exercise filter state provider
final exerciseFiltersProvider = StateProvider<ExerciseFilterState>((ref) {
  return const ExerciseFilterState();
});

/// Exercise categories provider
final exerciseCategoriesProvider = StateNotifierProvider<ExerciseCategoriesNotifier, AsyncValue<List<models.Category>>>((ref) {
  return ExerciseCategoriesNotifier(ref.watch(simpleExerciseRepositoryProvider));
});

/// Exercise equipment provider
final exerciseEquipmentProvider = StateNotifierProvider<ExerciseEquipmentNotifier, AsyncValue<List<Equipment>>>((ref) {
  return ExerciseEquipmentNotifier(ref.watch(equipmentRepositoryProvider));
});

/// Popular exercises provider
final popularExercisesProvider = StateNotifierProvider<PopularExercisesNotifier, AsyncValue<List<Exercise>>>((ref) {
  return PopularExercisesNotifier(ref.watch(simpleExerciseRepositoryProvider));
});

/// Search query provider
final exerciseSearchQueryProvider = StateProvider<String>((ref) => '');

/// Exercise sort provider
final exerciseSortProvider = StateProvider<ExerciseSortBy>((ref) => ExerciseSortBy.name);

/// Exercise sort order provider
final exerciseSortAscendingProvider = StateProvider<bool>((ref) => true);

/// Filtered exercises provider (computed from main provider + filters)
final filteredExercisesProvider = Provider<AsyncValue<List<Exercise>>>((ref) {
  return ref.watch(exercisesProvider);
});

/// Exercise pagination provider
final exercisePaginationProvider = Provider<ExercisePaginationState>((ref) {
  final notifier = ref.watch(exercisesProvider.notifier);
  return notifier.pagination;
});

/// Exercise statistics provider
final exerciseStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  try {
    final repository = ref.watch(simpleExerciseRepositoryProvider);
    final totalCount = await repository.count();
    
    // Count by difficulty
    final beginnerCount = await repository.count('difficulty_level = ?', ['beginner']);
    final intermediateCount = await repository.count('difficulty_level = ?', ['intermediate']);
    final advancedCount = await repository.count('difficulty_level = ?', ['advanced']);
    
    // Count by type
    final strengthCount = await repository.count('exercise_type = ?', ['strength']);
    final cardioCount = await repository.count('exercise_type = ?', ['cardio']);
    final flexibilityCount = await repository.count('exercise_type = ?', ['flexibility']);
    
    return {
      'total': totalCount,
      'beginner': beginnerCount,
      'intermediate': intermediateCount,
      'advanced': advancedCount,
      'strength': strengthCount,
      'cardio': cardioCount,
      'flexibility': flexibilityCount,
    };
  } catch (e) {
    return {
      'total': 0,
      'beginner': 0,
      'intermediate': 0,
      'advanced': 0,
      'strength': 0,
      'cardio': 0,
      'flexibility': 0,
    };
  }
});

/// Individual exercise provider by ID
final exerciseByIdProvider = FutureProvider.family<Exercise?, String>((ref, exerciseId) async {
  final repository = ref.watch(simpleExerciseRepositoryProvider);
  return await repository.getById(exerciseId);
});

/// Similar exercises provider
final similarExercisesProvider = FutureProvider.family<List<Exercise>, String>((ref, exerciseId) async {
  final repository = ref.watch(simpleExerciseRepositoryProvider);
  return await repository.findSimilarExercises(exerciseId, limit: 6);
});

/// Exercise progressions provider
final exerciseProgressionsProvider = FutureProvider.family<List<Exercise>, String>((ref, exerciseId) async {
  final repository = ref.watch(simpleExerciseRepositoryProvider);
  return await repository.getProgressions(exerciseId);
});

/// Exercise regressions provider
final exerciseRegressionsProvider = FutureProvider.family<List<Exercise>, String>((ref, exerciseId) async {
  final repository = ref.watch(simpleExerciseRepositoryProvider);
  return await repository.getRegressions(exerciseId);
});