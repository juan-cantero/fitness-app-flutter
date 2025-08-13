import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/workout_creation_providers.dart';
import '../../../../shared/widgets/cached_network_image_widget.dart';
import '../../../../shared/utils/image_utils.dart';

class WorkoutCoverImageWidget extends ConsumerStatefulWidget {
  final bool isEditMode;
  
  const WorkoutCoverImageWidget({
    super.key,
    this.isEditMode = false,
  });

  @override
  ConsumerState<WorkoutCoverImageWidget> createState() => _WorkoutCoverImageWidgetState();
}

class _WorkoutCoverImageWidgetState extends ConsumerState<WorkoutCoverImageWidget> {
  BoxFit _currentImageFit = BoxFit.cover;

  @override
  Widget build(BuildContext context) {
    // Watch both image state and imageFit from form data
    final imageState = ref.watch(workoutCreationProvider.select((state) => state.imageState));
    final formImageFit = ref.watch(workoutCreationProvider.select((state) => state.formData.imageFit));
    final notifier = ref.read(workoutCreationProvider.notifier);
    
    // Sync local state with form data
    final formBoxFit = ImageUtils.stringToBoxFit(formImageFit);
    if (_currentImageFit != formBoxFit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _currentImageFit = formBoxFit;
          });
        }
      });
    }
    
    // Reset image fit when the form is reset (no images present)
    if (imageState.images.isEmpty && _currentImageFit != BoxFit.cover) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _currentImageFit = BoxFit.cover;
          });
        }
      });
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isEditMode ? 'Change Workout Cover Image' : 'Workout Cover Image',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            if (imageState.images.isEmpty) ...[
              // Empty state - show upload button
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: imageState.isUploading ? null : () => _pickImage(context, ref),
                  borderRadius: BorderRadius.circular(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (imageState.isUploading) ...[
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          'Uploading image...',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        if (imageState.uploadProgress != null)
                          Text(
                            '${(imageState.uploadProgress! * 100).toInt()}%',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ] else ...[
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 48,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.isEditMode ? 'Change Cover Image' : 'Add Cover Image',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Click to select an image for your workout',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Show uploaded image with positioning controls
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                            width: 1,
                          ),
                        ),
                        child: CachedNetworkImageWidget(
                          imageId: imageState.images.first.id,
                          fit: _currentImageFit,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.white),
                                onPressed: () => _pickImage(context, ref),
                                tooltip: 'Change image',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.white),
                                onPressed: () => notifier.removeImage(),
                                tooltip: 'Remove image',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Image positioning controls
                  Text(
                    'Image Display',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('Fill'),
                        selected: _currentImageFit == BoxFit.cover,
                        onSelected: (_) => _setImageFit(BoxFit.cover),
                        tooltip: 'Fill container, may crop image',
                      ),
                      FilterChip(
                        label: const Text('Fit'),
                        selected: _currentImageFit == BoxFit.contain,
                        onSelected: (_) => _setImageFit(BoxFit.contain),
                        tooltip: 'Show full image, may have empty space',
                      ),
                      FilterChip(
                        label: const Text('Stretch'),
                        selected: _currentImageFit == BoxFit.fill,
                        onSelected: (_) => _setImageFit(BoxFit.fill),
                        tooltip: 'Stretch to fill container',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getImageFitDescription(_currentImageFit),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ],

            // Error display
            if (imageState.error != null) ...[
              const SizedBox(height: 12),
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
                        imageState.error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => notifier.clearImageError(),
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _setImageFit(BoxFit fit) {
    setState(() {
      _currentImageFit = fit;
    });
    
    // Save the preference to the form data
    final notifier = ref.read(workoutCreationProvider.notifier);
    final fitString = ImageUtils.boxFitToString(fit);
    notifier.updateField('imageFit', fitString);
  }

  String _getImageFitDescription(BoxFit fit) {
    switch (fit) {
      case BoxFit.cover:
        return 'Image fills the container. Parts of the image may be cropped to maintain aspect ratio.';
      case BoxFit.contain:
        return 'Full image is visible. Empty space may appear if aspect ratios differ.';
      case BoxFit.fill:
        return 'Image stretches to fill container. Aspect ratio may be changed.';
      default:
        return '';
    }
  }

  Future<void> _pickImage(BuildContext context, WidgetRef ref) async {
    try {
      final ImagePicker picker = ImagePicker();
      
      // Show source selection dialog
      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
            ],
          ),
        ),
      );

      if (source == null) return;

      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return;

      // Upload the image
      final notifier = ref.read(workoutCreationProvider.notifier);
      final imageData = await image.readAsBytes();
      await notifier.addImage(imageData, image.name);

    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}