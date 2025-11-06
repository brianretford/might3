# Understanding Beads in Might3

This document explains the Beads database concept and how it's implemented in Might3.

## What is Beads?

Beads is a database architecture proposed by Steve Yegge as an alternative to traditional relational databases and NoSQL solutions. The core idea is deceptively simple: **store all your data in a tree**.

## Core Concepts

### 1. Everything is a Tree

Just like the DOM in web browsers, Beads organizes all data in a hierarchical tree structure. Each node (or "bead") in the tree can:
- Contain data
- Have children
- Have metadata

```
Root
 ├─ Users
 │   ├─ User 1
 │   │   ├─ Name
 │   │   └─ Email
 │   └─ User 2
 └─ Tasks
     ├─ Task 1
     ├─ Task 2
     └─ Task 3
```

### 2. Local-First

Data lives on the client first. The tree is:
- Stored locally
- Modified locally
- Synced to server later

This means:
- ✅ Works offline
- ✅ Instant reads
- ✅ No loading spinners
- ✅ Better UX

### 3. Simple Operations

All operations are tree operations:
- **Read**: Traverse the tree
- **Create**: Add a node
- **Update**: Modify a node
- **Delete**: Remove a node

No complex SQL queries, no ORMs, no impedance mismatch.

## Beads vs Traditional Databases

### Relational Database
```sql
CREATE TABLE tasks (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255),
  completed BOOLEAN,
  user_id INTEGER REFERENCES users(id)
);

SELECT * FROM tasks 
WHERE user_id = 1 
  AND completed = false
ORDER BY priority DESC;
```

### Beads
```dart
// Everything is already in memory
final tasks = tree['root']['tasks'];
final myTasks = tasks.where((t) => t.userId == 1 && !t.completed);
```

## Implementation in Might3

### The Tree Structure

Our Beads tree is simple:

```dart
{
  'root': {
    'type': 'root',
    'metadata': {
      'created': '2024-01-01T00:00:00Z'
    },
    'children': [
      {
        'type': 'task',
        'id': '123',
        'title': 'Write documentation',
        'completed': false,
        'priority': 5,
        'created': '2024-01-01T10:00:00Z'
      }
    ]
  }
}
```

### Storage

**Local Storage (Primary)**
- Stored in SharedPreferences
- Entire tree as JSON string
- Loaded on app start
- Persisted on every change

**Cloud Sync (Secondary)**
- Stored in Supabase (PostgreSQL JSONB)
- Synced when online
- Last-write-wins for conflicts
- Full tree sync for MVP

### CRUD Operations

#### Create
```dart
// Add a new task bead to the tree
final task = {
  'type': 'task',
  'id': generateId(),
  'title': 'New task',
  'completed': false,
  'priority': 1,
  'created': DateTime.now().toIso8601String(),
};

tree['root']['children'].add(task);
await saveTree();
await syncTree();
```

#### Read
```dart
// Get all task beads
List<Task> getTasks() {
  final children = tree['root']['children'];
  return children
    .where((child) => child['type'] == 'task')
    .map((data) => Task.fromJson(data))
    .toList();
}
```

#### Update
```dart
// Update an existing task bead
final children = tree['root']['children'];
final index = children.indexWhere((c) => c['id'] == taskId);
if (index != -1) {
  children[index] = updatedTask.toJson();
  await saveTree();
  await syncTree();
}
```

#### Delete
```dart
// Remove a task bead
tree['root']['children'].removeWhere((c) => c['id'] == taskId);
await saveTree();
await syncTree();
```

## Benefits for Might3

### 1. Offline-First
Users can manage tasks without internet:
- Create tasks on a plane
- Update priorities in a tunnel
- Delete completed tasks anywhere
- Sync when connection returns

### 2. Fast Performance
No database queries means:
- Instant task list loading
- Immediate UI updates
- No loading states needed
- Smooth user experience

### 3. Simple Codebase
Tree operations are intuitive:
- No SQL to write
- No ORM configuration
- No migration scripts
- Just JavaScript objects

### 4. Easy Sync
Syncing is straightforward:
- Serialize tree to JSON
- Send to server
- Server stores JSONB
- Pull updates as needed

