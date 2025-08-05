-- Comprehensive Equipment Catalog for Fitness App
-- Detailed equipment database with categories, compatibility, and alternatives
-- Created: 2025-08-04

-- =============================================================================
-- COMPLETE EQUIPMENT CATALOG
-- =============================================================================

-- Clear existing equipment data for complete refresh
DELETE FROM user_equipment;
DELETE FROM equipment;

-- =============================================================================
-- BODYWEIGHT & NO EQUIPMENT
-- =============================================================================

INSERT OR IGNORE INTO equipment (id, name, description, category, sub_category, muscle_groups_primary, muscle_groups_secondary, space_requirement, difficulty_level, is_home_gym, is_commercial_gym, cost_category, alternatives, tags) VALUES
('eq_bodyweight', 'Bodyweight Only', 'No equipment needed - use your own body weight for resistance', 'bodyweight', 'none', '["full_body"]', '[]', 'minimal', 'beginner', TRUE, TRUE, 'free', '[]', '["bodyweight", "no_equipment", "anywhere", "beginner_friendly"]'),

('eq_wall', 'Wall', 'Use any wall for support and resistance exercises', 'bodyweight', 'structural', '["upper_body", "core"]', '["legs"]', 'minimal', 'beginner', TRUE, TRUE, 'free', '[]', '["wall", "support", "bodyweight", "home"]'),

('eq_floor', 'Floor Space', 'Open floor area for ground-based exercises', 'bodyweight', 'space', '["core", "full_body"]', '[]', 'small', 'beginner', TRUE, TRUE, 'free', '[]', '["floor", "space", "bodyweight", "stretching"]'),

('eq_stairs', 'Stairs', 'Staircase for cardio and strength exercises', 'cardio', 'structural', '["legs", "cardiovascular"]', '["glutes", "core"]', 'minimal', 'beginner', TRUE, FALSE, 'free', '["eq_step_platform"]', '["stairs", "cardio", "plyometric", "functional"]');

-- =============================================================================
-- BASIC ACCESSORIES & MATS
-- =============================================================================

INSERT OR IGNORE INTO equipment (id, name, description, category, sub_category, muscle_groups_primary, muscle_groups_secondary, space_requirement, difficulty_level, is_home_gym, is_commercial_gym, cost_category, alternatives, tags) VALUES
('eq_yoga_mat', 'Yoga Mat', 'Non-slip exercise mat for floor exercises and stretching', 'accessories', 'mats', '[]', '[]', 'minimal', 'beginner', TRUE, TRUE, 'low', '["eq_towel", "eq_carpet"]', '["mat", "floor_exercises", "comfort", "grip"]'),

('eq_exercise_mat', 'Exercise Mat', 'Thick padded mat for floor exercises and core work', 'accessories', 'mats', '["core"]', '[]', 'minimal', 'beginner', TRUE, TRUE, 'low', '["eq_yoga_mat"]', '["mat", "padding", "core", "comfort"]'),

('eq_towel', 'Towel', 'Regular towel for makeshift sliding exercises', 'accessories', 'household', '["core"]', '["shoulders"]', 'minimal', 'beginner', TRUE, TRUE, 'free', '["eq_gliding_discs"]', '["towel", "sliding", "core", "household"]'),

('eq_pillow', 'Pillow', 'Soft pillow for support and instability training', 'accessories', 'household', '["core"]', '["balance"]', 'minimal', 'beginner', TRUE, FALSE, 'free', '["eq_stability_ball"]', '["pillow", "instability", "support", "household"]'),

('eq_gliding_discs', 'Gliding Discs', 'Small discs for sliding exercises on various surfaces', 'accessories', 'sliding', '["core", "full_body"]', '["stability"]', 'minimal', 'intermediate', TRUE, TRUE, 'low', '["eq_towel", "eq_paper_plates"]', '["sliding", "core", "instability", "functional"]');

-- =============================================================================
-- RESISTANCE BANDS & ELASTIC EQUIPMENT
-- =============================================================================

INSERT OR IGNORE INTO equipment (id, name, description, category, sub_category, muscle_groups_primary, muscle_groups_secondary, space_requirement, difficulty_level, is_home_gym, is_commercial_gym, cost_category, alternatives, tags) VALUES
('eq_resistance_bands_light', 'Light Resistance Bands', 'Low-resistance elastic bands for rehabilitation and beginners', 'functional', 'bands', '["full_body"]', '[]', 'minimal', 'beginner', TRUE, TRUE, 'low', '[]', '["bands", "light_resistance", "rehabilitation", "portable"]'),

('eq_resistance_bands_medium', 'Medium Resistance Bands', 'Moderate resistance bands for general training', 'functional', 'bands', '["full_body"]', '[]', 'minimal', 'beginner', TRUE, TRUE, 'low', '[]', '["bands", "medium_resistance", "versatile", "portable"]'),

('eq_resistance_bands_heavy', 'Heavy Resistance Bands', 'High-resistance bands for advanced training', 'functional', 'bands', '["full_body"]', '[]', 'minimal', 'intermediate', TRUE, TRUE, 'low', '[]', '["bands", "heavy_resistance", "advanced", "portable"]'),

('eq_resistance_loop_bands', 'Resistance Loop Bands', 'Small circular bands for activation and isolation exercises', 'functional', 'bands', '["glutes", "legs"]', '["hips"]', 'minimal', 'beginner', TRUE, TRUE, 'low', '[]', '["loop_bands", "activation", "glutes", "portable"]'),

('eq_resistance_tube_handles', 'Resistance Tubes with Handles', 'Resistance tubes with comfortable handles and door anchor', 'functional', 'bands', '["full_body"]', '[]', 'minimal', 'beginner', TRUE, TRUE, 'low', '["eq_resistance_bands_medium"]', '["tubes", "handles", "door_anchor", "versatile"]'),

