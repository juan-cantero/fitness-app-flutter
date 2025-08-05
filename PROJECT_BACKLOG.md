# Fitness App Project Backlog

## Overview
This backlog tracks all features, tasks, and improvements for the Flutter Fitness App with AI-powered workout recommendations.

## Epic Structure
- 🏗️ **Foundation** - Core infrastructure and setup
- 🔐 **Authentication** - User management and security
- 💾 **Database** - Data modeling and persistence
- 💪 **Exercise Management** - Exercise CRUD and categorization
- 🏋️ **Workout Management** - Workout creation and management
- 🛠️ **Equipment Management** - User equipment inventory and management
- 🤖 **AI Intelligence** - LLM-powered recommendations
- 👤 **User Profile** - Profile management and preferences
- 📊 **Analytics** - Progress tracking and insights
- 🎨 **UI/UX** - Enhanced user interface
- 🧪 **Testing** - Quality assurance
- 🚀 **Deployment** - Production readiness

---

## 🏗️ Foundation Epic

### Database Architecture Strategy
**Approach:** Local-First Development with Structured Migration to Supabase

#### Phase 1: Local Foundation (Weeks 1-4)
- [ ] **[HIGH]** Design SQLite schema matching Supabase structure (User: Database Architecture Agent)
  - Tables: users, exercises, workouts, categories, user_profiles, equipment, user_equipment  
  - Relationships and foreign keys optimized for SQLite
  - Indexes for local query performance
  - Equipment-exercise compatibility tables
- [ ] **[HIGH]** Create SQLite migration system (User: Database Architecture Agent)
  - Version-controlled schema migrations
  - Data seeding for development and testing
  - Schema validation and integrity checks
- [ ] **[HIGH]** Design repository abstraction layer (User: API Integration Agent)
  - Abstract interfaces for all data operations
  - Local repository implementations for SQLite
  - Future-ready for remote implementation

#### Phase 2: Supabase Integration (Weeks 5-8) 
- [ ] **[HIGH]** Design Supabase schema matching local structure (User: Database Architecture Agent)
  - PostgreSQL schema identical to SQLite structure
  - Row Level Security (RLS) policies for production
  - Indexes optimized for PostgreSQL performance
- [ ] **[HIGH]** Implement sync layer architecture (User: API Integration Agent)
  - Conflict resolution strategies
  - Background synchronization service
  - Data consistency validation
- [ ] **[HIGH]** Implement media file sync system (User: API Integration Agent)
  - Local-to-Supabase storage sync
  - Image and video upload queuing
  - Media file conflict resolution
  - Bandwidth optimization for media sync
  - Progressive media sync (thumbnails first)
- [ ] **[MEDIUM]** Create data migration tools (User: API Integration Agent)
  - Local-to-remote data transfer utilities
  - Schema synchronization validation
  - Rollback and recovery mechanisms
  - Media file migration utilities

#### Phase 3: Production Integration (Weeks 9-12)
- [ ] **[MEDIUM]** Implement real-time sync features (User: API Integration Agent)
  - Supabase real-time subscriptions
  - Live data updates across devices
  - Optimistic UI updates with conflict resolution
- [ ] **[LOW]** Performance optimization and monitoring (User: Testing & Quality Agent)
  - Sync performance metrics
  - Database query optimization
  - Connection pooling and caching strategies

### Core Infrastructure
- [x] **[COMPLETED]** Flutter project setup with dependencies
- [x] **[COMPLETED]** Feature-based architecture implementation
- [x] **[COMPLETED]** Core configuration (theme, routing, constants)
- [x] **[COMPLETED]** Development agents creation
- [ ] **[HIGH]** Environment variable management system
- [ ] **[MEDIUM]** Logging and error reporting setup
- [ ] **[MEDIUM]** App performance monitoring integration

### Local Media Storage Strategy
**Approach:** Local-First Media with Background Sync to Supabase Storage

#### Phase 1: Local Media Foundation (Weeks 1-4)
- [ ] **[HIGH]** Design local file storage system (User: API Integration Agent)
  - Organized directory structure for different media types
  - Image compression and optimization pipelines
  - File naming conventions with UUID support
  - Metadata tracking (size, format, creation date, sync status)
- [ ] **[HIGH]** Implement media manager service (User: API Integration Agent)
  - Image capture, selection, and import functionality
  - Local file CRUD operations
  - Image processing (resize, compress, format conversion)
  - Thumbnail generation for performance
