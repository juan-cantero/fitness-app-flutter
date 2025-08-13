-- SQLite Schema for Fitness App
-- Compatible with Supabase structure for local-first development
-- Created: 2025-08-04

-- Enable foreign key constraints
PRAGMA foreign_keys = ON;

-- =============================================================================
-- CORE USER TABLES
-- =============================================================================

-- Users table (mirrors Supabase auth.users structure)
CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY NOT NULL,
    email TEXT UNIQUE NOT NULL,
    encrypted_password TEXT,
    email_confirmed_at DATETIME,
    invited_at DATETIME,
    confirmation_token TEXT,
    confirmation_sent_at DATETIME,
    recovery_token TEXT,
    recovery_sent_at DATETIME,
    email_change_token_new TEXT,
    email_change TEXT,
    email_change_sent_at DATETIME,
    last_sign_in_at DATETIME,
    raw_app_meta_data TEXT, -- JSON as TEXT
    raw_user_meta_data TEXT, -- JSON as TEXT
    is_super_admin BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    phone TEXT,
    phone_confirmed_at DATETIME,
    phone_change TEXT,
    phone_change_token TEXT,
    phone_change_sent_at DATETIME,
    confirmed_at DATETIME,
    email_change_token_current TEXT DEFAULT '',
    email_change_confirm_status INTEGER DEFAULT 0,
    banned_until DATETIME,
    reauthentication_token TEXT DEFAULT '',
    reauthentication_sent_at DATETIME,
    is_sso_user BOOLEAN DEFAULT FALSE,
    deleted_at DATETIME
);

