-- SQLite Sample Data Seeding for Fitness App
-- Development and testing data
-- Created: 2025-08-04

-- =============================================================================
-- CATEGORIES DATA
-- =============================================================================

-- Main exercise categories
INSERT OR IGNORE INTO categories (id, name, description, icon, color, sort_order) VALUES
('cat_strength', 'Strength Training', 'Exercises focused on building muscle strength and mass', 'fitness_center', '#FF6B35', 1),
('cat_cardio', 'Cardiovascular', 'Exercises to improve heart health and endurance', 'directions_run', '#4ECDC4', 2),
('cat_flexibility', 'Flexibility & Mobility', 'Stretching and mobility exercises', 'accessibility', '#45B7D1', 3),
('cat_functional', 'Functional Training', 'Real-world movement patterns', 'sports_gymnastics', '#96CEB4', 4),
('cat_sports', 'Sports Specific', 'Training for specific sports performance', 'sports_soccer', '#FFEAA7', 5),
('cat_rehabilitation', 'Rehabilitation', 'Recovery and injury prevention exercises', 'healing', '#DDA0DD', 6);

-- Strength training subcategories
INSERT OR IGNORE INTO categories (id, name, description, icon, color, parent_category_id, sort_order) VALUES
('cat_upper_body', 'Upper Body', 'Chest, shoulders, arms, and back exercises', 'fitness_center', '#FF6B35', 'cat_strength', 1),
('cat_lower_body', 'Lower Body', 'Legs, glutes, and hip exercises', 'fitness_center', '#FF6B35', 'cat_strength', 2),
('cat_core', 'Core', 'Abdominal and core stability exercises', 'fitness_center', '#FF6B35', 'cat_strength', 3),
('cat_full_body', 'Full Body', 'Compound movements working multiple muscle groups', 'fitness_center', '#FF6B35', 'cat_strength', 4);

-- Cardio subcategories
INSERT OR IGNORE INTO categories (id, name, description, icon, color, parent_category_id, sort_order) VALUES
('cat_hiit', 'HIIT', 'High-intensity interval training', 'timer', '#4ECDC4', 'cat_cardio', 1),
('cat_steady_state', 'Steady State', 'Continuous moderate-intensity cardio', 'trending_up', '#4ECDC4', 'cat_cardio', 2),
('cat_dance', 'Dance Cardio', 'Dance-based cardiovascular exercise', 'music_note', '#4ECDC4', 'cat_cardio', 3);

-- =============================================================================
-- EQUIPMENT DATA
-- =============================================================================

-- Bodyweight equipment
INSERT OR IGNORE INTO equipment (id, name, description, category, sub_category, muscle_groups_primary, muscle_groups_secondary, space_requirement, difficulty_level, is_home_gym, is_commercial_gym, cost_category, tags) VALUES
('eq_bodyweight', 'Bodyweight Only', 'No equipment needed - use your own body weight', 'bodyweight', 'none', '["full_body"]', '[]', 'minimal', 'beginner', TRUE, TRUE, 'free', '["bodyweight", "no_equipment", "anywhere"]'),
('eq_pull_up_bar', 'Pull-up Bar', 'Doorway or wall-mounted bar for pull-ups and chin-ups', 'strength', 'bars', '["back", "biceps"]', '["shoulders", "core"]', 'minimal', 'intermediate', TRUE, TRUE, 'low', '["upper_body", "pulling", "bodyweight"]'),
('eq_gymnastics_rings', 'Gymnastics Rings', 'Suspension rings for advanced bodyweight training', 'functional', 'suspension', '["upper_body", "core"]', '["shoulders", "back"]', 'small', 'advanced', TRUE, TRUE, 'medium', '["gymnastics", "suspension", "advanced"]');

