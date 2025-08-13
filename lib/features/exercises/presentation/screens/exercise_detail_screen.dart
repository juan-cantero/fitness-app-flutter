import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/exercises_providers.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/services/image_storage_service.dart';
import '../widgets/exercise_image_gallery.dart';
import '../widgets/exercise_info_card.dart';
import '../widgets/exercise_actions_bar.dart';

class ExerciseDetailScreen extends ConsumerStatefulWidget {
  final String exerciseId;
  
  const ExerciseDetailScreen({
    super.key,
    required this.exerciseId,
  });

  @override
  ConsumerState<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends ConsumerState<ExerciseDetailScreen> {
  bool _isGalleryExpanded = false;

  @override
  Widget build(BuildContext context) {
    final exerciseAsync = ref.watch(exerciseByIdProvider(widget.exerciseId));
    final similarExercises = ref.watch(similarExercisesProvider(widget.exerciseId));
    
    return Scaffold(
      body: exerciseAsync.when(
        data: (exercise) {
          if (exercise == null) {
            return _buildNotFound(context);
          }
          return _buildExerciseDetail(context, ref, exercise, similarExercises);
        },
        loading: () => _buildLoading(),
        error: (error, stack) => _buildError(context, error),
      ),
    );
  }

  Widget _buildExerciseDetail(
    BuildContext context, 
    WidgetRef ref, 
    Exercise exercise, 
    AsyncValue<List<Exercise>> similarExercises
  ) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context, exercise),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image gallery - show only additional images (excluding cover)
                _buildImageGallery(context, exercise),
                
                const SizedBox(height: 16),
                
                // Exercise actions
                ExerciseActionsBar(exercise: exercise),
                
                const SizedBox(height: 24),
                
                // Exercise information cards
                ExerciseInfoCard(
                  title: 'Instructions',
                  icon: Icons.format_list_bulleted_outlined,
                  child: Text(
                    exercise.instructions ?? 'No instructions available',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                if (exercise.description != null && exercise.description!.isNotEmpty)
                  ExerciseInfoCard(
                    title: 'Description',
                    icon: Icons.description_outlined,
                    child: Text(
                      exercise.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                
                const SizedBox(height: 16),
                
                // Exercise details grid
                _buildDetailsGrid(context, exercise),
                
                const SizedBox(height: 16),
                
                // Muscle groups
                if (exercise.primaryMuscleGroups.isNotEmpty)
                  ExerciseInfoCard(
                    title: 'Primary Muscles',
                    icon: Icons.fitness_center_outlined,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: exercise.primaryMuscleGroups
                          .map((muscle) => _buildMuscleChip(context, muscle, isPrimary: true))
                          .toList(),
                    ),
                  ),
                
                if (exercise.secondaryMuscleGroups.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ExerciseInfoCard(
                    title: 'Secondary Muscles',
                    icon: Icons.fitness_center,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: exercise.secondaryMuscleGroups
                          .map((muscle) => _buildMuscleChip(context, muscle, isPrimary: false))
                          .toList(),
                    ),
                  ),
                ],
                
                const SizedBox(height: 16),
                
                // Equipment required
                if (exercise.equipmentRequired.isNotEmpty)
                  ExerciseInfoCard(
                    title: 'Equipment Required',
                    icon: Icons.sports_gymnastics_outlined,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: exercise.equipmentRequired
                          .map((equipment) => _buildEquipmentChip(context, equipment))
                          .toList(),
                    ),
                  ),
                
                const SizedBox(height: 16),
                
                // Safety notes and tips
                if (exercise.safetyNotes != null && exercise.safetyNotes!.isNotEmpty)
                  ExerciseInfoCard(
                    title: 'Safety Notes',
                    icon: Icons.warning_outlined,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_outlined,
                            color: Theme.of(context).colorScheme.error,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              exercise.safetyNotes!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                const SizedBox(height: 16),
                
                // Common mistakes
                if (exercise.commonMistakes.isNotEmpty)
                  ExerciseInfoCard(
                    title: 'Common Mistakes',
                    icon: Icons.error_outline,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: exercise.commonMistakes
                          .map((mistake) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.close,
                                      color: Theme.of(context).colorScheme.error,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        mistake,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                
                const SizedBox(height: 24),
                
                // Similar exercises
                similarExercises.when(
                  data: (exercises) {
                    if (exercises.isEmpty) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Similar Exercises',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: exercises.length,
                            itemBuilder: (context, index) {
                              final similarExercise = exercises[index];
                              return _buildSimilarExerciseCard(context, similarExercise);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Exercise exercise) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          exercise.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 3,
                color: Colors.black45,
              ),
            ],
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                Theme.of(context).colorScheme.primary,
              ],
            ),
          ),
          child: exercise.imageUrl != null || exercise.demonstrationImages.isNotEmpty
              ? _buildCoverImage(context, exercise)
              : _buildDefaultHeader(context),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            context.push('/exercise/${widget.exerciseId}/edit');
          },
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () {
            // TODO: Implement favorite functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Favorite functionality coming soon')),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            // TODO: Implement share functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Share functionality coming soon')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDefaultHeader(BuildContext context) {
    return Center(
      child: Icon(
        Icons.sports_gymnastics,
        size: 80,
        color: Colors.white.withValues(alpha: 0.7),
      ),
    );
  }

