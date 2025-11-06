# Might3 Architecture

This document describes the architecture and design decisions for the Might3 app.

## Overview

Might3 is a task management app that keeps you focused on your top 3 priorities. It uses:
- **Flutter** for cross-platform UI
- **Beads-inspired database** for local-first data storage
- **Supabase** for cloud sync and authentication
- **Native widgets** for macOS and iOS

## Architecture Layers

```
┌─────────────────────────────────────────────────┐
│              Presentation Layer                  │
│  (HomeScreen, TaskCard widgets, iOS Widget)     │
└─────────────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────┐
│              Service Layer                       │
│  (BeadsService, WidgetService)                  │
└─────────────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────┐
│              Data Layer                          │
│  (SharedPreferences, Supabase Client)           │
└─────────────────────────────────────────────────┘
```

## Beads Database Implementation

### What is Beads?

Beads is a data architecture concept by Steve Yegge that proposes using tree-based structures for data storage. Key principles:

1. **Tree Structure**: All data organized in a hierarchical tree
2. **Local-First**: Data lives locally first, syncs later
3. **Simple Model**: Easy to understand and reason about
4. **Flexible Schema**: No rigid schema requirements

### Our Implementation

```
Root Bead
  ├── Metadata
  │   └── created: timestamp
  └── Children (Tasks)
       ├── Task Bead
       │    ├── id: string
       │    ├── title: string
       │    ├── completed: boolean
       │    ├── priority: number
       │    └── created: timestamp
       ├── Task Bead
       └── Task Bead
```

### Beads Tree Structure

```dart
{
  'root': {
    'type': 'root',
    'children': [
      {
        'type': 'task',
        'id': '1234567890',
        'title': 'Complete documentation',
        'completed': false,
        'priority': 5,
        'created': '2024-01-01T00:00:00.000Z'
      },
      // More tasks...
    ],
    'metadata': {
      'created': '2024-01-01T00:00:00.000Z'
    }
  }
}
```

### Why Beads for This App?

1. **Simplicity**: Tasks naturally fit a tree structure
2. **Local-First**: Users can work offline without issues
3. **Fast Reads**: No database queries needed - tree is in memory
4. **Easy Sync**: Entire tree can be synced as a single JSON blob
5. **Extensibility**: Easy to add sub-tasks, categories, etc.

## Service Architecture

### BeadsService

The core database service that manages the Beads tree:

**Responsibilities:**
- Load/save tree from local storage (SharedPreferences)
- CRUD operations on tasks
- Sync with Supabase
- Sort and filter tasks

**Key Methods:**
- `initialize()`: Load from local storage, sync with cloud
- `getTasks()`: Get all tasks from tree
- `getTopThreeTasks()`: Get 3 highest priority tasks
- `addTask()`: Add new task bead to tree
- `updateTask()`: Update existing task bead
- `deleteTask()`: Remove task bead from tree

**Sync Strategy:**
Simple last-write-wins for MVP. Future improvements could include:
- Operational transformation
- CRDTs for conflict-free merging
- Version vectors for causality tracking

### WidgetService

Manages data sharing with platform widgets:

**Responsibilities:**
- Format data for iOS widgets
- Save to shared preferences
- Trigger widget updates

**Implementation:**
- Uses SharedPreferences as bridge to iOS widget
- iOS widget reads from App Group shared container
- Updates on every task change

## Platform-Specific Features

### macOS Desktop Widget

**Window Configuration:**
```swift
WindowOptions(
  size: Size(320, 480),
  backgroundColor: Colors.transparent,
  titleBarStyle: TitleBarStyle.hidden,
  alwaysOnTop: true,
  opacity: 0.95
)
```

**Features:**
- Transparent background with blur effect
- Gradient overlay for visual appeal
- Floating above all other windows
- Draggable to any screen position
- Native macOS styling

**Implementation:**
- Uses `window_manager` package for window control
- `AppDelegate.swift` configures transparency
- SwiftUI integration for native feel

