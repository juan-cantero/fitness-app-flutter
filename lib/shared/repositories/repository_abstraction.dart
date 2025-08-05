
/// Comprehensive Repository Abstraction Layer
library;
/// 
/// This file provides the main exports for the repository abstraction layer,
/// enabling seamless switching between local SQLite and future remote Supabase implementations.
/// 
/// ## Key Components:
/// 
/// - **Interfaces**: Abstract repository contracts
/// - **Local Implementations**: SQLite-based repositories with sync support
/// - **Remote Stubs**: Placeholder Supabase implementations for future use
/// - **Mock Implementations**: Test doubles for unit testing
/// - **Provider System**: Riverpod-based dependency injection
/// - **Configuration**: Intelligent switching between local/remote
/// - **Error Handling**: Comprehensive exception hierarchy
/// - **Sync Management**: Conflict resolution and sync tracking
/// 
/// ## Quick Start:
/// 
/// ```dart
/// // In your widget
/// class ExerciseList extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final exerciseRepo = ref.watch(exerciseRepositoryProvider);
///     
///     return FutureBuilder<List<Exercise>>(
///       future: exerciseRepo.getAll(),
///       builder: (context, snapshot) {
///         // Handle data display
///       },
///     );
///   }
/// }
/// ```
/// 
/// See README.md for comprehensive documentation and examples.

// Core Interfaces
export 'interfaces/repository_interfaces.dart';

// Configuration and Strategy
export 'config/repository_config.dart';

// Provider System (Primary API)
export 'providers/repository_providers.dart';

// Sync and Conflict Management
export 'sync/sync_aware_repository.dart';

// Error Handling
export 'errors/repository_exceptions.dart';

// Local Implementations
export 'local/local_repositories.dart';

// Remote Implementations (Future)
export 'remote/remote_repositories.dart';

// Mock Implementations (Testing)
export 'mock/mock_repositories.dart';

// Legacy Support (Deprecated)
export 'repository_factory.dart';

// Re-export commonly used types for convenience
export '../models/sync.dart' show SyncStatus, SyncConflict;

/// Repository abstraction layer version
const String repositoryAbstractionVersion = '1.0.0';

/// Utility class for repository abstraction layer information
class RepositoryAbstractionInfo {
  static const String version = repositoryAbstractionVersion;
  static const String description = 'Comprehensive repository abstraction layer for Flutter fitness app';
  
  /// Supported repository implementations
  static const List<String> supportedImplementations = [
    'local',     // SQLite with sync support
    'remote',    // Supabase (future)
    'hybrid',    // Intelligent switching
    'mock',      // Testing
  ];
  
  /// Available repository modes
  static const List<String> availableModes = [
    'localOnly',
    'remoteOnly', 
    'localFirst',
    'remoteFirst',
    'hybrid',
  ];
  
  /// Supported conflict resolution strategies
  static const List<String> conflictResolutionStrategies = [
    'localWins',
    'serverWins',
    'merge',
    'manual',
    'lastWriteWins',
  ];
  
  /// Get repository abstraction layer information
  static Map<String, dynamic> getInfo() {
    return {
      'version': version,
      'description': description,
      'supportedImplementations': supportedImplementations,
      'availableModes': availableModes,
      'conflictResolutionStrategies': conflictResolutionStrategies,
      'features': [
        'Local-first architecture',
        'Sync-aware operations',
        'Conflict resolution',
        'Provider-based dependency injection',
        'Comprehensive error handling',
        'Mock implementations for testing',
        'Future remote support',
        'Intelligent mode switching',
        'Offline capability',
        'Real-time sync preparation',
      ],
    };
  }
}