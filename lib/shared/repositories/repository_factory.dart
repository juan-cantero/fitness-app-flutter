import '../../core/database/database_manager.dart';
import 'interfaces/repository_interfaces.dart';
import 'local/local_repositories.dart';
import 'config/repository_config.dart';

/// Enhanced factory class for creating repository instances with abstraction layer support
/// This factory is now DEPRECATED in favor of the Riverpod provider system
/// 
/// @deprecated Use repository providers from providers/repository_providers.dart instead
/// This class is maintained for backward compatibility only
class RepositoryFactory {
  final DatabaseManager _databaseManager;
  final RepositoryConfig? _config;

  // Repository instances (singletons) - now using interface types
  IExerciseRepository? _exerciseRepository;
  IWorkoutRepository? _workoutRepository;
  IUserProfileRepository? _userProfileRepository;
  IEquipmentRepository? _equipmentRepository;
  IWorkoutSessionRepository? _workoutSessionRepository;
  IExerciseLogRepository? _exerciseLogRepository;

  RepositoryFactory(this._databaseManager, [this._config]);

  /// Get ExerciseRepository instance
  IExerciseRepository get exerciseRepository {
    _exerciseRepository ??= LocalExerciseRepository(_databaseManager);
    return _exerciseRepository!;
  }

  /// Get WorkoutRepository instance
  IWorkoutRepository get workoutRepository {
    _workoutRepository ??= LocalWorkoutRepository(_databaseManager);
    return _workoutRepository!;
  }

  /// Get UserProfileRepository instance
  IUserProfileRepository get userProfileRepository {
    _userProfileRepository ??= LocalUserProfileRepository(_databaseManager);
    return _userProfileRepository!;
  }

  /// Get EquipmentRepository instance
  IEquipmentRepository get equipmentRepository {
    _equipmentRepository ??= LocalEquipmentRepository(_databaseManager);
    return _equipmentRepository!;
  }

  /// Get WorkoutSessionRepository instance
  IWorkoutSessionRepository get workoutSessionRepository {
    _workoutSessionRepository ??= LocalWorkoutSessionRepository(_databaseManager);
    return _workoutSessionRepository!;
  }

  /// Get ExerciseLogRepository instance
  IExerciseLogRepository get exerciseLogRepository {
    _exerciseLogRepository ??= LocalExerciseLogRepository(_databaseManager);
    return _exerciseLogRepository!;
  }

  /// Dispose all repository instances (for testing)
  void dispose() {
    _exerciseRepository = null;
    _workoutRepository = null;
    _userProfileRepository = null;
    _equipmentRepository = null;
    _workoutSessionRepository = null;
    _exerciseLogRepository = null;
  }
}

/// Extension to add convenience methods to RepositoryFactory
extension RepositoryFactoryExtensions on RepositoryFactory {
  /// Get all repositories as a map (useful for testing)
  Map<Type, dynamic> get allRepositories => {
    IExerciseRepository: exerciseRepository,
    IWorkoutRepository: workoutRepository,
    IUserProfileRepository: userProfileRepository,
    IEquipmentRepository: equipmentRepository,
    IWorkoutSessionRepository: workoutSessionRepository,
    IExerciseLogRepository: exerciseLogRepository,
  };
}