# ArvyaX Serenity

A beautiful, production-quality Flutter prototype app focused on providing a calm and immersive wellness experience. 

## Features

- **Ambience Library**: Browse through multiple curated soundscapes categorized by tags (Focus, Calm, Sleep, Reset).
- **Session Player**: Listen to looping ambient audio with custom breathing gradient animations for a meditative visual experience.
- **Mini Player Overlay**: The active session minimizes into a persistent global player when navigating back to the library or journal history.
- **Reflection Journaling**: Prompts a seamless mindfulness journal "What is gently present with you right now?" after every session.
- **Journal History**: Saved post-session journal entries and moods are persisted locally and viewable historically.
- **Calm Theming**: Both Light and Dark themes, structured around accessibility, soft contrast gradients, and rounded Apple-like aesthetics.

## Architecture

This project is built using **Clean Architecture** principles and modular feature folders:
- **`lib/data`**: Contains definitions and local data sources (e.g., Hive local DB and JSON loading).
  - Models (`Ambience`, `JournalEntry`)
  - Repositories (`AmbienceRepository`, `JournalRepository`)
- **`lib/features`**: The core screens and functionalities, grouped by feature:
  - `ambience`: Ambience library UI and detail screens.
  - `player`: `just_audio` playback screen, visual animations, and mini-player.
  - `journal`: Reflective text field screens and historical views.
- **`lib/shared`**: Reusable global configurations:
  - `theme`: Colors, `AppTheme` definitions (dark/light themes).
  - `widgets`: Shared structural widgets like the `BreathingBackground`.

## State Management

ArvyaX Serenity extensively uses **Riverpod** (`flutter_riverpod`) for reactive state management.
- **FutureProviders** asynchronously load Hive boxes and JSON configs.
- **NotifierProviders** maintain the active UI state globally (active tags, active sessions).

## Data Persistence

- **Hive**: Used to cleanly serialize and locally persist `JournalEntry` histories.
- **JSON Assets**: Ambience recipes and metadata are simulated as a network payload by reading from local `.json` configurations.

## Getting Started

1. Ensure you have the [Flutter SDK](https://flutter.dev/docs/get-started/install) installed (`^3.11.0`).
2. Clone this repository.
3. Run `flutter pub get`
4. Run `flutter run` on iOS, Android, macOS, or Windows platforms.

## Release

To compile the Android APK for production, run:
```bash
flutter build apk --release
```

The compiled APK file is available at: `build/app/outputs/flutter-apk/app-release.apk`

📥 **[Download Latest APK Release](build/app/outputs/flutter-apk/app-release.apk)**

*(Note: Audio tracks and images referenced in `assets/data/ambiences.json` are placeholders for the prototype.)*
