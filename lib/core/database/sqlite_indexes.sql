-- SQLite Performance Indexes for Fitness App
-- Optimized for local-first development with sync considerations
-- Created: 2025-08-04

-- =============================================================================
-- PRIMARY KEY INDEXES (automatically created by SQLite)
-- =============================================================================
-- All tables with PRIMARY KEY automatically have indexes created by SQLite
-- No additional action needed for primary key lookups

-- =============================================================================
-- USER & AUTHENTICATION INDEXES
-- =============================================================================

-- User lookups by email (authentication)
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- User profiles lookup by user_id (most common query)
CREATE INDEX IF NOT EXISTS idx_user_profiles_user_id ON user_profiles(user_id);

-- Public profile discovery
CREATE INDEX IF NOT EXISTS idx_user_profiles_public ON user_profiles(is_public) WHERE is_public = TRUE;

-- =============================================================================
-- EXERCISE MANAGEMENT INDEXES
-- =============================================================================

-- Exercise lookups by creator and public status
CREATE INDEX IF NOT EXISTS idx_exercises_created_by ON exercises(created_by);
CREATE INDEX IF NOT EXISTS idx_exercises_public ON exercises(is_public) WHERE is_public = TRUE;

-- Exercise filtering by difficulty and type
CREATE INDEX IF NOT EXISTS idx_exercises_difficulty ON exercises(difficulty_level);
CREATE INDEX IF NOT EXISTS idx_exercises_type ON exercises(exercise_type);

-- Exercise search by name (partial matching)
CREATE INDEX IF NOT EXISTS idx_exercises_name ON exercises(name COLLATE NOCASE);

-- Composite index for common exercise queries (public exercises by difficulty)
CREATE INDEX IF NOT EXISTS idx_exercises_public_difficulty ON exercises(is_public, difficulty_level) WHERE is_public = TRUE;

-- Exercise categories junction table
CREATE INDEX IF NOT EXISTS idx_exercise_categories_exercise ON exercise_categories(exercise_id);
CREATE INDEX IF NOT EXISTS idx_exercise_categories_category ON exercise_categories(category_id);

-- =============================================================================
-- EQUIPMENT INDEXES
-- =============================================================================

-- Equipment filtering by category and availability
CREATE INDEX IF NOT EXISTS idx_equipment_category ON equipment(category);
CREATE INDEX IF NOT EXISTS idx_equipment_active ON equipment(is_active) WHERE is_active = TRUE;

-- Equipment suitability filters
CREATE INDEX IF NOT EXISTS idx_equipment_home_gym ON equipment(is_home_gym) WHERE is_home_gym = TRUE;
CREATE INDEX IF NOT EXISTS idx_equipment_commercial_gym ON equipment(is_commercial_gym) WHERE is_commercial_gym = TRUE;

-- Equipment search by name
CREATE INDEX IF NOT EXISTS idx_equipment_name ON equipment(name COLLATE NOCASE);

-- User equipment access
CREATE INDEX IF NOT EXISTS idx_user_equipment_user ON user_equipment(user_id);
CREATE INDEX IF NOT EXISTS idx_user_equipment_equipment ON user_equipment(equipment_id);
CREATE INDEX IF NOT EXISTS idx_user_equipment_access_type ON user_equipment(access_type);

-- =============================================================================
-- CATEGORY INDEXES
-- =============================================================================

-- Category hierarchy and ordering
CREATE INDEX IF NOT EXISTS idx_categories_parent ON categories(parent_category_id);
CREATE INDEX IF NOT EXISTS idx_categories_sort_order ON categories(sort_order);
CREATE INDEX IF NOT EXISTS idx_categories_active ON categories(is_active) WHERE is_active = TRUE;

-- Category name search
CREATE INDEX IF NOT EXISTS idx_categories_name ON categories(name COLLATE NOCASE);

-- =============================================================================
-- WORKOUT MANAGEMENT INDEXES
-- =============================================================================

-- Workout lookups by creator and public status
CREATE INDEX IF NOT EXISTS idx_workouts_created_by ON workouts(created_by);
CREATE INDEX IF NOT EXISTS idx_workouts_public ON workouts(is_public) WHERE is_public = TRUE;

-- Workout filtering by type and difficulty
CREATE INDEX IF NOT EXISTS idx_workouts_type ON workouts(workout_type);
CREATE INDEX IF NOT EXISTS idx_workouts_difficulty ON workouts(difficulty_level);

