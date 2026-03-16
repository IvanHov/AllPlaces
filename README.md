# AllPlaces

A Flutter application for exploring nature locations in Uzbekistan, built with clean architecture and multi-package structure.

## Architecture

AllPlaces follows a multi-package clean architecture pattern with clear separation of concerns:

```
├── lib/                    # Main Flutter app (presentation layer)
├── domain/                 # Pure Dart - business entities & interfaces  
└── data/                   # Pure Dart - repository implementations
```

### Dependency Flow
- **Domain** ← **Data** ← **Presentation (main app)**
- Domain package has no dependencies
- Data depends only on domain
- Main app depends on both domain and data

## Features

- **Authentication** - Phone/OTP based authentication
- **Location Discovery** - Browse and explore nature locations
- **Interactive Maps** - Map visualization with location markers
- **Image Galleries** - View location photos and galleries
- **Search** - Find locations by name or criteria
- **Saved Locations** - Bookmark favorite places
- **User Profiles** - Manage user account and preferences
- **Multilingual Support** - English, Russian, and Uzbek languages

## Tech Stack

### Core Framework
- **Flutter** - Cross-platform mobile development
- **Dart** - Programming language

### State Management
- **flutter_bloc** - BLoC pattern implementation
- **equatable** - Value equality for BLoC states/events

### Navigation & UI
- **go_router** - Declarative routing
- **flutter_platform_widgets** - Platform-aware widgets
- **modal_bottom_sheet** - Modal presentations

### Maps & Location
- **flutter_map** - Map visualization
- **latlong2** - Coordinate handling
- **gpx** - GPS track file support

### Backend & Data
- **Appwrite** - Backend services integration
- **cached_network_image** - Image caching

### Development Tools
- **get_it** - Dependency injection
- **flutter_intl** - Internationalization

## Project Structure

### Main App (`lib/`)
```
lib/
├── common/                 # Shared utilities, theme, routing
├── modules/                # Feature-based modules
│   ├── auth/              # Authentication
│   ├── explore/           # Location discovery
│   ├── location/          # Location details
│   ├── gallery/           # Image galleries
│   ├── search/            # Search functionality
│   ├── map/               # Map visualization
│   ├── profile/           # User profiles
│   └── saved_locations/   # Bookmarked locations
├── generated/             # Auto-generated files
└── l10n/                  # Localization files
```

### Domain Layer (`domain/`)
- Pure Dart package with business logic
- Entities, interfaces, and use cases
- No external dependencies

### Data Layer (`data/`)
- Repository implementations
- External service integrations
- Depends only on domain layer

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd flutterapp
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate localization files:
```bash
dart run intl_utils:generate
```

4. Run the app:
```bash
flutter run
```

## Development

### Code Quality Commands
Always run these commands after making changes:

```bash
flutter analyze          # Identify and resolve warnings
dart format .            # Ensure proper code formatting
dart fix --apply         # Apply automatic fixes
```

### Testing
```bash
flutter test
```

## Code Standards

### Linting Rules
- Prefer single quotes
- Use const constructors
- Prefer final locals
- Use relative imports
- Maintain 80-character line length when practical

### Import Organization
1. Dart SDK imports
2. Flutter imports
3. Package imports
4. Local relative imports

### Architecture Patterns
- **BLoC Pattern** - For state management in each module
- **Repository Pattern** - For data access abstraction
- **Dependency Injection** - Using GetIt service locator
- **Feature-based Organization** - Modules organized by functionality

## Internationalization

Supports multiple languages:
- English (en)
- Russian (ru)
- Uzbek (uz)

Localization files are generated automatically using `flutter_intl`.

## Assets

- **Images** - WebP format for optimal performance
- **GPS Tracks** - Located in `assets/tracks/`
- **Location Data** - JSON files in `assets/`