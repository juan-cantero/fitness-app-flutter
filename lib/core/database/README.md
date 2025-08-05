# SQLite Database Architecture for Fitness App

## Overview

This directory contains a comprehensive SQLite database schema designed for local-first development of a Flutter fitness app. The schema is compatible with Supabase PostgreSQL structure to enable seamless synchronization between local and cloud databases.

## 🏗️ Architecture Features

- **Local-First Design**: Full offline functionality with sync capabilities
- **Supabase Compatible**: Schema mirrors Supabase structure for easy sync
- **Performance Optimized**: Comprehensive indexing strategy for fast queries  
- **Equipment Management**: Detailed equipment catalog with compatibility mapping
- **Progress Tracking**: Personal records, measurements, and analytics
- **Social Features**: Sharing, comments, ratings, and favorites
- **Data Integrity**: Foreign key constraints and validation checks
- **Conflict Resolution**: Built-in sync conflict handling

## 📁 File Structure

```
lib/core/database/
├── sqlite_schema.sql           # Complete database schema
├── sqlite_indexes.sql          # Performance indexes and FTS
├── seed_data.sql              # Sample data for development
├── equipment_catalog.sql      # Comprehensive equipment database
├── schema_validation.sql      # Integrity checks and validation
├── database_manager.dart      # Flutter database management class
└── README.md                  # This documentation
```

## 🚀 Quick Start

### 1. Initialize Database

```dart
import 'package:your_app/core/database/database_manager.dart';

// Initialize database
final db = await DatabaseInitializer.initializeDatabase();

// Or use the manager directly
final dbManager = DatabaseManager();
final database = await dbManager.database;
```

### 2. Validate Database

```dart
final dbManager = DatabaseManager();
final validation = await dbManager.validateDatabase();

if (validation.containsKey('error')) {
  print('Database validation failed: ${validation['error']}');
} else {
  print('Database is healthy');
  print('Tables: ${validation['tables'].length}');
  print('Indexes: ${validation['indexes'].length}');
}
```

### 3. Get Database Statistics

```dart
final stats = await dbManager.getDatabaseStats();
print('Users: ${stats['users']}');
print('Exercises: ${stats['exercises']}');
print('Workouts: ${stats['workouts']}');
```

## 📊 Database Schema

### Core Tables

#### Users & Profiles
- **users**: Core user authentication data (mirrors Supabase auth.users)
- **user_profiles**: Extended user information and preferences
- **user_progress**: Body measurements and fitness metrics over time
- **personal_records**: Achievement tracking for exercises

#### Exercise Management
- **categories**: Hierarchical exercise categorization
- **exercises**: Comprehensive exercise database with instructions
- **exercise_categories**: Many-to-many exercise-category relationships

#### Equipment System
- **equipment**: Detailed equipment catalog (150+ items)
- **user_equipment**: Track what equipment users have access to

#### Workout System
- **workouts**: Workout templates and user-created workouts
- **workout_exercises**: Exercise order and parameters within workouts
- **workout_sessions**: Actual workout performances
- **exercise_logs**: Individual exercise performance data

#### Social Features
- **favorites**: User favorites for exercises and workouts
- **workout_shares**: Workout sharing between users
- **workout_comments**: Comments on shared workouts
- **workout_ratings**: Rating system for workouts

#### Sync & Offline Support  
- **sync_status**: Track pending synchronization operations
- **sync_conflicts**: Handle sync conflicts between local and server

### Equipment Catalog Highlights

The equipment catalog includes 150+ items across categories:

- **Bodyweight**: No equipment needed exercises
- **Free Weights**: Dumbbells, barbells, kettlebells, plates
- **Cardio**: Treadmills, bikes, rowing machines, jump ropes
- **Functional**: Resistance bands, suspension trainers, medicine balls
- **Machines**: Cable machines, leg press, lat pulldown
- **Accessories**: Mats, foam rollers, straps, belts
- **Outdoor**: Running, park equipment, natural terrain
- **Household**: Creative use of everyday items

