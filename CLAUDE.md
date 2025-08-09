# Fitness App - Claude Code Configuration

## Project Overview
AI-powered fitness application with local-first architecture, using Flutter, SQLite, and Supabase for sync.

## Specialized Agents

### Database Architecture Agent
**File:** `agents/database_architecture_agent.md`
**Role:** PostgreSQL database architect specializing in fitness app data models with Supabase integration
**Use for:** Schema design, database optimization, relationships, indexing

### API Integration & Sync Agent  
**File:** `agents/api_integration_sync_agent.md`
**Role:** Supabase integration specialist for local-first sync architecture
**Use for:** API integration, sync strategies, conflict resolution, offline capabilities

### Flutter State Management Agent
**File:** `agents/flutter_state_management_agent.md`
**Role:** Flutter state management expert using Riverpod for complex app architecture
**Use for:** State management, Riverpod patterns, UI architecture, performance optimization

### LLM Workout Intelligence Agent
**File:** `agents/llm_workout_intelligence_agent.md`
**Role:** AI-powered workout recommendations and intelligent fitness coaching
**Use for:** AI features, workout algorithms, personalization, machine learning integration

### Security & Privacy Agent
**File:** `agents/security_privacy_agent.md`
**Role:** Security specialist for user data protection and privacy compliance
**Use for:** Security implementation, privacy compliance, data protection, authentication

### Testing & Quality Agent
**File:** `agents/testing_quality_agent.md`
**Role:** Quality assurance specialist for comprehensive testing strategies
**Use for:** Testing strategies, quality assurance, automation, CI/CD

### Documentation & Teaching Agent
**File:** `agents/documentation_teaching_agent.md`
**Role:** Technical documentation and educational content specialist
**Use for:** Documentation, user guides, tutorials, code comments

## Current Architecture

### Database Layer (✅ Complete)
- SQLite for local-first storage
- Web-compatible database manager
- Comprehensive seed data with exercises, equipment, categories
- Cross-platform compatibility (Mobile, Web, Desktop)

### Models & Repositories (✅ Complete)
- Freezed data models with JSON serialization
- Repository pattern with local/remote/mock implementations
- Sync-aware architecture ready for Supabase integration

### Debug Tools (✅ Complete)
- Database debug screen for real data inspection
- Demo data screen for UI preview
- Cross-platform compatibility

### Next Priorities
1. Implement core UI features (Exercise Management)
2. Add user authentication flow
3. Implement workout creation and management
4. Add AI-powered workout recommendations
5. Implement Supabase sync layer

## Usage Instructions
To invoke a specialized agent, use the Task tool and reference the specific agent file:
- For database work: Reference `agents/database_architecture_agent.md`  
- For state management: Reference `agents/flutter_state_management_agent.md`
- For AI features: Reference `agents/llm_workout_intelligence_agent.md`
- etc.

## Development Status
- **Foundation**: Complete (Database, Models, Repositories)
- **Core Features**: In Progress (UI, Authentication)
- **Advanced Features**: Planned (AI, Sync, Analytics)
- **Testing**: Basic setup complete, comprehensive testing planned