-- Free weights
INSERT OR IGNORE INTO equipment (id, name, description, category, sub_category, muscle_groups_primary, muscle_groups_secondary, space_requirement, difficulty_level, is_home_gym, is_commercial_gym, cost_category, tags) VALUES
('eq_dumbbells', 'Dumbbells', 'Adjustable or fixed-weight dumbbells', 'strength', 'free_weights', '["full_body"]', '[]', 'small', 'beginner', TRUE, TRUE, 'medium', '["dumbbells", "free_weights", "versatile"]'),
('eq_barbell', 'Barbell', 'Olympic or standard barbell with weight plates', 'strength', 'free_weights', '["full_body"]', '[]', 'medium', 'intermediate', TRUE, TRUE, 'high', '["barbell", "compound", "heavy"]'),
('eq_kettlebells', 'Kettlebells', 'Cast iron weights with handles for dynamic movements', 'functional', 'free_weights', '["full_body"]', '["core", "cardio"]', 'small', 'intermediate', TRUE, TRUE, 'medium', '["kettlebell", "functional", "dynamic"]'),
('eq_weight_plates', 'Weight Plates', 'Olympic or standard weight plates', 'strength', 'free_weights', '["full_body"]', '[]', 'small', 'beginner', TRUE, TRUE, 'medium', '["plates", "progressive", "loading"]');

-- Machines
INSERT OR IGNORE INTO equipment (id, name, description, category, sub_category, muscle_groups_primary, muscle_groups_secondary, space_requirement, difficulty_level, is_home_gym, is_commercial_gym, cost_category, tags) VALUES
('eq_cable_machine', 'Cable Machine', 'Adjustable cable system with various attachments', 'strength', 'machines', '["full_body"]', '[]', 'large', 'beginner', FALSE, TRUE, 'high', '["cables", "versatile", "machines"]'),
('eq_lat_pulldown', 'Lat Pulldown Machine', 'Seated machine for lat pulldowns and rows', 'strength', 'machines', '["back", "biceps"]', '["shoulders"]', 'large', 'beginner', FALSE, TRUE, 'high', '["back", "pulling", "seated"]'),
('eq_leg_press', 'Leg Press Machine', 'Seated or lying leg press machine', 'strength', 'machines', '["quadriceps", "glutes"]', '["hamstrings", "calves"]', 'large', 'beginner', FALSE, TRUE, 'high', '["legs", "compound", "safe"]'),
('eq_smith_machine', 'Smith Machine', 'Guided barbell system with safety features', 'strength', 'machines', '["full_body"]', '[]', 'large', 'beginner', FALSE, TRUE, 'high', '["guided", "safety", "compound"]');

-- Cardio equipment
INSERT OR IGNORE INTO equipment (id, name, description, category, sub_category, muscle_groups_primary, muscle_groups_secondary, space_requirement, difficulty_level, is_home_gym, is_commercial_gym, cost_category, tags) VALUES
('eq_treadmill', 'Treadmill', 'Motorized or manual treadmill for running/walking', 'cardio', 'treadmill', '["legs"]', '["cardiovascular"]', 'large', 'beginner', TRUE, TRUE, 'high', '["running", "walking", "cardio"]'),
('eq_stationary_bike', 'Stationary Bike', 'Upright or recumbent exercise bike', 'cardio', 'bike', '["legs"]', '["cardiovascular"]', 'medium', 'beginner', TRUE, TRUE, 'medium', '["cycling", "low_impact", "cardio"]'),
('eq_elliptical', 'Elliptical Machine', 'Low-impact full-body cardio machine', 'cardio', 'elliptical', '["legs", "arms"]', '["cardiovascular"]', 'large', 'beginner', TRUE, TRUE, 'high', '["low_impact", "full_body", "cardio"]'),
('eq_rowing_machine', 'Rowing Machine', 'Indoor rowing ergometer', 'cardio', 'rowing', '["back", "legs", "arms"]', '["core", "cardiovascular"]', 'medium', 'intermediate', TRUE, TRUE, 'medium', '["rowing", "full_body", "compound"]'),
('eq_jump_rope', 'Jump Rope', 'Speed rope or weighted jump rope', 'cardio', 'accessories', '["calves"]', '["cardiovascular", "coordination"]', 'minimal', 'beginner', TRUE, TRUE, 'low', '["cardio", "portable", "coordination"]');

