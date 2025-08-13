import 'package:flutter/material.dart';

/// Utility class for image-related operations
class ImageUtils {
  /// Convert string to BoxFit enum
  static BoxFit stringToBoxFit(String fitString) {
    switch (fitString.toLowerCase()) {
      case 'contain':
        return BoxFit.contain;
      case 'fill':
        return BoxFit.fill;
      case 'cover':
      default:
        return BoxFit.cover;
    }
  }

  /// Convert BoxFit enum to string
  static String boxFitToString(BoxFit fit) {
    switch (fit) {
      case BoxFit.contain:
        return 'contain';
      case BoxFit.fill:
        return 'fill';
      case BoxFit.cover:
      default:
        return 'cover';
    }
  }
}