- [ ] **[HIGH]** Create media repository layer (User: API Integration Agent)
  - Abstract interface for local and future remote operations
  - Media file relationship management with database entities
  - Bulk operations for media management
  - Media cleanup and storage optimization
- [ ] **[MEDIUM]** Add offline media caching (User: API Integration Agent)
  - Smart caching strategies for frequently accessed images
  - Cache size management and cleanup policies
  - Preloading strategies for common media assets
  - Memory management for image loading

#### Phase 2: Media Sync Integration (Weeks 5-8)
- [ ] **[HIGH]** Implement media sync queue system (User: API Integration Agent)
  - Upload queue management with retry logic
  - Progress tracking for media uploads
  - Bandwidth-aware upload scheduling
  - Sync status tracking and reporting
- [ ] **[MEDIUM]** Add media conflict resolution (User: API Integration Agent)
  - Handle media file conflicts during sync
  - Version management for updated media files
  - User-directed resolution for media conflicts
  - Automatic fallback strategies

---

## 🔐 Authentication Epic
**Strategy:** Local Authentication with Supabase Migration Path

### Phase 1: Local Authentication (Weeks 1-4)
- [ ] **[HIGH]** Implement local user authentication system (User: Security & Privacy Agent)
  - Local user registration and login
  - Secure password hashing and storage
  - Session management with secure storage
  - Guest mode for offline usage
- [ ] **[MEDIUM]** Prepare for Supabase auth integration (User: Security & Privacy Agent)
  - Authentication abstraction layer
  - Token management interface
  - User migration strategy planning

### Phase 2: Supabase Authentication Integration (Weeks 5-8)
- [ ] **[HIGH]** Implement Supabase authentication integration (User: Security & Privacy Agent)
  - Email/password authentication
  - Social login (Google, Apple)
  - Email verification flow
  - Local-to-remote user migration
- [ ] **[HIGH]** Complete login screen functionality (User: Security & Privacy Agent)
  - Form validation
  - Loading states
  - Error handling
- [ ] **[HIGH]** Complete registration screen functionality (User: Security & Privacy Agent)
  - Password strength validation
  - Terms acceptance
  - Success/error feedback
- [ ] **[MEDIUM]** Implement forgot password flow (User: Security & Privacy Agent)
- [ ] **[MEDIUM]** Add biometric authentication (User: Security & Privacy Agent)
- [ ] **[LOW]** Social media login integration (User: Security & Privacy Agent)

### Security & Privacy
- [ ] **[HIGH]** Implement secure token storage (User: Security & Privacy Agent)
- [ ] **[HIGH]** Add data encryption for sensitive information (User: Security & Privacy Agent)
- [ ] **[MEDIUM]** GDPR compliance features (User: Security & Privacy Agent)
  - Data export functionality
  - Account deletion
  - Privacy policy acceptance
- [ ] **[MEDIUM]** Security audit logging (User: Security & Privacy Agent)

---

## 💾 Database Epic
**Strategy:** Local-First Implementation with Supabase Migration Path

### Phase 1: Local Data Foundation 

#### Data Models (SQLite-First)
- [ ] **[HIGH]** Create Exercise model with SQLite optimization (User: API Integration Agent)
  - Model validation and business rules
  - SQLite-specific constraints and indexes
  - JSON field handling for complex data
- [ ] **[HIGH]** Create Workout model with SQLite optimization (User: API Integration Agent)
  - Exercise relationship handling
  - Workout configuration and metadata
  - Performance tracking integration
- [ ] **[HIGH]** Create UserProfile model (User: API Integration Agent)
  - User preferences and settings
  - Fitness goals and tracking data
  - Equipment inventory integration
- [ ] **[HIGH]** Create Equipment and UserEquipment models (User: API Integration Agent)
  - Equipment catalog structure
  - User inventory management
  - Equipment-exercise compatibility
- [ ] **[MEDIUM]** Create WorkoutSession model for tracking (User: API Integration Agent)
  - Session performance metrics
  - Exercise completion tracking
  - Progress analysis data
- [ ] **[MEDIUM]** Create ExerciseLog model for progress tracking (User: API Integration Agent)
  - Set/rep/weight progression
  - Performance metrics over time
  - Goal achievement tracking

