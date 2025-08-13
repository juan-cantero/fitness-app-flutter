import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/services/image_storage_service.dart';
import '../../providers/exercise_creation_providers.dart';
import '../../../../core/config/theme_config.dart';

/// Exercise card widget for grid display
class ExerciseCard extends ConsumerWidget {
  final Exercise exercise;
  final VoidCallback? onTap;

  const ExerciseCard({
    super.key,
    required this.exercise,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ?? () => context.push('/exercise/${exercise.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise image or placeholder
            Expanded(
              flex: 3,
              child: _buildExerciseImage(ref),
            ),
            
            // Exercise details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Exercise name
                    Flexible(
                      child: Text(
                        exercise.name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    // Difficulty level
                    Row(
                      children: [
                        _buildDifficultyChip(exercise.difficultyLevel),
                        const SizedBox(width: 6),
                        if (exercise.requiresSpotter)
                          Icon(
                            Icons.supervisor_account,
                            size: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    
                    // Primary muscle groups
                    if (exercise.primaryMuscleGroups.isNotEmpty)
                      Flexible(
                        child: Text(
                          exercise.primaryMuscleGroups.take(2).join(', '),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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

  Widget _buildExerciseImage(WidgetRef ref) {
    // Check if exercise has uploaded images
    final hasUploadedImages = exercise.demonstrationImages.isNotEmpty || 
                              (exercise.imageUrl != null && exercise.imageUrl!.isNotEmpty);
    
    if (hasUploadedImages) {
      // Try to load the first available image
      final imageSource = exercise.imageUrl ?? 
                         (exercise.demonstrationImages.isNotEmpty 
                          ? exercise.demonstrationImages.first 
                          : null);
      
      if (imageSource != null) {
        return _buildUploadedImageDisplay(ref, imageSource);
      }
    }
    
    // Fallback to placeholder with gradient and icon
    return _buildPlaceholder();
  }

  Widget _buildUploadedImageDisplay(WidgetRef ref, String imageSource) {
    final imageStorageService = ref.watch(imageStorageServiceProvider);
    
    return FutureBuilder<ImageMetadata?>(
      future: _findImageMetadata(imageStorageService, imageSource),
      builder: (context, metadataSnapshot) {
        if (metadataSnapshot.hasData && metadataSnapshot.data != null) {
          return FutureBuilder<Uint8List?>(
            future: imageStorageService.getImageData(metadataSnapshot.data!),
            builder: (context, imageSnapshot) {
              if (imageSnapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingPlaceholder();
              } else if (imageSnapshot.hasData && imageSnapshot.data != null) {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(imageSnapshot.data!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Optional overlay to improve text readability
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return _buildPlaceholder();
              }
            },
          );
        } else {
          return _buildPlaceholder();
        }
      },
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: _getExerciseTypeGradient(exercise.exerciseType),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: _getExerciseTypeGradient(exercise.exerciseType),
      ),
      child: Center(
        child: Icon(
          _getExerciseTypeIcon(exercise.exerciseType),
          size: 32,
          color: Colors.white.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Future<ImageMetadata?> _findImageMetadata(ImageStorageService service, String imageId) async {
    try {
      // Now we store proper image IDs, so we can use the service to get metadata
      return await service.getImageMetadata(imageId);
    } catch (e) {
      return null;
    }
  }

  Widget _buildDifficultyChip(String difficulty) {
    final color = _getDifficultyColor(difficulty);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        difficulty.toUpperCase(),
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  LinearGradient _getExerciseTypeGradient(String exerciseType) {
    switch (exerciseType.toLowerCase()) {
      case 'strength':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
        );
      case 'cardio':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)],
        );
      case 'flexibility':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF388E3C), Color(0xFF1B5E20)],
        );
      case 'balance':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7B1FA2), Color(0xFF4A148C)],
        );
      default:
        return ThemeConfig.primaryGradient;
    }
  }

  IconData _getExerciseTypeIcon(String exerciseType) {
    switch (exerciseType.toLowerCase()) {
      case 'strength':
        return Icons.fitness_center;
      case 'cardio':
        return Icons.directions_run;
      case 'flexibility':
        return Icons.self_improvement;
      case 'balance':
        return Icons.balance;
      default:
        return Icons.sports_gymnastics;
    }
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
}

/// Exercise list item widget for list display
class ExerciseListItem extends ConsumerWidget {
  final Exercise exercise;
  final VoidCallback? onTap;

  const ExerciseListItem({
    super.key,
    required this.exercise,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap ?? () => context.push('/exercise/${exercise.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Exercise image or icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildListItemImage(ref),
                ),
              ),
              const SizedBox(width: 16),
              
              // Exercise details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Exercise name
                    Text(
                      exercise.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    
                    // Description or muscle groups
                    Text(
                      exercise.description?.isNotEmpty == true
                          ? exercise.description!
                          : exercise.primaryMuscleGroups.join(', '),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    
                    // Tags and badges
                    Row(
                      children: [
                        _buildDifficultyChip(exercise.difficultyLevel),
                        const SizedBox(width: 8),
                        _buildTypeChip(context, exercise.exerciseType),
                        if (exercise.requiresSpotter) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.supervisor_account,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              
              // Arrow icon
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItemImage(WidgetRef ref) {
    // Check if exercise has uploaded images
    final hasUploadedImages = exercise.demonstrationImages.isNotEmpty || 
                              (exercise.imageUrl != null && exercise.imageUrl!.isNotEmpty);
    
    if (hasUploadedImages) {
      // Try to load the first available image
      final imageSource = exercise.imageUrl ?? 
                         (exercise.demonstrationImages.isNotEmpty 
                          ? exercise.demonstrationImages.first 
                          : null);
      
      if (imageSource != null) {
        return _buildUploadedImageDisplaySmall(ref, imageSource);
      }
    }
    
    // Fallback to placeholder with gradient and icon
    return _buildIconPlaceholder();
  }

  Widget _buildUploadedImageDisplaySmall(WidgetRef ref, String imageSource) {
    final imageStorageService = ref.watch(imageStorageServiceProvider);
    
    return FutureBuilder<ImageMetadata?>(
      future: _findImageMetadata(imageStorageService, imageSource),
      builder: (context, metadataSnapshot) {
        if (metadataSnapshot.hasData && metadataSnapshot.data != null) {
          return FutureBuilder<Uint8List?>(
            future: imageStorageService.getImageData(metadataSnapshot.data!),
            builder: (context, imageSnapshot) {
              if (imageSnapshot.connectionState == ConnectionState.waiting) {
                return _buildSmallLoadingPlaceholder();
              } else if (imageSnapshot.hasData && imageSnapshot.data != null) {
                return Image.memory(
                  imageSnapshot.data!,
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                );
              } else {
                return _buildIconPlaceholder();
              }
            },
          );
        } else {
          return _buildIconPlaceholder();
        }
      },
    );
  }

  Widget _buildSmallLoadingPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: _getExerciseTypeGradient(exercise.exerciseType),
      ),
      child: const Center(
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildIconPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: _getExerciseTypeGradient(exercise.exerciseType),
      ),
      child: Center(
        child: Icon(
          _getExerciseTypeIcon(exercise.exerciseType),
          size: 24,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<ImageMetadata?> _findImageMetadata(ImageStorageService service, String imageId) async {
    try {
      // Now we store proper image IDs, so we can use the service to get metadata
      return await service.getImageMetadata(imageId);
    } catch (e) {
      return null;
    }
  }

  Widget _buildDifficultyChip(String difficulty) {
    final color = _getDifficultyColor(difficulty);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        difficulty.toUpperCase(),
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildTypeChip(BuildContext context, String exerciseType) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        exerciseType.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  LinearGradient _getExerciseTypeGradient(String exerciseType) {
    switch (exerciseType.toLowerCase()) {
      case 'strength':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
        );
      case 'cardio':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)],
        );
      case 'flexibility':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF388E3C), Color(0xFF1B5E20)],
        );
      case 'balance':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7B1FA2), Color(0xFF4A148C)],
        );
      default:
        return ThemeConfig.primaryGradient;
    }
  }

  IconData _getExerciseTypeIcon(String exerciseType) {
    switch (exerciseType.toLowerCase()) {
      case 'strength':
        return Icons.fitness_center;
      case 'cardio':
        return Icons.directions_run;
      case 'flexibility':
        return Icons.self_improvement;
      case 'balance':
        return Icons.balance;
      default:
        return Icons.sports_gymnastics;
    }
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
}