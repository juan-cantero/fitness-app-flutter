# Database Architecture

This guide explains our database design, from the high-level schema to implementation details. You'll learn why we chose SQLite, how our tables relate to each other, and how to work with the database effectively.

## Table of Contents
1. [Database Design Philosophy](#database-design-philosophy)
2. [Technology Choices](#technology-choices)
3. [Schema Overview](#schema-overview)
4. [Core Tables Deep Dive](#core-tables-deep-dive)
5. [Database Relationships](#database-relationships)
6. [Indexes & Performance](#indexes--performance)
7. [Synchronization Strategy](#synchronization-strategy)
8. [Working with the Database](#working-with-the-database)
9. [Migration Strategy](#migration-strategy)

## Database Design Philosophy

### Local-First Database Design

Our database is designed with **local-first** principles:

```
Primary Database: SQLite (Local)
    ↓
Background Sync: Supabase (PostgreSQL)
    ↓
Conflict Resolution: Automatic + Manual
```

**Core Principles:**
1. **Immediate Operations**: All user actions complete instantly using local data
2. **Offline Resilience**: Full functionality without internet connection
3. **Sync Awareness**: Every record tracks its synchronization status
4. **Conflict Handling**: Automatic detection and resolution of data conflicts

### Fitness Domain Modeling

Our schema models the real-world fitness domain:

```
Users create Workouts containing Exercises
    ↓
Workouts are performed as Workout Sessions
    ↓
Each Exercise in a Session creates Exercise Logs
    ↓
Exercise Logs contribute to Personal Records and Progress
```

**Domain Relationships:**
- **Users** have profiles, equipment, and create workouts
- **Exercises** are reusable building blocks with equipment requirements
- **Workouts** are templates combining exercises with sets/reps
- **Sessions** are actual workout performances tracking real data
- **Progress** emerges from analyzing session and exercise log data

## Technology Choices

### Why SQLite for Local Storage?

**SQLite Benefits:**
- ⚡ **Performance**: Native C library, extremely fast for local queries
- 🌐 **Cross-Platform**: Identical behavior on mobile, web, and desktop
- 📦 **Size**: Entire database in a single file, easy backup/restore
- 🔍 **SQL Power**: Complex queries, joins, aggregations for fitness analytics
- 🛡️ **Reliability**: ACID compliant, battle-tested in production

**Alternatives Considered:**
- **Hive/ObjectBox**: Faster for simple operations, but no SQL for complex analytics
- **Realm**: Good performance, but licensing costs and complexity
- **JSON Files**: Simple, but no query capabilities or data integrity

### Database Configuration

Our SQLite database is optimized for performance:

```dart
class DatabaseManager {
  Future<void> _onConfigure(Database db) async {
    // Enable foreign key constraints for data integrity
    await db.execute('PRAGMA foreign_keys = ON');
    
    // WAL mode for better concurrent access
    await db.execute('PRAGMA journal_mode = WAL');
    
    // Balanced performance and durability
    await db.execute('PRAGMA synchronous = NORMAL');
    
    // Query optimization
    await db.execute('PRAGMA optimize');
  }
}
```

**Configuration Explanation:**
- **Foreign Keys**: Enforces referential integrity (exercises can't be deleted if used in workouts)
- **WAL Mode**: Write-Ahead Logging allows concurrent reads during writes
- **Synchronous Normal**: Balances performance vs data safety
- **Optimize**: Updates query planner statistics for better performance

### Cross-Platform Compatibility

```dart
// Platform-specific database factory initialization
static void _initializeDatabaseFactory() {
  if (kIsWeb) {
    // Web: SQLite compiled to WebAssembly
    databaseFactory = databaseFactoryFfiWeb;
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Desktop: Foreign Function Interface to native SQLite
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  // Mobile: Uses platform-optimized SQLite
}
```

## Schema Overview

Our database has 19 main tables organized into logical groups:

### Table Categories

```
┌─ USER MANAGEMENT ──────────────────────────────────────┐
│  users, user_profiles, user_equipment                 │
├─ EXERCISE CATALOG ─────────────────────────────────────┤
│  exercises, categories, exercise_categories, equipment │
├─ WORKOUT MANAGEMENT ───────────────────────────────────┤
│  workouts, workout_exercises                           │
├─ SESSION TRACKING ─────────────────────────────────────┤
│  workout_sessions, exercise_logs                       │
├─ SOCIAL & ENGAGEMENT ──────────────────────────────────┤
│  favorites, workout_shares, workout_comments, ratings  │
├─ ANALYTICS & PROGRESS ─────────────────────────────────┤
│  user_progress, personal_records                       │
└─ SYNCHRONIZATION ──────────────────────────────────────┘
   sync_status, sync_conflicts
```

### Entity Relationship Diagram (ERD)

```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐
│    users    │────│user_profiles │    │  equipment  │
└─────────────┘    └──────────────┘    └─────────────┘
      │                                       │
      │            ┌─────────────┐           │
      └────────────│ workouts    │───────────┘
                   └─────────────┘
                         │
                   ┌─────────────┐
                   │ exercises   │
                   └─────────────┘
                         │
                   ┌─────────────┐    ┌──────────────┐
                   │workout_exer-│────│exercise_logs │
                   │cises        │    └──────────────┘
                   └─────────────┘
                         │
                   ┌─────────────┐
                   │workout_     │
                   │sessions     │
                   └─────────────┘
```

## Core Tables Deep Dive

Let's examine the most important tables and their design decisions:

### Users & Profiles

**Users Table** (mirrors Supabase auth structure):
```sql
CREATE TABLE users (
    id TEXT PRIMARY KEY NOT NULL,
    email TEXT UNIQUE NOT NULL,
    encrypted_password TEXT,
    -- Authentication fields
    email_confirmed_at DATETIME,
    last_sign_in_at DATETIME,
    -- Metadata
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

**User Profiles Table** (extended user information):
```sql
CREATE TABLE user_profiles (
    id TEXT PRIMARY KEY NOT NULL,
    user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    display_name TEXT,
    avatar_url TEXT,
    date_of_birth DATE,
    gender TEXT CHECK (gender IN ('male', 'female', 'other', 'prefer_not_to_say')),
    height_cm INTEGER,
    weight_kg REAL,
    fitness_level TEXT CHECK (fitness_level IN ('beginner', 'intermediate', 'advanced')),
    fitness_goals TEXT, -- JSON array
    activity_level TEXT CHECK (activity_level IN ('sedentary', 'lightly_active', 'moderately_active', 'very_active', 'extremely_active')),
    preferred_units TEXT CHECK (preferred_units IN ('metric', 'imperial')),
    is_public BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

**Design Decisions:**
- **Separate Tables**: Authentication data separate from profile data
- **Check Constraints**: Ensure valid enum values at database level
- **JSON Fields**: Flexible storage for arrays (fitness_goals)
- **Privacy**: is_public flag for social features

### Exercises Catalog

**Exercises Table** (comprehensive exercise data):
```sql
CREATE TABLE exercises (
    id TEXT PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    instructions TEXT, -- Step-by-step instructions
    created_by TEXT REFERENCES users(id) ON DELETE SET NULL,
    is_public BOOLEAN DEFAULT FALSE,
    difficulty_level TEXT CHECK (difficulty_level IN ('beginner', 'intermediate', 'advanced')),
    exercise_type TEXT CHECK (exercise_type IN ('strength', 'cardio', 'flexibility', 'balance', 'plyometric', 'isometric')),
    
    -- Muscle targeting
    primary_muscle_groups TEXT, -- JSON array: ['chest', 'shoulders']
    secondary_muscle_groups TEXT, -- JSON array
    
    -- Equipment
    equipment_required TEXT, -- JSON array of equipment IDs
    equipment_alternatives TEXT, -- JSON array of alternative equipment
    
    -- Movement characteristics
    movement_pattern TEXT CHECK (movement_pattern IN ('push', 'pull', 'squat', 'hinge', 'lunge', 'carry', 'gait', 'rotation')),
    tempo TEXT, -- e.g., "3-1-2-1" (eccentric-pause-concentric-pause)
    range_of_motion TEXT,
    breathing_pattern TEXT,
    
    -- Guidance and safety
    common_mistakes TEXT, -- JSON array
    progressions TEXT, -- JSON array of progression exercise IDs
    regressions TEXT, -- JSON array of regression exercise IDs
    safety_notes TEXT,
    
    -- Media
    image_url TEXT,
    video_url TEXT,
    demonstration_images TEXT, -- JSON array of image URLs
    
    -- Metrics
    calories_per_minute REAL,
    met_value REAL, -- Metabolic equivalent of task
    
    -- Classification
    tags TEXT, -- JSON array
    is_unilateral BOOLEAN DEFAULT FALSE,
    is_compound BOOLEAN DEFAULT TRUE,
    requires_spotter BOOLEAN DEFAULT FALSE,
    setup_time_seconds INTEGER DEFAULT 30,
    cleanup_time_seconds INTEGER DEFAULT 15,
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

**Why JSON Arrays in SQL?**
```sql
-- Instead of separate tables for each array, we use comma-separated strings
primary_muscle_groups TEXT, -- "chest,shoulders,triceps"

-- Advantages:
-- 1. Simpler schema (fewer tables)
-- 2. Atomic operations (update exercise in one query)
-- 3. Better performance for small arrays
-- 4. Easier serialization to/from Dart models

-- Disadvantages:
-- 1. No referential integrity on array elements
-- 2. More complex queries for filtering
-- 3. SQLite has limited JSON functions

-- We chose this approach because:
-- - Muscle groups and equipment are relatively stable
-- - Arrays are small (typically 1-5 items)
-- - Read performance is more important than complex queries
```

**Equipment Table** (comprehensive equipment catalog):
```sql
CREATE TABLE equipment (
    id TEXT PRIMARY KEY NOT NULL,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    category TEXT CHECK (category IN ('cardio', 'strength', 'functional', 'flexibility', 'bodyweight', 'accessories')),
    sub_category TEXT,
    image_url TEXT,
    muscle_groups_primary TEXT, -- JSON array
    muscle_groups_secondary TEXT, -- JSON array
    space_requirement TEXT CHECK (space_requirement IN ('minimal', 'small', 'medium', 'large')),
    difficulty_level TEXT CHECK (difficulty_level IN ('beginner', 'intermediate', 'advanced')),
    is_home_gym BOOLEAN DEFAULT TRUE,
    is_commercial_gym BOOLEAN DEFAULT TRUE,
    cost_category TEXT CHECK (cost_category IN ('free', 'low', 'medium', 'high')),
    alternatives TEXT, -- JSON array of alternative equipment IDs
    tags TEXT, -- JSON array
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### Workouts & Sessions

**Workouts Table** (workout templates):
```sql
CREATE TABLE workouts (
    id TEXT PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    created_by TEXT REFERENCES users(id) ON DELETE SET NULL,
    is_public BOOLEAN DEFAULT FALSE,
    difficulty_level TEXT CHECK (difficulty_level IN ('beginner', 'intermediate', 'advanced')),
    estimated_duration_minutes INTEGER,
    workout_type TEXT CHECK (workout_type IN ('strength', 'cardio', 'hiit', 'circuit', 'stretching', 'yoga', 'pilates')),
    target_muscle_groups TEXT, -- JSON array
    equipment_needed TEXT, -- JSON array of equipment IDs
    space_requirement TEXT CHECK (space_requirement IN ('minimal', 'small', 'medium', 'large')),
    intensity_level TEXT CHECK (intensity_level IN ('low', 'moderate', 'high', 'maximum')),
    rest_between_exercises INTEGER DEFAULT 60, -- seconds
    rest_between_sets INTEGER DEFAULT 60, -- seconds
    warmup_duration_minutes INTEGER DEFAULT 5,
    cooldown_duration_minutes INTEGER DEFAULT 5,
    calories_estimate INTEGER,
    tags TEXT, -- JSON array
    notes TEXT,
    is_template BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

**Workout Exercises Junction Table**:
```sql
CREATE TABLE workout_exercises (
    id TEXT PRIMARY KEY NOT NULL,
    workout_id TEXT NOT NULL REFERENCES workouts(id) ON DELETE CASCADE,
    exercise_id TEXT NOT NULL REFERENCES exercises(id) ON DELETE CASCADE,
    order_index INTEGER NOT NULL, -- Order of exercise in workout
    sets INTEGER DEFAULT 1,
    reps INTEGER,
    weight_kg REAL,
    duration_seconds INTEGER,
    distance_meters REAL,
    rest_time_seconds INTEGER DEFAULT 60,
    intensity_percentage REAL, -- % of 1RM or max effort
    tempo TEXT, -- Override exercise default tempo
    notes TEXT,
    is_superset BOOLEAN DEFAULT FALSE,
    superset_group_id TEXT, -- Groups exercises performed back-to-back
    is_dropset BOOLEAN DEFAULT FALSE,
    is_warmup BOOLEAN DEFAULT FALSE,
    is_cooldown BOOLEAN DEFAULT FALSE,
    target_rpe INTEGER CHECK (target_rpe BETWEEN 1 AND 10), -- Rate of Perceived Exertion
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

**Workout Sessions Table** (actual workout performances):
```sql
CREATE TABLE workout_sessions (
    id TEXT PRIMARY KEY NOT NULL,
    user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    workout_id TEXT REFERENCES workouts(id) ON DELETE SET NULL, -- Template used
    name TEXT, -- Optional custom name for the session
    started_at DATETIME NOT NULL,
    completed_at DATETIME,
    duration_minutes INTEGER,
    status TEXT CHECK (status IN ('planned', 'in_progress', 'completed', 'cancelled', 'paused')),
    location TEXT,
    weather_conditions TEXT,
    energy_level_start INTEGER CHECK (energy_level_start BETWEEN 1 AND 10),
    energy_level_end INTEGER CHECK (energy_level_end BETWEEN 1 AND 10),
    perceived_exertion INTEGER CHECK (perceived_exertion BETWEEN 1 AND 10),
    mood_before TEXT,
    mood_after TEXT,
    calories_burned INTEGER,
    heart_rate_avg INTEGER,
    heart_rate_max INTEGER,
    notes TEXT,
    workout_rating INTEGER CHECK (workout_rating BETWEEN 1 AND 5),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

**Exercise Logs Table** (individual exercise performances):
```sql
CREATE TABLE exercise_logs (
    id TEXT PRIMARY KEY NOT NULL,
    workout_session_id TEXT NOT NULL REFERENCES workout_sessions(id) ON DELETE CASCADE,
    exercise_id TEXT NOT NULL REFERENCES exercises(id) ON DELETE CASCADE,
    workout_exercise_id TEXT REFERENCES workout_exercises(id) ON DELETE SET NULL,
    order_index INTEGER NOT NULL,
    sets_completed INTEGER DEFAULT 0,
    sets_planned INTEGER DEFAULT 1,
    reps_completed INTEGER,
    reps_planned INTEGER,
    weight_kg REAL,
    duration_seconds INTEGER,
    distance_meters REAL,
    rest_time_seconds INTEGER,
    intensity_percentage REAL,
    rpe INTEGER CHECK (rpe BETWEEN 1 AND 10), -- Actual Rate of Perceived Exertion
    form_rating INTEGER CHECK (form_rating BETWEEN 1 AND 5),
    equipment_used TEXT, -- JSON array of actual equipment IDs used
    notes TEXT,
    is_personal_record BOOLEAN DEFAULT FALSE,
    previous_best_weight REAL,
    previous_best_reps INTEGER,
    previous_best_duration INTEGER,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

## Database Relationships

### Primary Relationships

**One-to-Many Relationships:**
```sql
-- User has many workouts
users(id) ←──── workouts(created_by)

-- Workout has many exercises  
workouts(id) ←──── workout_exercises(workout_id)

-- User has many sessions
users(id) ←──── workout_sessions(user_id)

-- Session has many exercise logs
workout_sessions(id) ←──── exercise_logs(workout_session_id)
```

**Many-to-Many Relationships:**
```sql
-- Exercises belong to many categories (via junction table)
exercises ←──── exercise_categories ────→ categories

-- Users can favorite many exercises/workouts
users ←──── favorites ────→ exercises/workouts

-- Users have access to many equipment
users ←──── user_equipment ────→ equipment
```

### Referential Integrity

**CASCADE Deletes** (child records deleted when parent is deleted):
```sql
-- Delete user → delete all their sessions and logs
user_id REFERENCES users(id) ON DELETE CASCADE

-- Delete session → delete all exercise logs
workout_session_id REFERENCES workout_sessions(id) ON DELETE CASCADE
```

**SET NULL Deletes** (reference set to NULL when parent is deleted):
```sql
-- Delete workout template → sessions keep data but lose template reference
workout_id REFERENCES workouts(id) ON DELETE SET NULL

-- Delete user → exercises become anonymous but aren't lost
created_by REFERENCES users(id) ON DELETE SET NULL
```

### Complex Queries Examples

**Find all exercises that work chest muscles and use dumbbells:**
```sql
SELECT e.*, COUNT(we.exercise_id) as usage_count
FROM exercises e
LEFT JOIN workout_exercises we ON e.id = we.exercise_id
WHERE LOWER(e.primary_muscle_groups) LIKE '%chest%'
  AND LOWER(e.equipment_required) LIKE '%dumbbell%'
GROUP BY e.id
ORDER BY usage_count DESC, e.name ASC;
```

**Get user's workout history with exercise counts:**
```sql
SELECT 
    ws.id,
    ws.name,
    ws.started_at,
    ws.duration_minutes,
    COUNT(el.id) as exercises_performed,
    AVG(el.rpe) as average_rpe
FROM workout_sessions ws
LEFT JOIN exercise_logs el ON ws.id = el.workout_session_id
WHERE ws.user_id = ?
  AND ws.status = 'completed'
GROUP BY ws.id
ORDER BY ws.started_at DESC;
```

**Find personal records for a specific exercise:**
```sql
SELECT 
    MAX(weight_kg) as max_weight,
    MAX(reps_completed) as max_reps,
    MAX(weight_kg * reps_completed) as max_volume
FROM exercise_logs el
JOIN workout_sessions ws ON el.workout_session_id = ws.id
WHERE ws.user_id = ?
  AND el.exercise_id = ?
  AND ws.status = 'completed';
```

## Indexes & Performance

### Primary Indexes

**Automatically Created:**
```sql
-- Primary keys automatically get unique indexes
CREATE UNIQUE INDEX users_pkey ON users(id);
CREATE UNIQUE INDEX exercises_pkey ON exercises(id);
-- ... etc for all tables
```

### Query Optimization Indexes

**Most Important Indexes:**
```sql
-- User lookup performance
CREATE INDEX idx_user_profiles_user_id ON user_profiles(user_id);
CREATE INDEX idx_workout_sessions_user_id ON workout_sessions(user_id);
CREATE INDEX idx_exercise_logs_user_session ON exercise_logs(workout_session_id);

-- Exercise search performance
CREATE INDEX idx_exercises_name ON exercises(name);
CREATE INDEX idx_exercises_muscle_groups ON exercises(primary_muscle_groups);
CREATE INDEX idx_exercises_difficulty ON exercises(difficulty_level);
CREATE INDEX idx_exercises_equipment ON exercises(equipment_required);

-- Workout filtering
CREATE INDEX idx_workouts_created_by ON workouts(created_by);
CREATE INDEX idx_workouts_public ON workouts(is_public);
CREATE INDEX idx_workouts_type ON workouts(workout_type);

-- Session performance
CREATE INDEX idx_workout_sessions_status ON workout_sessions(status);
CREATE INDEX idx_workout_sessions_date ON workout_sessions(started_at);

-- Junction table performance
CREATE INDEX idx_workout_exercises_workout ON workout_exercises(workout_id);
CREATE INDEX idx_workout_exercises_exercise ON workout_exercises(exercise_id);
CREATE INDEX idx_exercise_categories_exercise ON exercise_categories(exercise_id);
CREATE INDEX idx_exercise_categories_category ON exercise_categories(category_id);

-- Sync performance
CREATE INDEX idx_sync_status_table_record ON sync_status(table_name, record_id);
CREATE INDEX idx_sync_status_pending ON sync_status(sync_status) WHERE sync_status = 'pending';
```

### Performance Monitoring

**Built-in Database Stats:**
```dart
// Get database statistics
Future<Map<String, int>> getDatabaseStats() async {
  final db = await database;
  final stats = <String, int>{};
  
  // Table record counts
  final tables = ['users', 'exercises', 'workouts', 'workout_sessions'];
  
  for (final table in tables) {
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM $table');
    stats[table] = result.first['count'] as int;
  }
  
  return stats;
}

// Check query performance
await db.rawQuery('EXPLAIN QUERY PLAN SELECT * FROM exercises WHERE name LIKE ?', ['%push%']);
```

## Synchronization Strategy

### Sync Status Tracking

Every data modification creates a sync record:

```sql
CREATE TABLE sync_status (
    id TEXT PRIMARY KEY NOT NULL,
    table_name TEXT NOT NULL, -- Which table was modified
    record_id TEXT NOT NULL,  -- Which record was modified
    operation TEXT NOT NULL CHECK (operation IN ('insert', 'update', 'delete')),
    local_timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    server_timestamp DATETIME,
    sync_status TEXT NOT NULL CHECK (sync_status IN ('pending', 'synced', 'conflict', 'failed')),
    retry_count INTEGER DEFAULT 0,
    error_message TEXT,
    record_data TEXT, -- JSON representation of the record
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### Conflict Resolution

When sync conflicts occur:

```sql
CREATE TABLE sync_conflicts (
    id TEXT PRIMARY KEY NOT NULL,
    table_name TEXT NOT NULL,
    record_id TEXT NOT NULL,
    local_data TEXT NOT NULL, -- JSON of local version
    server_data TEXT NOT NULL, -- JSON of server version
    conflict_type TEXT NOT NULL CHECK (conflict_type IN ('update_conflict', 'delete_conflict')),
    resolution_strategy TEXT CHECK (resolution_strategy IN ('local_wins', 'server_wins', 'manual', 'merge')),
    resolved_at DATETIME,
    resolved_by TEXT REFERENCES users(id) ON DELETE SET NULL,
    resolution_data TEXT, -- JSON of resolved data
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### Sync Implementation Example

```dart
// Mark record for sync when creating
Future<Exercise> create(Exercise exercise) async {
  final db = await database;
  
  await db.transaction((txn) async {
    // 1. Insert the exercise
    await txn.insert('exercises', exercise.toDatabase());
    
    // 2. Create sync record
    await txn.insert('sync_status', {
      'id': generateId(),
      'table_name': 'exercises',
      'record_id': exercise.id,
      'operation': 'insert',
      'sync_status': 'pending',
      'record_data': jsonEncode(exercise.toJson()),
    });
  });
  
  // 3. Schedule background sync
  _syncService.scheduleSync();
  
  return exercise;
}
```

## Working with the Database

### Database Manager Usage

```dart
// Get database instance
final dbManager = DatabaseManager();
final db = await dbManager.database;

// Validate database integrity
final validation = await dbManager.validateDatabase();
print('Tables: ${validation['tables']}');
print('Foreign key violations: ${validation['foreign_key_violations']}');

// Get statistics
final stats = await dbManager.getDatabaseStats();
print('Total exercises: ${stats['exercises']}');

// Backup database
final backupPath = await dbManager.backupDatabase();
print('Database backed up to: $backupPath');
```

### Direct SQL Queries

```dart
// Simple query
final exercises = await db.query('exercises', limit: 10);

// Complex query with joins
final workoutDetails = await db.rawQuery('''
  SELECT 
    w.name as workout_name,
    e.name as exercise_name,
    we.sets,
    we.reps
  FROM workouts w
  JOIN workout_exercises we ON w.id = we.workout_id
  JOIN exercises e ON we.exercise_id = e.id
  WHERE w.id = ?
  ORDER BY we.order_index
''', [workoutId]);

// Parameterized queries (always use these for user input!)
final searchResults = await db.query(
  'exercises',
  where: 'LOWER(name) LIKE ?',
  whereArgs: ['%${query.toLowerCase()}%'],
);
```

### Transaction Usage

```dart
// Use transactions for multi-table operations
await db.transaction((txn) async {
  // Create workout
  await txn.insert('workouts', workout.toDatabase());
  
  // Add exercises to workout
  for (final exercise in workoutExercises) {
    await txn.insert('workout_exercises', exercise.toDatabase());
  }
  
  // Update user stats
  await txn.update('user_profiles', {
    'total_workouts': totalWorkouts + 1,
  }, where: 'user_id = ?', whereArgs: [userId]);
});
```

## Migration Strategy

### Version Management

```dart
class DatabaseManager {
  static const int _databaseVersion = 1;
  
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    for (int version = oldVersion + 1; version <= newVersion; version++) {
      await _runMigration(db, version);
    }
  }
  
  Future<void> _runMigration(Database db, int version) async {
    switch (version) {
      case 2:
        await _migrationV2(db);
        break;
      case 3:
        await _migrationV3(db);
        break;
      default:
        throw Exception('No migration defined for version $version');
    }
  }
}
```

### Migration Examples

**Adding a New Column:**
```dart
Future<void> _migrationV2(Database db) async {
  // Add new column to exercises table
  await db.execute('''
    ALTER TABLE exercises 
    ADD COLUMN difficulty_rating REAL DEFAULT NULL
  ''');
  
  // Update existing records with default values
  await db.execute('''
    UPDATE exercises 
    SET difficulty_rating = 
      CASE difficulty_level
        WHEN 'beginner' THEN 2.0
        WHEN 'intermediate' THEN 5.0
        WHEN 'advanced' THEN 8.0
        ELSE 5.0
      END
  ''');
}
```

**Creating New Tables:**
```dart
Future<void> _migrationV3(Database db) async {
  // Create new achievements table
  await db.execute('''
    CREATE TABLE achievements (
      id TEXT PRIMARY KEY NOT NULL,
      user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
      achievement_type TEXT NOT NULL,
      title TEXT NOT NULL,
      description TEXT,
      earned_at DATETIME NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  ''');
  
  // Create index for performance
  await db.execute('''
    CREATE INDEX idx_achievements_user_id ON achievements(user_id)
  ''');
}
```

### Safe Migration Practices

**Always:**
- ✅ Test migrations on backup data first
- ✅ Use transactions for multi-step migrations
- ✅ Provide default values for new columns
- ✅ Update indexes after schema changes

**Never:**
- ❌ Delete columns (SQLite doesn't support it easily)
- ❌ Change data types without careful conversion
- ❌ Remove foreign key constraints on existing data
- ❌ Run migrations without backups

## Next Steps

Now that you understand the database architecture:

1. **Explore the Schema**: Look at the actual SQL files in `lib/core/database/`
2. **Study Repository Implementation**: See how [Repository Pattern](./05-repository-pattern.md) abstracts database access
3. **Practice Queries**: Use the database debug screen to experiment with queries
4. **Understand Data Models**: Learn how [Data Models](./07-data-models.md) map to database tables

**Questions about the database?**
- Use the database debug screen in the app to explore real data
- Check the SQL files for the complete schema
- Look at repository implementations for query examples

---

**Next:** Continue to [Repository Pattern & Local-First](./05-repository-pattern.md) to understand how we abstract database access and implement sync-aware operations.