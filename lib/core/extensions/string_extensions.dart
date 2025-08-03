extension StringExtensions on String {
  // Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
  
  // Title case (capitalize each word)
  String get titleCase {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.capitalize)
        .join(' ');
  }
  
  // Convert to snake_case
  String get toSnakeCase {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^_'), '');
  }
  
  // Convert from snake_case to readable text
  String get fromSnakeCase {
    return split('_')
        .map((word) => word.capitalize)
        .join(' ');
  }
  
  // Remove extra whitespace
  String get trimmed {
    return trim().replaceAll(RegExp(r'\s+'), ' ');
  }
  
  // Check if string is a valid email
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }
  
  // Check if string is numeric
  bool get isNumeric {
    return double.tryParse(this) != null;
  }
  
  // Convert to proper muscle group display name
  String get toMuscleGroupDisplay {
    switch (toLowerCase()) {
      case 'abs':
        return 'Abs';
      case 'biceps':
        return 'Biceps';
      case 'triceps':
        return 'Triceps';
      case 'quadriceps':
        return 'Quadriceps';
      case 'hamstrings':
        return 'Hamstrings';
      case 'glutes':
        return 'Glutes';
      case 'calves':
        return 'Calves';
      case 'forearms':
        return 'Forearms';
      case 'obliques':
        return 'Obliques';
      case 'full_body':
        return 'Full Body';
      default:
        return titleCase;
    }
  }
  
  // Convert to proper equipment display name
  String get toEquipmentDisplay {
    switch (toLowerCase()) {
      case 'bodyweight':
        return 'Bodyweight';
      case 'dumbbells':
        return 'Dumbbells';
      case 'barbell':
        return 'Barbell';
      case 'kettlebell':
        return 'Kettlebell';
      case 'resistance_bands':
        return 'Resistance Bands';
      case 'pull_up_bar':
        return 'Pull-up Bar';
      case 'cable_machine':
        return 'Cable Machine';
      case 'smith_machine':
        return 'Smith Machine';
      case 'cardio_machine':
        return 'Cardio Machine';
      case 'medicine_ball':
        return 'Medicine Ball';
      case 'yoga_mat':
        return 'Yoga Mat';
      case 'foam_roller':
        return 'Foam Roller';
      default:
        return fromSnakeCase;
    }
  }
  
  // Convert difficulty level to display name
  String get toDifficultyDisplay {
    switch (toLowerCase()) {
      case 'beginner':
        return 'Beginner';
      case 'intermediate':
        return 'Intermediate';
      case 'advanced':
        return 'Advanced';
      case 'expert':
        return 'Expert';
      default:
        return capitalize;
    }
  }
  
  // Truncate string with ellipsis
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }
  
  // Generate initials from name
  String get initials {
    final words = split(' ').where((word) => word.isNotEmpty).toList();
    if (words.isEmpty) return '';
    if (words.length == 1) return words.first[0].toUpperCase();
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }
  
  // Convert duration in minutes to readable format
  String get toDurationDisplay {
    final minutes = int.tryParse(this);
    if (minutes == null) return this;
    
    if (minutes < 60) {
      return '${minutes}min';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '${hours}h';
      } else {
        return '${hours}h ${remainingMinutes}min';
      }
    }
  }
  
  // Convert rest time in seconds to readable format
  String get toRestTimeDisplay {
    final seconds = int.tryParse(this);
    if (seconds == null) return this;
    
    if (seconds < 60) {
      return '${seconds}s';
    } else {
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;
      if (remainingSeconds == 0) {
        return '${minutes}min';
      } else {
        return '${minutes}min ${remainingSeconds}s';
      }
    }
  }
}