#### Local Repositories (SQLite Implementation)
- [ ] **[HIGH]** Implement Exercise repository with SQLite CRUD (User: API Integration Agent)
  - Complex filtering and search operations
  - Equipment-based exercise filtering
  - Category and tag management
- [ ] **[HIGH]** Implement Workout repository with SQLite CRUD (User: API Integration Agent)
  - Workout creation and modification
  - Exercise ordering and configuration
  - Template and sharing functionality
- [ ] **[HIGH]** Implement UserProfile repository (User: API Integration Agent)
  - Profile management and preferences
  - Settings persistence and retrieval
  - Data export and import capabilities
- [ ] **[HIGH]** Implement Equipment repositories (User: API Integration Agent)
  - Equipment catalog management
  - User inventory CRUD operations
  - Equipment availability tracking

#### Local Database Infrastructure
- [ ] **[HIGH]** Set up SQLite database with migrations (User: API Integration Agent)
  - Database initialization and versioning
  - Migration scripts for schema evolution
  - Data integrity and validation
- [ ] **[HIGH]** Implement offline-first architecture (User: API Integration Agent)
  - Local-first data operations
  - Queue system for future sync
  - Data consistency and validation
- [ ] **[MEDIUM]** Create local caching and indexing (User: API Integration Agent)
  - Query performance optimization
  - Full-text search capabilities
  - Data relationship caching

### Phase 2: Sync Layer Implementation

#### Repository Abstraction
- [ ] **[HIGH]** Create repository interface abstractions (User: API Integration Agent)
  - Common interface for local and remote operations
  - Dependency injection setup
  - Error handling standardization
- [ ] **[HIGH]** Implement sync-aware repositories (User: API Integration Agent)
  - Local-first with remote sync capability
  - Conflict detection and resolution
  - Optimistic updates with rollback

#### Data Synchronization
- [ ] **[MEDIUM]** Add conflict resolution for sync (User: API Integration Agent)
  - Last-write-wins and custom conflict strategies
  - User-directed conflict resolution UI
  - Data merging and validation
- [ ] **[MEDIUM]** Background synchronization service (User: API Integration Agent)
  - Automatic sync when network available
  - Retry logic and error handling
  - Sync status tracking and reporting

### Phase 3: Remote Integration (Future)
- [ ] **[LOW]** Supabase repository implementations (User: API Integration Agent)
  - PostgreSQL-optimized queries
  - Real-time subscription integration
  - Production performance optimization
- [ ] **[LOW]** Production sync optimization (User: API Integration Agent)
  - Incremental sync strategies
  - Bandwidth optimization
  - Connection pooling and caching

---

## 💪 Exercise Management Epic

### Exercise CRUD
- [ ] **[HIGH]** Complete exercises listing screen (User: Flutter State Management Agent)
  - Grid/list view toggle
  - Search functionality
  - Category filtering
  - Infinite scroll pagination
- [ ] **[HIGH]** Implement exercise creation form (User: Flutter State Management Agent)
  - Image upload support
  - Video demonstration support
  - Muscle group selection
  - Equipment requirements
- [ ] **[HIGH]** Complete exercise detail screen (User: Flutter State Management Agent)
  - Exercise instructions
  - Media gallery
  - Related exercises
  - Favorite functionality
- [ ] **[MEDIUM]** Add exercise editing capabilities (User: Flutter State Management Agent)
- [ ] **[MEDIUM]** Implement exercise sharing functionality (User: Flutter State Management Agent)

### Exercise Categories & Filtering
- [ ] **[HIGH]** Implement dynamic category system (User: Flutter State Management Agent)
- [ ] **[HIGH]** Add advanced filtering options (User: Flutter State Management Agent)
  - By equipment type
  - By muscle group
  - By difficulty level
  - By duration
- [ ] **[MEDIUM]** Add exercise search with tags (User: Flutter State Management Agent)
- [ ] **[MEDIUM]** Implement exercise recommendations based on history (User: LLM Intelligence Agent)

### Exercise Media & Local Storage
- [ ] **[HIGH]** Implement local image storage for exercises (User: API Integration Agent)
  - Local file system management for exercise images
  - Image caching and optimization for offline access
  - Image sync queuing for future Supabase upload
  - Image compression and format standardization