('eq_power_bands', 'Power Bands', 'Heavy-duty bands for powerlifting assistance', 'strength', 'bands', '["full_body"]', '[]', 'minimal', 'advanced', TRUE, TRUE, 'medium', '[]', '["power_bands", "powerlifting", "assistance", "heavy_duty"]');

-- =============================================================================
-- SUSPENSION TRAINING
-- =============================================================================

INSERT OR IGNORE INTO equipment (id, name, description, category, sub_category, muscle_groups_primary, muscle_groups_secondary, space_requirement, difficulty_level, is_home_gym, is_commercial_gym, cost_category, alternatives, tags) VALUES
('eq_trx', 'TRX Suspension Trainer', 'Professional suspension training system', 'functional', 'suspension', '["full_body"]', '["core", "stability"]', 'minimal', 'intermediate', TRUE, TRUE, 'medium', '[]', '["suspension", "bodyweight", "functional", "portable"]'),

('eq_gymnastics_rings', 'Gymnastics Rings', 'Olympic gymnastics rings for advanced bodyweight training', 'functional', 'suspension', '["upper_body", "core"]', '["shoulders", "back"]', 'small', 'advanced', TRUE, TRUE, 'medium', '[]', '["gymnastics", "rings", "advanced", "upper_body"]'),

('eq_suspension_straps', 'Suspension Straps', 'Basic suspension straps for bodyweight exercises', 'functional', 'suspension', '["full_body"]', '["core"]', 'minimal', 'intermediate', TRUE, TRUE, 'low', '["eq_trx"]', '["suspension", "basic", "bodyweight", "budget"]');

-- =============================================================================
-- PULL-UP & HANGING EQUIPMENT
-- =============================================================================

INSERT OR IGNORE INTO equipment (id, name, description, category, sub_category, muscle_groups_primary, muscle_groups_secondary, space_requirement, difficulty_level, is_home_gym, is_commercial_gym, cost_category, alternatives, tags) VALUES
('eq_pull_up_bar_doorway', 'Doorway Pull-up Bar', 'Removable pull-up bar that fits in doorways', 'strength', 'bars', '["back", "biceps"]', '["shoulders", "core"]', 'minimal', 'intermediate', TRUE, FALSE, 'low', '[]', '["pull_up", "doorway", "removable", "upper_body"]'),

('eq_pull_up_bar_wall_mounted', 'Wall-Mounted Pull-up Bar', 'Permanent wall-mounted pull-up bar', 'strength', 'bars', '["back", "biceps"]', '["shoulders", "core"]', 'minimal', 'intermediate', TRUE, FALSE, 'medium', '[]', '["pull_up", "wall_mounted", "permanent", "sturdy"]'),

('eq_power_tower', 'Power Tower', 'Multi-station tower for pull-ups, dips, and knee raises', 'strength', 'stations', '["upper_body", "core"]', '[]', 'medium', 'intermediate', TRUE, TRUE, 'high', '[]', '["power_tower", "multi_station", "pull_up", "dip"]'),

('eq_pull_up_assist_band', 'Pull-up Assist Band', 'Resistance band to assist with pull-up movements', 'accessories', 'assistance', '["back", "biceps"]', '[]', 'minimal', 'beginner', TRUE, TRUE, 'low', '[]', '["assistance", "pull_up", "progression", "band"]');

-- =============================================================================
-- CARDIO EQUIPMENT - TRADITIONAL
-- =============================================================================

