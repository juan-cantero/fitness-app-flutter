import 'package:flutter/foundation.dart';

/// Comprehensive error handling for repository operations
/// Provides specific exception types for different failure scenarios

/// Base repository exception
abstract class RepositoryException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const RepositoryException(
    this.message, {
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'RepositoryException: $message';
}

/// Network-related exceptions
class NetworkException extends RepositoryException {
  final bool isTimeout;
  final bool isNoConnection;

  const NetworkException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
    this.isTimeout = false,
    this.isNoConnection = false,
  });

  @override
  String toString() => 'NetworkException: $message';
}

/// Database-related exceptions
class DatabaseException extends RepositoryException {
  final bool isCorrupted;
  final bool isDiskFull;
  final bool isLocked;

  const DatabaseException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
    this.isCorrupted = false,
    this.isDiskFull = false,
    this.isLocked = false,
  });

  @override
  String toString() => 'DatabaseException: $message';
}

/// Validation-related exceptions
class ValidationException extends RepositoryException {
  final Map<String, List<String>>? fieldErrors;

  const ValidationException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
    this.fieldErrors,
  });

  @override
  String toString() => 'ValidationException: $message';
}

/// Authorization-related exceptions
class AuthorizationException extends RepositoryException {
  final bool isExpiredToken;
  final bool isInsufficientPermissions;

  const AuthorizationException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
    this.isExpiredToken = false,
    this.isInsufficientPermissions = false,
  });

  @override
  String toString() => 'AuthorizationException: $message';
}

/// Sync-related exceptions
class SyncException extends RepositoryException {
  final bool isConflict;
  final bool isVersionMismatch;
  final String? conflictId;

  const SyncException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
    this.isConflict = false,
    this.isVersionMismatch = false,
    this.conflictId,
  });

  @override
  String toString() => 'SyncException: $message';
}

/// Resource not found exception
class NotFoundException extends RepositoryException {
  final String resourceType;
  final String resourceId;

  const NotFoundException(
    this.resourceType,
    this.resourceId, {
    super.code,
    super.originalError,
    super.stackTrace,
  }) : super('$resourceType with id $resourceId not found');

  @override
  String toString() => 'NotFoundException: $message';
}

/// Conflict exception (e.g., unique constraint violations)
class ConflictException extends RepositoryException {
  final String conflictType;
  final Map<String, dynamic>? conflictData;

  const ConflictException(
    super.message,
    this.conflictType, {
    super.code,
    super.originalError,
    super.stackTrace,
    this.conflictData,
  });

  @override
  String toString() => 'ConflictException: $message';
}

/// Rate limiting exception
class RateLimitException extends RepositoryException {
  final Duration retryAfter;
  final int requestsPerMinute;

  const RateLimitException(
    super.message,
    this.retryAfter,
    this.requestsPerMinute, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'RateLimitException: $message';
}

/// Service unavailable exception
class ServiceUnavailableException extends RepositoryException {
  final Duration? estimatedDowntime;
  final bool isMaintenanceMode;

  const ServiceUnavailableException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
    this.estimatedDowntime,
    this.isMaintenanceMode = false,
  });

  @override
  String toString() => 'ServiceUnavailableException: $message';
}

/// Quota exceeded exception
class QuotaExceededException extends RepositoryException {
  final String quotaType;
  final int currentUsage;
  final int maxAllowed;