  Widget _buildCoverImage(BuildContext context, Exercise exercise) {
    // Get the first image ID (cover image)
    String? imageId = exercise.imageUrl;
    if (imageId == null && exercise.demonstrationImages.isNotEmpty) {
      imageId = exercise.demonstrationImages.first;
    }
    
    if (imageId == null) {
      return _buildDefaultHeader(context);
    }
    
    return FutureBuilder<ImageMetadata?>(
      future: const ImageStorageService().getImageMetadata(imageId),
      builder: (context, metadataSnapshot) {
        if (metadataSnapshot.connectionState == ConnectionState.waiting) {
          return _buildDefaultHeader(context);
        }
        
        if (metadataSnapshot.hasData && metadataSnapshot.data != null) {
          return FutureBuilder<Uint8List?>(
            future: const ImageStorageService().getImageData(metadataSnapshot.data!),
            builder: (context, imageSnapshot) {
              if (imageSnapshot.connectionState == ConnectionState.waiting) {
                return _buildDefaultHeader(context);
              }
              
              if (imageSnapshot.hasData && imageSnapshot.data != null) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(imageSnapshot.data!),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withValues(alpha: 0.3),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                );
              }
              
              return _buildDefaultHeader(context);
            },
          );
        }
        
        return _buildDefaultHeader(context);
      },
    );
  }

  Widget _buildImageGallery(BuildContext context, Exercise exercise) {
    // Additional images shows ALL demonstration images (including the cover)
    // The term "additional" means additional ways to view the exercise images
    List<String> additionalImages = exercise.demonstrationImages;
    
    // Only show gallery if there are demonstration images to display
    if (additionalImages.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Collapsible header button
        InkWell(
          onTap: () {
            setState(() {
              _isGalleryExpanded = !_isGalleryExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text(
                  'Additional Images (${additionalImages.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 200),
                  turns: _isGalleryExpanded ? 0.5 : 0,
                  child: Icon(
                    Icons.expand_more,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Collapsible gallery content
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _isGalleryExpanded
              ? Column(
                  children: [
                    const SizedBox(height: 8),
                    ExerciseImageGallery(
                      images: additionalImages,
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildDetailsGrid(BuildContext context, Exercise exercise) {
    final details = <MapEntry<String, String>>[];
    
    details.add(MapEntry('Difficulty', exercise.difficultyLevel.toUpperCase()));
    details.add(MapEntry('Type', exercise.exerciseType.toUpperCase()));
    
    if (exercise.movementPattern != null) {
      details.add(MapEntry('Pattern', exercise.movementPattern!.toUpperCase()));
    }
    
    if (exercise.setupTimeSeconds > 0) {
      details.add(MapEntry('Setup Time', '${exercise.setupTimeSeconds}s'));
    }
    
    if (exercise.caloriesPerMinute != null) {
      details.add(MapEntry('Calories/min', '${exercise.caloriesPerMinute!.round()}'));
    }
    
    return ExerciseInfoCard(
      title: 'Exercise Details',
      icon: Icons.info_outlined,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: details.length,
        itemBuilder: (context, index) {
          final detail = details[index];
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  detail.value,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detail.key,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMuscleChip(BuildContext context, String muscle, {required bool isPrimary}) {
    return Chip(
      label: Text(
        muscle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: isPrimary ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      backgroundColor: isPrimary 
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      side: isPrimary 
          ? BorderSide(color: Theme.of(context).colorScheme.primary)
          : null,
    );
  }

  Widget _buildEquipmentChip(BuildContext context, String equipment) {
    return Chip(
      label: Text(equipment),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      avatar: Icon(
        Icons.fitness_center,
        size: 16,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  Widget _buildSimilarExerciseCard(BuildContext context, Exercise exercise) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            context.pushReplacement('/exercise/${exercise.id}');
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                child: Center(
                  child: Icon(
                    Icons.sports_gymnastics,
                    size: 40,
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        exercise.difficultyLevel.toUpperCase(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotFound(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Exercise Not Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The requested exercise could not be found.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildError(BuildContext context, Object error) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
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
              'Error Loading Exercise',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}