- [ ] **[HIGH]** Create image management repository (User: API Integration Agent)
  - Local image CRUD operations
  - Image metadata tracking (size, format, sync status)
  - Image cleanup and storage optimization
  - Batch image operations for sync preparation
- [ ] **[MEDIUM]** Image upload and management for Supabase (User: API Integration Agent)
  - Integration with Supabase storage buckets
  - Image sync from local to remote storage
  - Conflict resolution for image updates
- [ ] **[MEDIUM]** Video upload and streaming (User: API Integration Agent)
  - Local video file management
  - Video compression and optimization
  - Streaming preparation for remote access
- [ ] **[LOW]** Exercise animation support (User: Flutter State Management Agent)

---

## 🏋️ Workout Management Epic

### Workout Creation
- [ ] **[HIGH]** Complete workout creation screen (User: Flutter State Management Agent)
  - Drag-and-drop exercise ordering
  - Set/rep/weight configuration
  - Rest time settings
  - Workout duration estimation
- [ ] **[HIGH]** Implement workout builder with exercise selection (User: Flutter State Management Agent)
- [ ] **[HIGH]** Add workout templates system (User: Flutter State Management Agent)
- [ ] **[MEDIUM]** Workout duplication and modification (User: Flutter State Management Agent)
- [ ] **[MEDIUM]** Workout scheduling and planning (User: Flutter State Management Agent)

### Workout Execution
- [ ] **[HIGH]** Create workout execution screen (User: Flutter State Management Agent)
  - Timer functionality
  - Progress tracking
  - Set completion marking
  - Rest timer with notifications
- [ ] **[HIGH]** Implement workout session tracking (User: Flutter State Management Agent)
- [ ] **[MEDIUM]** Add workout modifications during execution (User: Flutter State Management Agent)
- [ ] **[MEDIUM]** Workout history and statistics (User: Flutter State Management Agent)

### Workout Sharing & Social
- [ ] **[MEDIUM]** Workout sharing functionality (User: Security & Privacy Agent)
- [ ] **[MEDIUM]** Public workout discovery (User: Flutter State Management Agent)
- [ ] **[LOW]** Workout rating and reviews (User: Flutter State Management Agent)
- [ ] **[LOW]** Social features (follow users, workout challenges) (User: Flutter State Management Agent)

---

## 🛠️ Equipment Management Epic

### Equipment Data Model & Media
- [ ] **[HIGH]** Create Equipment model with validation (User: API Integration Agent)
  - Equipment name, type, category
  - Purchase date, condition, weight capacity
  - Custom equipment support
  - Equipment images and specifications
- [ ] **[HIGH]** Implement local equipment image storage (User: API Integration Agent)
  - Local storage for equipment catalog images
  - User equipment photo management
  - Image caching for offline equipment browsing
  - Equipment image sync preparation
- [ ] **[HIGH]** Create UserEquipment model for inventory (User: API Integration Agent)
  - User-equipment relationships
  - Equipment availability status
  - Custom notes and modifications
  - Maintenance history tracking

### Equipment Repository
- [ ] **[HIGH]** Implement Equipment repository with CRUD operations (User: API Integration Agent)
  - Standard equipment catalog management
  - User equipment inventory operations
  - Equipment search and filtering
  - Bulk equipment operations
- [ ] **[MEDIUM]** Add equipment sync and caching (User: API Integration Agent)
  - Offline equipment catalog
  - User inventory synchronization
  - Equipment data versioning

### Equipment Management UI
- [ ] **[HIGH]** Create equipment catalog screen (User: Flutter State Management Agent)
  - Browse available equipment types
  - Search and filter equipment
  - Equipment details and specifications
  - Add to user inventory functionality
- [ ] **[HIGH]** Implement user equipment inventory screen (User: Flutter State Management Agent)
  - View owned equipment
  - Add/remove equipment from inventory
  - Equipment condition and notes management
  - Equipment availability toggle
- [ ] **[HIGH]** Add equipment selection components (User: Flutter State Management Agent)
  - Equipment picker for workout creation
  - Multi-select equipment filtering
  - Equipment availability indicators
  - Quick equipment access shortcuts

### Equipment Integration
- [ ] **[HIGH]** Integrate equipment filtering in exercise screens (User: Flutter State Management Agent)
  - Filter exercises by available equipment
  - Show equipment requirements for exercises
  - Equipment substitute suggestions
  - Equipment compatibility indicators
