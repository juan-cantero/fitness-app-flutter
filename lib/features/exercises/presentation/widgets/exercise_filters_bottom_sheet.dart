import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/models/exercise.dart' as models;
import '../../providers/exercises_providers.dart';

class ExerciseFiltersBottomSheet extends ConsumerStatefulWidget {
  const ExerciseFiltersBottomSheet({super.key});

  @override
  ConsumerState<ExerciseFiltersBottomSheet> createState() =>
      _ExerciseFiltersBottomSheetState();
}

class _ExerciseFiltersBottomSheetState
    extends ConsumerState<ExerciseFiltersBottomSheet> {
  late ExerciseFilterState _tempFilters;

  @override
  void initState() {
    super.initState();
    _tempFilters = ref.read(exerciseFiltersProvider);
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(exerciseCategoriesProvider);
    final equipmentAsync = ref.watch(exerciseEquipmentProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Exercises',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),

          // Filter content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Difficulty Level
                  _buildSectionTitle('Difficulty Level'),
                  const SizedBox(height: 12),
                  _buildDifficultyFilters(),
                  const SizedBox(height: 24),

                  // Exercise Type
                  _buildSectionTitle('Exercise Type'),
                  const SizedBox(height: 12),
                  _buildExerciseTypeFilters(),
                  const SizedBox(height: 24),

                  // Muscle Groups
                  _buildSectionTitle('Muscle Groups'),
                  const SizedBox(height: 12),
                  _buildMuscleGroupFilters(categoriesAsync),
                  const SizedBox(height: 24),

                  // Equipment
                  _buildSectionTitle('Equipment'),
                  const SizedBox(height: 12),
                  _buildEquipmentFilters(equipmentAsync),
                  const SizedBox(height: 24),

                  // Options
                  _buildSectionTitle('Options'),
                  const SizedBox(height: 12),
                  _buildOptionFilters(),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildDifficultyFilters() {
    const difficulties = ['beginner', 'intermediate', 'advanced'];
    
    return Wrap(
      spacing: 8,
      children: difficulties.map((difficulty) {
        final isSelected = _tempFilters.selectedDifficulty == difficulty;
        return FilterChip(
          label: Text(_capitalizeFirst(difficulty)),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _tempFilters = _tempFilters.copyWith(
                selectedDifficulty: selected ? difficulty : null,
              );
            });
          },
          selectedColor: _getDifficultyColor(difficulty).withOpacity(0.2),
          checkmarkColor: _getDifficultyColor(difficulty),
        );
      }).toList(),
    );
  }

  Widget _buildExerciseTypeFilters() {
    const exerciseTypes = ['strength', 'cardio', 'flexibility', 'balance'];
    
    return Wrap(
      spacing: 8,
      children: exerciseTypes.map((type) {
        final isSelected = _tempFilters.selectedExerciseType == type;
        return FilterChip(
          label: Text(_capitalizeFirst(type)),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _tempFilters = _tempFilters.copyWith(
                selectedExerciseType: selected ? type : null,
              );
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildMuscleGroupFilters(AsyncValue<List<models.Category>> categoriesAsync) {
    return categoriesAsync.when(
      data: (categories) {
        // Filter to get only muscle group categories
        final muscleGroups = categories
            .where((cat) => _isMuscleGroup(cat.name))
            .take(12) // Limit to most common muscle groups
            .toList();

        if (muscleGroups.isEmpty) {
          return const Text('No muscle groups available');
        }

        return Wrap(
          spacing: 8,
          runSpacing: 4,
          children: muscleGroups.map((category) {
            final isSelected = _tempFilters.selectedMuscleGroups.contains(category.name);
            return FilterChip(
              label: Text(category.name),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  final updatedGroups = List<String>.from(_tempFilters.selectedMuscleGroups);
                  if (selected) {
                    updatedGroups.add(category.name);
                  } else {
                    updatedGroups.remove(category.name);
                  }
                  _tempFilters = _tempFilters.copyWith(
                    selectedMuscleGroups: updatedGroups,
                  );
                });
              },
            );
          }).toList(),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error loading muscle groups: $error'),
    );
  }

  Widget _buildEquipmentFilters(AsyncValue<List<Equipment>> equipmentAsync) {
    return equipmentAsync.when(
      data: (equipment) {
        if (equipment.isEmpty) {
          return const Text('No equipment available');
        }

        return Wrap(
          spacing: 8,
          runSpacing: 4,
          children: equipment.take(10).map((eq) {
            final isSelected = _tempFilters.selectedEquipment.contains(eq.id);
            return FilterChip(
              label: Text(eq.name),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  final updatedEquipment = List<String>.from(_tempFilters.selectedEquipment);
                  if (selected) {
                    updatedEquipment.add(eq.id);
                  } else {
                    updatedEquipment.remove(eq.id);
                  }
                  _tempFilters = _tempFilters.copyWith(
                    selectedEquipment: updatedEquipment,
                  );
                });
              },
            );
          }).toList(),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error loading equipment: $error'),
    );
  }

  Widget _buildOptionFilters() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Public exercises only'),
          subtitle: const Text('Show only exercises available to everyone'),
          value: _tempFilters.showPublicOnly,
          onChanged: (value) {
            setState(() {
              _tempFilters = _tempFilters.copyWith(showPublicOnly: value);
            });
          },
        ),
      ],
    );
  }

  bool _isMuscleGroup(String categoryName) {
    const muscleGroups = {
      'chest', 'back', 'shoulders', 'biceps', 'triceps', 'legs', 'glutes',
      'abs', 'core', 'quadriceps', 'hamstrings', 'calves', 'forearms',
      'lats', 'delts', 'traps',
    };
    
    return muscleGroups.any((muscle) => 
      categoryName.toLowerCase().contains(muscle));
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _capitalizeFirst(String text) {
    return text.isNotEmpty 
        ? '${text[0].toUpperCase()}${text.substring(1)}'
        : text;
  }

  void _clearAllFilters() {
    setState(() {
      _tempFilters = const ExerciseFilterState();
    });
  }

  void _applyFilters() {
    ref.read(exerciseFiltersProvider.notifier).state = _tempFilters;
    ref.read(exercisesProvider.notifier).applyFilters(_tempFilters);
    Navigator.of(context).pop();
  }
}

/// Show exercise filters bottom sheet
void showExerciseFiltersBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const ExerciseFiltersBottomSheet(),
  );
}