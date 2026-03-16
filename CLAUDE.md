# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AllPlaces is a Flutter application for exploring nature locations in Uzbekistan. It follows a multi-package clean architecture pattern with separate `domain`, `data`, and presentation layers.

## Development Commands

### Code Quality (Required)
Always run these MCP Dart commands at the end of work sessions:
- `mcp_dart_sdk_mcp__analyze_files` - identify and resolve warnings
- `mcp_dart_sdk_mcp__dart_format` - ensure proper code formatting  
- `mcp_dart_sdk_mcp__dart_fix` - apply automatic fixes

### Package Management
- `mcp_dart_sdk_mcp__pub` - for all package operations (get, deps, etc.)
- `mcp_dart_sdk_mcp__pub_dev_search` - search for packages

### Testing
- `mcp_dart_sdk_mcp__run_tests` - run unit tests (do not use terminal commands)

### Development Tools
- `mcp_dart_sdk_mcp__connect_dart_tooling_daemon` - connect to Dart tooling
- `mcp_dart_sdk_mcp__get_active_location` - get cursor position context
- `mcp_dart_sdk_mcp__hover` - symbol information
- `mcp_dart_sdk_mcp__signature_help` - function signatures

### Prohibited Commands
- **NEVER** run `flutter run` or `flutter build`
- **NEVER** use terminal commands for Dart operations - use MCP tools instead

## Architecture

### Multi-Package Structure
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

### Package Interfaces
- `domain/lib/domain.dart` - exports all domain entities, interfaces, and use cases
- `data/lib/data.dart` - exports repository implementations and registers dependencies
- Each package uses barrel exports for clean APIs

### Dependency Injection
- Uses GetIt service locator pattern
- Data layer registers all repositories and use cases in `data.dart`
- Main app initializes data layer in `main.dart` using `data.register()`

## Code Organization

### Main App Structure
- `lib/common/` - shared utilities, theme, routing, widgets
- `lib/modules/` - feature-based modules with BLoC pattern
- `lib/generated/` - auto-generated internationalization files

### Module Pattern
Each module follows this structure:
```
lib/modules/[feature]/
├── [feature]_page.dart     # Main page widget
├── bloc/                   # BLoC state management
│   ├── [feature]_bloc.dart
│   ├── [feature]_event.dart
│   └── [feature]_state.dart
└── widgets/                # Feature-specific widgets
```

### Available Modules
- `auth` - Authentication with phone/OTP
- `explore` - Location discovery and browsing
- `location` - Individual location details
- `gallery` - Image galleries
- `search` - Location search functionality
- `map` - Map visualization
- `profile` - User profile management
- `saved_locations` - Bookmarked locations

## Data Layer

### JSON Data Sources
- `assets/locations.json` - location data loaded in main.dart
- `assets/collections.json` - collection data loaded in main.dart

### External Services
- Appwrite backend integration (endpoint configured in main.dart)
- Image caching with `cached_network_image`

### Repository Pattern
- Interfaces defined in `domain/interfaces/`
- Implementations in `data/repositories/`
- All repositories use async initialization pattern

## Key Dependencies

### State Management
- `flutter_bloc` - BLoC pattern implementation
- `equatable` - value equality for BLoC states/events

### Navigation & UI
- `go_router` - declarative routing
- `flutter_platform_widgets` - platform-aware widgets
- `modal_bottom_sheet` - modal presentations

### Map & Location
- `flutter_map` - map visualization
- `latlong2` - coordinate handling
- `gpx` - GPS track file support

### Utilities
- `get_it` - dependency injection
- `table_calendar` - calendar widgets
- `package_info_plus` - app metadata

## Code Quality Standards

### Linting Rules (analysis_options.yaml)
- `prefer_single_quotes: true`
- `prefer_const_constructors: true`
- `prefer_final_locals: true`
- `prefer_relative_imports: true`
- Generated files excluded from analysis

### Coding Conventions
- Use `const` constructors for performance
- Prefer `final` over `var`
- Use trailing commas for formatting
- Keep line length under 80 characters when practical
- Follow feature-based folder organization

### Import Organization
1. Dart SDK imports
2. Flutter imports  
3. Package imports
4. Local relative imports

## Internationalization

- Uses `flutter_intl` with generated localization files
- Supported locales: English (en), Russian (ru), Uzbek (uz)
- Localization files in `lib/l10n/`
- Generated files in `lib/generated/l10n/`

## Testing

- Unit tests located in `domain/test/`
- Use MCP Dart tools for test execution
- Focus on domain logic and repository implementations

## Asset Management

- Images in `assets/icons/` and content directories use WebP format
- GPS tracks in `assets/tracks/`
- Proper asset declarations in `pubspec.yaml`
- Image caching configured in `common/utils/image_cache_config.dart`