- [ ] **[HIGH]** Integrate equipment in workout creation (User: Flutter State Management Agent)
  - Equipment-based workout templates
  - Automatic equipment validation
  - Equipment conflict detection
  - Equipment setup reminders
- [ ] **[MEDIUM]** Add equipment-based workout recommendations (User: LLM Intelligence Agent)
  - AI recommendations based on available equipment
  - Equipment utilization optimization
  - Equipment progression suggestions
  - Home gym setup recommendations

### Equipment Catalog & Data
- [ ] **[MEDIUM]** Build comprehensive equipment database (User: Database Architecture Agent)
  - Standard gym equipment catalog
  - Home equipment options
  - Bodyweight alternatives
  - Equipment specifications and images
- [ ] **[MEDIUM]** Add equipment categorization system (User: Database Architecture Agent)
  - Equipment types (cardio, strength, flexibility)
  - Space requirements (home, gym, outdoor)
  - Skill level requirements
  - Price ranges and recommendations
- [ ] **[LOW]** Equipment marketplace integration (User: API Integration Agent)
  - Equipment purchasing links
  - Price comparison features
  - Equipment reviews and ratings
  - Used equipment marketplace

### Equipment Analytics
- [ ] **[MEDIUM]** Track equipment usage statistics (User: Flutter State Management Agent)
  - Most/least used equipment
  - Equipment efficiency metrics
  - Usage patterns and trends
  - Equipment ROI analysis
- [ ] **[LOW]** Equipment maintenance reminders (User: Flutter State Management Agent)
  - Maintenance schedules
  - Equipment condition tracking
  - Replacement recommendations
  - Safety check reminders

---

## 🤖 AI Intelligence Epic

### Workout Recommendations
- [ ] **[HIGH]** Implement core recommendation engine (User: LLM Intelligence Agent)
  - User preference analysis
  - Equipment-based filtering
  - Time constraint optimization
  - Fitness level adaptation
- [ ] **[HIGH]** Create user context builder for AI (User: LLM Intelligence Agent)
  - Workout history analysis
  - Goal setting integration
  - Equipment availability tracking
- [ ] **[HIGH]** Design and implement prompt templates (User: LLM Intelligence Agent)
- [ ] **[MEDIUM]** Add recommendation explanation system (User: LLM Intelligence Agent)
- [ ] **[MEDIUM]** Implement feedback learning loop (User: LLM Intelligence Agent)

### Smart Features
- [ ] **[MEDIUM]** Progressive overload suggestions (User: LLM Intelligence Agent)
- [ ] **[MEDIUM]** Recovery time recommendations (User: LLM Intelligence Agent)
- [ ] **[MEDIUM]** Exercise alternative suggestions (User: LLM Intelligence Agent)
- [ ] **[LOW]** Injury prevention recommendations (User: LLM Intelligence Agent)
- [ ] **[LOW]** Nutrition suggestions integration (User: LLM Intelligence Agent)

### AI Performance
- [ ] **[MEDIUM]** Implement response caching system (User: LLM Intelligence Agent)
- [ ] **[MEDIUM]** Add fallback strategies for API failures (User: LLM Intelligence Agent)
- [ ] **[LOW]** A/B testing for prompt optimization (User: LLM Intelligence Agent)

---

## 👤 User Profile Epic

### Profile Management & Media
- [ ] **[HIGH]** Complete profile screen implementation (User: Flutter State Management Agent)
  - Personal information editing
  - Profile picture upload
  - Fitness goals setting
  - Equipment inventory management
- [ ] **[HIGH]** Implement local profile image storage (User: API Integration Agent)
  - Local profile picture management
  - Image compression and optimization
  - Profile image sync queuing
  - Multiple profile photo support
- [ ] **[HIGH]** Implement user preferences system (User: Flutter State Management Agent)
  - Workout preferences
  - Notification settings
  - Privacy settings
  - Theme preferences
- [ ] **[MEDIUM]** Add user statistics dashboard (User: Flutter State Management Agent)
- [ ] **[MEDIUM]** Implement goal tracking system (User: Flutter State Management Agent)

### User Settings
- [ ] **[HIGH]** Settings screen with all app preferences (User: Flutter State Management Agent)
- [ ] **[MEDIUM]** Data export functionality (User: Security & Privacy Agent)
- [ ] **[MEDIUM]** Account deletion process (User: Security & Privacy Agent)
- [ ] **[LOW]** Dark/light theme toggle (User: Flutter State Management Agent)