-- Template workouts
CREATE INDEX IF NOT EXISTS idx_workouts_template ON workouts(is_template) WHERE is_template = TRUE;

-- Workout search by name
CREATE INDEX IF NOT EXISTS idx_workouts_name ON workouts(name COLLATE NOCASE);

-- Composite index for popular workout queries
CREATE INDEX IF NOT EXISTS idx_workouts_public_type ON workouts(is_public, workout_type) WHERE is_public = TRUE;

-- Workout exercises junction table
CREATE INDEX IF NOT EXISTS idx_workout_exercises_workout ON workout_exercises(workout_id);
CREATE INDEX IF NOT EXISTS idx_workout_exercises_exercise ON workout_exercises(exercise_id);
CREATE INDEX IF NOT EXISTS idx_workout_exercises_order ON workout_exercises(workout_id, order_index);

-- Superset grouping
CREATE INDEX IF NOT EXISTS idx_workout_exercises_superset ON workout_exercises(superset_group_id) WHERE superset_group_id IS NOT NULL;

-- =============================================================================
-- WORKOUT TRACKING INDEXES
-- =============================================================================

-- Workout sessions by user (most common query)
CREATE INDEX IF NOT EXISTS idx_workout_sessions_user ON workout_sessions(user_id);

-- Workout sessions by workout template
CREATE INDEX IF NOT EXISTS idx_workout_sessions_workout ON workout_sessions(workout_id);

-- Session status filtering
CREATE INDEX IF NOT EXISTS idx_workout_sessions_status ON workout_sessions(status);

-- Session date range queries (analytics)
CREATE INDEX IF NOT EXISTS idx_workout_sessions_dates ON workout_sessions(user_id, started_at);

-- Completed sessions for progress tracking
CREATE INDEX IF NOT EXISTS idx_workout_sessions_completed ON workout_sessions(user_id, completed_at) WHERE completed_at IS NOT NULL;

-- Exercise logs by session (most common relationship)
CREATE INDEX IF NOT EXISTS idx_exercise_logs_session ON exercise_logs(workout_session_id);

-- Exercise logs by exercise (for progress tracking)
CREATE INDEX IF NOT EXISTS idx_exercise_logs_exercise ON exercise_logs(exercise_id);

-- Exercise logs order within session
CREATE INDEX IF NOT EXISTS idx_exercise_logs_order ON exercise_logs(workout_session_id, order_index);

-- Personal records tracking
CREATE INDEX IF NOT EXISTS idx_exercise_logs_pr ON exercise_logs(is_personal_record) WHERE is_personal_record = TRUE;

-- =============================================================================
-- SOCIAL & ENGAGEMENT INDEXES
-- =============================================================================

-- Favorites by user
CREATE INDEX IF NOT EXISTS idx_favorites_user ON favorites(user_id);

-- Favorites by type and item
CREATE INDEX IF NOT EXISTS idx_favorites_item ON favorites(favoritable_type, favoritable_id);

-- Workout shares
CREATE INDEX IF NOT EXISTS idx_workout_shares_workout ON workout_shares(workout_id);
CREATE INDEX IF NOT EXISTS idx_workout_shares_shared_by ON workout_shares(shared_by);
CREATE INDEX IF NOT EXISTS idx_workout_shares_shared_with ON workout_shares(shared_with);
CREATE INDEX IF NOT EXISTS idx_workout_shares_active ON workout_shares(is_active) WHERE is_active = TRUE;

-- Share type filtering
CREATE INDEX IF NOT EXISTS idx_workout_shares_type ON workout_shares(share_type);

-- Public shares
CREATE INDEX IF NOT EXISTS idx_workout_shares_public ON workout_shares(share_type) WHERE share_type = 'public';

-- Workout comments
CREATE INDEX IF NOT EXISTS idx_workout_comments_workout ON workout_comments(workout_id);
CREATE INDEX IF NOT EXISTS idx_workout_comments_user ON workout_comments(user_id);
CREATE INDEX IF NOT EXISTS idx_workout_comments_parent ON workout_comments(parent_comment_id);

-- Comment threading and chronological order
CREATE INDEX IF NOT EXISTS idx_workout_comments_thread ON workout_comments(workout_id, created_at);

-- Pinned comments
CREATE INDEX IF NOT EXISTS idx_workout_comments_pinned ON workout_comments(workout_id, is_pinned) WHERE is_pinned = TRUE;