-- Functional training
INSERT OR IGNORE INTO equipment (id, name, description, category, sub_category, muscle_groups_primary, muscle_groups_secondary, space_requirement, difficulty_level, is_home_gym, is_commercial_gym, cost_category, tags) VALUES
('eq_resistance_bands', 'Resistance Bands', 'Elastic bands for variable resistance training', 'functional', 'bands', '["full_body"]', '[]', 'minimal', 'beginner', TRUE, TRUE, 'low', '["bands", "portable", "variable_resistance"]'),
('eq_trx', 'TRX Suspension Trainer', 'Suspension straps for bodyweight exercises', 'functional', 'suspension', '["full_body"]', '["core", "stability"]', 'minimal', 'intermediate', TRUE, TRUE, 'medium', '["suspension", "bodyweight", "functional"]'),
('eq_medicine_ball', 'Medicine Ball', 'Weighted ball for power and core training', 'functional', 'balls', '["core", "full_body"]', '["power", "coordination"]', 'small', 'beginner', TRUE, TRUE, 'low', '["medicine_ball", "power", "core"]'),
('eq_stability_ball', 'Stability Ball', 'Large inflatable ball for balance and core work', 'functional', 'balls', '["core"]', '["balance", "stability"]', 'small', 'beginner', TRUE, TRUE, 'low', '["stability", "balance", "core"]'),
('eq_bosu_ball', 'BOSU Ball', 'Half stability ball for balance training', 'functional', 'balance', '["core"]', '["balance", "proprioception"]', 'small', 'intermediate', TRUE, TRUE, 'medium', '["balance", "instability", "core"]');

-- Accessories
INSERT OR IGNORE INTO equipment (id, name, description, category, sub_category, muscle_groups_primary, muscle_groups_secondary, space_requirement, difficulty_level, is_home_gym, is_commercial_gym, cost_category, tags) VALUES
('eq_yoga_mat', 'Yoga Mat', 'Non-slip mat for floor exercises and stretching', 'accessories', 'mats', '[]', '[]', 'minimal', 'beginner', TRUE, TRUE, 'low', '["mat", "floor_exercises", "comfort"]'),
('eq_foam_roller', 'Foam Roller', 'Cylindrical foam tool for self-myofascial release', 'accessories', 'recovery', '[]', '["recovery", "flexibility"]', 'minimal', 'beginner', TRUE, TRUE, 'low', '["recovery", "massage", "flexibility"]'),
('eq_ab_wheel', 'Ab Wheel', 'Wheel with handles for core strengthening', 'accessories', 'core', '["core"]', '["shoulders", "stability"]', 'minimal', 'intermediate', TRUE, TRUE, 'low', '["abs", "core", "challenging"]'),
('eq_battle_ropes', 'Battle Ropes', 'Heavy ropes for high-intensity training', 'cardio', 'ropes', '["arms", "core"]', '["cardiovascular", "power"]', 'medium', 'intermediate', TRUE, TRUE, 'medium', '["hiit", "power", "cardio"]');

-- =============================================================================
-- SAMPLE USERS DATA
-- =============================================================================

-- Sample users (for development/testing)
INSERT OR IGNORE INTO users (id, email, created_at, updated_at) VALUES
('user_demo_1', 'demo1@fitness.com', '2024-01-01 10:00:00', '2024-01-01 10:00:00'),
('user_demo_2', 'demo2@fitness.com', '2024-01-02 11:00:00', '2024-01-02 11:00:00'),
('user_demo_3', 'demo3@fitness.com', '2024-01-03 12:00:00', '2024-01-03 12:00:00');

-- Sample user profiles
INSERT OR IGNORE INTO user_profiles (id, user_id, display_name, bio, gender, height_cm, weight_kg, fitness_level, fitness_goals, activity_level, is_public) VALUES
('prof_demo_1', 'user_demo_1', 'Alex Trainer', 'Certified personal trainer specializing in strength training', 'other', 175, 70.5, 'advanced', '["strength", "muscle_building", "coaching"]', 'very_active', TRUE),
('prof_demo_2', 'user_demo_2', 'Sarah Runner', 'Marathon enthusiast and cardio lover', 'female', 165, 58.0, 'intermediate', '["endurance", "weight_loss", "running"]', 'very_active', TRUE),
('prof_demo_3', 'user_demo_3', 'Mike Beginner', 'Just starting my fitness journey', 'male', 180, 85.0, 'beginner', '["weight_loss", "general_fitness", "health"]', 'lightly_active', FALSE);

-- Sample user equipment (what equipment users have access to)
INSERT OR IGNORE INTO user_equipment (id, user_id, equipment_id, access_type, condition_rating, notes) VALUES
('ueq_1', 'user_demo_1', 'eq_dumbbells', 'owned', 5, 'Adjustable dumbbells up to 50lbs each'),
('ueq_2', 'user_demo_1', 'eq_barbell', 'owned', 4, 'Olympic barbell with 300lbs of plates'),
('ueq_3', 'user_demo_1', 'eq_pull_up_bar', 'owned', 5, 'Doorway pull-up bar'),
('ueq_4', 'user_demo_2', 'eq_treadmill', 'gym_access', NULL, 'Available at local gym'),
('ueq_5', 'user_demo_2', 'eq_jump_rope', 'owned', 5, 'Speed rope for cardio'),
('ueq_6', 'user_demo_3', 'eq_bodyweight', 'owned', 5, 'No equipment needed'),
('ueq_7', 'user_demo_3', 'eq_yoga_mat', 'owned', 4, 'Basic yoga mat for floor exercises');

