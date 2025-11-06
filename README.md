# Might3 - Top 3 Tasks Manager

A Flutter app with an always-visible transparent widget for macOS desktop, iPhone home screen widget, backed by Supabase and using a Beads-inspired database architecture.

## Features

- ✨ **Transparent macOS Desktop Widget**: Always-on-top transparent window that floats above other apps
- 📱 **iOS Home Screen Widget**: Quick glance at your top 3 tasks from your iPhone home screen
- 🌐 **Supabase Backend**: Cloud sync for your tasks across devices
- 🌳 **Beads-Inspired Database**: Local-first tree-based data structure inspired by Steve Yegge's Beads architecture
- 🎯 **Top 3 Focus**: Keep focused on what matters most - your top 3 priority tasks

## Architecture

### Beads Database Layer
The app uses a simplified implementation of the Beads concept - a tree-based data structure that stores data hierarchically. This provides:
- Local-first operation (works offline)
- Tree-based hierarchical data organization
- Automatic sync with Supabase when online
- Simple last-write-wins conflict resolution

### Tech Stack
- **Frontend**: Flutter (supports macOS, iOS, Android, Web)
- **Desktop Window Management**: window_manager package for transparent overlay
- **Backend**: Supabase for authentication and data sync
- **Local Storage**: SharedPreferences for Beads tree persistence
- **State Management**: Provider pattern

## Setup

### Prerequisites
- Flutter SDK (>= 3.0.0)
- Xcode (for macOS/iOS development)
- Supabase account

### Installation

1. Clone the repository:
```bash
git clone https://github.com/brianretford/might3.git
cd might3
```

2. Install dependencies:
```bash
flutter pub get
```

3. Set up Supabase:
   - Create a new project at [supabase.com](https://supabase.com)
   - Create a table called `beads_data` with columns:
     - `id` (uuid, primary key)
     - `user_id` (text)
     - `tree_data` (jsonb)
     - `updated_at` (timestamp)
   - Set your Supabase URL and anon key as environment variables:

```bash
export SUPABASE_URL="your-project-url"
export SUPABASE_ANON_KEY="your-anon-key"
```

Or pass them at runtime:
```bash
flutter run --dart-define=SUPABASE_URL=your-url --dart-define=SUPABASE_ANON_KEY=your-key
```

### Running the App

#### macOS Desktop Widget
```bash
flutter run -d macos
```

The app will launch as a transparent, always-on-top widget that floats above your other windows.

#### iOS (with Widget Extension)
```bash
flutter run -d ios
```

To add the widget to your home screen:
1. Long press on your home screen
2. Tap the "+" button
3. Search for "Might3"
4. Select the widget size and add it

#### Web
```bash
flutter run -d chrome
```

## Usage

### Adding Tasks
1. Type your task in the input field
2. Press Enter or click the + button
3. Tasks are automatically saved locally and synced to Supabase

### Managing Tasks
- **Complete**: Click the circle icon to mark as complete
- **Delete**: Click the trash icon to remove a task
- **Priority**: The app automatically shows your top 3 tasks based on:
  - Incomplete tasks first
  - Priority level
  - Creation date

### macOS Transparent Widget
- The widget stays on top of all other windows
- Drag it anywhere on your screen
- It's semi-transparent so you can see what's behind it
- Perfect for keeping your top 3 tasks visible while working

### iOS Widget
- Add the widget to your home screen
- It updates every 15 minutes automatically
- Shows your current top 3 tasks
- Tap to open the full app

## Project Structure

```
might3/
├── lib/
│   ├── main.dart                 # App entry point with window setup
│   ├── models/
│   │   ├── task.dart            # Task data model
│   │   └── task.g.dart          # Generated JSON serialization
│   ├── services/
│   │   └── beads_service.dart   # Beads database implementation
│   └── screens/
│       └── home_screen.dart     # Main UI screen
├── macos/
│   └── Runner/
│       ├── AppDelegate.swift    # macOS app delegate with transparency
│       └── MainFlutterWindow.swift
├── ios/
│   └── Might3Widget/
│       └── Might3Widget.swift   # iOS home screen widget
└── pubspec.yaml                  # Dependencies
```

## Development

### Building for Production

**macOS**:
```bash
flutter build macos --release
```

**iOS**:
```bash
flutter build ios --release
```

### Testing
```bash
flutter test
```

## About Beads

This project is inspired by Steve Yegge's Beads architecture, which proposes:
- Tree-based hierarchical data structure
- Local-first with eventual consistency
- Simple mental model for developers
- Easy to reason about data relationships

Our implementation simplifies this concept while maintaining the core benefits of local-first storage with cloud sync.

## License

MIT License - see LICENSE file for details

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
