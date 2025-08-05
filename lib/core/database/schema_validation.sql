-- SQLite Schema Validation and Integrity Checks
-- Ensures database integrity and validates schema structure
-- Created: 2025-08-04

-- =============================================================================
-- SCHEMA VALIDATION FUNCTIONS
-- =============================================================================

-- Check if all required tables exist
.mode column
.headers on

-- List all tables that should exist
WITH required_tables(table_name) AS (
    VALUES 
    ('users'), ('user_profiles'), ('categories'), ('equipment'), ('user_equipment'),
    ('exercises'), ('exercise_categories'), ('workouts'), ('workout_exercises'),
    ('workout_sessions'), ('exercise_logs'), ('favorites'), ('workout_shares'),
    ('workout_comments'), ('workout_ratings'), ('user_progress'), ('personal_records'),
    ('sync_status'), ('sync_conflicts')
)
SELECT 
    rt.table_name,
    CASE 
        WHEN st.name IS NOT NULL THEN '✓ EXISTS'
        ELSE '✗ MISSING'
    END as status
FROM required_tables rt
LEFT JOIN sqlite_master st ON rt.table_name = st.name AND st.type = 'table'
ORDER BY rt.table_name;

-- =============================================================================
-- FOREIGN KEY CONSTRAINT VALIDATION
-- =============================================================================

-- Check foreign key constraints integrity
PRAGMA foreign_key_check;

-- Check for orphaned records in junction tables
SELECT 'exercise_categories orphaned exercises' as check_name, COUNT(*) as count
FROM exercise_categories ec
LEFT JOIN exercises e ON ec.exercise_id = e.id
WHERE e.id IS NULL;

SELECT 'exercise_categories orphaned categories' as check_name, COUNT(*) as count
FROM exercise_categories ec
LEFT JOIN categories c ON ec.category_id = c.id
WHERE c.id IS NULL;

SELECT 'workout_exercises orphaned workouts' as check_name, COUNT(*) as count
FROM workout_exercises we
LEFT JOIN workouts w ON we.workout_id = w.id
WHERE w.id IS NULL;

SELECT 'workout_exercises orphaned exercises' as check_name, COUNT(*) as count
FROM workout_exercises we
LEFT JOIN exercises e ON we.exercise_id = e.id
WHERE e.id IS NULL;

SELECT 'user_equipment orphaned users' as check_name, COUNT(*) as count
FROM user_equipment ue
LEFT JOIN users u ON ue.user_id = u.id
WHERE u.id IS NULL;

SELECT 'user_equipment orphaned equipment' as check_name, COUNT(*) as count
FROM user_equipment ue
LEFT JOIN equipment eq ON ue.equipment_id = eq.id
WHERE eq.id IS NULL;

-- =============================================================================
-- DATA INTEGRITY CHECKS
-- =============================================================================

-- Check for duplicate user emails
SELECT 'Duplicate user emails' as check_name, COUNT(*) as count
FROM (
    SELECT email, COUNT(*) as email_count
    FROM users
    GROUP BY email
    HAVING COUNT(*) > 1
);

-- Check for users without profiles
SELECT 'Users without profiles' as check_name, COUNT(*) as count
FROM users u
LEFT JOIN user_profiles up ON u.id = up.user_id
WHERE up.id IS NULL;

-- Check for invalid enum values
SELECT 'Invalid gender values' as check_name, COUNT(*) as count
FROM user_profiles
WHERE gender NOT IN ('male', 'female', 'other', 'prefer_not_to_say') AND gender IS NOT NULL;

SELECT 'Invalid fitness levels' as check_name, COUNT(*) as count
FROM user_profiles
WHERE fitness_level NOT IN ('beginner', 'intermediate', 'advanced');

SELECT 'Invalid activity levels' as check_name, COUNT(*) as count
FROM user_profiles
WHERE activity_level NOT IN ('sedentary', 'lightly_active', 'moderately_active', 'very_active', 'extremely_active');

SELECT 'Invalid exercise difficulty levels' as check_name, COUNT(*) as count
FROM exercises
WHERE difficulty_level NOT IN ('beginner', 'intermediate', 'advanced');

SELECT 'Invalid exercise types' as check_name, COUNT(*) as count
FROM exercises
WHERE exercise_type NOT IN ('strength', 'cardio', 'flexibility', 'balance', 'plyometric', 'isometric', 'compound', 'isolation');

-- Check for invalid workout types
SELECT 'Invalid workout types' as check_name, COUNT(*) as count
FROM workouts
WHERE workout_type NOT IN ('strength', 'cardio', 'hiit', 'circuit', 'stretching', 'yoga', 'pilates', 'crosstraining', 'sports_specific', 'rehabilitation');

