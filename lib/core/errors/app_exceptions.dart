abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppException: $message';
}

// Network Exceptions
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
  });
}

class NoInternetException extends NetworkException {
  const NoInternetException()
      : super(
          message: 'No internet connection available',
          code: 'NO_INTERNET',
        );
}

class TimeoutException extends NetworkException {
  const TimeoutException()
      : super(
          message: 'Request timeout. Please try again.',
          code: 'TIMEOUT',
        );
}

class ServerException extends NetworkException {
  const ServerException({
    super.message = 'Server error occurred',
    super.code = 'SERVER_ERROR',
    super.originalError,
  });
}

// Authentication Exceptions
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.originalError,
  });
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException()
      : super(
          message: 'Invalid email or password',
          code: 'INVALID_CREDENTIALS',
        );
}

class UserNotFoundException extends AuthException {
  const UserNotFoundException()
      : super(
          message: 'User not found',
          code: 'USER_NOT_FOUND',
        );
}

class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException()
      : super(
          message: 'Email address is already in use',
          code: 'EMAIL_ALREADY_IN_USE',
        );
}

class WeakPasswordException extends AuthException {
  const WeakPasswordException()
      : super(
          message: 'Password is too weak',
          code: 'WEAK_PASSWORD',
        );
}

class EmailNotVerifiedException extends AuthException {
  const EmailNotVerifiedException()
      : super(
          message: 'Email address is not verified',
          code: 'EMAIL_NOT_VERIFIED',
        );
}

class AccountDisabledException extends AuthException {
  const AccountDisabledException()
      : super(
          message: 'Account has been disabled',
          code: 'ACCOUNT_DISABLED',
        );
}

class TokenExpiredException extends AuthException {
  const TokenExpiredException()
      : super(
          message: 'Session has expired. Please log in again.',
          code: 'TOKEN_EXPIRED',
        );
}

// Database Exceptions
class DatabaseException extends AppException {
  const DatabaseException({
    required super.message,
    super.code,
    super.originalError,
  });
}

class RecordNotFoundException extends DatabaseException {
  const RecordNotFoundException({
    required String entity,
  }) : super(
          message: '$entity not found',
          code: 'RECORD_NOT_FOUND',
        );
}

class DuplicateRecordException extends DatabaseException {
  const DuplicateRecordException({
    required String entity,
  }) : super(
          message: '$entity already exists',
          code: 'DUPLICATE_RECORD',
        );
}

class DatabaseConstraintException extends DatabaseException {
  const DatabaseConstraintException({
    required super.message,
  }) : super(code: 'CONSTRAINT_VIOLATION');
}

// Validation Exceptions
class ValidationException extends AppException {
  final Map<String, String> fieldErrors;

  const ValidationException({
    required super.message,
    this.fieldErrors = const {},
  }) : super(code: 'VALIDATION_ERROR');
}

class InvalidInputException extends ValidationException {
  const InvalidInputException({
    required super.message,
    super.fieldErrors,
  });
}

// Business Logic Exceptions
class BusinessLogicException extends AppException {
  const BusinessLogicException({
    required super.message,
    super.code,
  });
}

class WorkoutGenerationException extends BusinessLogicException {
  const WorkoutGenerationException({
    super.message = 'Failed to generate workout',
    super.code = 'WORKOUT_GENERATION_FAILED',
  });
}

class InsufficientDataException extends BusinessLogicException {
  const InsufficientDataException({
    required super.message,
  }) : super(code: 'INSUFFICIENT_DATA');
}

class ExerciseLimitExceededException extends BusinessLogicException {
  const ExerciseLimitExceededException()
      : super(
          message: 'Maximum number of exercises per workout exceeded',
          code: 'EXERCISE_LIMIT_EXCEEDED',
        );
}

// Storage Exceptions
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code,
    super.originalError,
  });
}

class LocalStorageException extends StorageException {
  const LocalStorageException({
    super.message = 'Local storage error',
    super.code = 'LOCAL_STORAGE_ERROR',
    super.originalError,
  });
}

class SecureStorageException extends StorageException {
  const SecureStorageException({
    super.message = 'Secure storage error',
    super.code = 'SECURE_STORAGE_ERROR',
    super.originalError,
  });
}

// Permission Exceptions
class PermissionException extends AppException {
  const PermissionException({
    required super.message,
    super.code = 'PERMISSION_DENIED',
  });
}

class InsufficientPermissionException extends PermissionException {
  const InsufficientPermissionException({
    required String permission,
  }) : super(
          message: 'Permission required: $permission',
        );
}

// File Exceptions
class FileException extends AppException {
  const FileException({
    required super.message,
    super.code,
    super.originalError,
  });
}

class FileNotFoundException extends FileException {
  const FileNotFoundException({
    required String fileName,
  }) : super(
          message: 'File not found: $fileName',
          code: 'FILE_NOT_FOUND',
        );
}

class FileUploadException extends FileException {
  const FileUploadException({
    super.message = 'File upload failed',
    super.code = 'FILE_UPLOAD_FAILED',
    super.originalError,
  });
}

// LLM Service Exceptions
class LLMServiceException extends AppException {
  const LLMServiceException({
    required super.message,
    super.code,
    super.originalError,
  });
}

class LLMRateLimitException extends LLMServiceException {
  const LLMRateLimitException()
      : super(
          message: 'AI service rate limit exceeded. Please try again later.',
          code: 'LLM_RATE_LIMIT',
        );
}

class LLMQuotaExceededException extends LLMServiceException {
  const LLMQuotaExceededException()
      : super(
          message: 'AI service quota exceeded.',
          code: 'LLM_QUOTA_EXCEEDED',
        );
}

class LLMInvalidResponseException extends LLMServiceException {
  const LLMInvalidResponseException()
      : super(
          message: 'Invalid response from AI service',
          code: 'LLM_INVALID_RESPONSE',
        );
}

// Sync Exceptions
class SyncException extends AppException {
  const SyncException({
    required super.message,
    super.code,
    super.originalError,
  });
}

class ConflictException extends SyncException {
  const ConflictException({
    required String entity,
  }) : super(
          message: 'Sync conflict detected for $entity',
          code: 'SYNC_CONFLICT',
        );
}

class SyncFailedException extends SyncException {
  const SyncFailedException({
    super.message = 'Synchronization failed',
    super.code = 'SYNC_FAILED',
    super.originalError,
  });
}

// Cache Exceptions
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code = 'CACHE_ERROR',
    super.originalError,
  });
}

class CacheExpiredException extends CacheException {
  const CacheExpiredException()
      : super(
          message: 'Cached data has expired',
          code: 'CACHE_EXPIRED',
        );
}