Each equipment entry includes:
- Muscle groups targeted
- Space requirements
- Difficulty level
- Home vs commercial gym suitability
- Cost category
- Alternative equipment suggestions

## 🔍 Performance Optimization

### Indexing Strategy

The database includes 40+ indexes optimized for common queries:

- **User Lookups**: Fast authentication and profile access
- **Exercise Filtering**: By difficulty, type, muscle groups, equipment
- **Workout Discovery**: Public workouts, user workouts, templates
- **Session Tracking**: User workout history and progress
- **Social Queries**: Favorites, shares, comments, ratings
- **Sync Operations**: Pending changes and conflict resolution

### Full-Text Search

FTS5 virtual tables enable fast text search across:
- Exercise names, descriptions, and instructions
- Workout names, descriptions, and tags
- Automatic index maintenance via triggers

### Query Performance

Common query patterns are optimized:
```sql
-- User exercises (uses idx_exercises_created_by)
SELECT * FROM exercises WHERE created_by = ? ORDER BY created_at DESC;

-- Public workouts by type (uses idx_workouts_public_type)
SELECT * FROM workouts WHERE is_public = TRUE AND workout_type = ?;

-- User workout history (uses idx_workout_sessions_user)
SELECT * FROM workout_sessions WHERE user_id = ? ORDER BY started_at DESC;
```

## 🛠️ Development Tools

### Schema Validation

Run comprehensive integrity checks:
```bash
# In SQLite CLI
.read lib/core/database/schema_validation.sql
```

Validation includes:
- Foreign key constraint verification
- Data type and enum validation
- Business logic checks (e.g., no negative weights)
- Orphaned record detection
- Index usage analysis

### Database Maintenance

```dart
// Optimize database performance
await dbManager.optimizeDatabase();

// Backup database
final backupPath = await dbManager.backupDatabase();

// Restore from backup
await dbManager.restoreDatabase(backupPath);

// Reset to factory defaults
await DatabaseInitializer.resetDatabase();
```

## 🔄 Sync Architecture

### Local-First Approach

1. **All operations work offline**: Create, read, update, delete
2. **Automatic change tracking**: Every modification logged in sync_status
3. **Conflict resolution**: Handle concurrent changes gracefully
4. **Incremental sync**: Only sync changed records

### Sync Status Tracking

```dart
// Check if sync is needed
final hasPending = await dbManager.hasPendingSync();

// Get pending changes
final pendingRecords = await dbManager.getPendingSyncRecords();

// Mark sync completed
await dbManager.markSyncCompleted(syncId, serverTimestamp: DateTime.now());
```

### Conflict Resolution

When sync conflicts occur:
1. Record stored in `sync_conflicts` table
2. Present resolution options to user:
   - Keep local changes
   - Accept server changes  
   - Manual merge
3. Apply resolution and update sync status

## 📱 Flutter Integration

### Using with sqflite

```dart
// Get database instance
final db = await DatabaseManager().database;

// Query exercises
final exercises = await db.query(
  'exercises',
  where: 'is_public = ? AND difficulty_level = ?',
  whereArgs: [true, 'beginner'],
  orderBy: 'name ASC',
);

// Insert workout session
final sessionId = await db.insert('workout_sessions', {
  'id': uuid.v4(),
  'user_id': currentUserId,
  'workout_id': workoutId,
  'started_at': DateTime.now().toIso8601String(),
  'status': 'in_progress',
});
```

### Using with Riverpod

```dart
// Database provider
final databaseProvider = FutureProvider<Database>((ref) async {
  return await DatabaseManager().database;
});

// Exercises repository
final exercisesRepositoryProvider = Provider<ExercisesRepository>((ref) {
  final database = ref.watch(databaseProvider).value;
  return ExercisesRepository(database!);
});
```