-- Workout ratings
CREATE INDEX IF NOT EXISTS idx_workout_ratings_workout ON workout_ratings(workout_id);
CREATE INDEX IF NOT EXISTS idx_workout_ratings_user ON workout_ratings(user_id);

-- Rating analysis
CREATE INDEX IF NOT EXISTS idx_workout_ratings_rating ON workout_ratings(workout_id, rating);

-- =============================================================================
-- ANALYTICS & PROGRESS TRACKING INDEXES
-- =============================================================================

-- User progress by metric type
CREATE INDEX IF NOT EXISTS idx_user_progress_user_metric ON user_progress(user_id, metric_type);

-- Progress tracking over time
CREATE INDEX IF NOT EXISTS idx_user_progress_timeline ON user_progress(user_id, metric_type, measured_at);

-- Personal records
CREATE INDEX IF NOT EXISTS idx_personal_records_user ON personal_records(user_id);
CREATE INDEX IF NOT EXISTS idx_personal_records_exercise ON personal_records(exercise_id);
CREATE INDEX IF NOT EXISTS idx_personal_records_type ON personal_records(user_id, record_type);

-- Record achievement timeline
CREATE INDEX IF NOT EXISTS idx_personal_records_achieved ON personal_records(user_id, achieved_at);

-- Verified records
CREATE INDEX IF NOT EXISTS idx_personal_records_verified ON personal_records(is_verified) WHERE is_verified = TRUE;

-- =============================================================================
-- SYNC & OFFLINE SUPPORT INDEXES
-- =============================================================================

-- Sync status by table and operation
CREATE INDEX IF NOT EXISTS idx_sync_status_table ON sync_status(table_name);
CREATE INDEX IF NOT EXISTS idx_sync_status_record ON sync_status(table_name, record_id);
CREATE INDEX IF NOT EXISTS idx_sync_status_operation ON sync_status(operation);

-- Pending sync items
CREATE INDEX IF NOT EXISTS idx_sync_status_pending ON sync_status(sync_status, local_timestamp) WHERE sync_status = 'pending';

-- Failed sync items for retry
CREATE INDEX IF NOT EXISTS idx_sync_status_failed ON sync_status(sync_status, retry_count) WHERE sync_status = 'failed';

-- Sync conflicts
CREATE INDEX IF NOT EXISTS idx_sync_conflicts_table_record ON sync_conflicts(table_name, record_id);
CREATE INDEX IF NOT EXISTS idx_sync_conflicts_unresolved ON sync_conflicts(resolved_at) WHERE resolved_at IS NULL;

-- =============================================================================
-- TEMPORAL INDEXES FOR ANALYTICS
-- =============================================================================

-- Created/Updated timestamps for all major entities
CREATE INDEX IF NOT EXISTS idx_users_created ON users(created_at);
CREATE INDEX IF NOT EXISTS idx_exercises_created ON exercises(created_at);
CREATE INDEX IF NOT EXISTS idx_workouts_created ON workouts(created_at);
CREATE INDEX IF NOT EXISTS idx_workout_sessions_created ON workout_sessions(created_at);

-- Updated timestamps for sync optimization
CREATE INDEX IF NOT EXISTS idx_users_updated ON users(updated_at);
CREATE INDEX IF NOT EXISTS idx_exercises_updated ON exercises(updated_at);
CREATE INDEX IF NOT EXISTS idx_workouts_updated ON workouts(updated_at);
CREATE INDEX IF NOT EXISTS idx_workout_sessions_updated ON workout_sessions(updated_at);

-- =============================================================================
-- FULL-TEXT SEARCH INDEXES (FTS5)
-- =============================================================================

-- Note: SQLite FTS5 requires separate virtual tables
-- These would be created and maintained alongside the main tables

-- Exercise search
CREATE VIRTUAL TABLE IF NOT EXISTS exercises_fts USING fts5(
    name,
    description,
    instructions,
    tags,
    content='exercises',
    content_rowid='rowid'
);

-- Workout search
CREATE VIRTUAL TABLE IF NOT EXISTS workouts_fts USING fts5(
    name,
    description,
    tags,
    content='workouts',
    content_rowid='rowid'
);

-- FTS triggers to maintain search indexes
CREATE TRIGGER IF NOT EXISTS exercises_fts_insert AFTER INSERT ON exercises BEGIN
    INSERT INTO exercises_fts(rowid, name, description, instructions, tags)
    VALUES (NEW.rowid, NEW.name, NEW.description, NEW.instructions, NEW.tags);
