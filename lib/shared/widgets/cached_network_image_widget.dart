import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../services/image_storage_service.dart';
import '../utils/image_utils.dart';

/// A widget that displays images stored in ImageStorageService
/// Handles loading, error states, and fallback images
class CachedNetworkImageWidget extends StatelessWidget {
  final String? imageId;
  final BoxFit fit;
  final String? imageFitString; // Optional override from workout data
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const CachedNetworkImageWidget({
    super.key,
    required this.imageId,
    this.fit = BoxFit.cover,
    this.imageFitString,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (imageId == null) {
      return _buildErrorWidget(context);
    }

    return FutureBuilder<ImageMetadata?>(
      future: const ImageStorageService().getImageMetadata(imageId!),
      builder: (context, metadataSnapshot) {
        if (metadataSnapshot.connectionState == ConnectionState.waiting) {
          return _buildPlaceholder(context);
        }

        if (metadataSnapshot.hasData && metadataSnapshot.data != null) {
          return FutureBuilder<Uint8List?>(
            future: const ImageStorageService().getImageData(metadataSnapshot.data!),
            builder: (context, imageSnapshot) {
              if (imageSnapshot.connectionState == ConnectionState.waiting) {
                return _buildPlaceholder(context);
              }

              if (imageSnapshot.hasData && imageSnapshot.data != null) {
                final effectiveFit = imageFitString != null 
                    ? ImageUtils.stringToBoxFit(imageFitString!)
                    : fit;
                    
                Widget imageWidget = Image.memory(
                  imageSnapshot.data!,
                  fit: effectiveFit,
                  width: width,
                  height: height,
                );

                if (borderRadius != null) {
                  imageWidget = ClipRRect(
                    borderRadius: borderRadius!,
                    child: imageWidget,
                  );
                }

                return imageWidget;
              }

              return _buildErrorWidget(context);
            },
          );
        }

        return _buildErrorWidget(context);
      },
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    if (placeholder != null) {
      return placeholder!;
    }

    return Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    if (errorWidget != null) {
      return errorWidget!;
    }

    return Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Icon(
        Icons.fitness_center,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}