-- =============================================================================
-- SAMPLE EXERCISES DATA
-- =============================================================================

-- Bodyweight exercises
INSERT OR IGNORE INTO exercises (id, name, description, instructions, created_by, is_public, difficulty_level, exercise_type, primary_muscle_groups, secondary_muscle_groups, equipment_required, movement_pattern, tempo, common_mistakes, safety_notes, calories_per_minute, met_value, tags, is_unilateral, is_compound, requires_spotter) VALUES
('ex_push_up', 'Push-Up', 'Classic bodyweight chest exercise', 'Start in plank position. Lower chest to floor, push back up. Keep body straight throughout.', 'user_demo_1', TRUE, 'beginner', 'strength', '["chest", "shoulders", "triceps"]', '["core"]', '["eq_bodyweight"]', 'push', '2-1-2-1', '["sagging hips", "incomplete range of motion", "flared elbows"]', 'Keep core engaged, avoid putting strain on lower back', 8.0, 3.8, '["bodyweight", "push", "upper_body"]', FALSE, TRUE, FALSE),

('ex_squat', 'Bodyweight Squat', 'Fundamental lower body movement', 'Stand with feet shoulder-width apart. Lower hips back and down, keeping chest up. Return to standing.', 'user_demo_1', TRUE, 'beginner', 'strength', '["quadriceps", "glutes"]', '["hamstrings", "calves", "core"]', '["eq_bodyweight"]', 'squat', '2-1-2-1', '["knees caving in", "forward lean", "incomplete depth"]', 'Keep knees aligned with toes, maintain neutral spine', 6.0, 3.5, '["bodyweight", "squat", "lower_body"]', FALSE, TRUE, FALSE),

('ex_plank', 'Plank', 'Isometric core strengthening exercise', 'Hold push-up position with forearms on ground. Keep body straight from head to heels.', 'user_demo_1', TRUE, 'beginner', 'isometric', '["core"]', '["shoulders", "back"]', '["eq_bodyweight"]', 'carry', 'hold', '["sagging hips", "raised hips", "holding breath"]', 'Breathe normally, keep neutral spine throughout', 4.0, 2.8, '["bodyweight", "core", "isometric"]', FALSE, TRUE, FALSE),

('ex_mountain_climber', 'Mountain Climbers', 'Dynamic cardio and core exercise', 'Start in plank. Alternate bringing knees to chest rapidly while maintaining plank position.', 'user_demo_1', TRUE, 'intermediate', 'cardio', '["core"]', '["shoulders", "legs", "cardiovascular"]', '["eq_bodyweight"]', 'gait', 'fast', '["bouncing hips", "losing plank position", "irregular breathing"]', 'Maintain plank position throughout, control the movement', 10.0, 8.0, '["bodyweight", "cardio", "hiit"]', TRUE, TRUE, FALSE),

-- Additional exercises
('ex_dumbbell_press', 'Dumbbell Chest Press', 'Upper body pressing movement with dumbbells', 'Lie on bench with dumbbells at chest level. Press weights up and together. Lower with control.', 'user_demo_1', TRUE, 'intermediate', 'strength', '["chest", "shoulders", "triceps"]', '["core"]', '["eq_dumbbells"]', 'push', '2-1-2-1', '["flared elbows", "arching back", "bouncing weights"]', 'Use spotter for heavy weights, control the negative portion', 7.0, 5.0, '["dumbbells", "chest", "compound"]', FALSE, TRUE, TRUE),

('ex_dumbbell_row', 'Dumbbell Row', 'Pulling exercise for back development', 'Hinge at hips, pull dumbbell to hip while squeezing shoulder blade back. Lower with control.', 'user_demo_1', TRUE, 'intermediate', 'strength', '["back", "biceps"]', '["rear_delts", "core"]', '["eq_dumbbells"]', 'pull', '2-1-2-1', '["using momentum", "rounding back", "not squeezing shoulder blades"]', 'Maintain neutral spine, avoid using momentum', 6.0, 4.5, '["dumbbells", "back", "pulling"]', TRUE, TRUE, FALSE),