-- Check for invalid workout session statuses
SELECT 'Invalid workout session statuses' as check_name, COUNT(*) as count
FROM workout_sessions
WHERE status NOT IN ('planned', 'in_progress', 'completed', 'cancelled', 'paused');

-- =============================================================================
-- BUSINESS LOGIC VALIDATION
-- =============================================================================

-- Check for workout sessions with invalid duration
SELECT 'Workout sessions with negative duration' as check_name, COUNT(*) as count
FROM workout_sessions
WHERE duration_minutes < 0;

-- Check for completed sessions without completion time
SELECT 'Completed sessions without completion time' as check_name, COUNT(*) as count
FROM workout_sessions
WHERE status = 'completed' AND completed_at IS NULL;

-- Check for exercise logs with invalid sets/reps
SELECT 'Exercise logs with negative sets' as check_name, COUNT(*) as count
FROM exercise_logs
WHERE sets_completed < 0 OR sets_planned < 0;

SELECT 'Exercise logs with negative reps' as check_name, COUNT(*) as count
FROM exercise_logs
WHERE reps_completed < 0 OR reps_planned < 0;

-- Check for exercise logs with impossible weight values
SELECT 'Exercise logs with impossible weights' as check_name, COUNT(*) as count
FROM exercise_logs
WHERE weight_kg < 0 OR weight_kg > 1000; -- 1000kg is unrealistic max

-- Check for personal records with invalid values
SELECT 'Personal records with negative values' as check_name, COUNT(*) as count
FROM personal_records
WHERE value < 0;

-- Check for ratings outside valid range
SELECT 'Workout ratings outside 1-5 range' as check_name, COUNT(*) as count
FROM workout_ratings
WHERE rating < 1 OR rating > 5;

-- Check for RPE values outside valid range
SELECT 'Exercise logs with invalid RPE' as check_name, COUNT(*) as count
FROM exercise_logs
WHERE rpe < 1 OR rpe > 10;

-- =============================================================================
-- INDEX VALIDATION
-- =============================================================================

-- Check if critical indexes exist
WITH required_indexes(index_name) AS (
    VALUES 
    ('idx_users_email'),
    ('idx_user_profiles_user_id'),
    ('idx_exercises_created_by'),
    ('idx_exercises_public'),
    ('idx_workouts_created_by'),
    ('idx_workouts_public'),
    ('idx_workout_sessions_user'),
    ('idx_exercise_logs_session'),
    ('idx_favorites_user'),
    ('idx_sync_status_pending')
)
SELECT 
    ri.index_name,
    CASE 
        WHEN si.name IS NOT NULL THEN '✓ EXISTS'
        ELSE '✗ MISSING'
    END as status
FROM required_indexes ri
LEFT JOIN sqlite_master si ON ri.index_name = si.name AND si.type = 'index'
ORDER BY ri.index_name;

-- =============================================================================
-- PERFORMANCE VALIDATION QUERIES
-- =============================================================================

-- Test query performance for common operations

-- User profile lookup (should use index)
EXPLAIN QUERY PLAN
SELECT * FROM user_profiles WHERE user_id = 'user_demo_1';

-- Public exercises lookup (should use index)
EXPLAIN QUERY PLAN
SELECT * FROM exercises WHERE is_public = TRUE LIMIT 10;

-- User workouts lookup (should use index)
EXPLAIN QUERY PLAN
SELECT * FROM workouts WHERE created_by = 'user_demo_1';

-- Workout sessions by user (should use index)
EXPLAIN QUERY PLAN
SELECT * FROM workout_sessions WHERE user_id = 'user_demo_1' ORDER BY started_at DESC;

-- Exercise logs for session (should use index)
EXPLAIN QUERY PLAN
SELECT * FROM exercise_logs WHERE workout_session_id = 'ws_1' ORDER BY order_index;

-- =============================================================================
-- TRIGGER VALIDATION
-- =============================================================================

-- Check if update triggers exist for timestamp columns
WITH required_triggers(trigger_name) AS (
    VALUES 
    ('users_updated_at'),
    ('user_profiles_updated_at'),
    ('exercises_updated_at'),
    ('workouts_updated_at'),
    ('workout_sessions_updated_at')
)
SELECT 
    rt.trigger_name,
    CASE 
        WHEN st.name IS NOT NULL THEN '✓ EXISTS'
        ELSE '✗ MISSING'
    END as status
FROM required_triggers rt
LEFT JOIN sqlite_master st ON rt.trigger_name = st.name AND st.type = 'trigger'
ORDER BY rt.trigger_name;