### iOS Home Screen Widget

**Widget Configuration:**
- Update interval: 15 minutes
- Supports: Small and Medium sizes
- Data source: Shared UserDefaults (App Group)

**Timeline:**
```swift
Timeline(
  entries: [currentEntry],
  policy: .after(refreshDate) // 15 min later
)
```

**Features:**
- Shows top 3 tasks
- Color-coded status (green = complete)
- Tap to open main app
- Auto-refreshes periodically

## Data Flow

### Task Creation Flow

```
User Input → HomeScreen → BeadsService
                              ↓
                        Add to Tree
                              ↓
                    Save to SharedPreferences
                              ↓
                      Sync to Supabase
                              ↓
                      Update Widget Data
```

### Task Sync Flow

```
App Launch → BeadsService.initialize()
                    ↓
           Load from Local Storage
                    ↓
           Fetch from Supabase
                    ↓
        Compare timestamps (last-write-wins)
                    ↓
           Use most recent data
                    ↓
        Save to local if needed
```

## State Management

Currently using simple `setState()` for MVP. Future improvements:

- **Provider/Riverpod**: For better state management
- **Bloc Pattern**: For complex state logic
- **GetX**: For reactive programming

## Performance Considerations

### Current Optimizations

1. **Local-First**: No network calls for reads
2. **In-Memory Tree**: Fast access to all tasks
3. **Lazy Sync**: Sync happens in background
4. **Minimal UI Updates**: Only rebuild what changed

### Future Optimizations

1. **Pagination**: For large task lists
2. **Incremental Sync**: Only sync changed beads
3. **Index/Cache**: For fast queries
4. **Background Sync**: Using WorkManager/Background Tasks

## Security

### Current Implementation

- Anonymous access allowed for MVP
- Supabase RLS policies control access
- Local data encrypted by OS (keychain/shared prefs)

### Production Recommendations

1. Implement Supabase Authentication
2. Row-level security based on user ID
3. Encrypt sensitive data
4. Use secure storage (flutter_secure_storage)
5. API key management (environment variables)

## Testing Strategy

### Unit Tests
- Task model serialization/deserialization
- BeadsService CRUD operations
- Task sorting logic

### Widget Tests
- UI component rendering
- User interaction flows
- State changes

### Integration Tests (Future)
- Sync flow end-to-end
- Widget data sharing
- Offline/online transitions

## Scalability

### Current Limits

- Single tree structure (flat list of tasks)
- Last-write-wins sync (can lose data)
- No pagination (all tasks loaded)

### Scaling Strategies

1. **Multiple Trees**: Separate trees for different contexts
2. **Subtrees**: Hierarchical task organization
3. **Smart Sync**: Only sync changed branches
4. **Caching**: Intelligent caching strategies
5. **CRDT**: Conflict-free replicated data types

## Future Enhancements

### Short Term
- [ ] User authentication
- [ ] Task categories
- [ ] Priority UI controls
- [ ] Search functionality

### Medium Term
- [ ] Sub-tasks (nested beads)
- [ ] Task sharing
- [ ] Reminders/notifications
- [ ] Android widget

### Long Term
- [ ] Collaborative tasks
- [ ] Real-time sync
- [ ] Analytics dashboard
- [ ] AI-powered prioritization

## References

- [Steve Yegge's Beads Blog Post](https://steve-yegge.blogspot.com/2020/09/beads.html)
- [Flutter Architecture Patterns](https://docs.flutter.dev/development/data-and-backend/state-mgmt/options)
- [Supabase Documentation](https://supabase.com/docs)
- [Local-First Software](https://www.inkandswitch.com/local-first.html)

## Contributing to Architecture

When proposing architectural changes:

1. Discuss in GitHub Issues first
2. Consider backwards compatibility
3. Update this document
4. Provide migration path if needed
5. Consider performance implications

---

Last Updated: 2024-01-01
