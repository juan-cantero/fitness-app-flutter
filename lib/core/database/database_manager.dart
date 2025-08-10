import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// SQLite Database Manager for Fitness App
/// 
/// Handles database initialization, migrations, and local-first functionality
/// Compatible with Supabase structure for sync operations
class DatabaseManager {
  static const String _databaseName = 'fitness_app.db';
  static const int _databaseVersion = 1;
  
  static Database? _database;
  static DatabaseManager? _instance;
  
  DatabaseManager._internal();
  
  factory DatabaseManager() {
    _instance ??= DatabaseManager._internal();
    return _instance!;
  }
  
  /// Initialize database factory for desktop platforms
  static void _initializeDatabaseFactory() {
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      try {
        // Initialize FFI for desktop platforms
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
        debugPrint('Database factory initialized for desktop platform');
      } catch (e) {
        debugPrint('Failed to initialize desktop database factory: $e');
        debugPrint('This is normal on systems without SQLite3 libraries installed');
        // Fall back to default factory (will work on mobile)
      }
    }
  }
  
  /// Get the database instance
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }
  
  /// Initialize the database
  Future<Database> _initDatabase() async {
    // Initialize database factory for desktop platforms
    _initializeDatabaseFactory();
    
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }
  
  /// Configure database settings
  Future<void> _onConfigure(Database db) async {
    try {
      // Temporarily disable foreign key constraints during initialization
      await db.execute('PRAGMA foreign_keys = OFF');
      
      // Try to set journal mode to WAL for better performance
      // Some Android emulators don't support this
      try {
        await db.execute('PRAGMA journal_mode = WAL');
      } catch (e) {
        debugPrint('WAL mode not supported, using default: $e');
      }
      
      // Set synchronous mode to NORMAL for better performance
      await db.execute('PRAGMA synchronous = NORMAL');
      
      // Enable query optimization
      await db.execute('PRAGMA optimize');
    } catch (e) {
      debugPrint('Database configuration warning: $e');
    }
  }
  
  /// Create database tables and initial data
  Future<void> _onCreate(Database db, int version) async {
    try {
      // Load and execute schema
      final schemaScript = await rootBundle.loadString('lib/core/database/sqlite_schema.sql');
      await _executeSqlScript(db, schemaScript);
      
      // Load and execute indexes (with FTS5 fallback handling)
      final indexScript = await rootBundle.loadString('lib/core/database/sqlite_indexes.sql');
      await _executeSqlScriptWithFallback(db, indexScript);
      
      // Load and execute equipment catalog
      final equipmentScript = await rootBundle.loadString('lib/core/database/equipment_catalog.sql');
      await _executeSqlScript(db, equipmentScript);
      
      // Load and execute seed data
      final seedScript = await rootBundle.loadString('lib/core/database/seed_data.sql');
      await _executeSqlScript(db, seedScript);
      
      debugPrint('Database created successfully with version $_databaseVersion');
    } catch (e) {
      debugPrint('Error creating database: $e');
      rethrow;
    }
  }
  
  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('Upgrading database from version $oldVersion to $newVersion');
    
    // Handle version-specific migrations
    for (int version = oldVersion + 1; version <= newVersion; version++) {
      await _runMigration(db, version);
    }
  }
  
  /// Execute a specific migration
  Future<void> _runMigration(Database db, int version) async {
    switch (version) {
      case 2:
        // Example future migration
        // await _migrationV2(db);
        break;
      // Add more cases for future versions
      default:
        debugPrint('No migration defined for version $version');
    }
  }
  
  /// Execute SQL script with proper error handling
  Future<void> _executeSqlScript(Database db, String script) async {
    // Parse SQL script properly handling triggers and multi-statement blocks
    final statements = _parseSqlStatements(script);
    
    for (final statement in statements) {
      try {
        await db.execute(statement);
      } catch (e) {
        // Skip statements that might fail (like DROP TABLE IF EXISTS on fresh install)
        if (!statement.toUpperCase().contains('DROP') &&
            !statement.toUpperCase().contains('IF NOT EXISTS')) {
          debugPrint('Error executing statement: $statement');
          debugPrint('Error: $e');
          rethrow;
        }
      }
    }
  }
  
  /// Parse SQL statements correctly handling triggers and compound statements
  List<String> _parseSqlStatements(String script) {
    final statements = <String>[];
    final lines = script.split('\n');
    final buffer = StringBuffer();
    var inTrigger = false;
    var triggerDepth = 0;
    var isFtsTrigger = false;
    
    for (final line in lines) {
      final trimmedLine = line.trim();
      
      // Skip comments and empty lines
      if (trimmedLine.isEmpty || trimmedLine.startsWith('--')) {
        continue;
      }
      
      buffer.writeln(line);
      
      // Check for trigger start
      if (trimmedLine.toUpperCase().contains('CREATE TRIGGER')) {
        inTrigger = true;
        triggerDepth = 0;
        // Check if this is an FTS5 trigger
        isFtsTrigger = trimmedLine.toUpperCase().contains('_FTS_') ||
                      trimmedLine.toUpperCase().contains('EXERCISES_FTS') ||
                      trimmedLine.toUpperCase().contains('WORKOUTS_FTS');
      }
      
      // Track BEGIN/END depth in triggers
      if (inTrigger) {
        if (trimmedLine.toUpperCase().contains('BEGIN')) {
          triggerDepth++;
        }
        if (trimmedLine.toUpperCase().contains('END;')) {
          triggerDepth--;
          if (triggerDepth <= 0) {
            // End of trigger definition
            if (!isFtsTrigger) {
              statements.add(buffer.toString().trim());
            } else {
              debugPrint('FTS5 trigger skipped during parsing: ${buffer.toString().split('\n').first}...');
            }
            buffer.clear();
            inTrigger = false;
            triggerDepth = 0;
            isFtsTrigger = false;
          }
        }
      } else {
        // Regular statement - check for semicolon termination
        if (trimmedLine.endsWith(';')) {
          final statement = buffer.toString().trim();
          // Skip FTS5-related statements during parsing
          if (!statement.toUpperCase().contains('FTS5') &&
              !statement.toUpperCase().contains('EXERCISES_FTS') &&
              !statement.toUpperCase().contains('WORKOUTS_FTS')) {
            statements.add(statement);
          } else {
            debugPrint('FTS5 statement skipped during parsing: ${statement.split('\n').first}...');
          }
          buffer.clear();
        }
      }
    }
    
    // Add any remaining content
    if (buffer.isNotEmpty) {
      final statement = buffer.toString().trim();
      if (!statement.toUpperCase().contains('FTS5') &&
          !statement.toUpperCase().contains('EXERCISES_FTS') &&
          !statement.toUpperCase().contains('WORKOUTS_FTS')) {
        statements.add(statement);
      } else {
        debugPrint('FTS5 statement skipped during parsing: ${statement.split('\n').first}...');
      }
    }
    
    return statements.where((s) => s.isNotEmpty).toList();
  }
  
  /// Execute SQL script with FTS5 fallback handling
  Future<void> _executeSqlScriptWithFallback(Database db, String script) async {
    final statements = _parseSqlStatements(script);
    
    for (final statement in statements) {
      try {
        await db.execute(statement);
      } catch (e) {
        final upperStatement = statement.toUpperCase();
        
        // Handle FTS5 failures gracefully
        if (upperStatement.contains('FTS5') || 
            upperStatement.contains('VIRTUAL TABLE') ||
            upperStatement.contains('EXERCISES_FTS') ||
            upperStatement.contains('WORKOUTS_FTS') ||
            upperStatement.contains('_FTS_INSERT') ||
            upperStatement.contains('_FTS_DELETE') ||
            upperStatement.contains('_FTS_UPDATE') ||
            e.toString().contains('no such module') ||
            e.toString().contains('fts5') ||
            e.toString().contains('no such table: main.exercises_fts') ||
            e.toString().contains('no such table: main.workouts_fts')) {
          debugPrint('FTS5 not supported, skipping: ${statement.split('\n').first}...');
          continue;
        }
        
        // Skip statements that might fail (like DROP TABLE IF EXISTS on fresh install)
        if (!upperStatement.contains('DROP') && 
            !upperStatement.contains('IF NOT EXISTS')) {
          debugPrint('Error executing statement: $statement');
          debugPrint('Error: $e');
          rethrow;
        }
      }
    }
  }
  
  /// Validate database schema and integrity
  Future<Map<String, dynamic>> validateDatabase() async {
    final db = await database;
    
    try {
      // Basic validation - validationScript would need to be adapted 
      // to return results instead of just executing
      // For now, we'll do basic validation
      
      final results = <String, dynamic>{};
      
      // Check if all required tables exist
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
      );
      results['tables'] = tables.map((t) => t['name']).toList();
      
      // Check foreign key integrity
      final foreignKeyCheck = await db.rawQuery('PRAGMA foreign_key_check');
      results['foreign_key_violations'] = foreignKeyCheck;
      
      // Get database size
      final dbSize = await db.rawQuery('PRAGMA page_count');
      final pageSize = await db.rawQuery('PRAGMA page_size');
      results['database_size_bytes'] = 
          (dbSize.first['page_count'] as int) * (pageSize.first['page_size'] as int);
      
      // Check index usage
      final indexes = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='index' ORDER BY name"
      );
      results['indexes'] = indexes.map((i) => i['name']).toList();
      
      return results;
    } catch (e) {
      debugPrint('Error validating database: $e');
      return {'error': e.toString()};
    }
  }
  
  /// Get database statistics
  Future<Map<String, int>> getDatabaseStats() async {
    final db = await database;
    final stats = <String, int>{};
    
    // Table record counts
    final tables = [
      'users', 'user_profiles', 'categories', 'equipment', 'user_equipment',
      'exercises', 'exercise_categories', 'workouts', 'workout_exercises',
      'workout_sessions', 'exercise_logs', 'favorites', 'workout_shares',
      'workout_comments', 'workout_ratings', 'user_progress', 'personal_records',
      'sync_status', 'sync_conflicts'
    ];
    
    for (final table in tables) {
      try {
        final result = await db.rawQuery('SELECT COUNT(*) as count FROM $table');
        stats[table] = result.first['count'] as int;
      } catch (e) {
        stats[table] = 0;
      }
    }
    
    return stats;
  }
  
  /// Clear all data (for testing/reset)
  Future<void> clearAllData() async {
    final db = await database;
    
    // Disable foreign key constraints temporarily
    await db.execute('PRAGMA foreign_keys = OFF');
    
    try {
      // Get all table names except sqlite_* tables
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"
      );
      
      // Delete from all tables
      for (final table in tables) {
        await db.execute('DELETE FROM ${table['name']}');
      }
      
      // Reset auto-increment counters
      await db.execute('DELETE FROM sqlite_sequence');
      
      debugPrint('All data cleared successfully');
    } finally {
      // Re-enable foreign key constraints
      await db.execute('PRAGMA foreign_keys = ON');
    }
  }
  
  /// Rebuild database (vacuum and analyze)
  Future<void> optimizeDatabase() async {
    final db = await database;
    
    try {
      // Update query planner statistics
      await db.execute('ANALYZE');
      
      // Rebuild database to reclaim space
      await db.execute('VACUUM');
      
      debugPrint('Database optimized successfully');
    } catch (e) {
      debugPrint('Error optimizing database: $e');
      rethrow;
    }
  }
  
  /// Backup database to file
  Future<String> backupDatabase() async {
    final db = await database;
    final databasePath = db.path;
    
    // Create backup filename with timestamp
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final backupPath = '${databasePath}_backup_$timestamp';
    
    try {
      final dbFile = File(databasePath);
      await dbFile.copy(backupPath);
      debugPrint('Database backed up to: $backupPath');
      return backupPath;
    } catch (e) {
      debugPrint('Error backing up database: $e');
      rethrow;
    }
  }
  
  /// Restore database from backup
  Future<void> restoreDatabase(String backupPath) async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
    
    try {
      final databasesPath = await getDatabasesPath();
      final currentPath = join(databasesPath, _databaseName);
      
      final backupFile = File(backupPath);
      await backupFile.copy(currentPath);
      
      // Reinitialize database
      _database = await _initDatabase();
      
      debugPrint('Database restored from: $backupPath');
    } catch (e) {
      debugPrint('Error restoring database: $e');
      rethrow;
    }
  }
  
  /// Check if database needs sync (has pending changes)
  Future<bool> hasPendingSync() async {
    final db = await database;
    
    try {
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM sync_status WHERE sync_status = ?',
        ['pending']
      );
      
      return (result.first['count'] as int) > 0;
    } catch (e) {
      debugPrint('Error checking sync status: $e');
      return false;
    }
  }
  
  /// Get pending sync records
  Future<List<Map<String, dynamic>>> getPendingSyncRecords() async {
    final db = await database;
    
    try {
      return await db.query(
        'sync_status',
        where: 'sync_status = ?',
        whereArgs: ['pending'],
        orderBy: 'local_timestamp ASC'
      );
    } catch (e) {
      debugPrint('Error getting pending sync records: $e');
      return [];
    }
  }
  
  /// Mark sync record as completed
  Future<void> markSyncCompleted(String syncId, {DateTime? serverTimestamp}) async {
    final db = await database;
    
    try {
      await db.update(
        'sync_status',
        {
          'sync_status': 'synced',
          'server_timestamp': (serverTimestamp ?? DateTime.now()).toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [syncId],
      );
    } catch (e) {
      debugPrint('Error marking sync completed: $e');
      rethrow;
    }
  }
  
  /// Close database connection
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}

/// Database initialization helper
class DatabaseInitializer {
  /// Initialize database with proper error handling
  static Future<Database> initializeDatabase() async {
    try {
      final dbManager = DatabaseManager();
      final db = await dbManager.database;
      
      // Validate database after initialization
      final validation = await dbManager.validateDatabase();
      
      if (validation.containsKey('error')) {
        throw Exception('Database validation failed: ${validation['error']}');
      }
      
      debugPrint('Database initialized successfully');
      debugPrint('Tables: ${(validation['tables'] as List).length}');
      debugPrint('Indexes: ${(validation['indexes'] as List).length}');
      
      return db;
    } catch (e) {
      debugPrint('Failed to initialize database: $e');
      rethrow;
    }
  }
  
  /// Reset database to factory defaults
  static Future<void> resetDatabase() async {
    try {
      final dbManager = DatabaseManager();
      await dbManager.clearAllData();
      
      // Reload seed data
      final db = await dbManager.database;
      final seedScript = await rootBundle.loadString('lib/core/database/seed_data.sql');
      await dbManager._executeSqlScript(db, seedScript);
      
      debugPrint('Database reset to factory defaults');
    } catch (e) {
      debugPrint('Failed to reset database: $e');
      rethrow;
    }
  }
}