INSERT OR IGNORE INTO equipment (id, name, description, category, sub_category, muscle_groups_primary, muscle_groups_secondary, space_requirement, difficulty_level, is_home_gym, is_commercial_gym, cost_category, alternatives, tags) VALUES
('eq_treadmill', 'Treadmill', 'Motorized treadmill for running and walking', 'cardio', 'treadmill', '["legs"]', '["cardiovascular"]', 'large', 'beginner', TRUE, TRUE, 'high', '["eq_outdoor_running"]', '["treadmill", 'running", "walking", "cardio"]'),

('eq_treadmill_manual', 'Manual Treadmill', 'Non-motorized curved treadmill', 'cardio', 'treadmill', '["legs"]', '["cardiovascular"]', 'large', 'intermediate', TRUE, TRUE, 'medium', '["eq_treadmill"]', '["manual", "curved", "self_powered", "intense"]'),

('eq_stationary_bike_upright', 'Upright Stationary Bike', 'Traditional upright exercise bicycle', 'cardio', 'bike', '["legs"]', '["cardiovascular"]', 'medium', 'beginner', TRUE, TRUE, 'medium', '[]', '["bike", "upright", "cardio", "low_impact"]'),

('eq_stationary_bike_recumbent', 'Recumbent Bike', 'Reclined position exercise bike for back support', 'cardio', 'bike', '["legs"]', '["cardiovascular"]', 'medium', 'beginner', TRUE, TRUE, 'medium', '[]', '["bike", "recumbent", "back_support", "comfortable"]'),

('eq_spin_bike', 'Spin Bike', 'High-intensity indoor cycling bike', 'cardio', 'bike', '["legs"]', '["cardiovascular"]', 'medium', 'intermediate', TRUE, TRUE, 'medium', '[]', '["spin", "intense", "cycling", "flywheel"]'),

('eq_air_bike', 'Air Bike', 'Fan-based bike with moving handles for full-body cardio', 'cardio', 'bike', '["legs", "arms"]', '["cardiovascular"]', 'medium', 'intermediate', TRUE, TRUE, 'medium', '[]', '["air_bike", "fan", "full_body", "intense"]'),

('eq_elliptical', 'Elliptical Machine', 'Low-impact elliptical trainer', 'cardio', 'elliptical', '["legs", "arms"]', '["cardiovascular"]', 'large', 'beginner', TRUE, TRUE, 'high', '[]', '["elliptical", "low_impact", "full_body", "cardio"]'),

('eq_rowing_machine', 'Rowing Machine', 'Indoor rowing ergometer', 'cardio', 'rowing', '["back", "legs", "arms"]', '["core", "cardiovascular"]', 'medium', 'intermediate', TRUE, TRUE, 'medium', '[]', '["rowing", "full_body", "compound", "erg"]'),

('eq_stair_climber', 'Stair Climber', 'Machine that simulates stair climbing', 'cardio', 'climber', '["legs", "glutes"]', '["cardiovascular"]', 'medium', 'intermediate', TRUE, TRUE, 'high', '["eq_stairs"]', '["stairs", "climber", "intense", "legs"]');

-- =============================================================================
-- CARDIO EQUIPMENT - PORTABLE & ACCESSORIES
-- =============================================================================

INSERT OR IGNORE INTO equipment (id, name, description, category, sub_category, muscle_groups_primary, muscle_groups_secondary, space_requirement, difficulty_level, is_home_gym, is_commercial_gym, cost_category, alternatives, tags) VALUES
('eq_jump_rope_basic', 'Basic Jump Rope', 'Simple jump rope for cardio exercise', 'cardio', 'rope', '["calves"]', '["cardiovascular", "coordination"]', 'minimal', 'beginner', TRUE, TRUE, 'low', '[]', '["jump_rope", "cardio", "portable", "coordination"]'),

('eq_jump_rope_speed', 'Speed Jump Rope', 'Lightweight speed rope for fast jumping', 'cardio', 'rope', '["calves"]', '["cardiovascular", "coordination"]', 'minimal', 'intermediate', TRUE, TRUE, 'low', '[]', '["speed_rope", "fast", "competition", "coordination"]'),

('eq_jump_rope_weighted', 'Weighted Jump Rope', 'Heavy rope for increased resistance', 'cardio', 'rope', '["arms", "calves"]', '["cardiovascular", "strength"]', 'minimal', 'intermediate', TRUE, TRUE, 'low', '[]', '["weighted", "resistance", "strength_cardio", "intense"]'),

('eq_agility_ladder', 'Agility Ladder', 'Flat ladder for footwork and agility drills', 'cardio', 'agility', '["legs"]', '["coordination", "agility"]', 'small', 'beginner', TRUE, TRUE, 'low', '[]', '["agility", "footwork", "speed", "sports"]'),

('eq_speed_hurdles', 'Speed Hurdles', 'Low hurdles for agility and plyometric training', 'cardio', 'agility', '["legs"]', '["power", "agility"]', 'small', 'intermediate', TRUE, TRUE, 'low', '[]', '["hurdles", "plyometric", "agility", "speed"]'),

('eq_cones', 'Training Cones', 'Marker cones for agility and sport training', 'cardio', 'agility', '[]', '["agility"]', 'minimal', 'beginner', TRUE, TRUE, 'low', '[]', '["cones", "markers", "agility", "sports"]'),

('eq_step_platform', 'Step Platform', 'Adjustable step for aerobic exercise', 'cardio', 'step', '["legs"]', '["cardiovascular"]', 'small', 'beginner', TRUE, TRUE, 'low', '["eq_stairs"]', '["step", "aerobic", "cardio", "adjustable"]');

-- =============================================================================
-- FREE WEIGHTS - BASIC
-- =============================================================================

INSERT OR IGNORE INTO equipment (id, name, description, category, sub_category, muscle_groups_primary, muscle_groups_secondary, space_requirement, difficulty_level, is_home_gym, is_commercial_gym, cost_category, alternatives, tags) VALUES
('eq_dumbbells_fixed', 'Fixed Weight Dumbbells', 'Individual dumbbells with fixed weights', 'strength', 'dumbbells', '["full_body"]', '[]', 'small', 'beginner', TRUE, TRUE, 'medium', '[]', '["dumbbells", "fixed", "free_weights", "versatile"]'),

('eq_dumbbells_adjustable', 'Adjustable Dumbbells', 'Dumbbells with removable weight plates', 'strength', 'dumbbells', '["full_body"]', '[]', 'small', 'beginner', TRUE, FALSE, 'medium', '[]', '["dumbbells", "adjustable", "space_saving", "versatile"]'),

('eq_dumbbells_selectable', 'Selectable Weight Dumbbells', 'Quick-adjust dumbbells with dial system', 'strength', 'dumbbells', '["full_body"]', '[]', 'small', 'beginner', TRUE, FALSE, 'high', '[]', '["dumbbells", "selectable", "quick_adjust", "premium"]'),

('eq_weight_plates_standard', 'Standard Weight Plates', 'Weight plates for standard barbells (1 inch hole)', 'strength', 'plates', '["full_body"]', '[]', 'small', 'beginner', TRUE, TRUE, 'medium', '[]', '["plates", "standard", "1_inch", "basic"]'),

('eq_weight_plates_olympic', 'Olympic Weight Plates', 'Weight plates for Olympic barbells (2 inch hole)', 'strength', 'plates', '["full_body"]', '[]', 'small', 'intermediate', TRUE, TRUE, 'medium', '[]', '["plates", "olympic", "2_inch", "standard"]'),

('eq_bumper_plates', 'Bumper Plates', 'Rubber-coated plates for dropping safely', 'strength', 'plates', '["full_body"]', '[]', 'small', 'intermediate', TRUE, TRUE, 'high', '["eq_weight_plates_olympic"]', '["bumper", "rubber", "dropping", "crossfit"]');

-- =============================================================================
-- BARBELLS & BARS
-- =============================================================================

INSERT OR IGNORE INTO equipment (id, name, description, category, sub_category, muscle_groups_primary, muscle_groups_secondary, space_requirement, difficulty_level, is_home_gym, is_commercial_gym, cost_category, alternatives, tags) VALUES
('eq_barbell_olympic', 'Olympic Barbell', '45lb/20kg Olympic barbell with 2-inch sleeves', 'strength', 'barbells', '["full_body"]', '[]', 'medium', 'intermediate', TRUE, TRUE, 'high', '[]', '["barbell", "olympic", "45lb", "standard"]'),

('eq_barbell_standard', 'Standard Barbell', 'Basic barbell with 1-inch sleeves', 'strength', 'barbells', '["full_body"]', '[]', 'medium', 'beginner', TRUE, TRUE, 'medium', '[]', '["barbell", "standard", "1_inch", "basic"]'),

('eq_ez_curl_bar', 'EZ Curl Bar', 'Curved bar for comfortable arm exercises', 'strength', 'barbells', '["arms"]', '[]', 'small', 'beginner', TRUE, TRUE, 'low', '[]', '["ez_bar", "curl", "arms", "ergonomic"]'),

('eq_trap_bar', 'Trap Bar', 'Hexagonal bar for deadlifts and shrugs', 'strength', 'barbells', '["back", "legs"]', '["traps"]', 'medium', 'intermediate', TRUE, TRUE, 'medium', '[]', '["trap_bar", "hex_bar", "deadlift", "shrug"]'),

('eq_safety_squat_bar', 'Safety Squat Bar', 'Cambered bar with handles for safe squatting', 'strength', 'barbells', '["legs"]', '[]', 'medium', 'intermediate', FALSE, TRUE, 'high', '[]', '["safety_bar", "squat", "cambered", "specialty"]'),

('eq_curl_bar_fixed', 'Fixed Weight Curl Bar', 'Pre-loaded curl bar with fixed weight', 'strength', 'barbells', '["arms"]', '[]', 'small', 'beginner', TRUE, TRUE, 'low', '["eq_ez_curl_bar"]', '["curl_bar", "fixed", "arms", "convenient"]');

-- =============================================================================
-- KETTLEBELLS
-- =============================================================================

INSERT OR IGNORE INTO equipment (id, name, description, category, sub_category, muscle_groups_primary, muscle_groups_secondary, space_requirement, difficulty_level, is_home_gym, is_commercial_gym, cost_category, alternatives, tags) VALUES
('eq_kettlebell_light', 'Light Kettlebell (8-16kg)', 'Light kettlebell for beginners and rehabilitation', 'functional', 'kettlebells', '["full_body"]', '["core", "cardio"]', 'small', 'beginner', TRUE, TRUE, 'low', '[]', '["kettlebell", "light", "beginner", "functional"]'),

('eq_kettlebell_medium', 'Medium Kettlebell (20-28kg)', 'Medium weight kettlebell for general training', 'functional', 'kettlebells', '["full_body"]', '["core", "cardio"]', 'small', 'intermediate', TRUE, TRUE, 'medium', '[]', '["kettlebell", "medium", "general", "functional"]'),

('eq_kettlebell_heavy', 'Heavy Kettlebell (32kg+)', 'Heavy kettlebell for advanced strength training', 'functional', 'kettlebells', '["full_body"]', '["core", "power"]', 'small', 'advanced', TRUE, TRUE, 'medium', '[]', '["kettlebell", "heavy", "advanced", "strength"]'),

('eq_kettlebell_adjustable', 'Adjustable Kettlebell', 'Kettlebell with removable weight plates', 'functional', 'kettlebells', '["full_body"]', '[]', 'small', 'intermediate', TRUE, FALSE, 'high', '[]', '["kettlebell", "adjustable", "space_saving", "versatile"]'),

('eq_competition_kettlebell', 'Competition Kettlebell', 'Steel kettlebell with uniform size for competition', 'functional', 'kettlebells', '["full_body"]', '[]', 'small', 'advanced', FALSE, TRUE, 'high', '[]', '["kettlebell", "competition", "steel", "uniform"]');

-- =============================================================================
-- FUNCTIONAL TRAINING BALLS
-- =============================================================================

INSERT OR IGNORE INTO equipment (id, name, description, category, sub_category, muscle_groups_primary, muscle_groups_secondary, space_requirement, difficulty_level, is_home_gym, is_commercial_gym, cost_category, alternatives, tags) VALUES
('eq_medicine_ball_light', 'Light Medicine Ball (2-6kg)', 'Light medicine ball for core and power training', 'functional', 'balls', '["core", "full_body"]', '["power", "coordination"]', 'small', 'beginner', TRUE, TRUE, 'low', '[]', '["medicine_ball", "light", "core", "power"]'),

('eq_medicine_ball_heavy', 'Heavy Medicine Ball (8-15kg)', 'Heavy medicine ball for advanced power training', 'functional', 'balls', '["core", "full_body"]', '["power", "strength"]', 'small', 'intermediate', TRUE, TRUE, 'medium', '[]', '["medicine_ball", "heavy", "power", "strength"]'),

('eq_slam_ball', 'Slam Ball', 'Dead-bounce ball for aggressive throwing exercises', 'functional', 'balls', '["core", "full_body"]', '["power", "cardio"]', 'small', 'intermediate', TRUE, TRUE, 'medium', '[]', '["slam_ball", "throwing", "dead_bounce", "aggressive"]'),

('eq_wall_ball', 'Wall Ball', 'Soft medicine ball for wall throws', 'functional', 'balls', '["legs", "core", "shoulders"]', '["full_body"]', 'small', 'intermediate', TRUE, TRUE, 'low', '[]', '["wall_ball", "soft", "wall_throws", "crossfit"]'),

('eq_stability_ball_55cm', 'Stability Ball (55cm)', 'Small stability ball for core and balance work', 'functional', 'balls', '["core"]', '["balance", "stability"]', 'small', 'beginner', TRUE, TRUE, 'low', '[]', '["stability_ball", "55cm", "small", "balance"]'),

('eq_stability_ball_65cm', 'Stability Ball (65cm)', 'Medium stability ball for general use', 'functional', 'balls', '["core"]', '["balance", "stability"]', 'small', 'beginner', TRUE, TRUE, 'low', '[]', '["stability_ball", "65cm", "medium", "general"]'),

('eq_stability_ball_75cm', 'Stability Ball (75cm)', 'Large stability ball for tall users', 'functional', 'balls', '["core"]', '["balance", "stability"]', 'small', 'beginner', TRUE, TRUE, 'low', '[]', '["stability_ball", "75cm", "large", "tall_users"]'),

('eq_bosu_ball', 'BOSU Ball', 'Half stability ball with platform for balance training', 'functional', 'balance', '["core"]', '["balance", "proprioception"]', 'small', 'intermediate', TRUE, TRUE, 'medium', '[]', '["bosu", "balance", "instability", "proprioception"]');

-- =============================================================================
-- BALANCE & INSTABILITY EQUIPMENT
-- =============================================================================

INSERT OR IGNORE INTO equipment (id, name, description, category, sub_category, muscle_groups_primary, muscle_groups_secondary, space_requirement, difficulty_level, is_home_gym, is_commercial_gym, cost_category, alternatives, tags) VALUES
('eq_balance_board', 'Balance Board', 'Wobble board for balance and proprioception training', 'functional', 'balance', '["core", "ankles"]', '["balance", "proprioception"]', 'minimal', 'beginner', TRUE, TRUE, 'low', '[]', '["balance_board", "wobble", "proprioception", "ankles"]'),

('eq_balance_pad', 'Balance Pad', 'Foam pad for unstable surface training', 'functional', 'balance', '["core"]', '["balance", "stability"]', 'minimal', 'beginner', TRUE, TRUE, 'low', '[]', '["balance_pad", "foam", "unstable", "simple"]'),

('eq_balance_disc', 'Balance Disc', 'Inflatable disc for balance challenges', 'functional', 'balance', '["core"]', '["balance"]', 'minimal', 'beginner', TRUE, TRUE, 'low', '[]', '["balance_disc", "inflatable", "disc", "versatile"]'),

('eq_slackline', 'Slackline', 'Tensioned line for advanced balance training', 'functional', 'balance', '["core", "legs"]', '["balance", "focus"]', 'large', 'advanced', TRUE, FALSE, 'medium', '[]', '["slackline", "advanced", "outdoor", "focus"]');

-- =============================================================================
-- STRENGTH MACHINES - HOME GYM
-- =============================================================================

INSERT OR IGNORE INTO equipment (id, name, description, category, sub_category, muscle_groups_primary, muscle_groups_secondary, space_requirement, difficulty_level, is_home_gym, is_commercial_gym, cost_category, alternatives, tags) VALUES
('eq_home_gym_multi_station', 'Multi-Station Home Gym', 'All-in-one home gym with multiple exercise stations', 'strength', 'machines', '["full_body"]', '[]', 'large', 'beginner', TRUE, FALSE, 'high', '[]', '["home_gym", "multi_station", "all_in_one", "convenient"]'),

('eq_smith_machine_home', 'Home Smith Machine', 'Compact Smith machine for home use', 'strength', 'machines', '["full_body"]', '[]', 'large', 'intermediate', TRUE, FALSE, 'high', '[]', '["smith_machine", "home", "guided", "safety"]'),

('eq_cable_crossover_home', 'Home Cable Crossover', 'Dual-tower cable system for home gyms', 'strength', 'machines', '["full_body"]', '[]', 'large', 'intermediate', TRUE, FALSE, 'high', '[]', '["cable", "crossover", "home", "versatile"]'),

('eq_lat_pulldown_home', 'Home Lat Pulldown', 'Compact lat pulldown machine', 'strength', 'machines', '["back", "biceps"]', '["shoulders"]', 'medium', 'beginner', TRUE, FALSE, 'medium', '[]', '["lat_pulldown", "home", "back", "compact"]'),

('eq_bench_adjustable', 'Adjustable Weight Bench', 'Multi-angle adjustable bench', 'strength', 'benches', '[]', '[]', 'small', 'beginner', TRUE, TRUE, 'medium', '[]', '["bench", "adjustable", "incline", "decline"]'),

('eq_bench_flat', 'Flat Weight Bench', 'Basic flat bench for pressing exercises', 'strength', 'benches', '[]', '[]', 'small', 'beginner', TRUE, TRUE, 'low', '[]', '["bench", "flat", "basic", "pressing"]'),

('eq_preacher_curl_bench', 'Preacher Curl Bench', 'Specialized bench for arm curls', 'strength', 'benches', '["arms"]', '[]', 'small', 'intermediate', TRUE, TRUE, 'medium', '[]', '["preacher", "curl", "arms", "isolation"]');

-- =============================================================================
-- RACKS & STANDS
-- =============================================================================

INSERT OR IGNORE INTO equipment (id, name, description, category, sub_category, muscle_groups_primary, muscle_groups_secondary, space_requirement, difficulty_level, is_home_gym, is_commercial_gym, cost_category, alternatives, tags) VALUES
('eq_squat_rack', 'Squat Rack', 'Basic squat rack with safety bars', 'strength', 'racks', '["legs"]', '[]', 'medium', 'intermediate', TRUE, TRUE, 'high', '[]', '["squat_rack", "safety", "basic", "legs"]'),

('eq_power_rack', 'Power Rack', 'Full cage with pull-up bar and safety features', 'strength', 'racks', '["full_body"]', '[]', 'large', 'intermediate', TRUE, TRUE, 'high', '[]', '["power_rack", "cage", "versatile", "safety"]'),

('eq_half_rack', 'Half Rack', 'Space-saving half rack with pull-up bar', 'strength', 'racks', '["full_body"]', '[]', 'medium', 'intermediate', TRUE, TRUE, 'medium', '[]', '["half_rack", "space_saving", "compact", "versatile"]'),

('eq_dumbbell_rack', 'Dumbbell Rack', 'Storage rack for dumbbells', 'accessories', 'storage', '[]', '[]', 'small', 'beginner', TRUE, TRUE, 'low', '[]', '["storage", "dumbbell", "organization", "rack"]'),

('eq_weight_plate_tree', 'Weight Plate Tree', 'Vertical storage for weight plates', 'accessories', 'storage', '[]', '[]', 'small', 'beginner', TRUE, TRUE, 'low', '[]', '["storage", "plates", "vertical", "organization"]'),

('eq_barbell_rack', 'Barbell Rack', 'Horizontal storage for barbells', 'accessories', 'storage', '[]', '[]', 'small', 'beginner', TRUE, TRUE, 'low', '[]', '["storage", "barbell", "horizontal", "rack"]');

-- =============================================================================
-- RECOVERY & MOBILITY EQUIPMENT
-- =============================================================================

INSERT OR IGNORE INTO equipment (id, name, description, category, sub_category, muscle_groups_primary, muscle_groups_secondary, space_requirement, difficulty_level, is_home_gym, is_commercial_gym, cost_category, alternatives, tags) VALUES
('eq_foam_roller_basic', 'Basic Foam Roller', 'Standard foam roller for self-myofascial release', 'accessories', 'recovery', '[]', '["recovery", "flexibility"]', 'minimal', 'beginner', TRUE, TRUE, 'low', '[]', '["foam_roller", "basic", "recovery", "massage"]'),

('eq_foam_roller_textured', 'Textured Foam Roller', 'Textured surface foam roller for deeper massage', 'accessories', 'recovery', '[]', '["recovery", "flexibility"]', 'minimal', 'beginner', TRUE, TRUE, 'low', '[]', '["foam_roller", "textured", "deep", "massage"]'),

('eq_massage_ball', 'Massage Ball', 'Firm ball for trigger point therapy', 'accessories', 'recovery', '[]', '["recovery"]', 'minimal', 'beginner', TRUE, TRUE, 'low', '[]', '["massage_ball", "trigger_point", "therapy", "small"]'),

('eq_lacrosse_ball', 'Lacrosse Ball', 'Hard ball for precise trigger point work', 'accessories', 'recovery', '[]', '["recovery"]', 'minimal', 'beginner', TRUE, TRUE, 'low', '[]', '["lacrosse_ball", "trigger_point", "precise", "hard"]'),

('eq_massage_stick', 'Massage Stick', 'Roller stick for self-massage', 'accessories', 'recovery', '[]', '["recovery"]', 'minimal', 'beginner', TRUE, TRUE, 'low', '[]', '["massage_stick", "roller", "self_massage", "portable"]'),

('eq_stretching_strap', 'Stretching Strap', 'Strap with loops for assisted stretching', 'flexibility', 'straps', '[]', '["flexibility"]', 'minimal', 'beginner', TRUE, TRUE, 'low', '[]', '["stretching", "strap", "assisted", "flexibility"]'),

('eq_yoga_blocks', 'Yoga Blocks', 'Support blocks for yoga and stretching', 'flexibility', 'props', '[]', '["flexibility", "support"]', 'minimal', 'beginner', TRUE, TRUE, 'low', '[]', '["yoga", "blocks", "support", "props"]'),

('eq_yoga_wheel', 'Yoga Wheel', 'Circular prop for back bending and stretching', 'flexibility', 'props', '["back"]', '["flexibility"]', 'small', 'intermediate', TRUE, TRUE, 'medium', '[]', '["yoga_wheel", "back_bend", "flexibility", "prop"]');

-- =============================================================================
-- SPECIALTY & ADVANCED EQUIPMENT
-- =============================================================================

INSERT OR IGNORE INTO equipment (id, name, description, category, sub_category, muscle_groups_primary, muscle_groups_secondary, space_requirement, difficulty_level, is_home_gym, is_commercial_gym, cost_category, alternatives, tags) VALUES
('eq_battle_ropes', 'Battle Ropes', 'Heavy ropes for high-intensity training', 'cardio', 'ropes', '["arms", "core"]', '["cardiovascular", "power"]', 'medium', 'intermediate', TRUE, TRUE, 'medium', '[]', '["battle_ropes", "hiit", "power", "cardio"]'),

('eq_tire', 'Training Tire', 'Large tire for flipping and strength training', 'functional', 'implements', '["full_body"]', '["power", "strength"]', 'large', 'advanced', FALSE, TRUE, 'medium', '[]', '["tire", "flipping", "power", "strongman"]'),

('eq_sledgehammer', 'Sledgehammer', 'Heavy hammer for tire strikes and conditioning', 'functional', 'implements', '["arms", "core"]', '["power", "cardio"]', 'medium', 'intermediate', FALSE, TRUE, 'low', '[]', '["sledgehammer", "tire_strikes", "power", "conditioning"]'),

('eq_farmers_walk_handles', 'Farmers Walk Handles', 'Handles for loaded carries', 'functional', 'implements', '["forearms", "traps"]', '["full_body"]', 'medium', 'intermediate', TRUE, TRUE, 'medium', '[]', '["farmers_walk", "carries", "grip", "strongman"]'),

('eq_yoke', 'Yoke', 'Frame for loaded yoke walks', 'strength', 'implements', '["legs", "back"]', '["core"]', 'large', 'advanced', FALSE, TRUE, 'high', '[]', '["yoke", "strongman", "walk", "heavy"]'),

('eq_prowler_sled', 'Prowler Sled', 'Weight sled for pushing exercises', 'functional', 'sleds', '["legs", "full_body"]', '["cardio", "power"]', 'large', 'intermediate', FALSE, TRUE, 'high', '[]', '["prowler", "sled", "pushing", "conditioning"]'),

('eq_ab_wheel', 'Ab Wheel', 'Wheel with handles for core strengthening', 'accessories', 'core', '["core"]', '["shoulders", "stability"]', 'minimal', 'intermediate', TRUE, TRUE, 'low', '[]', '["ab_wheel", "core", "challenging", "rollout"]'),

('eq_parallette_bars', 'Parallette Bars', 'Low parallel bars for bodyweight training', 'functional', 'bars', '["upper_body", "core"]', '[]', 'small', 'intermediate', TRUE, TRUE, 'low', '[]', '["parallettes", "bodyweight", "gymnastics", "handstand"]'),

('eq_sand_bag', 'Sandbag', 'Adjustable weight sandbag for functional training', 'functional', 'bags', '["full_body"]', '["stability", "core"]', 'small', 'intermediate', TRUE, TRUE, 'medium', '[]', '["sandbag", "unstable", "functional", "adjustable"]');

-- =============================================================================
-- ENVIRONMENT & SAFETY
-- =============================================================================

INSERT OR IGNORE INTO equipment (id, name, description, category, sub_category, muscle_groups_primary, muscle_groups_secondary, space_requirement, difficulty_level, is_home_gym, is_commercial_gym, cost_category, alternatives, tags) VALUES
('eq_gym_flooring', 'Gym Flooring', 'Protective flooring for home gym', 'accessories', 'flooring', '[]', '[]', 'large', 'beginner', TRUE, TRUE, 'medium', '[]', '["flooring", "protective", "home_gym", "safety"]'),

('eq_mirrors', 'Gym Mirrors', 'Wall mirrors for form checking', 'accessories', 'environment', '[]', '[]', 'minimal', 'beginner', TRUE, TRUE, 'low', '[]', '["mirrors", "form", "feedback", "motivation"]'),

('eq_timer', 'Interval Timer', 'Digital timer for workout intervals', 'accessories', 'timing', '[]', '[]', 'minimal', 'beginner', TRUE, TRUE, 'low', '[]', '["timer", "intervals", "hiit", "timing"]'),

('eq_weight_belt', 'Weight Belt', 'Support belt for heavy lifting', 'accessories', 'support', '["core"]', '[]', 'minimal', 'intermediate', TRUE, TRUE, 'low', '[]', '["belt", "support", "heavy_lifting", "safety"]'),

('eq_lifting_straps', 'Lifting Straps', 'Wrist straps for grip assistance', 'accessories', 'assistance', '["forearms"]', '[]', 'minimal', 'intermediate', TRUE, TRUE, 'low', '[]', '["straps", "grip", "assistance", "deadlift"]'),

('eq_wrist_wraps', 'Wrist Wraps', 'Supportive wraps for wrist stability', 'accessories', 'support', '["wrists"]', '[]', 'minimal', 'intermediate', TRUE, TRUE, 'low', '[]', '["wrist_wraps", "support", "pressing", "stability"]'),

('eq_knee_sleeves', 'Knee Sleeves', 'Compression sleeves for knee support', 'accessories', 'support', '["knees"]', '[]', 'minimal', 'beginner', TRUE, TRUE, 'low', '[]', '["knee_sleeves", "compression", "support", "squats"]');

-- =============================================================================
-- OUTDOOR & ALTERNATIVE EQUIPMENT
-- =============================================================================

INSERT OR IGNORE INTO equipment (id, name, description, category, sub_category, muscle_groups_primary, muscle_groups_secondary, space_requirement, difficulty_level, is_home_gym, is_commercial_gym, cost_category, alternatives, tags) VALUES
('eq_outdoor_running', 'Outdoor Running', 'Running outdoors on various terrain', 'cardio', 'outdoor', '["legs"]', '["cardiovascular"]', 'large', 'beginner', FALSE, FALSE, 'free', '["eq_treadmill"]', '["outdoor", "running", "fresh_air", "terrain"]'),

('eq_park_bench', 'Park Bench', 'Public bench for step-ups and support exercises', 'functional', 'outdoor', '["legs"]', '[]', 'minimal', 'beginner', FALSE, FALSE, 'free', '["eq_step_platform"]', '["park", "bench", "outdoor", "public"]'),

('eq_playground', 'Playground Equipment', 'Public playground for creative workouts', 'functional', 'outdoor', '["full_body"]', '[]', 'large', 'beginner', FALSE, FALSE, 'free', '[]', '["playground", "creative", "outdoor", "fun"]'),

('eq_swimming_pool', 'Swimming Pool', 'Pool for swimming and water exercises', 'cardio', 'water', '["full_body"]', '["cardiovascular"]', 'large', 'beginner', FALSE, TRUE, 'high', '[]', '["swimming", "water", "low_impact", "full_body"]'),

('eq_beach_sand', 'Beach/Sand', 'Sand surface for increased resistance training', 'functional', 'outdoor', '["legs", "core"]', '["stability"]', 'large', 'intermediate', FALSE, FALSE, 'free', '[]', '["beach", "sand", "instability", "resistance"]'),

('eq_hills_stairs_outdoor', 'Hills/Outdoor Stairs', 'Natural terrain for cardio and strength', 'cardio', 'outdoor', '["legs"]', '["cardiovascular"]', 'large', 'beginner', FALSE, FALSE, 'free', '["eq_stair_climber"]', '["hills", "stairs", "outdoor", "natural"]');

-- =============================================================================
-- ALTERNATIVE & HOUSEHOLD ITEMS
-- =============================================================================

INSERT OR IGNORE INTO equipment (id, name, description, category, sub_category, muscle_groups_primary, muscle_groups_secondary, space_requirement, difficulty_level, is_home_gym, is_commercial_gym, cost_category, alternatives, tags) VALUES
('eq_water_jugs', 'Water Jugs', 'Large water containers as adjustable weights', 'strength', 'household', '["full_body"]', '[]', 'minimal', 'beginner', TRUE, FALSE, 'free', '["eq_dumbbells"]', '["water_jugs", "household", "adjustable", "budget"]'),

('eq_backpack_weighted', 'Weighted Backpack', 'Backpack filled with books or weights', 'functional', 'household', '["full_body"]', '["core"]', 'minimal', 'beginner', TRUE, FALSE, 'free', '["eq_weight_vest"]', '["backpack", "weighted", "household", "creative"]'),

('eq_chair', 'Sturdy Chair', 'Chair for support, step-ups, and dips', 'functional', 'household', '["legs", "arms"]', '[]', 'minimal', 'beginner', TRUE, FALSE, 'free', '["eq_step_platform"]', '["chair", "household", "support", "versatile"]'),

('eq_books', 'Books', 'Heavy books as light weights', 'strength', 'household', '["arms"]', '[]', 'minimal', 'beginner', TRUE, FALSE, 'free', '["eq_dumbbells_light"]', '["books", "household", "light_weights", "creative"]'),

('eq_canned_goods', 'Canned Goods', 'Canned food as light weights', 'strength', 'household', '["arms"]', '[]', 'minimal', 'beginner', TRUE, FALSE, 'free', '["eq_dumbbells_light"]', '["canned_goods", "household", "light_weights", "convenient"]'),

('eq_laundry_detergent', 'Laundry Detergent Jug', 'Heavy detergent container as weight', 'strength', 'household', '["full_body"]', '[]', 'minimal', 'beginner', TRUE, FALSE, 'free', '["eq_kettlebell_light"]', '["detergent", "household", "handle", "weight"]');

-- =============================================================================
-- EQUIPMENT ALTERNATIVES MAPPING
-- =============================================================================

-- Update alternatives for better equipment recommendations
UPDATE equipment SET alternatives = '["eq_dumbbells_adjustable", "eq_dumbbells_selectable"]' WHERE id = 'eq_dumbbells_fixed';
UPDATE equipment SET alternatives = '["eq_dumbbells_fixed", "eq_dumbbells_selectable"]' WHERE id = 'eq_dumbbells_adjustable';
UPDATE equipment SET alternatives = '["eq_dumbbells_fixed", "eq_dumbbells_adjustable"]' WHERE id = 'eq_dumbbells_selectable';

UPDATE equipment SET alternatives = '["eq_barbell_standard", "eq_ez_curl_bar"]' WHERE id = 'eq_barbell_olympic';
UPDATE equipment SET alternatives = '["eq_barbell_olympic", "eq_ez_curl_bar"]' WHERE id = 'eq_barbell_standard';

UPDATE equipment SET alternatives = '["eq_kettlebell_medium", "eq_kettlebell_heavy"]' WHERE id = 'eq_kettlebell_light';
UPDATE equipment SET alternatives = '["eq_kettlebell_light", "eq_kettlebell_heavy"]' WHERE id = 'eq_kettlebell_medium';
UPDATE equipment SET alternatives = '["eq_kettlebell_light", "eq_kettlebell_medium"]' WHERE id = 'eq_kettlebell_heavy';

UPDATE equipment SET alternatives = '["eq_resistance_bands_medium", "eq_resistance_bands_heavy"]' WHERE id = 'eq_resistance_bands_light';
UPDATE equipment SET alternatives = '["eq_resistance_bands_light", "eq_resistance_bands_heavy"]' WHERE id = 'eq_resistance_bands_medium';
UPDATE equipment SET alternatives = '["eq_resistance_bands_light", "eq_resistance_bands_medium"]' WHERE id = 'eq_resistance_bands_heavy';

-- Add more specific alternatives
UPDATE equipment SET alternatives = '["eq_medicine_ball_heavy", "eq_slam_ball"]' WHERE id = 'eq_medicine_ball_light';
UPDATE equipment SET alternatives = '["eq_medicine_ball_light", "eq_slam_ball", "eq_wall_ball"]' WHERE id = 'eq_medicine_ball_heavy';

UPDATE equipment SET alternatives = '["eq_stability_ball_65cm", "eq_stability_ball_75cm"]' WHERE id = 'eq_stability_ball_55cm';
UPDATE equipment SET alternatives = '["eq_stability_ball_55cm", "eq_stability_ball_75cm"]' WHERE id = 'eq_stability_ball_65cm';
UPDATE equipment SET alternatives = '["eq_stability_ball_55cm", "eq_stability_ball_65cm"]' WHERE id = 'eq_stability_ball_75cm';

-- =============================================================================
-- FINAL EQUIPMENT COUNT AND VALIDATION
-- =============================================================================

-- Summary of equipment added
SELECT 'Total Equipment Items' as metric, COUNT(*) as count FROM equipment
UNION ALL
SELECT 'Bodyweight/Free Items', COUNT(*) FROM equipment WHERE cost_category = 'free'
UNION ALL
SELECT 'Low Cost Items', COUNT(*) FROM equipment WHERE cost_category = 'low'
UNION ALL
SELECT 'Medium Cost Items', COUNT(*) FROM equipment WHERE cost_category = 'medium'
UNION ALL
SELECT 'High Cost Items', COUNT(*) FROM equipment WHERE cost_category = 'high'
UNION ALL
SELECT 'Home Gym Compatible', COUNT(*) FROM equipment WHERE is_home_gym = TRUE
UNION ALL
SELECT 'Commercial Gym Only', COUNT(*) FROM equipment WHERE is_home_gym = FALSE
ORDER BY count DESC;