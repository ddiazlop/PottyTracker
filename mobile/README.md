# PottyTracker Mobile

A Flutter mobile app for tracking dog potty events. This app works with the PottyTracker Phoenix backend API.

## Features

- View all walk events in a clean list
- Add new walk events with pee/poop counts and duration
- Edit existing walk events
- Delete walk events
- View statistics dashboard
- Pull-to-refresh functionality

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Running PottyTracker backend API

### Installation

1. Navigate to the mobile directory:
   ```bash
   cd mobile
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Update the API base URL in `lib/services/api_service.dart` if needed:
   ```dart
   static const String baseUrl = 'http://your-backend-url:4000';
   ```

### Running the App

For Android:
```bash
flutter run
```

For iOS (macOS only):
```bash
flutter run
```

### Building for Production

For Android APK:
```bash
flutter build apk
```

For iOS (macOS only):
```bash
flutter build ios
```

## Architecture

The app follows a clean architecture pattern:

- **Models**: Data structures (WalkEvent)
- **Services**: API communication (ApiService)
- **Providers**: State management (WalkEventProvider)
- **Screens**: UI screens (HomeScreen)
- **Widgets**: Reusable UI components

## API Integration

The app communicates with the Phoenix backend through REST API endpoints:

- `GET /api/walk_events` - Fetch all walk events
- `POST /api/walk_events` - Create new walk event
- `PUT /api/walk_events/:id` - Update walk event
- `DELETE /api/walk_events/:id` - Delete walk event
- `GET /api/walk_events/stats` - Get statistics

## Dependencies

- `http`: For API calls
- `provider`: State management
- `intl`: Date/time formatting
- `shared_preferences`: Local storage (future use)

## Contributing

1. Follow Flutter best practices
2. Use Provider for state management
3. Keep widgets small and focused
4. Test on both Android and iOS

## License

This project is licensed under the MIT License.