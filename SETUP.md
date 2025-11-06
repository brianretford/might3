# Might3 - Setup Guide

## Quick Start

### 1. Install Flutter

If you don't have Flutter installed:

```bash
# macOS
brew install flutter

# Or download from https://docs.flutter.dev/get-started/install
```

### 2. Clone and Setup

```bash
git clone https://github.com/brianretford/might3.git
cd might3
flutter pub get
```

### 3. Configure Supabase

#### Create Supabase Project
1. Go to [supabase.com](https://supabase.com) and create a free account
2. Create a new project
3. Go to Settings → API to find your URL and anon key

#### Create Database Table
Run this SQL in the Supabase SQL editor:

```sql
-- Create beads_data table
CREATE TABLE beads_data (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id TEXT NOT NULL,
  tree_data JSONB NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id)
);

-- Enable Row Level Security
ALTER TABLE beads_data ENABLE ROW LEVEL SECURITY;

-- Create policy to allow all operations for now (adjust for production)
CREATE POLICY "Enable all access for authenticated users" ON beads_data
  FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Create policy for anonymous users (for development)
CREATE POLICY "Enable all access for anonymous users" ON beads_data
  FOR ALL
  TO anon
  USING (true)
  WITH CHECK (true);
```

#### Set Environment Variables

Create a `.env.local` file in the project root:

```bash
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

Or export them:

```bash
export SUPABASE_URL="https://your-project-id.supabase.co"
export SUPABASE_ANON_KEY="your-anon-key-here"
```

### 4. Run the App

#### macOS Desktop Widget

```bash
flutter run -d macos --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
```

#### iOS with Widget Extension

```bash
# Open in Xcode to configure signing
open ios/Runner.xcworkspace

# Then run from Xcode or
flutter run -d ios --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
```

**Note**: For iOS widgets, you'll need to:
1. Set up proper code signing in Xcode
2. Configure an App Group (`group.com.might3.app`)
3. Add the App Group to both the main app and widget extension capabilities

## Platform-Specific Setup

### macOS

The app runs as a transparent, always-on-top window. No special configuration needed!

Features:
- Transparent background with blur effect
- Always stays on top of other windows
- Draggable to any position on screen
- Semi-transparent (95% opacity)

### iOS Widget

To add the widget to your home screen:
1. Long press on your iPhone home screen
2. Tap the "+" button in the top-left corner
3. Search for "Might3" or scroll to find it
4. Choose widget size (Small or Medium recommended)
5. Tap "Add Widget"

The widget updates automatically every 15 minutes.

## Understanding Beads Architecture

This app uses a simplified implementation of Steve Yegge's Beads concept:

### What is Beads?

Beads is a tree-based data architecture where:
- All data is stored in a hierarchical tree structure
- Each "bead" (node) can contain data and have children
- The structure is similar to XML/DOM but more flexible
- Local-first: works offline, syncs when online

### Our Implementation

```
Root Bead
  └── Children (Tasks)
       ├── Task 1
       ├── Task 2
       └── Task 3
```

Each task bead contains:
- `id`: Unique identifier
- `title`: Task description
- `completed`: Boolean status
- `priority`: Numeric priority
- `created`: Timestamp

### Benefits

1. **Local-First**: All data is stored locally first
2. **Works Offline**: Full functionality without internet
3. **Simple Sync**: Tree is synced to Supabase when online
4. **Fast Reads**: No network latency for viewing data
5. **Version Control Friendly**: Tree structure can be versioned

## Troubleshooting

### Flutter not found
```bash
# Add Flutter to your PATH
export PATH="$PATH:`pwd`/flutter/bin"
```

### macOS build fails
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build macos
```

### iOS widget not updating
- Check App Group configuration in Xcode
- Ensure widget extension has same App Group as main app
- Try removing and re-adding the widget

### Supabase connection fails
- Verify your SUPABASE_URL and SUPABASE_ANON_KEY are correct
- Check that the beads_data table exists
- Ensure RLS policies are configured correctly

### Window not transparent on macOS
- Requires macOS 10.14 or later
- Check that window_manager package is properly installed
- Try rebuilding: `flutter clean && flutter build macos`

## Development

### Running Tests

```bash
flutter test
```

### Code Generation

For JSON serialization:

```bash
flutter pub run build_runner build
```

### Linting

```bash
flutter analyze
```

## Next Steps

- [ ] Add authentication (Supabase Auth)
- [ ] Implement priority levels UI
- [ ] Add task categories/tags
- [ ] Create Android widget
- [ ] Add web version
- [ ] Implement real-time sync
- [ ] Add task reminders
- [ ] Theme customization

## Support

For issues or questions:
- GitHub Issues: https://github.com/brianretford/might3/issues
- Documentation: See README.md

## Resources

- [Flutter Documentation](https://docs.flutter.dev)
- [Supabase Documentation](https://supabase.com/docs)
- [Steve Yegge's Beads](https://steve-yegge.blogspot.com/2020/09/beads.html)
- [WidgetKit Documentation](https://developer.apple.com/documentation/widgetkit)