-- User profiles table for extended user information
CREATE TABLE IF NOT EXISTS user_profiles (
    id TEXT PRIMARY KEY NOT NULL,
    user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    display_name TEXT,
    avatar_url TEXT,
    bio TEXT,
    date_of_birth DATE,
    gender TEXT CHECK (gender IN ('male', 'female', 'other', 'prefer_not_to_say')),
    height_cm INTEGER,
    weight_kg REAL,
    fitness_level TEXT CHECK (fitness_level IN ('beginner', 'intermediate', 'advanced')) DEFAULT 'beginner',
    fitness_goals TEXT, -- JSON array as TEXT
    activity_level TEXT CHECK (activity_level IN ('sedentary', 'lightly_active', 'moderately_active', 'very_active', 'extremely_active')) DEFAULT 'moderately_active',
    preferred_units TEXT CHECK (preferred_units IN ('metric', 'imperial')) DEFAULT 'metric',
    timezone TEXT DEFAULT 'UTC',
    is_public BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- EXERCISE MANAGEMENT TABLES
-- =============================================================================

-- Categories table for organizing exercises
CREATE TABLE IF NOT EXISTS categories (
    id TEXT PRIMARY KEY NOT NULL,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    icon TEXT,
    color TEXT,
    parent_category_id TEXT REFERENCES categories(id) ON DELETE SET NULL,
    sort_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Equipment catalog table
CREATE TABLE IF NOT EXISTS equipment (
    id TEXT PRIMARY KEY NOT NULL,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    category TEXT CHECK (category IN (
        'cardio',
        'strength',
        'functional',
        'flexibility',
        'bodyweight',
        'accessories'
    )) DEFAULT 'strength',
    sub_category TEXT,
    image_url TEXT,
    muscle_groups_primary TEXT, -- JSON array as TEXT
    muscle_groups_secondary TEXT, -- JSON array as TEXT
    space_requirement TEXT CHECK (space_requirement IN ('minimal', 'small', 'medium', 'large')) DEFAULT 'minimal',
    difficulty_level TEXT CHECK (difficulty_level IN ('beginner', 'intermediate', 'advanced')) DEFAULT 'beginner',
    is_home_gym BOOLEAN DEFAULT TRUE,
    is_commercial_gym BOOLEAN DEFAULT TRUE,
    cost_category TEXT CHECK (cost_category IN ('free', 'low', 'medium', 'high')) DEFAULT 'medium',
    alternatives TEXT, -- JSON array of alternative equipment IDs
    tags TEXT, -- JSON array as TEXT
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- User equipment for tracking what equipment users have access to
CREATE TABLE IF NOT EXISTS user_equipment (
    id TEXT PRIMARY KEY NOT NULL,
    user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    equipment_id TEXT NOT NULL REFERENCES equipment(id) ON DELETE CASCADE,
    access_type TEXT CHECK (access_type IN ('owned', 'gym_access', 'occasional')) DEFAULT 'owned',
    condition_rating INTEGER CHECK (condition_rating BETWEEN 1 AND 5),
    notes TEXT,
    acquired_date DATE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, equipment_id)
);

-- Exercises table with comprehensive exercise data
CREATE TABLE IF NOT EXISTS exercises (
    id TEXT PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    instructions TEXT, -- Detailed step-by-step instructions
    created_by TEXT REFERENCES users(id) ON DELETE SET NULL,
    is_public BOOLEAN DEFAULT FALSE,
    difficulty_level TEXT CHECK (difficulty_level IN ('beginner', 'intermediate', 'advanced')) DEFAULT 'beginner',
    exercise_type TEXT CHECK (exercise_type IN (
        'strength',
        'cardio',
        'flexibility',
        'balance',
        'plyometric',
        'isometric',
        'compound',
        'isolation'
    )) DEFAULT 'strength',
    primary_muscle_groups TEXT, -- JSON array as TEXT ['chest', 'shoulders', etc.]
    secondary_muscle_groups TEXT, -- JSON array as TEXT
    equipment_required TEXT, -- JSON array of equipment IDs
    equipment_alternatives TEXT, -- JSON array of alternative equipment combinations
    movement_pattern TEXT CHECK (movement_pattern IN (
        'push',
        'pull',
        'squat',
        'hinge',
        'lunge',
        'carry',
        'gait',
        'rotation'
    )),
    tempo TEXT, -- e.g., "3-1-2-1" (eccentric-pause-concentric-pause)
    range_of_motion TEXT,
    breathing_pattern TEXT,
    common_mistakes TEXT, -- JSON array as TEXT
    progressions TEXT, -- JSON array of progression exercise IDs
    regressions TEXT, -- JSON array of regression exercise IDs
    safety_notes TEXT,
    image_url TEXT,
    video_url TEXT,
    demonstration_images TEXT, -- JSON array of image URLs
    calories_per_minute REAL,
    met_value REAL, -- Metabolic equivalent of task
    tags TEXT, -- JSON array as TEXT
    is_unilateral BOOLEAN DEFAULT FALSE, -- Whether exercise is performed one side at a time
    is_compound BOOLEAN DEFAULT TRUE, -- Whether exercise works multiple muscle groups
    requires_spotter BOOLEAN DEFAULT FALSE,
    setup_time_seconds INTEGER DEFAULT 30,
    cleanup_time_seconds INTEGER DEFAULT 15,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Exercise categories junction table (many-to-many)
CREATE TABLE IF NOT EXISTS exercise_categories (
    id TEXT PRIMARY KEY NOT NULL,
    exercise_id TEXT NOT NULL REFERENCES exercises(id) ON DELETE CASCADE,
    category_id TEXT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(exercise_id, category_id)
);

-- =============================================================================
-- WORKOUT MANAGEMENT TABLES
-- =============================================================================

-- Workouts table
CREATE TABLE IF NOT EXISTS workouts (
    id TEXT PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    created_by TEXT REFERENCES users(id) ON DELETE SET NULL,
    is_public BOOLEAN DEFAULT FALSE,
    difficulty_level TEXT CHECK (difficulty_level IN ('beginner', 'intermediate', 'advanced')) DEFAULT 'beginner',
    estimated_duration_minutes INTEGER,
    actual_duration_minutes INTEGER,
    workout_type TEXT CHECK (workout_type IN (
        'strength',
        'cardio',
        'hiit',
        'circuit',
        'stretching',
        'yoga',
        'pilates',
        'crosstraining',
        'sports_specific',
        'rehabilitation'
    )) DEFAULT 'strength',
    target_muscle_groups TEXT, -- JSON array as TEXT
    equipment_needed TEXT, -- JSON array of equipment IDs
    space_requirement TEXT CHECK (space_requirement IN ('minimal', 'small', 'medium', 'large')) DEFAULT 'small',
    intensity_level TEXT CHECK (intensity_level IN ('low', 'moderate', 'high', 'maximum')) DEFAULT 'moderate',
    rest_between_exercises INTEGER DEFAULT 60, -- seconds
    rest_between_sets INTEGER DEFAULT 60, -- seconds
    warmup_duration_minutes INTEGER DEFAULT 5,
    cooldown_duration_minutes INTEGER DEFAULT 5,
    calories_estimate INTEGER,
    tags TEXT, -- JSON array as TEXT
    notes TEXT,
    is_template BOOLEAN DEFAULT FALSE,
    template_category TEXT,
    image_url TEXT,
    image_fit TEXT CHECK (image_fit IN ('cover', 'contain', 'fill')) DEFAULT 'cover',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Workout exercises junction table with exercise-specific parameters
CREATE TABLE IF NOT EXISTS workout_exercises (
    id TEXT PRIMARY KEY NOT NULL,
    workout_id TEXT NOT NULL REFERENCES workouts(id) ON DELETE CASCADE,
    exercise_id TEXT NOT NULL REFERENCES exercises(id) ON DELETE CASCADE,
    order_index INTEGER NOT NULL,
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

-- =============================================================================
-- WORKOUT TRACKING TABLES
-- =============================================================================

-- Workout sessions (actual workout performances)
CREATE TABLE IF NOT EXISTS workout_sessions (
    id TEXT PRIMARY KEY NOT NULL,
    user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    workout_id TEXT REFERENCES workouts(id) ON DELETE SET NULL,
    name TEXT, -- Optional custom name for the session
    started_at DATETIME NOT NULL,
    completed_at DATETIME,
    duration_minutes INTEGER,
    status TEXT CHECK (status IN ('planned', 'in_progress', 'completed', 'cancelled', 'paused')) DEFAULT 'planned',
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

-- Exercise logs (individual exercise performances within sessions)
CREATE TABLE IF NOT EXISTS exercise_logs (
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

-- =============================================================================
-- SOCIAL & ENGAGEMENT TABLES
-- =============================================================================

-- Favorites (users can favorite exercises and workouts)
CREATE TABLE IF NOT EXISTS favorites (
    id TEXT PRIMARY KEY NOT NULL,
    user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    favoritable_type TEXT NOT NULL CHECK (favoritable_type IN ('exercise', 'workout')),
    favoritable_id TEXT NOT NULL,
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, favoritable_type, favoritable_id)
);

-- Workout shares (sharing workouts between users)
CREATE TABLE IF NOT EXISTS workout_shares (
    id TEXT PRIMARY KEY NOT NULL,
    workout_id TEXT NOT NULL REFERENCES workouts(id) ON DELETE CASCADE,
    shared_by TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    shared_with TEXT REFERENCES users(id) ON DELETE CASCADE, -- NULL for public shares
    share_type TEXT CHECK (share_type IN ('private', 'public', 'link')) DEFAULT 'private',
    permissions TEXT CHECK (permissions IN ('view', 'copy', 'modify')) DEFAULT 'view',
    message TEXT,
    expires_at DATETIME,
    access_count INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Workout comments
CREATE TABLE IF NOT EXISTS workout_comments (
    id TEXT PRIMARY KEY NOT NULL,
    workout_id TEXT NOT NULL REFERENCES workouts(id) ON DELETE CASCADE,
    user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    parent_comment_id TEXT REFERENCES workout_comments(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    is_edited BOOLEAN DEFAULT FALSE,
    is_pinned BOOLEAN DEFAULT FALSE,
    like_count INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Workout ratings
CREATE TABLE IF NOT EXISTS workout_ratings (
    id TEXT PRIMARY KEY NOT NULL,
    workout_id TEXT NOT NULL REFERENCES workouts(id) ON DELETE CASCADE,
    user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review TEXT,
    difficulty_rating INTEGER CHECK (difficulty_rating BETWEEN 1 AND 5),
    effectiveness_rating INTEGER CHECK (effectiveness_rating BETWEEN 1 AND 5),
    enjoyment_rating INTEGER CHECK (enjoyment_rating BETWEEN 1 AND 5),
    would_recommend BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(workout_id, user_id)
);

-- =============================================================================
-- ANALYTICS & PROGRESS TRACKING
-- =============================================================================

-- User progress tracking
CREATE TABLE IF NOT EXISTS user_progress (
    id TEXT PRIMARY KEY NOT NULL,
    user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    metric_type TEXT NOT NULL CHECK (metric_type IN (
        'weight',
        'body_fat_percentage',
        'muscle_mass',
        'chest_circumference',
        'waist_circumference',
        'hip_circumference',
        'bicep_circumference',
        'thigh_circumference',
        'neck_circumference',
        'resting_heart_rate',
        'blood_pressure_systolic',
        'blood_pressure_diastolic'
    )),
    value REAL NOT NULL,
    unit TEXT NOT NULL,
    measured_at DATETIME NOT NULL,
    measurement_method TEXT,
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Personal records tracking
CREATE TABLE IF NOT EXISTS personal_records (
    id TEXT PRIMARY KEY NOT NULL,
    user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    exercise_id TEXT NOT NULL REFERENCES exercises(id) ON DELETE CASCADE,
    record_type TEXT NOT NULL CHECK (record_type IN (
        'max_weight',
        'max_reps',
        'max_duration',
        'max_distance',
        'best_time',
        'max_volume'
    )),
    value REAL NOT NULL,
    unit TEXT NOT NULL,
    secondary_value REAL, -- For combination records (e.g., weight + reps)
    secondary_unit TEXT,
    achieved_at DATETIME NOT NULL,
    workout_session_id TEXT REFERENCES workout_sessions(id) ON DELETE SET NULL,
    exercise_log_id TEXT REFERENCES exercise_logs(id) ON DELETE SET NULL,
    previous_record_value REAL,
    improvement_percentage REAL,
    notes TEXT,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, exercise_id, record_type)
);

-- =============================================================================
-- SYNC & OFFLINE SUPPORT
-- =============================================================================

-- Sync status tracking for offline-first functionality
CREATE TABLE IF NOT EXISTS sync_status (
    id TEXT PRIMARY KEY NOT NULL,
    table_name TEXT NOT NULL,
    record_id TEXT NOT NULL,
    operation TEXT NOT NULL CHECK (operation IN ('insert', 'update', 'delete')),
    local_timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    server_timestamp DATETIME,
    sync_status TEXT NOT NULL CHECK (sync_status IN ('pending', 'synced', 'conflict', 'failed')) DEFAULT 'pending',
    retry_count INTEGER DEFAULT 0,
    error_message TEXT,
    record_data TEXT, -- JSON representation of the record
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Conflict resolution for sync conflicts
CREATE TABLE IF NOT EXISTS sync_conflicts (
    id TEXT PRIMARY KEY NOT NULL,
    table_name TEXT NOT NULL,
    record_id TEXT NOT NULL,
    local_data TEXT NOT NULL, -- JSON
    server_data TEXT NOT NULL, -- JSON
    conflict_type TEXT NOT NULL CHECK (conflict_type IN ('update_conflict', 'delete_conflict')),
    resolution_strategy TEXT CHECK (resolution_strategy IN ('local_wins', 'server_wins', 'manual', 'merge')),
    resolved_at DATETIME,
    resolved_by TEXT REFERENCES users(id) ON DELETE SET NULL,
    resolution_data TEXT, -- JSON of resolved data
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- TRIGGERS FOR UPDATED_AT COLUMNS
-- =============================================================================

-- Users trigger
CREATE TRIGGER IF NOT EXISTS users_updated_at 
    AFTER UPDATE ON users
    FOR EACH ROW
BEGIN
    UPDATE users SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- User profiles trigger
CREATE TRIGGER IF NOT EXISTS user_profiles_updated_at 
    AFTER UPDATE ON user_profiles
    FOR EACH ROW
BEGIN
    UPDATE user_profiles SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Categories trigger
CREATE TRIGGER IF NOT EXISTS categories_updated_at 
    AFTER UPDATE ON categories
    FOR EACH ROW
BEGIN
    UPDATE categories SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Equipment trigger
CREATE TRIGGER IF NOT EXISTS equipment_updated_at 
    AFTER UPDATE ON equipment
    FOR EACH ROW
BEGIN
    UPDATE equipment SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- User equipment trigger
CREATE TRIGGER IF NOT EXISTS user_equipment_updated_at 
    AFTER UPDATE ON user_equipment
    FOR EACH ROW
BEGIN
    UPDATE user_equipment SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Exercises trigger
CREATE TRIGGER IF NOT EXISTS exercises_updated_at 
    AFTER UPDATE ON exercises
    FOR EACH ROW
BEGIN
    UPDATE exercises SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Workouts trigger
CREATE TRIGGER IF NOT EXISTS workouts_updated_at 
    AFTER UPDATE ON workouts
    FOR EACH ROW
BEGIN
    UPDATE workouts SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Workout exercises trigger
CREATE TRIGGER IF NOT EXISTS workout_exercises_updated_at 
    AFTER UPDATE ON workout_exercises
    FOR EACH ROW
BEGIN
    UPDATE workout_exercises SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Workout sessions trigger
CREATE TRIGGER IF NOT EXISTS workout_sessions_updated_at 
    AFTER UPDATE ON workout_sessions
    FOR EACH ROW
BEGIN
    UPDATE workout_sessions SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Exercise logs trigger
CREATE TRIGGER IF NOT EXISTS exercise_logs_updated_at 
    AFTER UPDATE ON exercise_logs
    FOR EACH ROW
BEGIN
    UPDATE exercise_logs SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Workout shares trigger
CREATE TRIGGER IF NOT EXISTS workout_shares_updated_at 
    AFTER UPDATE ON workout_shares
    FOR EACH ROW
BEGIN
    UPDATE workout_shares SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Workout comments trigger
CREATE TRIGGER IF NOT EXISTS workout_comments_updated_at 
    AFTER UPDATE ON workout_comments
    FOR EACH ROW
BEGIN
    UPDATE workout_comments SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Workout ratings trigger
CREATE TRIGGER IF NOT EXISTS workout_ratings_updated_at 
    AFTER UPDATE ON workout_ratings
    FOR EACH ROW
BEGIN
    UPDATE workout_ratings SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Sync status trigger
CREATE TRIGGER IF NOT EXISTS sync_status_updated_at 
    AFTER UPDATE ON sync_status
    FOR EACH ROW
BEGIN
    UPDATE sync_status SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;