-- =============================================================================
-- JSON FIELD VALIDATION
-- =============================================================================

-- Validate JSON fields (SQLite 3.38+ with JSON support)
-- Note: These checks will fail gracefully on older SQLite versions

-- Check if primary_muscle_groups contains valid JSON arrays
SELECT 'Invalid primary_muscle_groups JSON' as check_name, COUNT(*) as count
FROM exercises
WHERE primary_muscle_groups IS NOT NULL 
  AND json_valid(primary_muscle_groups) = 0;

-- Check if tags contain valid JSON arrays
SELECT 'Invalid exercise tags JSON' as check_name, COUNT(*) as count
FROM exercises
WHERE tags IS NOT NULL 
  AND json_valid(tags) = 0;

-- Check if fitness_goals contain valid JSON arrays
SELECT 'Invalid fitness_goals JSON' as check_name, COUNT(*) as count
FROM user_profiles
WHERE fitness_goals IS NOT NULL 
  AND json_valid(fitness_goals) = 0;

-- =============================================================================
-- SYNC STATUS VALIDATION
-- =============================================================================

-- Check for old pending sync records (older than 1 day)
SELECT 'Old pending sync records' as check_name, COUNT(*) as count
FROM sync_status
WHERE sync_status = 'pending' 
  AND local_timestamp < datetime('now', '-1 day');

-- Check for failed sync records with high retry count
SELECT 'Failed sync records with high retry count' as check_name, COUNT(*) as count
FROM sync_status
WHERE sync_status = 'failed' 
  AND retry_count > 5;

-- Check for unresolved sync conflicts
SELECT 'Unresolved sync conflicts' as check_name, COUNT(*) as count
FROM sync_conflicts
WHERE resolved_at IS NULL;

-- =============================================================================
-- CLEANUP SUGGESTIONS
-- =============================================================================

-- Find potentially orphaned data

-- Old deleted users (soft deletes)
SELECT 'Soft deleted users older than 30 days' as check_name, COUNT(*) as count
FROM users
WHERE deleted_at IS NOT NULL 
  AND deleted_at < datetime('now', '-30 days');

-- Expired workout shares
SELECT 'Expired workout shares' as check_name, COUNT(*) as count
FROM workout_shares
WHERE expires_at IS NOT NULL 
  AND expires_at < datetime('now')
  AND is_active = TRUE;

-- Old completed workout sessions (for archival consideration)
SELECT 'Completed sessions older than 1 year' as check_name, COUNT(*) as count
FROM workout_sessions
WHERE status = 'completed' 
  AND completed_at < datetime('now', '-1 year');

-- =============================================================================
-- SUMMARY STATISTICS
-- =============================================================================

-- Database size and record counts
SELECT 'Total tables' as metric, COUNT(*) as value
FROM sqlite_master WHERE type = 'table';

SELECT 'Total indexes' as metric, COUNT(*) as value
FROM sqlite_master WHERE type = 'index';

SELECT 'Total triggers' as metric, COUNT(*) as value
FROM sqlite_master WHERE type = 'trigger';

-- Record counts by table
SELECT 'Users' as table_name, COUNT(*) as record_count FROM users
UNION ALL
SELECT 'User Profiles', COUNT(*) FROM user_profiles
UNION ALL
SELECT 'Categories', COUNT(*) FROM categories
UNION ALL
SELECT 'Equipment', COUNT(*) FROM equipment
UNION ALL
SELECT 'Exercises', COUNT(*) FROM exercises
UNION ALL
SELECT 'Workouts', COUNT(*) FROM workouts
UNION ALL
SELECT 'Workout Sessions', COUNT(*) FROM workout_sessions
UNION ALL
SELECT 'Exercise Logs', COUNT(*) FROM exercise_logs
UNION ALL
SELECT 'Favorites', COUNT(*) FROM favorites
UNION ALL
SELECT 'Personal Records', COUNT(*) FROM personal_records
ORDER BY record_count DESC;

-- Database file size (requires PRAGMA in actual SQLite session)
-- PRAGMA page_count;
-- PRAGMA page_size;
-- SELECT (page_count * page_size) / 1024 / 1024 as 'Database Size (MB)' FROM (SELECT * FROM PRAGMA_page_count(), PRAGMA_page_size());

-- =============================================================================
-- VACUUM AND ANALYZE RECOMMENDATIONS
-- =============================================================================

-- These commands should be run periodically for maintenance
-- VACUUM; -- Rebuilds database to reclaim space
-- ANALYZE; -- Updates query planner statistics

SELECT 'Schema validation completed' as status, datetime('now') as timestamp;