('ex_goblet_squat', 'Goblet Squat', 'Squat variation holding weight at chest', 'Hold dumbbell at chest. Squat down keeping chest up and elbows inside knees. Drive through heels to stand.', 'user_demo_1', TRUE, 'beginner', 'strength', '["quadriceps", "glutes"]', '["hamstrings", "core", "upper_back"]', '["eq_dumbbells"]', 'squat', '2-1-2-1', '["knees caving in", "weight drifting away from body", "incomplete depth"]', 'Keep weight close to body, maintain upright torso', 7.0, 5.5, '["dumbbells", "squat", "goblet"]', FALSE, TRUE, FALSE),

('ex_deadlift', 'Barbell Deadlift', 'King of all exercises - full body pulling movement', 'Stand with barbell over mid-foot. Hinge at hips, grab bar. Drive through heels, extend hips to stand tall.', 'user_demo_1', TRUE, 'advanced', 'strength', '["hamstrings", "glutes", "back"]', '["quadriceps", "traps", "forearms", "core"]', '["eq_barbell", "eq_weight_plates"]', 'hinge', '2-1-3-1', '["rounding back", "bar drifting forward", "hyperextending at top"]', 'Use proper form, progress gradually, consider belt for heavy loads', 8.0, 6.0, '["barbell", "deadlift", "compound"]', FALSE, TRUE, TRUE),

('ex_squat_barbell', 'Barbell Back Squat', 'Fundamental barbell squatting movement', 'Bar on upper back, feet shoulder-width apart. Squat down keeping chest up. Drive through heels to stand.', 'user_demo_1', TRUE, 'intermediate', 'strength', '["quadriceps", "glutes"]', '["hamstrings", "core", "upper_back"]', '["eq_barbell", "eq_weight_plates"]', 'squat', '3-1-2-1', '["knees caving in", "forward lean", "not reaching depth"]', 'Use safety bars, proper warm-up essential, maintain knee alignment', 9.0, 6.5, '["barbell", "squat", "compound"]', FALSE, TRUE, TRUE),

('ex_treadmill_run', 'Treadmill Running', 'Steady-state cardiovascular exercise', 'Maintain steady pace on treadmill. Focus on proper running form and breathing rhythm.', 'user_demo_2', TRUE, 'intermediate', 'cardio', '["legs"]', '["cardiovascular", "core"]', '["eq_treadmill"]', 'gait', 'steady', '["overstriding", "heel striking", "poor posture"]', 'Start slowly, maintain proper form throughout', 12.0, 8.0, '["cardio", "running", "endurance"]', FALSE, TRUE, FALSE),

('ex_jump_rope', 'Jump Rope', 'High-intensity cardio exercise', 'Jump over rope with both feet, maintaining rhythm. Land softly on balls of feet.', 'user_demo_2', TRUE, 'intermediate', 'cardio', '["calves"]', '["cardiovascular", "coordination"]', '["eq_jump_rope"]', 'gait', 'fast', '["jumping too high", "landing on heels", "irregular rhythm"]', 'Start with shorter sessions, focus on rhythm', 15.0, 12.0, '["cardio", "hiit", "coordination"]', FALSE, TRUE, FALSE),

('ex_burpee', 'Burpee', 'Full-body high-intensity exercise', 'Squat down, kick back to plank, do push-up, jump feet to hands, jump up with arms overhead.', 'user_demo_1', TRUE, 'advanced', 'cardio', '["full_body"]', '["cardiovascular"]', '["eq_bodyweight"]', 'compound', 'fast', '["sloppy push-up", "not jumping high", "poor plank position"]', 'Maintain form throughout, modify if needed', 18.0, 15.0, '["bodyweight", "hiit", "full_body"]', FALSE, TRUE, FALSE);

-- =============================================================================
-- SAMPLE WORKOUTS DATA
-- =============================================================================

-- Beginner bodyweight workout
INSERT OR IGNORE INTO workouts (id, name, description, created_by, is_public, difficulty_level, estimated_duration_minutes, workout_type, target_muscle_groups, equipment_needed, space_requirement, intensity_level, tags, is_template) VALUES
('wo_beginner_bodyweight', 'Beginner Full Body Bodyweight', 'Perfect starting workout requiring no equipment', 'user_demo_1', TRUE, 'beginner', 30, 'strength', '["full_body"]', '["eq_bodyweight"]', 'minimal', 'moderate', '["beginner", "bodyweight", "full_body"]', TRUE),