---

## 📊 Analytics Epic

### Progress Tracking
- [ ] **[HIGH]** Implement workout session logging (User: Flutter State Management Agent)
- [ ] **[HIGH]** Create progress visualization charts (User: Flutter State Management Agent)
  - Weight progression
  - Volume tracking
  - Frequency analysis
- [ ] **[MEDIUM]** Add achievement system (User: Flutter State Management Agent)
- [ ] **[MEDIUM]** Weekly/monthly progress reports (User: Flutter State Management Agent)

### Performance Metrics
- [ ] **[MEDIUM]** Implement performance analytics (User: Testing & Quality Agent)
  - App usage statistics
  - Feature adoption metrics
  - Performance monitoring
- [ ] **[LOW]** User behavior analytics (User: Testing & Quality Agent)

---

## 🎨 UI/UX Epic

### Enhanced User Interface
- [ ] **[MEDIUM]** Implement advanced animations (User: Flutter State Management Agent)
- [ ] **[MEDIUM]** Add haptic feedback (User: Flutter State Management Agent)
- [ ] **[MEDIUM]** Improve accessibility features (User: Flutter State Management Agent)
- [ ] **[LOW]** Custom workout card designs (User: Flutter State Management Agent)
- [ ] **[LOW]** Onboarding flow for new users (User: Flutter State Management Agent)

### Responsive Design
- [ ] **[MEDIUM]** Tablet layout optimization (User: Flutter State Management Agent)
- [ ] **[LOW]** Desktop/web responsive design (User: Flutter State Management Agent)

---

## 🧪 Testing Epic

### Test Implementation
- [ ] **[HIGH]** Unit tests for all business logic (User: Testing & Quality Agent)
- [ ] **[HIGH]** Widget tests for all screens (User: Testing & Quality Agent)
- [ ] **[HIGH]** Integration tests for user workflows (User: Testing & Quality Agent)
- [ ] **[MEDIUM]** Performance tests (User: Testing & Quality Agent)
- [ ] **[MEDIUM]** Security testing (User: Testing & Quality Agent)

### Quality Assurance
- [ ] **[HIGH]** Set up CI/CD pipeline (User: Testing & Quality Agent)
- [ ] **[MEDIUM]** Code coverage reporting (User: Testing & Quality Agent)
- [ ] **[MEDIUM]** Automated testing in pipeline (User: Testing & Quality Agent)
- [ ] **[LOW]** Load testing for backend (User: Testing & Quality Agent)

---

## 🚀 Deployment Epic

### Production Setup
- [ ] **[HIGH]** Configure production Supabase instance (User: API Integration Agent)
- [ ] **[HIGH]** Set up app store deployment pipeline (User: Testing & Quality Agent)
- [ ] **[MEDIUM]** Configure production environment variables (User: API Integration Agent)
- [ ] **[MEDIUM]** Set up monitoring and alerting (User: Testing & Quality Agent)

### App Store Optimization
- [ ] **[MEDIUM]** App store screenshots and descriptions (User: Documentation Agent)
- [ ] **[MEDIUM]** App icon and branding finalization (User: Flutter State Management Agent)
- [ ] **[LOW]** App store keyword optimization (User: Documentation Agent)

---

## Technical Debt & Improvements

### Code Quality
- [ ] **[MEDIUM]** Code refactoring and optimization (User: Testing & Quality Agent)
- [ ] **[MEDIUM]** Documentation updates (User: Documentation Agent)
- [ ] **[LOW]** Performance optimizations (User: Flutter State Management Agent)

### Architecture Improvements
- [ ] **[LOW]** Microservices consideration for scaling (User: API Integration Agent)
- [ ] **[LOW]** Advanced caching strategies (User: API Integration Agent)

---

## Notes
- **Agent Assignment**: Each task includes the recommended development agent to use
- **Priority Levels**: HIGH (must-have), MEDIUM (should-have), LOW (nice-to-have)
- **Dependencies**: Some tasks depend on completion of others (e.g., database schema before repositories)
- **Estimation**: Tasks are sized for 1-3 days of development work each

## Usage with Development Agents
For each task, use the specified agent with Claude Code's Task tool:
```bash
claude-code task --agent="agents/[agent_name].md" "[task description]"
```