  const QuotaExceededException(
    super.message,
    this.quotaType,
    this.currentUsage,
    this.maxAllowed, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'QuotaExceededException: $message';
}

/// Exception factory for converting common errors to repository exceptions
class RepositoryExceptionFactory {
  /// Convert a generic exception to a specific repository exception
  static RepositoryException fromException(
    dynamic error, {
    String? context,
    StackTrace? stackTrace,
  }) {
    if (error is RepositoryException) {
      return error;
    }

    final errorString = error.toString().toLowerCase();
    final contextMessage = context != null ? '$context: ' : '';

    // Network errors
    if (errorString.contains('timeout') || errorString.contains('timed out')) {
      return NetworkException(
        '${contextMessage}Operation timed out',
        originalError: error,
        stackTrace: stackTrace,
        isTimeout: true,
      );
    }

    if (errorString.contains('no internet') || 
        errorString.contains('network unreachable') ||
        errorString.contains('connection failed')) {
      return NetworkException(
        '${contextMessage}No internet connection',
        originalError: error,
        stackTrace: stackTrace,
        isNoConnection: true,
      );
    }

    // Database errors
    if (errorString.contains('database is locked')) {
      return DatabaseException(
        '${contextMessage}Database is locked',
        originalError: error,
        stackTrace: stackTrace,
        isLocked: true,
      );
    }

    if (errorString.contains('disk full') || errorString.contains('no space')) {
      return DatabaseException(
        '${contextMessage}Insufficient storage space',
        originalError: error,
        stackTrace: stackTrace,
        isDiskFull: true,
      );
    }

    if (errorString.contains('corrupted') || errorString.contains('malformed')) {
      return DatabaseException(
        '${contextMessage}Database corrupted',
        originalError: error,
        stackTrace: stackTrace,
        isCorrupted: true,
      );
    }

    // Supabase specific errors
    if (errorString.contains('jwt expired') || errorString.contains('token expired')) {
      return AuthorizationException(
        '${contextMessage}Authentication token expired',
        originalError: error,
        stackTrace: stackTrace,
        isExpiredToken: true,
      );
    }

    if (errorString.contains('insufficient privileges') || 
        errorString.contains('permission denied')) {
      return AuthorizationException(
        '${contextMessage}Insufficient permissions',
        originalError: error,
        stackTrace: stackTrace,
        isInsufficientPermissions: true,
      );
    }

    if (errorString.contains('unique constraint') || 
        errorString.contains('duplicate key')) {
      return ConflictException(
        '${contextMessage}Record already exists',
        'unique_constraint',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (errorString.contains('rate limit') || errorString.contains('too many requests')) {
      return RateLimitException(
        '${contextMessage}Rate limit exceeded',
        const Duration(minutes: 1),
        60,
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (errorString.contains('service unavailable') || 
        errorString.contains('maintenance')) {
      return ServiceUnavailableException(
        '${contextMessage}Service temporarily unavailable',
        originalError: error,
        stackTrace: stackTrace,
        isMaintenanceMode: errorString.contains('maintenance'),
      );
    }

    // Generic repository exception
    return GenericRepositoryException(
      '${contextMessage}Repository operation failed: ${error.toString()}',
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  /// Create a network exception with retry information
  static NetworkException networkError(
    String message, {
    bool canRetry = true,
    Duration? retryDelay,
    dynamic originalError,
    StackTrace? stackTrace,
  }) {
    return NetworkException(
      message,
      originalError: originalError,
      stackTrace: stackTrace,
      code: canRetry ? 'NETWORK_RETRY' : 'NETWORK_FATAL',
    );
  }

  /// Create a validation exception with field errors
  static ValidationException validationError(
    String message,
    Map<String, List<String>> fieldErrors, {
    dynamic originalError,
    StackTrace? stackTrace,
  }) {
    return ValidationException(
      message,
      fieldErrors: fieldErrors,
      originalError: originalError,
      stackTrace: stackTrace,
    );
  }

  /// Create a sync conflict exception
  static SyncException syncConflict(
    String message,
    String conflictId, {
    dynamic originalError,
    StackTrace? stackTrace,
  }) {
    return SyncException(
      message,
      isConflict: true,
      conflictId: conflictId,
      originalError: originalError,
      stackTrace: stackTrace,
    );
  }
}

/// Generic repository exception for uncategorized errors
class GenericRepositoryException extends RepositoryException {
  const GenericRepositoryException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'GenericRepositoryException: $message';
}

/// Repository error handler utility
class RepositoryErrorHandler {
  /// Handle and categorize repository exceptions
  static T handleError<T>(
    dynamic error,
    StackTrace stackTrace, {
    String? context,
    T? fallbackValue,
    bool shouldRethrow = true,
  }) {
    final repositoryException = RepositoryExceptionFactory.fromException(
      error,
      context: context,
      stackTrace: stackTrace,
    );

    // Log the error (in a real app, use a proper logging framework)
    _logError(repositoryException);

    if (fallbackValue != null) {
      return fallbackValue;
    }

    if (shouldRethrow) {
      throw repositoryException;
    }

    // This should never be reached with proper typing, but needed for compilation
    throw repositoryException;
  }

  /// Determine if an error is retryable
  static bool isRetryable(RepositoryException exception) {
    switch (exception.runtimeType) {
      case NetworkException _:
        final networkException = exception as NetworkException;
        return !networkException.isNoConnection; // Can retry timeouts, not no connection
      
      case DatabaseException _:
        final dbException = exception as DatabaseException;
        return dbException.isLocked; // Can retry locked database, not corruption
      
      case AuthorizationException _:
        final authException = exception as AuthorizationException;
        return authException.isExpiredToken; // Can retry with new token
      
      case ServiceUnavailableException _:
        return true; // Service might come back
      
      case RateLimitException _:
        return true; // Can retry after delay
      
      default:
        return false; // Most other errors are not retryable
    }
  }

  /// Get suggested retry delay for retryable errors
  static Duration getRetryDelay(RepositoryException exception, int attemptNumber) {
    switch (exception.runtimeType) {
      case RateLimitException _:
        final rateLimitException = exception as RateLimitException;
        return rateLimitException.retryAfter;
      
      case ServiceUnavailableException _:
        final serviceException = exception as ServiceUnavailableException;
        return serviceException.estimatedDowntime ?? Duration(seconds: 30 * attemptNumber);
      
      default:
        // Exponential backoff: 1s, 2s, 4s, 8s, 16s (max)
        final delay = Duration(seconds: (1 << (attemptNumber - 1)).clamp(1, 16));
        return delay;
    }
  }

  /// Check if error indicates offline state
  static bool isOfflineError(RepositoryException exception) {
    if (exception is NetworkException) {
      return exception.isNoConnection;
    }
    return false;
  }

  /// Check if error indicates auth issue
  static bool isAuthError(RepositoryException exception) {
    return exception is AuthorizationException;
  }

  /// Check if error indicates sync conflict
  static bool isSyncConflict(RepositoryException exception) {
    return exception is SyncException && exception.isConflict;
  }

  static void _logError(RepositoryException exception) {
    // In a real application, you would use a proper logging framework
    // For now, just print to console in debug mode
    debugPrint('Repository Error: ${exception.toString()}');
    if (exception.originalError != null) {
      debugPrint('Original Error: ${exception.originalError}');
    }
    if (exception.stackTrace != null) {
      debugPrint('Stack Trace: ${exception.stackTrace}');
    }
  }
}

/// Retry policy for repository operations
class RetryPolicy {
  final int maxAttempts;
  final Duration initialDelay;
  final double backoffMultiplier;
  final Duration maxDelay;
  final bool Function(RepositoryException) shouldRetry;

  const RetryPolicy({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.backoffMultiplier = 2.0,
    this.maxDelay = const Duration(seconds: 30),
    this.shouldRetry = RepositoryErrorHandler.isRetryable,
  });

  /// Default retry policy for network operations
  static const RetryPolicy network = RetryPolicy(
    maxAttempts: 3,
    initialDelay: Duration(seconds: 1),
    backoffMultiplier: 2.0,
    maxDelay: Duration(seconds: 10),
  );

  /// Aggressive retry policy for critical operations
  static const RetryPolicy aggressive = RetryPolicy(
    maxAttempts: 5,
    initialDelay: Duration(milliseconds: 500),
    backoffMultiplier: 1.5,
    maxDelay: Duration(seconds: 15),
  );

  /// Conservative retry policy for non-critical operations
  static const RetryPolicy conservative = RetryPolicy(
    maxAttempts: 2,
    initialDelay: Duration(seconds: 2),
    backoffMultiplier: 3.0,
    maxDelay: Duration(seconds: 60),
  );

  /// No retry policy
  static const RetryPolicy none = RetryPolicy(
    maxAttempts: 1,
    shouldRetry: _neverRetry,
  );

  static bool _neverRetry(RepositoryException exception) => false;

  /// Calculate delay for attempt number
  Duration getDelay(int attemptNumber) {
    if (attemptNumber <= 1) return Duration.zero;
    
    final delay = Duration(
      milliseconds: (initialDelay.inMilliseconds * 
          (backoffMultiplier * (attemptNumber - 1))).round(),
    );
    
    return delay.compareTo(maxDelay) > 0 ? maxDelay : delay;
  }
}