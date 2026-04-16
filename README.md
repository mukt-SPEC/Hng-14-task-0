# Quattro (unitcoverter)

Quattro is a Flutter productivity app that combines:
- a smart unit converter,
- a local to-do manager,
- and a lightweight daily overview screen.

The app is built with Riverpod for state management, Hive for local persistence, and `quantify` for conversion logic.

## Features

### 1) Home Dashboard
- Displays a daily productivity summary from your to-do list.
- Highlights whether you have no tasks, all tasks done, or pending tasks.
- Shows completion progress for tasks due today.
- Includes quick dark/light theme toggle.

### 2) Todo Manager
- Add, edit, and delete tasks.
- Optional note field for each task.
- Mark tasks as completed.
- Auto-groups tasks into:
  - Overdue
  - Today
  - Later
- Persists tasks locally using Hive (`todos` box), so data remains after app restarts.

### 3) Unit Converter
- Two-way conversion (type in top or bottom input).
- Category-based converter with selectable units.
- Real-time conversion powered by `quantify`.
- Supported categories currently wired into the UI:
  - Length
  - Time
  - Weight
  - Temperature
  - Volume

### 4) Theming
- Light, dark, and system theme support.
- Shared color + typography system for consistent UI.

## Tech Stack

- Flutter (Material UI)
- Dart
- Riverpod (`Notifier`, `StateNotifier`, `Provider`)
- Hive + Hive Flutter (local database)
- Quantify (unit conversion engine)
- Intl (date formatting)
- Phosphor Flutter (icons)
- Google Fonts (Geist + Geist Mono)

## How It Is Structured

The codebase is organized by responsibility:

- `lib/presentation/`:
  UI pages and reusable widgets (`home_page.dart`, `todo_page.dart`, `unit_converter_page.dart`)
- `lib/provider/`:
  Riverpod providers and state wiring
- `lib/notifiers/`:
  Stateful business logic (`TodoNotifier`)
- `lib/service/`:
  Data access layer (`TodoDB`)
- `lib/Model/`:
  Domain models (`TodoModel`, `UnitModel`, `UnitCategory`)
- `lib/Core/`:
  Unit category enums and lists
- `lib/theme/`:
  App colors and typography
- `lib/utils/`:
  Small helper extensions

## Getting Started

### Prerequisites

- Flutter SDK (project is configured for Dart SDK `^3.9.2`)
- A connected device or emulator (Android/iOS/web/desktop)

### Install Dependencies

```bash
flutter pub get
```

### Run the App

```bash
flutter run
```

Useful target examples:

```bash
flutter run -d chrome
flutter run -d windows
```

## Development Commands

Run static analysis:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

Format code:

```bash
dart format lib test
```

Regenerate Hive adapters after model changes:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Data and State Notes

- Todo items are stored locally in Hive and loaded at app startup.
- Converter state is in-memory and responds to category/unit/value changes.
- Theme selection is managed by Riverpod during runtime.

## Future Improvements (Optional)

- Persist selected theme mode across launches.
- Add search/filtering for todo items.
- Add remaining conversion categories already defined in the enum (energy, frequency, power, pressure, speed).
- Increase test coverage for providers and notifier logic.
