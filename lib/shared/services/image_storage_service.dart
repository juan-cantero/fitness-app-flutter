import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';

/// Image metadata for tracking stored images
class ImageMetadata {
  final String id;
  final String fileName;
  final String originalFileName;
  final String filePath;
  final int sizeBytes;
  final int width;
  final int height;
  final String format;
  final double compressionLevel;
  final DateTime createdAt;
  final bool isSynced;

  const ImageMetadata({
    required this.id,
    required this.fileName,
    required this.originalFileName,
    required this.filePath,
    required this.sizeBytes,
    required this.width,
    required this.height,
    required this.format,
    required this.compressionLevel,
    required this.createdAt,
    this.isSynced = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'fileName': fileName,
        'originalFileName': originalFileName,
        'filePath': filePath,
        'sizeBytes': sizeBytes,
        'width': width,
        'height': height,
        'format': format,
        'compressionLevel': compressionLevel,
        'createdAt': createdAt.toIso8601String(),
        'isSynced': isSynced,
      };

  factory ImageMetadata.fromJson(Map<String, dynamic> json) => ImageMetadata(
        id: json['id'] as String,
        fileName: json['fileName'] as String,
        originalFileName: json['originalFileName'] as String,
        filePath: json['filePath'] as String,
        sizeBytes: json['sizeBytes'] as int,
        width: json['width'] as int,
        height: json['height'] as int,
        format: json['format'] as String,
        compressionLevel: (json['compressionLevel'] as num).toDouble(),
        createdAt: DateTime.parse(json['createdAt'] as String),
        isSynced: json['isSynced'] as bool? ?? false,
      );

  ImageMetadata copyWith({
    String? id,
    String? fileName,
    String? originalFileName,
    String? filePath,
    int? sizeBytes,
    int? width,
    int? height,
    String? format,
    double? compressionLevel,
    DateTime? createdAt,
    bool? isSynced,
  }) =>
      ImageMetadata(
        id: id ?? this.id,
        fileName: fileName ?? this.fileName,
        originalFileName: originalFileName ?? this.originalFileName,
        filePath: filePath ?? this.filePath,
        sizeBytes: sizeBytes ?? this.sizeBytes,
        width: width ?? this.width,
        height: height ?? this.height,
        format: format ?? this.format,
        compressionLevel: compressionLevel ?? this.compressionLevel,
        createdAt: createdAt ?? this.createdAt,
        isSynced: isSynced ?? this.isSynced,
      );
}

/// Exception thrown when image operations fail
class ImageStorageException implements Exception {
  final String message;
  final Object? originalException;
  
  const ImageStorageException(this.message, [this.originalException]);
  
  @override
  String toString() => 'ImageStorageException: $message';
}

/// Cross-platform image storage service
/// Handles local storage, compression, and metadata tracking
class ImageStorageService {
  static const String _metadataKey = 'image_metadata';
  static const String _webStoragePrefix = 'exercise_image_';
  static const int _maxImageWidth = 1024;
  static const int _maxImageHeight = 1024;
  static const double _compressionQuality = 0.8;

  const ImageStorageService();

  /// Store an image file and return metadata
  /// [imageData] - Raw image bytes
  /// [originalFileName] - Original file name for reference
  /// [maxWidth] - Maximum width for resizing (default: 1024)
  /// [maxHeight] - Maximum height for resizing (default: 1024)
  /// [quality] - Compression quality 0.0-1.0 (default: 0.8)
  Future<ImageMetadata> storeImage(
    Uint8List imageData,
    String originalFileName, {
    int maxWidth = _maxImageWidth,
    int maxHeight = _maxImageHeight,
    double quality = _compressionQuality,
  }) async {
    try {
      // Generate unique ID and filename
      final id = const Uuid().v4();
      final extension = path.extension(originalFileName).toLowerCase();
      final fileName = '$id$extension';

      // Decode and process image
      final originalImage = img.decodeImage(imageData);
      if (originalImage == null) {
        throw const ImageStorageException('Failed to decode image');
      }

      // Resize if necessary
      final resizedImage = _resizeImage(originalImage, maxWidth, maxHeight);

      // Compress image
      final compressedData = _compressImage(resizedImage, extension, quality);

      // Store image based on platform
      String filePath;
      if (kIsWeb) {
        filePath = await _storeImageWeb(fileName, compressedData);
      } else {
        filePath = await _storeImageFile(fileName, compressedData);
      }

      // Create metadata
      final metadata = ImageMetadata(
        id: id,
        fileName: fileName,
        originalFileName: originalFileName,
        filePath: filePath,
        sizeBytes: compressedData.length,
        width: resizedImage.width,
        height: resizedImage.height,
        format: extension.replaceFirst('.', '').toUpperCase(),
        compressionLevel: quality,
        createdAt: DateTime.now(),
        isSynced: false,
      );

      // Save metadata
      await _saveImageMetadata(metadata);

      return metadata;
    } catch (e) {
      throw ImageStorageException('Failed to store image: $e', e);
    }
  }

  /// Get image data by metadata
  Future<Uint8List?> getImageData(ImageMetadata metadata) async {
    try {
      if (kIsWeb) {
        return await _getImageDataWeb(metadata.fileName);
      } else {
        return await _getImageDataFile(metadata.filePath);
      }
    } catch (e) {
      debugPrint('Failed to get image data: $e');
      return null;
    }
  }