END;

CREATE TRIGGER IF NOT EXISTS exercises_fts_delete AFTER DELETE ON exercises BEGIN
    INSERT INTO exercises_fts(exercises_fts, rowid, name, description, instructions, tags)
    VALUES ('delete', OLD.rowid, OLD.name, OLD.description, OLD.instructions, OLD.tags);
END;

CREATE TRIGGER IF NOT EXISTS exercises_fts_update AFTER UPDATE ON exercises BEGIN
    INSERT INTO exercises_fts(exercises_fts, rowid, name, description, instructions, tags)
    VALUES ('delete', OLD.rowid, OLD.name, OLD.description, OLD.instructions, OLD.tags);
    INSERT INTO exercises_fts(rowid, name, description, instructions, tags)
    VALUES (NEW.rowid, NEW.name, NEW.description, NEW.instructions, NEW.tags);
END;

CREATE TRIGGER IF NOT EXISTS workouts_fts_insert AFTER INSERT ON workouts BEGIN
    INSERT INTO workouts_fts(rowid, name, description, tags)
    VALUES (NEW.rowid, NEW.name, NEW.description, NEW.tags);
END;

CREATE TRIGGER IF NOT EXISTS workouts_fts_delete AFTER DELETE ON workouts BEGIN
    INSERT INTO workouts_fts(workouts_fts, rowid, name, description, tags)
    VALUES ('delete', OLD.rowid, OLD.name, OLD.description, OLD.tags);
END;

CREATE TRIGGER IF NOT EXISTS workouts_fts_update AFTER UPDATE ON workouts BEGIN
    INSERT INTO workouts_fts(workouts_fts, rowid, name, description, tags)
    VALUES ('delete', OLD.rowid, OLD.name, OLD.description, OLD.tags);
    INSERT INTO workouts_fts(rowid, name, description, tags)
    VALUES (NEW.rowid, NEW.name, NEW.description, NEW.tags);
END;

-- =============================================================================
-- PERFORMANCE ANALYSIS VIEWS
-- =============================================================================

-- Create view for index usage analysis (development/debug only)
-- This helps identify which indexes are being used effectively

-- Exercise performance stats
CREATE VIEW IF NOT EXISTS exercise_performance_stats AS
SELECT 
    e.id,
    e.name,
    COUNT(DISTINCT el.id) as times_performed,
    COUNT(DISTINCT el.workout_session_id) as unique_sessions,
    AVG(el.rpe) as avg_rpe,
    MAX(el.weight_kg) as max_weight,
    MAX(el.reps_completed) as max_reps,
    COUNT(CASE WHEN el.is_personal_record THEN 1 END) as personal_records_count
FROM exercises e
LEFT JOIN exercise_logs el ON e.id = el.exercise_id
GROUP BY e.id, e.name;

-- Workout popularity stats
CREATE VIEW IF NOT EXISTS workout_popularity_stats AS
SELECT 
    w.id,
    w.name,
    w.created_by,
    COUNT(DISTINCT ws.id) as times_performed,
    COUNT(DISTINCT ws.user_id) as unique_users,
    AVG(ws.workout_rating) as avg_rating,
    COUNT(DISTINCT f.id) as favorite_count,
    COUNT(DISTINCT wc.id) as comment_count
FROM workouts w
LEFT JOIN workout_sessions ws ON w.id = ws.workout_id
LEFT JOIN favorites f ON w.id = f.favoritable_id AND f.favoritable_type = 'workout'
LEFT JOIN workout_comments wc ON w.id = wc.workout_id
GROUP BY w.id, w.name, w.created_by;

-- User activity summary
CREATE VIEW IF NOT EXISTS user_activity_summary AS
SELECT 
    u.id,
    up.display_name,
    COUNT(DISTINCT ws.id) as total_workouts,
    COUNT(DISTINCT DATE(ws.started_at)) as unique_workout_days,
    AVG(ws.duration_minutes) as avg_workout_duration,
    COUNT(DISTINCT pr.id) as personal_records_count,
    MAX(ws.started_at) as last_workout_date
FROM users u
LEFT JOIN user_profiles up ON u.id = up.user_id
LEFT JOIN workout_sessions ws ON u.id = ws.user_id AND ws.status = 'completed'
LEFT JOIN personal_records pr ON u.id = pr.user_id
GROUP BY u.id, up.display_name;