('wo_upper_body_strength', 'Upper Body Strength Builder', 'Intermediate upper body workout with dumbbells', 'user_demo_1', TRUE, 'intermediate', 45, 'strength', '["chest", "back", "shoulders", "arms"]', '["eq_dumbbells"]', 'small', 'high', '["intermediate", "upper_body", "dumbbells"]', TRUE),

('wo_cardio_hiit', 'High-Intensity Cardio Blast', 'Fat-burning HIIT workout', 'user_demo_2', TRUE, 'intermediate', 25, 'hiit', '["full_body", "cardiovascular"]', '["eq_bodyweight"]', 'minimal', 'high', '["hiit", "cardio", "fat_loss"]', TRUE);

-- Workout exercises (exercise order and parameters within workouts)
INSERT OR IGNORE INTO workout_exercises (id, workout_id, exercise_id, order_index, sets, reps, rest_time_seconds, notes, target_rpe) VALUES
-- Beginner bodyweight workout
('we_1', 'wo_beginner_bodyweight', 'ex_squat', 1, 3, 10, 60, 'Focus on proper form over speed', 6),
('we_2', 'wo_beginner_bodyweight', 'ex_push_up', 2, 3, 8, 60, 'Modify on knees if needed', 6),
('we_3', 'wo_beginner_bodyweight', 'ex_plank', 3, 3, NULL, 60, 'Hold for 30 seconds', 6),
('we_4', 'wo_beginner_bodyweight', 'ex_mountain_climber', 4, 3, 20, 60, '10 reps each leg', 7),

-- Upper body strength workout
('we_5', 'wo_upper_body_strength', 'ex_dumbbell_press', 1, 4, 8, 90, 'Choose challenging weight', 8),
('we_6', 'wo_upper_body_strength', 'ex_dumbbell_row', 2, 4, 10, 90, 'Each arm alternating', 8),
('we_7', 'wo_upper_body_strength', 'ex_push_up', 3, 3, 12, 60, 'Slow and controlled', 7),

-- HIIT cardio workout
('we_8', 'wo_cardio_hiit', 'ex_burpee', 1, 4, 8, 45, '45 seconds work, 15 seconds rest', 9),
('we_9', 'wo_cardio_hiit', 'ex_mountain_climber', 2, 4, 30, 45, 'Maximum intensity', 9),
('we_10', 'wo_cardio_hiit', 'ex_jump_rope', 3, 4, NULL, 45, '45 seconds continuous', 8);

-- =============================================================================
-- EXERCISE CATEGORIES ASSOCIATIONS
-- =============================================================================

-- Associate exercises with categories
INSERT OR IGNORE INTO exercise_categories (id, exercise_id, category_id) VALUES
('ec_1', 'ex_push_up', 'cat_upper_body'),
('ec_2', 'ex_push_up', 'cat_strength'),
('ec_3', 'ex_squat', 'cat_lower_body'),
('ec_4', 'ex_squat', 'cat_strength'),
('ec_5', 'ex_plank', 'cat_core'),
('ec_6', 'ex_plank', 'cat_strength'),
('ec_7', 'ex_mountain_climber', 'cat_cardio'),
('ec_8', 'ex_mountain_climber', 'cat_hiit'),
('ec_9', 'ex_dumbbell_press', 'cat_upper_body'),
('ec_10', 'ex_dumbbell_press', 'cat_strength'),
('ec_11', 'ex_dumbbell_row', 'cat_upper_body'),
('ec_12', 'ex_dumbbell_row', 'cat_strength'),
('ec_13', 'ex_goblet_squat', 'cat_lower_body'),
('ec_14', 'ex_goblet_squat', 'cat_strength'),
('ec_15', 'ex_deadlift', 'cat_full_body'),
('ec_16', 'ex_deadlift', 'cat_strength'),
('ec_17', 'ex_squat_barbell', 'cat_lower_body'),
('ec_18', 'ex_squat_barbell', 'cat_strength'),
('ec_19', 'ex_treadmill_run', 'cat_cardio'),
('ec_20', 'ex_treadmill_run', 'cat_steady_state'),
('ec_21', 'ex_jump_rope', 'cat_cardio'),
('ec_22', 'ex_jump_rope', 'cat_hiit'),
('ec_23', 'ex_burpee', 'cat_cardio'),
('ec_24', 'ex_burpee', 'cat_hiit'),
('ec_25', 'ex_burpee', 'cat_full_body');

