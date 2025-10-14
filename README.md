# Vocabricks — Minimal, Ad‑Free Vocabulary Builder

Vocabricks is a simple, free vocabulary trainer built by an independent developer while learning a language. After trying a number of Play Store apps that were either too complex, too pricey, or full of ads, it was decided to build a minimal, clean, and maintainable app to learn efficiently — with no ads and no paywalls.

This project also serves as a practice ground to refine programming skills and design a small, well‑structured, multi‑platform Flutter application that’s easy to maintain and extend.

## Project Goals

- Keep the experience simple and fast.
- Stay free.
- Keep the code maintainable and approachable for learning and extension.

## Features

- Email/password sign‑in (Firebase Authentication).
- Cloud sync of your deck (Firebase Realtime Database).
- Add, edit, and review vocabulary cards: word, translation, and example context.
- Straightforward review flow with two buttons: “Remember” and “Don’t remember”.

Planned/TODO:

- [ ] Offline caching and better error handling.
- [ ] Export/import deck data.
- [ ] Additional review algorithms (e.g., SM‑2 variants, statistical, machine learning etc) and settings.
- [ ] Possibility to have several decks
- [ ] Logging

The codebase is intentionally small and attempted to be organized for clarity and maintainability.

## Platform Support and Requirements

- Flutter/Dart
  - Dart SDK: `>=3.5.2` (from `pubspec.yaml`)
  - Tested on Flutter stable corresponding to this Dart line; any recent stable Flutter with Dart 3.5.x should work.

- Android
  - minSdk: Flutter plugin default (commonly 21+). Some Firebase plugins may require a higher minSdk; if you see build errors, set `minSdk` accordingly in `android/app/build.gradle`.
  - targetSdk / compileSdk: aligned with your installed Flutter SDK (currently typical is 34).
  - Toolchain: Android Gradle Plugin 8.6, Java/Kotlin set to 17 in this project.

- iOS
  - Minimum iOS: 12.0 (see `ios/Flutter/AppFrameworkInfo.plist`).

- Web
  - Modern evergreen browsers (Chrome, Firefox, Edge, Safari). Firebase is configured for Web in `firebase_options.dart` and `web/manifest.json`.

- Desktop (macOS, Windows, Linux)
  - Scaffolding is present, but Firebase is not configured for these platforms in `firebase_options.dart`. Not officially supported yet.

## Tech Stack

- Flutter with Material design
- Provider for state management
- Firebase Core, Authentication (email/password), Realtime Database

## Getting Started

Prerequisites:

- Flutter (stable channel) and Dart 3.5.2+
- Android Studio/Xcode as needed for mobile targets
- A Firebase project (already configured in this repo). If you fork or create a new project, run FlutterFire to regenerate configs.

Install and run:

```bash
flutter pub get

# Run on a device/emulator of your choice
flutter run

# Or explicitly choose a target, e.g. Web
flutter run -d chrome
```

## Usage

1. Sign in with email/password (no third‑party providers).
2. Add your vocabulary: word, translation, and an optional example in context.
3. Review cards; tap to toggle word/translation, then choose “Remember” or “Don’t remember”.

## Contributing

Feedback and suggestions are very welcome. If you spot a bug or want to propose an improvement, feel free to open an issue or a PR.