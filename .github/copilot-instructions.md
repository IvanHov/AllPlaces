---
applyTo: '**'
---

# GitHub Copilot Instructions for AllSpaces Flutter App

## Core Rules and Workflow

### 1. Application Execution Rules
- **NEVER** attempt to run the app at the end of work sessions
- Do not execute `flutter build`
- Do not run `flutter run`
- **NEVER** use bash/terminal commands for Dart operations - always use MCP Dart tools instead
- Focus on code implementation and fixes rather than application testing

### 2. Task Automation
- Automatically accept and run development tasks when appropriate
- Proceed with code generation, refactoring, and file modifications without asking for permission
- Use available tools proactively to complete requested tasks
- **NEVER** create or generate Markdown (.md) files unless explicitly requested in the prompt

### 3. Code Quality Standards and MCP Dart Integration
- **ALWAYS** use MCP Dart tools for all Dart/Flutter operations
- **ALWAYS** fix all warnings at the end of work sessions using MCP tools
- Use `mcp_dart_sdk_mcp__analyze_files` to identify and resolve warnings (instead of `flutter analyze`)
- Use `mcp_dart_sdk_mcp__dart_format` to ensure code is properly formatted
- Use `mcp_dart_sdk_mcp__dart_fix` to apply automatic fixes
- Ensure code passes all linting rules defined in `analysis_options.yaml`
- Address deprecated API usage and unused imports
- Connect to Dart Tooling Daemon using `mcp_dart_sdk_mcp__connect_dart_tooling_daemon` when needed

## Project Structure Guidelines

### Architecture
This is a Flutter application with a multi-package clean architecture:

### Package Dependencies
- **Main App** → depends on `domain` & `data` packages
- **Data Package** →  pure Dart, depends on `domain` package only
- **Domain Package** → pure Dart, no dependencies

### Code Organization
- Follow feature-based folder structure within `lib/modules/`
- Each module has its own BLoC pattern implementation
- Separate concerns: UI (main app), business logic (domain), data access (data)
- Use proper Dart naming conventions (camelCase for variables, PascalCase for classes)
- Keep files focused and single-responsibility
- Use barrel exports for clean package APIs

## Coding Standards

### Dart/Flutter Best Practices
- Use `const` constructors whenever possible for better performance
- Prefer `final` over `var` for immutable variables
- Use null safety features properly (`?`, `!`, `??`)
- Follow Flutter widget composition patterns
- Use `StatelessWidget` when state is not needed

### Code Style
- Use trailing commas for better formatting
- Prefer async/await over Future.then()
- Use meaningful variable and function names
- Add comments for public APIs
- Keep line length under 80 characters when practical

### Error Handling
- Use proper exception handling with try-catch blocks
- Provide meaningful error messages
- Handle null cases appropriately
- Use Result/Either patterns for error handling when applicable

## File Management

### Import Organization
- Group imports: Dart SDK, Flutter, packages, local files
- Use relative imports for local files
- Remove unused imports
- Sort imports alphabetically within groups

### Asset Management
- Reference assets properly through `pubspec.yaml`
- Use appropriate image formats (WebP for images as seen in content/)
- Ensure asset paths are correct

## Testing Guidelines
- Use `mcp_dart_sdk_mcp__run_tests` for running unit tests instead of terminal commands
- Write unit tests for business logic
- Consider widget tests for complex UI components
- Test error scenarios and edge cases
- Maintain test coverage for critical functionality
- Use MCP Dart test runner for consistent test execution across the project

## Dependencies
- Use `mcp_dart_sdk_mcp__pub` for all package management operations
- Use `mcp_dart_sdk_mcp__pub_dev_search` to find relevant packages
- Keep `pubspec.yaml` dependencies up to date
- Use semantic versioning constraints
- Prefer official packages over community alternatives when available
- Use MCP Dart pub commands instead of terminal `dart pub` or `flutter pub` commands