### 5. Extensibility
Adding features is natural:
- Sub-tasks? Add children to task beads
- Categories? Add a categories branch
- Tags? Add tags array to task bead
- History? Add history branch

## Challenges & Solutions

### Challenge 1: Large Data Sets

**Problem**: Loading 10,000 tasks into memory is slow

**Solutions**:
- Lazy loading: Only load recent tasks
- Pagination: Load tasks in chunks
- Multiple trees: Split by time period
- Pruning: Archive old completed tasks

### Challenge 2: Sync Conflicts

**Problem**: Two devices modify the same task offline

**Solutions**:
- Last-write-wins (current MVP approach)
- Operational Transform (complex but powerful)
- CRDTs (automatic conflict resolution)
- Manual merge UI (user decides)

### Challenge 3: Query Performance

**Problem**: Finding tasks by multiple criteria

**Solutions**:
- In-memory indices
- Caching query results
- Indexing strategy
- Full-text search index

### Challenge 4: Schema Evolution

**Problem**: Changing task structure over time

**Solutions**:
- Versioning: Add version field to beads
- Migrations: Transform tree on load
- Backwards compatibility: Support old formats
- Type checking: Validate bead structure

## Beads Best Practices

### 1. Keep Trees Shallow
```dart
// Good: Shallow tree
root → tasks → [task1, task2, task3]

// Bad: Deep tree
root → year → month → day → hour → [tasks]
```

### 2. Use Consistent Types
```dart
// Every task bead has same structure
{
  'type': 'task',
  'id': string,
  'title': string,
  'completed': boolean,
  'priority': number,
  'created': ISO8601 string
}
```

### 3. Index by ID
```dart
// Keep a map for O(1) lookups
final taskById = {
  '123': taskBead1,
  '456': taskBead2,
};
```

### 4. Lazy Load Children
```dart
// Don't load all children immediately
// Load on demand or in background
if (!node.childrenLoaded) {
  await node.loadChildren();
}
```

### 5. Batch Sync
```dart
// Don't sync on every change
// Batch changes and sync periodically
class BeadSync {
  bool _dirty = false;
  
  void markDirty() => _dirty = true;
  
  // Sync every 30 seconds if dirty
  Timer.periodic(Duration(seconds: 30), (_) {
    if (_dirty) {
      sync();
      _dirty = false;
    }
  });
}
```

## Advanced Beads Concepts

### Subtrees

Organize related data:
```dart
{
  'root': {
    'work': {
      'tasks': [...],
      'projects': [...]
    },
    'personal': {
      'tasks': [...],
      'goals': [...]
    }
  }
}
```

### Linked Beads

Reference beads in other trees:
```dart
{
  'type': 'task',
  'id': '123',
  'assignee_ref': 'user:456' // Reference to user bead
}
```

### Bead Metadata

Store bead information:
```dart
{
  'type': 'task',
  'data': {...},
  'metadata': {
    'created': '2024-01-01',
    'modified': '2024-01-02',
    'version': 2,
    'author': 'user:123'
  }
}
```

## Future Enhancements

### Real-Time Sync
Use Supabase Realtime for live updates:
```dart
supabase
  .from('beads_data')
  .stream(primaryKey: ['user_id'])
  .listen((data) {
    mergeRemoteTree(data);
  });
```

### Bead History
Track all changes:
```dart
{
  'type': 'task',
  'data': {...},
  'history': [
    {
      'version': 1,
      'timestamp': '2024-01-01',
      'changes': {...}
    }
  ]
}
```

### Bead Validation
Ensure data integrity:
```dart
class TaskBead extends Bead {
  void validate() {
    assert(hasField('title'));
    assert(hasField('completed'));
    assert(title.isNotEmpty);
  }
}
```

## Resources

- [Steve Yegge's Beads Blog](https://steve-yegge.blogspot.com/2020/09/beads.html)
- [Local-First Software](https://www.inkandswitch.com/local-first.html)
- [Tree Data Structures](https://en.wikipedia.org/wiki/Tree_(data_structure))
- [CRDT Resources](https://crdt.tech/)

## Questions?

If you have questions about the Beads implementation:
1. Check existing GitHub issues
2. Open a new issue with "Beads:" prefix
3. Reference this document in discussions

---

*"The best database is no database at all - just trees." - Inspired by Steve Yegge*
