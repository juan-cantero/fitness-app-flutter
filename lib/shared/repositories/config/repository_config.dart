import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Repository configuration and strategy management
/// Determines when to use local vs remote repositories based on various factors
class RepositoryConfig {
  static const String _keyRepositoryMode = 'repository_mode';
  static const String _keySyncEnabled = 'sync_enabled';
  static const String _keyOfflineMode = 'offline_mode';
  static const String _keyAutoSyncInterval = 'auto_sync_interval';
  static const String _keyConflictResolutionStrategy = 'conflict_resolution_strategy';
  static const String _keyRemoteEnabled = 'remote_enabled';

  final SharedPreferences _prefs;
  final Connectivity _connectivity;

  RepositoryConfig._(this._prefs, this._connectivity);

  static RepositoryConfig? _instance;

  /// Get singleton instance
  static Future<RepositoryConfig> getInstance() async {
    if (_instance != null) return _instance!;
    
    final prefs = await SharedPreferences.getInstance();
    final connectivity = Connectivity();
    
    _instance = RepositoryConfig._(prefs, connectivity);
    return _instance!;
  }

  /// Repository operation modes
  RepositoryMode get repositoryMode {
    final modeString = _prefs.getString(_keyRepositoryMode) ?? 'local_first';
    return RepositoryMode.values.firstWhere(
      (mode) => mode.name == modeString,
      orElse: () => RepositoryMode.localFirst,
    );
  }

  set repositoryMode(RepositoryMode mode) {
    _prefs.setString(_keyRepositoryMode, mode.name);
  }

  /// Whether sync is enabled
  bool get isSyncEnabled => _prefs.getBool(_keySyncEnabled) ?? true;

  set isSyncEnabled(bool enabled) {
    _prefs.setBool(_keySyncEnabled, enabled);
  }

  /// Whether the app is in offline mode
  bool get isOfflineMode => _prefs.getBool(_keyOfflineMode) ?? false;

  set isOfflineMode(bool offline) {
    _prefs.setBool(_keyOfflineMode, offline);
  }

  /// Auto sync interval in minutes
  int get autoSyncInterval => _prefs.getInt(_keyAutoSyncInterval) ?? 15;

  set autoSyncInterval(int minutes) {
    _prefs.setInt(_keyAutoSyncInterval, minutes);
  }

  /// Default conflict resolution strategy
  ConflictResolutionStrategy get conflictResolutionStrategy {
    final strategyString = _prefs.getString(_keyConflictResolutionStrategy) ?? 'local_wins';
    return ConflictResolutionStrategy.values.firstWhere(
      (strategy) => strategy.name == strategyString,
      orElse: () => ConflictResolutionStrategy.localWins,
    );
  }

  set conflictResolutionStrategy(ConflictResolutionStrategy strategy) {
    _prefs.setString(_keyConflictResolutionStrategy, strategy.name);
  }

  /// Whether remote repositories are enabled
  bool get isRemoteEnabled => _prefs.getBool(_keyRemoteEnabled) ?? false;

  set isRemoteEnabled(bool enabled) {
    _prefs.setBool(_keyRemoteEnabled, enabled);
  }