-- =============================================================================
-- SAMPLE WORKOUT SESSIONS AND LOGS
-- =============================================================================

-- Sample workout sessions (completed workouts)
INSERT OR IGNORE INTO workout_sessions (id, user_id, workout_id, name, started_at, completed_at, duration_minutes, status, energy_level_start, energy_level_end, perceived_exertion, calories_burned, notes, workout_rating) VALUES
('ws_1', 'user_demo_3', 'wo_beginner_bodyweight', 'My First Workout!', '2024-02-01 09:00:00', '2024-02-01 09:32:00', 32, 'completed', 6, 8, 7, 180, 'Felt great to start my fitness journey!', 5),
('ws_2', 'user_demo_1', 'wo_upper_body_strength', 'Morning Strength Session', '2024-02-01 07:00:00', '2024-02-01 07:48:00', 48, 'completed', 8, 7, 8, 280, 'Good pump, increased weight on dumbbell press', 4),
('ws_3', 'user_demo_2', 'wo_cardio_hiit', 'Quick HIIT Before Work', '2024-02-01 06:30:00', '2024-02-01 06:56:00', 26, 'completed', 7, 9, 9, 320, 'Intense but effective!', 5);

-- Sample exercise logs
INSERT OR IGNORE INTO exercise_logs (id, workout_session_id, exercise_id, workout_exercise_id, order_index, sets_completed, sets_planned, reps_completed, reps_planned, weight_kg, duration_seconds, rpe, form_rating, notes) VALUES
-- User demo 3's first workout
('el_1', 'ws_1', 'ex_squat', 'we_1', 1, 3, 3, 10, 10, NULL, NULL, 6, 4, 'Form felt good by third set'),
('el_2', 'ws_1', 'ex_push_up', 'we_2', 2, 3, 3, 6, 8, NULL, NULL, 7, 3, 'Had to do knee push-ups for last set'),
('el_3', 'ws_1', 'ex_plank', 'we_3', 3, 3, 3, NULL, NULL, NULL, 25, 6, 4, 'Could only hold 25 seconds each'),
('el_4', 'ws_1', 'ex_mountain_climber', 'we_4', 4, 3, 3, 20, 20, NULL, NULL, 8, 3, 'Got winded quickly'),

-- User demo 1's strength workout
('el_5', 'ws_2', 'ex_dumbbell_press', 'we_5', 1, 4, 4, 8, 8, 35.0, NULL, 8, 5, 'Increased from 30kg last week'),
('el_6', 'ws_2', 'ex_dumbbell_row', 'we_6', 2, 4, 4, 10, 10, 32.5, NULL, 7, 5, 'Great mind-muscle connection'),
('el_7', 'ws_2', 'ex_push_up', 'we_7', 3, 3, 3, 12, 12, NULL, NULL, 6, 5, 'Easy after the press work'),

-- User demo 2's HIIT workout
('el_8', 'ws_3', 'ex_burpee', 'we_8', 1, 4, 4, 8, 8, NULL, NULL, 9, 4, 'Brutal but effective'),
('el_9', 'ws_3', 'ex_mountain_climber', 'we_9', 2, 4, 4, 30, 30, NULL, NULL, 9, 4, 'Heart rate maxed out'),
('el_10', 'ws_3', 'ex_jump_rope', 'we_10', 3, 4, 4, NULL, NULL, NULL, 45, 8, 5, 'Good rhythm maintained');

-- =============================================================================
-- FAVORITES AND SOCIAL DATA
-- =============================================================================

-- Sample favorites
INSERT OR IGNORE INTO favorites (id, user_id, favoritable_type, favoritable_id, notes) VALUES
('fav_1', 'user_demo_3', 'workout', 'wo_beginner_bodyweight', 'Perfect for my fitness level'),
('fav_2', 'user_demo_3', 'exercise', 'ex_push_up', 'Working on getting stronger at these'),
('fav_3', 'user_demo_1', 'exercise', 'ex_deadlift', 'The king of exercises'),
('fav_4', 'user_demo_2', 'workout', 'wo_cardio_hiit', 'Quick and effective');

