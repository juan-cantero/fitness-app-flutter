# Fitness App Flutter

A Flutter fitness application with AI-powered workout recommendations, built with Supabase backend and comprehensive agent-based development architecture.

## Features

- 🔐 **Authentication**: Secure user registration and login with Supabase Auth
- 💪 **Exercise Management**: Create, browse, and categorize exercises
- 🏋️ **Workout Creation**: Build custom workouts with exercises
- 🤖 **AI Recommendations**: LLM-powered personalized workout suggestions
- 📱 **Offline-First**: Works seamlessly without internet connection
- 🎨 **Modern UI**: Material Design 3 with light/dark theme support
- 🔄 **Real-time Sync**: Live updates across devices

## Tech Stack

### Frontend
- **Flutter** - Cross-platform mobile framework
- **Riverpod** - State management
- **Go Router** - Declarative routing
- **Material Design 3** - UI components

### Backend
- **Supabase** - Backend-as-a-Service
  - PostgreSQL database
  - Row Level Security (RLS)
  - Real-time subscriptions
  - Authentication
  - File storage

### AI Integration
- **OpenAI API** / **Anthropic Claude** - Workout recommendations
- **Custom prompt engineering** - Fitness-specific AI responses

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── app.dart                  # Main app widget
├── core/                     # Core functionality
│   ├── config/              # Configuration files
│   ├── constants/           # App constants
│   ├── utils/               # Utility functions
│   ├── extensions/          # Dart extensions
│   └── errors/              # Custom exceptions
├── features/                # Feature modules
│   ├── auth/               # Authentication
│   ├── exercises/          # Exercise management
│   ├── workouts/           # Workout management
│   └── profile/            # User profile
├── shared/                 # Shared components
│   ├── widgets/            # Reusable widgets
│   ├── services/           # Business services
│   ├── models/             # Data models
│   └── repositories/       # Data repositories
├── providers/              # Riverpod providers
└── agents/                 # AI development agents
```

## Development Agents

This project uses specialized AI agents for different aspects of development:

1. **Database Architecture Agent** - Schema design, RLS policies, performance optimization
2. **Flutter State Management Agent** - Riverpod patterns, offline-first architecture
3. **LLM Workout Intelligence Agent** - AI-powered recommendations, prompt engineering
4. **API Integration & Sync Agent** - Supabase integration, offline synchronization
5. **Security & Privacy Agent** - Authentication, data protection, compliance
6. **Testing & Quality Agent** - Comprehensive testing strategies, CI/CD
7. **Documentation & Teaching Agent** - Technical docs, tutorials, knowledge transfer

## Getting Started

### Prerequisites

- Flutter SDK (3.32.7 or later)
- Dart SDK (3.8.1 or later)
- A Supabase project
- OpenAI or Anthropic API key (for AI features)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd fitness-app-flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your API keys and configuration
   ```

4. **Set up Supabase**
   - Create a new Supabase project
   - Copy your project URL and anon key to `.env`
   - Run database migrations (will be provided by Database Architecture Agent)

5. **Run the app**
   ```bash
   flutter run
   ```

### Environment Variables

Create a `.env` file based on `.env.example`:

```bash
# Required
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key

# Optional (for AI features)
OPENAI_API_KEY=your_openai_api_key
ANTHROPIC_API_KEY=your_anthropic_api_key
```

## Development Workflow

### Using Development Agents

Each agent can be used with Claude Code's Task tool:

```bash
# Example: Use Database Architecture Agent
claude-code task --agent="agents/database_architecture_agent.md" \
  "Design the database schema for exercises and workouts"

# Example: Use LLM Intelligence Agent  
claude-code task --agent="agents/llm_workout_intelligence_agent.md" \
  "Implement workout recommendation based on user preferences"
```

### Recommended Development Order

1. **Database Architecture** - Set up data foundation
2. **Security & Privacy** - Implement authentication and permissions
3. **API Integration** - Connect Flutter to Supabase
4. **State Management** - Build reactive UI patterns
5. **LLM Intelligence** - Add AI-powered features
6. **Testing & Quality** - Ensure reliability and performance
7. **Documentation** - Create guides and tutorials

## Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/

# Analyze code quality
flutter analyze
```

## Building

```bash
# Build for Android
flutter build apk

# Build for iOS
flutter build ios

# Build for web
flutter build web
```

## Architecture Highlights

### Offline-First Design
- Local SQLite caching
- Optimistic updates
- Background synchronization
- Conflict resolution

### Security Features
- Row Level Security (RLS) in Supabase
- Encrypted local storage
- JWT token management
- Data validation and sanitization

### AI Integration
- Context-aware workout generation
- User preference learning
- Equipment and time constraints
- Progressive difficulty adjustment

### Performance Optimizations
- Lazy loading
- Efficient state management
- Minimal rebuilds
- Connection pooling

## Contributing

1. Choose an agent to work with based on your task
2. Use the agent's guidelines and patterns
3. Follow the established project structure
4. Write tests for new features
5. Update documentation as needed

## License

MIT License - see LICENSE file for details

## Support

For questions or issues:
- Check the documentation in `docs/`
- Review troubleshooting guides
- Use the appropriate development agent for guidance