  /// Check current connectivity status
  Future<bool> get isConnected async {
    if (isOfflineMode) return false;
    
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      return !connectivityResults.contains(ConnectivityResult.none);
    } catch (e) {
      if (kDebugMode) {
        print('Error checking connectivity: $e');
      }
      return false;
    }
  }

  /// Get connectivity stream
  Stream<bool> get connectivityStream {
    return _connectivity.onConnectivityChanged.map((results) {
      if (isOfflineMode) return false;
      return !results.contains(ConnectivityResult.none);
    });
  }

  /// Determine which repository implementation to use
  Future<RepositoryImplementation> getRepositoryImplementation() async {
    switch (repositoryMode) {
      case RepositoryMode.localOnly:
        return RepositoryImplementation.local;
        
      case RepositoryMode.remoteOnly:
        if (!isRemoteEnabled) {
          throw RepositoryConfigException(
            'Remote-only mode requested but remote repositories are not enabled'
          );
        }
        if (!await isConnected) {
          throw RepositoryConfigException(
            'Remote-only mode requested but no internet connection available'
          );
        }
        return RepositoryImplementation.remote;
        
      case RepositoryMode.localFirst:
        return RepositoryImplementation.local;
        
      case RepositoryMode.remoteFirst:
        if (isRemoteEnabled && await isConnected) {
          return RepositoryImplementation.remote;
        }
        return RepositoryImplementation.local;
        
      case RepositoryMode.hybrid:
        // For hybrid mode, return the appropriate implementation based on operation type
        // This would be determined by the specific operation context
        return await isConnected && isRemoteEnabled
            ? RepositoryImplementation.hybrid
            : RepositoryImplementation.local;
    }
  }

  /// Check if sync should be performed
  Future<bool> shouldSync() async {
    if (!isSyncEnabled || isOfflineMode || !isRemoteEnabled) {
      return false;
    }
    
    return await isConnected;
  }

  /// Check if background sync should be performed
  Future<bool> shouldPerformBackgroundSync() async {
    if (!await shouldSync()) return false;
    
    final lastSyncTime = await getLastSyncTime();
    if (lastSyncTime == null) return true;
    
    final timeSinceLastSync = DateTime.now().difference(lastSyncTime);
    return timeSinceLastSync.inMinutes >= autoSyncInterval;
  }

  /// Get last sync time
  Future<DateTime?> getLastSyncTime() async {
    final timestamp = _prefs.getString('last_sync_time');
    return timestamp != null ? DateTime.parse(timestamp) : null;
  }

  /// Update last sync time
  Future<void> updateLastSyncTime(DateTime time) async {
    await _prefs.setString('last_sync_time', time.toIso8601String());
  }

  /// Reset configuration to defaults
  Future<void> resetToDefaults() async {
    await _prefs.remove(_keyRepositoryMode);
    await _prefs.remove(_keySyncEnabled);
    await _prefs.remove(_keyOfflineMode);
    await _prefs.remove(_keyAutoSyncInterval);
    await _prefs.remove(_keyConflictResolutionStrategy);
    await _prefs.remove(_keyRemoteEnabled);
    await _prefs.remove('last_sync_time');
  }

  /// Enable remote repositories (for gradual migration)
  Future<void> enableRemoteRepositories() async {
    isRemoteEnabled = true;
    
    // If currently in local-only mode, switch to local-first
    if (repositoryMode == RepositoryMode.localOnly) {
      repositoryMode = RepositoryMode.localFirst;
    }
  }

  /// Disable remote repositories (fallback to local-only)
  Future<void> disableRemoteRepositories() async {
    isRemoteEnabled = false;
    repositoryMode = RepositoryMode.localOnly;
  }

  /// Configure for development environment
  Future<void> configureForDevelopment() async {
    repositoryMode = RepositoryMode.localFirst;
    isSyncEnabled = true;
    isOfflineMode = false;
    autoSyncInterval = 5; // More frequent sync in development
    conflictResolutionStrategy = ConflictResolutionStrategy.localWins;
  }

  /// Configure for production environment
  Future<void> configureForProduction() async {
    repositoryMode = RepositoryMode.hybrid;
    isSyncEnabled = true;
    isOfflineMode = false;
    autoSyncInterval = 15;
    conflictResolutionStrategy = ConflictResolutionStrategy.manual;
    isRemoteEnabled = true;
  }
}

/// Repository operation modes
enum RepositoryMode {
  /// Use only local repositories
  localOnly,
  
  /// Use only remote repositories (requires connection)
  remoteOnly,
  
  /// Prefer local repositories, sync in background
  localFirst,
  
  /// Prefer remote repositories, fallback to local when offline
  remoteFirst,
  
  /// Hybrid mode with intelligent switching
  hybrid,
}

/// Repository implementation types
enum RepositoryImplementation {
  local,
  remote,
  hybrid,
  mock, // For testing
}

/// Conflict resolution strategies
enum ConflictResolutionStrategy {
  /// Local changes take precedence
  localWins,
  
