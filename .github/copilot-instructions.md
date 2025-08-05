# Copilot Instructions for Notas App

<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

## Project Context

This is a Flutter notes application with calendar integration using Clean Architecture and BLoC pattern.

## Architecture Guidelines

- Follow Clean Architecture principles (Domain, Data, Presentation layers)
- Use BLoC pattern for state management
- Implement Repository pattern for data access
- Use dependency injection with GetIt
- Follow SOLID principles

## Code Style

- Use meaningful variable and function names in English
- Add comprehensive documentation for complex functions
- Follow Flutter/Dart conventions
- Use immutable classes where possible
- Implement proper error handling

## Key Features to Implement

- Rich text editing for notes
- Calendar integration with color tags
- Local and push notifications
- Task management with checkboxes
- Home screen widgets
- Data persistence with Hive/SQLite

## Testing Strategy

- Unit tests for business logic
- Widget tests for UI components
- Integration tests for user flows
- Mock external dependencies
