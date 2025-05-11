# Mini Service Booking App

![App Preview](assets/videos/app.gif)

## Project Overview
A Flutter app for managing service bookings with full CRUD functionality, built using Clean Architecture and GetX for state management.

## Features
- View list of services
- Add/edit/delete services
- Search and filter services
- Offline support with Hive
- Multi-language support (English/Spanish)
- Clean UI with dark/light theme

## Setup Instructions
1. Clone the repository
2. Run `flutter pub get`
3. Run `flutter packages pub run build_runner build`
4. Start the app with `flutter run`

## Implemented Features
### Core Features
- Full CRUD operations for services
- GetX state management and routing
- Clean Architecture separation
- REST API consumption
- Form validation

### Bonus Features
- Local persistence with Hive
- Search and filter functionality
- Multi-language support
- Theme switching

## Folder Structure
- `core/`: App-wide constants, themes, and utilities
- `data/`: Data sources, models, and repository implementations
- `domain/`: Business logic, entities, and use cases
- `presentation/`: UI components, controllers, and bindings

## Dependencies
- flutter: SDK
- get: ^4.6.5
- dio: ^5.3.0
- hive: ^2.2.3
- connectivity_plus: ^3.0.3