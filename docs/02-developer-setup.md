# Developer Setup Guide

This guide will walk you through setting up your development environment for the Fitness App. By the end, you'll have a fully functional development setup and understand how to run, test, and debug the application.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Flutter Environment Setup](#flutter-environment-setup)
3. [Project Setup](#project-setup)
4. [Database Setup](#database-setup)
5. [IDE Configuration](#ide-configuration)
6. [Running the App](#running-the-app)
7. [Development Workflow](#development-workflow)
8. [Troubleshooting](#troubleshooting)

## Prerequisites

### System Requirements

**Minimum Requirements:**
- **RAM**: 8GB (16GB recommended for smooth development)
- **Storage**: 10GB free space for Flutter SDK and tools
- **OS**: macOS 10.14+, Windows 10+, or Ubuntu 18.04+

**Required Software:**
- **Git**: Version control (install from [git-scm.com](https://git-scm.com/))
- **Flutter SDK**: Version 3.8.1 or higher
- **Dart SDK**: Comes bundled with Flutter
- **IDE**: VS Code (recommended) or Android Studio

### Platform-Specific Requirements

**For iOS Development (macOS only):**
- Xcode 14.0+ (install from Mac App Store)
- iOS Simulator (comes with Xcode)
- CocoaPods: `sudo gem install cocoapods`

**For Android Development:**
- Android Studio (or just Android SDK)
- Java Development Kit (JDK) 11 or higher
- Android SDK (API level 31+)
- Android Virtual Device (AVD) or physical Android device

**For Web Development:**
- Modern web browser (Chrome recommended for debugging)

**For Desktop Development:**
- **Windows**: Visual Studio 2022 with C++ development tools
- **macOS**: Xcode command line tools
- **Linux**: build-essential package (`sudo apt-get install build-essential`)

## Flutter Environment Setup

### 1. Install Flutter

**Option A: Using Flutter Version Manager (Recommended)**
```bash
# Install fvm (Flutter Version Manager)
dart pub global activate fvm

# Install and use Flutter 3.8.1
fvm install 3.8.1
fvm use 3.8.1 --force
```

**Option B: Direct Installation**

**macOS/Linux:**
```bash
# Download Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Add to your shell profile (.bashrc, .zshrc, etc.)
echo 'export PATH="$PATH:/path/to/flutter/bin"' >> ~/.bashrc
```

**Windows:**
1. Download Flutter SDK from [flutter.dev](https://flutter.dev/)
2. Extract to `C:\flutter`
3. Add `C:\flutter\bin` to your PATH environment variable

### 2. Verify Flutter Installation

```bash
# Check Flutter installation
flutter --version

# Run Flutter doctor to identify any issues
flutter doctor

# Install any missing dependencies
flutter doctor --android-licenses  # Accept Android licenses
```

**Expected Output:**
```
Flutter 3.8.1 • channel stable
Framework • revision afb9ece1b4 (3 months ago) • 2023-02-13 19:12:56 -0800
Engine • revision a9d88a6d38
Tools • Dart 3.0.1 • DevTools 2.20.1
```

### 3. Configure Platform Support

**Enable required platforms:**
```bash
# Enable web support
flutter config --enable-web

# Enable desktop support (optional)
flutter config --enable-windows-desktop  # Windows
flutter config --enable-macos-desktop    # macOS  
flutter config --enable-linux-desktop    # Linux
```

## Project Setup

### 1. Clone the Repository

```bash
# Clone the project
git clone <repository-url> fitness-app-flutter
cd fitness-app-flutter

# Check out the main branch
git checkout main
```

### 2. Install Dependencies

```bash
# Install Flutter dependencies
flutter pub get

# Generate code (Freezed models, etc.)
flutter packages pub run build_runner build
```

**What this does:**
- Downloads all package dependencies listed in `pubspec.yaml`
- Generates code for Freezed data models (`*.freezed.dart` files)
- Generates JSON serialization code (`*.g.dart` files)

### 3. Verify Project Structure

Your project should look like this:
```
fitness-app-flutter/
├── lib/
│   ├── main.dart              # App entry point
│   ├── app.dart               # Main app widget
│   ├── core/                  # Core configuration
│   ├── features/              # Feature modules
│   └── shared/                # Shared code
├── assets/                    # Images, animations, etc.
├── test/                      # Unit tests
├── integration_test/          # Integration tests
├── pubspec.yaml              # Dependencies & configuration
└── docs/                     # This documentation!
```

## Database Setup

Our app uses SQLite for local storage, which requires no additional setup! The database is automatically created when you first run the app.

### Understanding the Database

**What happens on first run:**
1. App checks if `fitness_app.db` exists
2. If not, creates new database with our schema
3. Loads seed data (exercises, equipment, categories)
4. Database is ready for use!

**Database Location:**
- **Mobile**: App's private documents directory
- **Desktop**: `~/Documents/fitness_app.db` (or OS equivalent)
- **Web**: Browser's IndexedDB storage

### Viewing Database Contents (Optional)

If you want to inspect the database during development:

**Desktop/Mobile:**
```bash
# Install sqlite3 command line tool
# macOS: brew install sqlite3
# Ubuntu: sudo apt-get install sqlite3
# Windows: Download from sqlite.org

# Open database (after running app once)
sqlite3 ~/Documents/fitness_app.db

# Some useful commands:
.tables                    # List all tables
.schema exercises         # Show table structure
SELECT * FROM exercises LIMIT 5;  # View sample data
```

**Web:**
Use browser Developer Tools:
1. Open app in Chrome
2. Press F12 → Application tab → Storage → IndexedDB
3. Browse `fitness_app.db` contents

## IDE Configuration

### VS Code (Recommended)

**Required Extensions:**
```bash
# Install VS Code extensions
code --install-extension Dart-Code.dart-code
code --install-extension Dart-Code.flutter
code --install-extension bradlc.vscode-tailwindcss  # For CSS hints
```

**Recommended Extensions:**
```bash
code --install-extension usernamehw.errorlens       # Inline error display
code --install-extension aaron-bond.better-comments  # Better comment highlighting
code --install-extension MS-CEINTL.vscode-language-pack-es  # If you prefer Spanish
```

**VS Code Settings (`.vscode/settings.json`):**
```json
{
  "dart.debugExternalLibraries": false,
  "dart.debugSdkLibraries": false,
  "dart.flutterHotReloadOnSave": "allIfDirty",
  "dart.openDevTools": "flutter",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  },
  "files.associations": {
    "*.freezed.dart": "dart",
    "*.g.dart": "dart"
  }
}
```

### Android Studio (Alternative)

1. Install Android Studio
2. Install Flutter and Dart plugins
3. Open project and let Android Studio configure everything

## Running the App

### 1. Start Debug Mode

**VS Code:**
1. Press `F5` or go to Run → Start Debugging
2. Select target device from status bar
3. App will build and launch

**Command Line:**
```bash
# See available devices
flutter devices

# Run on specific device
flutter run -d chrome          # Web
flutter run -d macos           # macOS desktop  
flutter run -d android         # Android emulator/device
flutter run -d ios             # iOS simulator (macOS only)

# Hot reload during development
# Press 'r' to hot reload
# Press 'R' to hot restart
# Press 'q' to quit
```

### 2. First Run Experience

**What you'll see:**
1. **Splash Screen**: App initialization
2. **Home Screen**: Main navigation with workouts, exercises, profile tabs
3. **Sample Data**: Pre-loaded exercises and equipment from our seed data

**If you see errors:**
- Check the debug console for error messages
- Most common issues are missing dependencies or platform setup

### 3. Development Features

**Debug Menu Access:**
- Tap the debug icon in the app bar (development builds only)
- Access database debug screen to inspect data
- View demo data for UI development

**Hot Reload:**
- Make changes to Dart code
- Save the file
- See changes instantly without losing app state

## Development Workflow

### Daily Development Process

**1. Start Your Day:**
```bash
# Update to latest code
git pull origin main

# Install any new dependencies
flutter pub get

# Regenerate code if models changed
flutter packages pub run build_runner build --delete-conflicting-outputs
```

**2. Make Changes:**
```bash
# Create feature branch
git checkout -b feature/new-exercise-form

# Make your changes
# Use hot reload to see changes instantly

# Run tests
flutter test

# Format code
flutter format .
```

**3. End Your Day:**
```bash
# Run comprehensive checks
flutter analyze          # Static analysis
flutter test            # Unit tests
flutter build web       # Ensure it builds

# Commit your work
git add .
git commit -m "feat: add new exercise form validation"
git push origin feature/new-exercise-form
```

### Code Generation Workflow

Our app uses code generation for data models. When you modify model files:

```bash
# Watch for changes and regenerate automatically
flutter packages pub run build_runner watch

# Or generate once after changes
flutter packages pub run build_runner build --delete-conflicting-outputs
```

**When to regenerate:**
- After modifying any `@freezed` model classes
- After adding new JSON serialization annotations
- When you see "undefined method" errors for generated code

### Testing Workflow

```bash
# Run all unit tests
flutter test

# Run specific test file
flutter test test/repositories/exercise_repository_test.dart

# Run tests with coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html  # Generate HTML report

# Run integration tests
flutter test integration_test/
```

## Troubleshooting

### Common Issues & Solutions

**❌ "Flutter command not found"**
```bash
# Add Flutter to PATH
export PATH="$PATH:/path/to/flutter/bin"

# Or use fvm
fvm flutter --version
```

**❌ "Pub get failed"**
```bash
# Clear pub cache and retry
flutter clean
flutter pub cache repair
flutter pub get
```

**❌ "Build runner fails"**
```bash
# Delete conflicting generated files
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs
```

**❌ "Database not found" or "Table doesn't exist"**
```bash
# Delete existing database to recreate with latest schema
# Location varies by platform - check app documents directory
rm ~/Documents/fitness_app.db  # macOS/Linux
# Then restart app
```

**❌ "Hot reload not working"**
```bash
# Restart the app
# Press 'R' in terminal or restart debug session in VS Code
```

**❌ "iOS build fails"**
```bash
# Clean iOS build files
cd ios
rm -rf Pods/
rm Podfile.lock
pod install
cd ..
flutter clean
flutter run
```

**❌ "Android build fails"**
```bash
# Clean Android build
cd android
./gradlew clean
cd ..
flutter clean
flutter run
```

### Platform-Specific Issues

**Web:**
- CORS issues: Run with `flutter run -d chrome --web-renderer html`
- SQLite issues: Web uses different SQLite implementation (sql.js)

**Desktop:**
- SQLite FFI issues: Install system SQLite libraries
- Window doesn't appear: Check if app is hidden behind other windows

**Mobile:**
- Emulator issues: Wipe emulator data and restart
- Device not detected: Enable USB debugging (Android) or trust computer (iOS)

### Performance Issues

**Slow compilation:**
```bash
# Use development build
flutter run --debug

# Skip unnecessary platforms
flutter config --no-enable-windows-desktop
flutter config --no-enable-macos-desktop
flutter config --no-enable-linux-desktop
```

**Large app size:**
```bash
# Analyze bundle size
flutter build apk --analyze-size
flutter build web --analyze-size
```

## Getting Help

### Documentation Resources
- [Flutter Docs](https://flutter.dev/docs) - Official Flutter documentation
- [Dart Language Tour](https://dart.dev/guides/language/language-tour) - Learn Dart syntax
- [Riverpod Docs](https://riverpod.dev/) - State management documentation

### Community Support
- [Flutter Community Discord](https://discord.gg/flutter)
- [r/FlutterDev](https://reddit.com/r/FlutterDev) - Reddit community
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter) - Q&A platform

### Project-Specific Help
- Check our [FAQ](./99-faq.md) for common questions
- Look at existing code examples in the `lib/` directory
- Use the debug screens in the app to inspect data

## Next Steps

Now that your environment is set up:

1. **Explore the App**: Run it and click around to understand the current features
2. **Study the Code**: Start with [Code Architecture](./03-code-architecture.md) to understand the project structure
3. **Make Your First Change**: Try modifying an existing screen or adding a simple feature
4. **Read the Database Docs**: Understanding our [Database Architecture](./04-database-architecture.md) is crucial

**Ready to start coding?** Continue to [Code Architecture](./03-code-architecture.md) to understand how the project is organized.

---

**Questions?** If you run into issues not covered here, please:
1. Check the [FAQ](./99-faq.md)
2. Search existing issues in the project repository
3. Ask for help in the team chat or create a new issue