## 🚨 Data Validation

### Business Rules Enforced

- Users must have profiles
- Completed workout sessions must have completion times
- Exercise weights cannot be negative or exceed 1000kg
- RPE values must be between 1-10
- Ratings must be between 1-5 stars
- Set and rep counts cannot be negative

### JSON Field Validation

For SQLite 3.38+ with JSON support:
- Validates JSON structure in array fields
- Ensures muscle groups, tags, and fitness goals are valid JSON
- Graceful degradation for older SQLite versions

## 🎯 Best Practices

### 1. Use Transactions for Multi-Table Operations

```dart
await db.transaction((txn) async {
  // Insert workout
  await txn.insert('workouts', workoutData);
  
  // Insert workout exercises
  for (final exercise in exercises) {
    await txn.insert('workout_exercises', exercise);
  }
});
```

### 2. Implement Proper Error Handling

```dart
try {
  final result = await db.query('exercises', where: 'id = ?', whereArgs: [id]);
  return result.isNotEmpty ? Exercise.fromJson(result.first) : null;
} catch (e) {
  // Log error and return appropriate response
  logger.error('Failed to fetch exercise: $e');
  return null;
}
```

### 3. Use Prepared Statements

```dart
// Good - uses parameters
await db.query('exercises', where: 'name LIKE ?', whereArgs: ['%$searchTerm%']);

// Bad - SQL injection risk  
await db.rawQuery("SELECT * FROM exercises WHERE name LIKE '%$searchTerm%'");
```

### 4. Optimize Queries with EXPLAIN

```dart
// Analyze query performance
final explanation = await db.rawQuery('EXPLAIN QUERY PLAN SELECT * FROM exercises WHERE is_public = 1');
print(explanation);
```

## 📈 Monitoring & Analytics

### Database Metrics

Track key metrics for performance monitoring:
- Query execution times
- Database file size growth
- Sync operation success rates
- Most frequently accessed tables
- Index usage statistics

### User Analytics

Built-in views for analytics:
- `exercise_performance_stats`: Exercise popularity and performance
- `workout_popularity_stats`: Workout usage and ratings
- `user_activity_summary`: User engagement metrics

## 🔧 Troubleshooting

### Common Issues

1. **Foreign Key Violations**
   ```sql
   PRAGMA foreign_key_check;
   ```

2. **Query Performance Issues**
   ```sql
   EXPLAIN QUERY PLAN SELECT ...;
   ANALYZE;
   ```

3. **Database Corruption**
   ```sql
   PRAGMA integrity_check;
   ```

4. **Sync Conflicts**
   ```dart
   final conflicts = await db.query('sync_conflicts', where: 'resolved_at IS NULL');
   ```

### Recovery Procedures

1. **Database Repair**: Use VACUUM and ANALYZE
2. **Schema Reset**: Drop and recreate tables
3. **Data Recovery**: Restore from backup
4. **Sync Reset**: Clear sync status and re-sync all data

## 🚀 Future Enhancements

### Planned Features

1. **Advanced Analytics**: ML-based workout recommendations
2. **Media Management**: Image and video storage optimization
3. **Offline Mapping**: GPS workout tracking with offline maps
4. **Social Features**: Friend connections and challenges
5. **Wearable Integration**: Heart rate and fitness tracker sync

### Schema Evolution

When adding new features:
1. Create migration scripts in `database_manager.dart`
2. Update schema version number
3. Test migration with existing data
4. Document changes in this README

## 📚 References

- [SQLite Documentation](https://sqlite.org/docs.html)
- [sqflite Package](https://pub.dev/packages/sqflite)
- [Supabase Flutter](https://pub.dev/packages/supabase_flutter)
- [Database Design Best Practices](https://www.sqlstyle.guide/)

---

**Created**: 2025-08-04  
**Version**: 1.0  
**Compatibility**: SQLite 3.35+, Flutter 3.0+