  /// Delete image and its metadata
  Future<void> deleteImage(String imageId) async {
    try {
      final metadata = await getImageMetadata(imageId);
      if (metadata == null) return;

      // Delete file
      if (kIsWeb) {
        await _deleteImageWeb(metadata.fileName);
      } else {
        await _deleteImageFile(metadata.filePath);
      }

      // Remove metadata
      await _removeImageMetadata(imageId);
    } catch (e) {
      debugPrint('Failed to delete image: $e');
    }
  }

  /// Get image metadata by ID
  Future<ImageMetadata?> getImageMetadata(String imageId) async {
    try {
      final allMetadata = await _getAllImageMetadata();
      return allMetadata.firstWhere((m) => m.id == imageId);
    } catch (e) {
      return null;
    }
  }

  /// Get all stored image metadata
  Future<List<ImageMetadata>> getAllImageMetadata() async {
    try {
      return await _getAllImageMetadata();
    } catch (e) {
      debugPrint('Failed to get image metadata: $e');
      return [];
    }
  }

  /// Clean up orphaned images (no longer referenced)
  Future<void> cleanup(Set<String> referencedImageIds) async {
    try {
      final allMetadata = await _getAllImageMetadata();
      
      for (final metadata in allMetadata) {
        if (!referencedImageIds.contains(metadata.id)) {
          await deleteImage(metadata.id);
        }
      }
    } catch (e) {
      debugPrint('Failed to cleanup images: $e');
    }
  }

  /// Mark image as synced
  Future<void> markAsSynced(String imageId) async {
    try {
      final metadata = await getImageMetadata(imageId);
      if (metadata == null) return;

      final updatedMetadata = metadata.copyWith(isSynced: true);
      await _updateImageMetadata(updatedMetadata);
    } catch (e) {
      debugPrint('Failed to mark image as synced: $e');
    }
  }

  /// Get unsynced images
  Future<List<ImageMetadata>> getUnsyncedImages() async {
    try {
      final allMetadata = await _getAllImageMetadata();
      return allMetadata.where((m) => !m.isSynced).toList();
    } catch (e) {
      debugPrint('Failed to get unsynced images: $e');
      return [];
    }
  }

  // Private helper methods

  img.Image _resizeImage(img.Image image, int maxWidth, int maxHeight) {
    if (image.width <= maxWidth && image.height <= maxHeight) {
      return image;
    }

    final aspectRatio = image.width / image.height;
    int newWidth, newHeight;

    if (aspectRatio > 1) {
      // Landscape
      newWidth = maxWidth;
      newHeight = (maxWidth / aspectRatio).round();
    } else {
      // Portrait or square
      newHeight = maxHeight;
      newWidth = (maxHeight * aspectRatio).round();
    }

    return img.copyResize(image, width: newWidth, height: newHeight);
  }

  Uint8List _compressImage(img.Image image, String extension, double quality) {
    switch (extension.toLowerCase()) {
      case '.jpg':
      case '.jpeg':
        return Uint8List.fromList(img.encodeJpg(image, quality: (quality * 100).round()));
      case '.png':
        return Uint8List.fromList(img.encodePng(image, level: (quality * 9).round()));
      case '.webp':
        // WebP not supported, fallback to JPEG
        return Uint8List.fromList(img.encodeJpg(image, quality: (quality * 100).round()));
      default:
        // Default to JPEG
        return Uint8List.fromList(img.encodeJpg(image, quality: (quality * 100).round()));
    }
  }

  Future<String> _storeImageFile(String fileName, Uint8List data) async {
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(path.join(appDir.path, 'exercise_images'));
    
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final file = File(path.join(imagesDir.path, fileName));
    await file.writeAsBytes(data);
    
    return file.path;
  }

  Future<String> _storeImageWeb(String fileName, Uint8List data) async {
    final prefs = await SharedPreferences.getInstance();
    final base64Data = base64Encode(data);
    final key = '$_webStoragePrefix$fileName';
    
    await prefs.setString(key, base64Data);
    
    return key; // Use storage key as "path" for web
  }

  Future<Uint8List?> _getImageDataFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) return null;
    
    return await file.readAsBytes();
  }

  Future<Uint8List?> _getImageDataWeb(String fileName) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_webStoragePrefix$fileName';
    final base64Data = prefs.getString(key);
    
    if (base64Data == null) return null;
    
    return base64Decode(base64Data);
  }

  Future<void> _deleteImageFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> _deleteImageWeb(String fileName) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_webStoragePrefix$fileName';
    await prefs.remove(key);
  }

  Future<void> _saveImageMetadata(ImageMetadata metadata) async {
    final allMetadata = await _getAllImageMetadata();
    allMetadata.removeWhere((m) => m.id == metadata.id);
    allMetadata.add(metadata);
    
    await _saveAllImageMetadata(allMetadata);
  }

  Future<void> _updateImageMetadata(ImageMetadata metadata) async {
    await _saveImageMetadata(metadata);
  }

  Future<void> _removeImageMetadata(String imageId) async {
    final allMetadata = await _getAllImageMetadata();
    allMetadata.removeWhere((m) => m.id == imageId);
    
    await _saveAllImageMetadata(allMetadata);
  }

  Future<List<ImageMetadata>> _getAllImageMetadata() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_metadataKey);
      
      if (jsonString == null) return [];
      
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList.map((json) => ImageMetadata.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('Failed to load image metadata: $e');
      return [];
    }
  }

  Future<void> _saveAllImageMetadata(List<ImageMetadata> metadata) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = metadata.map((m) => m.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      
      await prefs.setString(_metadataKey, jsonString);
    } catch (e) {
      debugPrint('Failed to save image metadata: $e');
    }
  }
}