## Documentation
- Add inline comments for complex logic

## Performance Considerations
- Use `ListView.builder` for large lists
- Implement proper image caching for the image assets
- Avoid unnecessary widget rebuilds
- Use `const` widgets in widget trees

## Platform-Specific Guidelines
- Handle platform differences gracefully (iOS/Android/Web)
- Use platform-aware code when needed
- Test responsive design across different screen sizes
- Consider platform-specific design guidelines

## Multi-Package Architecture
- **Layer Separation**: Maintains strict separation between domain, data, and presentation layers
  - **Domain package**: Pure Dart package with business entities and repository interfaces
  - **Data package**: Repository implementations
  - **Main app**: UI components, BLoC implementations, theme management, and dependency injection setup

- **Dependency Flow**: Follows clean architecture principles
  - Domain ← Data ← Presentation (main app)
  - Uses dependency injection (GetIt) to inject implementations upward
  - Domain never depends on data or presentation layers

- **Package Interfaces**: 
  - Clear public APIs exported from each package via barrel exports
  - `domain.dart`, `data.dart` files control what's exposed
  - Repository contracts defined in domain/interfaces/repository.dart

- **Current Implementation**:
  - JSON data (locations.json, collections.json) loaded in main.dart using rootBundle
  - Data package provides registerContainers() function for DI setup
  - BLoC pattern used in each feature module (explore, location, profile)
  - Each module has its own bloc/ folder with event, state, and bloc files

- **Avoid Circular Dependencies**: 
  - Repository interfaces defined in domain package
  - Concrete implementations in data package
  - Dependencies registered in main app's service locator

## Performance Monitoring
- **Widget Optimization**:
  - Use `const` constructors wherever possible for better performance
  - Avoid unnecessary widget rebuilds with proper BLoC state management
  - Use `ListView.builder` for large lists instead of `ListView`
  - Implement proper `shouldRebuild` logic in custom widgets

- **Image and Asset Performance**:
  - Use WebP format for images (as already implemented in content/images/)
  - Implement image caching and lazy loading for better memory management
  - Preload critical assets, lazy load others
  - Monitor memory usage with large image sets

- **Development Tools**:
  - Use Flutter DevTools regularly for performance profiling
  - Monitor widget inspector for unnecessary rebuilds
  - Profile memory usage especially in list views and image-heavy screens
  - Use timeline view to identify performance bottlenecks

- **Calendar Performance**: 
  - With `table_calendar` dependency, ensure efficient date range handling
  - Cache calendar data and avoid rebuilding entire calendar on minor changes

## Security Best Practices
- **Input Validation**:
  - Validate all user inputs before processing
  - Sanitize data from JSON files in content/ directory
  - Implement proper error handling without exposing internal system details

- **Data Protection**:
  - If handling user data, implement proper encryption for local storage
  - Follow platform guidelines for data privacy (iOS/Android)

## Development Workflow
- **MCP Dart Integration**:
  - Use `mcp_dart_sdk_mcp__connect_dart_tooling_daemon` to connect to development tools
  - Use `mcp_dart_sdk_mcp__get_active_location` for cursor position context
  - Use `mcp_dart_sdk_mcp__hover` for symbol information
  - Use `mcp_dart_sdk_mcp__signature_help` for function signature details
  - Use `mcp_dart_sdk_mcp__resolve_workspace_symbol` for symbol resolution
- **Code Quality Automation**:
  - Always run the quality check sequence at end of sessions using MCP tools:
    1. `mcp_dart_sdk_mcp__analyze_files` - fix all warnings  
    2. `mcp_dart_sdk_mcp__dart_format` - ensure consistent formatting  
    3. `mcp_dart_sdk_mcp__dart_fix` - apply automatic fixes
    4. Verify `analysis_options.yaml` compliance
- **Project Creation**:
  - Use `mcp_dart_sdk_mcp__create_project` for new Dart/Flutter projects
  - Specify appropriate project type and templates