  /// Server changes take precedence
  serverWins,
  
  /// Attempt to merge changes intelligently
  merge,
  
  /// Require manual resolution
  manual,
  
  /// Use timestamp to determine winner (last write wins)
  lastWriteWins,
}

/// Repository configuration exception
class RepositoryConfigException implements Exception {
  final String message;
  const RepositoryConfigException(this.message);
  
  @override
  String toString() => 'RepositoryConfigException: $message';
}

/// Repository strategy that encapsulates decision logic
class RepositoryStrategy {
  final RepositoryConfig _config;
  
  const RepositoryStrategy(this._config);
  
  /// Determine the best repository implementation for a read operation
  Future<RepositoryImplementation> getReadStrategy() async {
    final baseImplementation = await _config.getRepositoryImplementation();
    
    // Read operations can be more flexible
    switch (baseImplementation) {
      case RepositoryImplementation.hybrid:
        // For reads, prefer remote if available, fallback to local
        return await _config.isConnected && _config.isRemoteEnabled
            ? RepositoryImplementation.remote
            : RepositoryImplementation.local;
      default:
        return baseImplementation;
    }
  }
  
  /// Determine the best repository implementation for a write operation
  Future<RepositoryImplementation> getWriteStrategy() async {
    final baseImplementation = await _config.getRepositoryImplementation();
    
    // Write operations should prioritize consistency
    switch (baseImplementation) {
      case RepositoryImplementation.hybrid:
        // For writes, always write to local first, then sync
        return RepositoryImplementation.local;
      default:
        return baseImplementation;
    }
  }
  
  /// Determine if operation should be cached locally
  Future<bool> shouldCacheLocally() async {
    switch (await _config.getRepositoryImplementation()) {
      case RepositoryImplementation.local:
      case RepositoryImplementation.hybrid:
        return true;
      case RepositoryImplementation.remote:
        // Cache remote operations for offline access
        return true;
      case RepositoryImplementation.mock:
        return false;
    }
  }
  
  /// Determine if operation should trigger immediate sync
  Future<bool> shouldTriggerImmediateSync() async {
    if (!await _config.shouldSync()) return false;
    
    switch (await _config.getRepositoryImplementation()) {
      case RepositoryImplementation.remote:
      case RepositoryImplementation.hybrid:
        return await _config.isConnected;
      default:
        return false;
    }
  }
}

/// Repository configuration builder for easy setup
class RepositoryConfigBuilder {
  RepositoryMode _mode = RepositoryMode.localFirst;
  bool _syncEnabled = true;
  bool _offlineMode = false;
  int _autoSyncInterval = 15;
  ConflictResolutionStrategy _conflictStrategy = ConflictResolutionStrategy.localWins;
  bool _remoteEnabled = false;
  
  RepositoryConfigBuilder setMode(RepositoryMode mode) {
    _mode = mode;
    return this;
  }
  
  RepositoryConfigBuilder setSyncEnabled(bool enabled) {
    _syncEnabled = enabled;
    return this;
  }
  
  RepositoryConfigBuilder setOfflineMode(bool offline) {
    _offlineMode = offline;
    return this;
  }
  
  RepositoryConfigBuilder setAutoSyncInterval(int minutes) {
    _autoSyncInterval = minutes;
    return this;
  }
  
  RepositoryConfigBuilder setConflictResolutionStrategy(ConflictResolutionStrategy strategy) {
    _conflictStrategy = strategy;
    return this;
  }
  
  RepositoryConfigBuilder setRemoteEnabled(bool enabled) {
    _remoteEnabled = enabled;
    return this;
  }
  
  Future<void> apply() async {
    final config = await RepositoryConfig.getInstance();
    config.repositoryMode = _mode;
    config.isSyncEnabled = _syncEnabled;
    config.isOfflineMode = _offlineMode;
    config.autoSyncInterval = _autoSyncInterval;
    config.conflictResolutionStrategy = _conflictStrategy;
    config.isRemoteEnabled = _remoteEnabled;
  }
}