-- Sample workout ratings
INSERT OR IGNORE INTO workout_ratings (id, workout_id, user_id, rating, review, difficulty_rating, effectiveness_rating, enjoyment_rating, would_recommend) VALUES
('wr_1', 'wo_beginner_bodyweight', 'user_demo_3', 5, 'Perfect introduction to fitness. Clear instructions and appropriate difficulty.', 2, 5, 5, TRUE),
('wr_2', 'wo_upper_body_strength', 'user_demo_1', 4, 'Solid upper body workout. Could use one more exercise for complete development.', 4, 4, 4, TRUE),
('wr_3', 'wo_cardio_hiit', 'user_demo_2', 5, 'Incredibly efficient workout. Burns calories and builds endurance quickly.', 5, 5, 4, TRUE);

-- Sample workout comments
INSERT OR IGNORE INTO workout_comments (id, workout_id, user_id, content) VALUES
('wc_1', 'wo_beginner_bodyweight', 'user_demo_2', 'Great workout for beginners! I started with this one too.'),
('wc_2', 'wo_beginner_bodyweight', 'user_demo_1', 'Nice progression structure. Consider adding time-based challenges as you advance.'),
('wc_3', 'wo_cardio_hiit', 'user_demo_1', 'This one kicks my butt every time. Excellent for conditioning.');

-- =============================================================================
-- PROGRESS TRACKING DATA
-- =============================================================================

-- Sample user progress measurements
INSERT OR IGNORE INTO user_progress (id, user_id, metric_type, value, unit, measured_at, notes) VALUES
('up_1', 'user_demo_3', 'weight', 85.0, 'kg', '2024-01-01 08:00:00', 'Starting weight'),
('up_2', 'user_demo_3', 'weight', 84.2, 'kg', '2024-02-01 08:00:00', 'After one month of training'),
('up_3', 'user_demo_1', 'weight', 70.5, 'kg', '2024-01-01 08:00:00', 'Maintaining current weight'),
('up_4', 'user_demo_1', 'muscle_mass', 32.5, '%', '2024-01-01 08:00:00', 'DEXA scan results'),
('up_5', 'user_demo_2', 'resting_heart_rate', 65, 'bpm', '2024-01-01 08:00:00', 'Good cardiovascular baseline');

-- Sample personal records
INSERT OR IGNORE INTO personal_records (id, user_id, exercise_id, record_type, value, unit, secondary_value, secondary_unit, achieved_at, workout_session_id, notes) VALUES
('pr_1', 'user_demo_1', 'ex_dumbbell_press', 'max_weight', 35.0, 'kg', 8.0, 'reps', '2024-02-01 07:30:00', 'ws_2', 'New PR! Previous was 30kg'),
('pr_2', 'user_demo_3', 'ex_push_up', 'max_reps', 6.0, 'reps', NULL, NULL, '2024-02-01 09:15:00', 'ws_1', 'First time doing standard push-ups'),
('pr_3', 'user_demo_2', 'ex_treadmill_run', 'best_time', 25.5, 'minutes', 5.0, 'km', '2024-01-15 18:00:00', NULL, '5K personal best');

-- =============================================================================
-- SYNC STATUS INITIALIZATION
-- =============================================================================

-- Mark all sample data as synced (for testing purposes)
INSERT OR IGNORE INTO sync_status (id, table_name, record_id, operation, sync_status, server_timestamp) 
SELECT 
    'sync_' || substr(hex(randomblob(8)), 1, 16),
    'users',
    id,
    'insert',
    'synced',
    CURRENT_TIMESTAMP
FROM users WHERE id LIKE 'user_demo_%';

-- Add sync status for other critical tables
INSERT OR IGNORE INTO sync_status (id, table_name, record_id, operation, sync_status, server_timestamp) 
SELECT 
    'sync_' || substr(hex(randomblob(8)), 1, 16),
    'exercises',
    id,
    'insert',
    'synced',
    CURRENT_TIMESTAMP
FROM exercises WHERE id LIKE 'ex_%';

INSERT OR IGNORE INTO sync_status (id, table_name, record_id, operation, sync_status, server_timestamp) 
SELECT 
    'sync_' || substr(hex(randomblob(8)), 1, 16),
    'workouts',
    id,
    'insert',
    'synced',
    CURRENT_TIMESTAMP
FROM workouts WHERE id LIKE 'wo_%';