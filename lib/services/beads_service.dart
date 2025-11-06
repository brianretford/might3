import 'dart:convert';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task.dart';

/// BeadsService implements a local-first database inspired by Steve Yegge's Beads
/// architecture. It uses a tree-based data structure with local storage backed
/// by Supabase for sync.
class BeadsService {
  static final BeadsService instance = BeadsService._internal();
  BeadsService._internal();
  
  late SharedPreferences _prefs;
  final _supabase = Supabase.instance.client;
  
  // Beads tree structure - hierarchical data storage
  Map<String, dynamic> _beadsTree = {};
  
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadBeadsFromLocal();
    await _syncWithSupabase();
  }
  
  /// Load the Beads tree from local storage
  Future<void> _loadBeadsFromLocal() async {
    final String? treeJson = _prefs.getString('beads_tree');
    if (treeJson != null) {
      _beadsTree = jsonDecode(treeJson) as Map<String, dynamic>;
    } else {
      _beadsTree = {
        'root': {
          'type': 'root',
          'children': [],
          'metadata': {
            'created': DateTime.now().toIso8601String(),
          }
        }
      };
    }
  }
  
  /// Save the Beads tree to local storage
  Future<void> _saveBeadsToLocal() async {
    await _prefs.setString('beads_tree', jsonEncode(_beadsTree));
  }
  
  /// Sync with Supabase backend
  Future<void> _syncWithSupabase() async {
    try {
      // Push local changes to Supabase
      await _supabase.from('beads_data').upsert({
        'user_id': _supabase.auth.currentUser?.id ?? 'anonymous',
        'tree_data': _beadsTree,
        'updated_at': DateTime.now().toIso8601String(),
      });
      
      // Pull remote changes (simple last-write-wins for MVP)
      final response = await _supabase
          .from('beads_data')
          .select()
          .eq('user_id', _supabase.auth.currentUser?.id ?? 'anonymous')
          .maybeSingle();
      
      if (response != null) {
        final remoteTree = response['tree_data'] as Map<String, dynamic>?;
        if (remoteTree != null) {
          _beadsTree = remoteTree;
          await _saveBeadsToLocal();
        }
      }
    } catch (e) {
      developer.log('Sync error: $e', name: 'BeadsService');
      // Fail gracefully - local-first approach
    }
  }
  
  /// Get tasks from the Beads tree
  List<Task> getTasks() {
    final root = _beadsTree['root'] as Map<String, dynamic>?;
    if (root == null) return [];
    
    final children = root['children'] as List<dynamic>?;
    if (children == null) return [];
    
    return children
        .where((child) => child['type'] == 'task')
        .map((taskData) => Task.fromJson(taskData as Map<String, dynamic>))
        .toList();
  }
  
  /// Add a task to the Beads tree
  Future<void> addTask(Task task) async {
    final root = _beadsTree['root'] as Map<String, dynamic>;
    final children = root['children'] as List<dynamic>;
    
    children.add({
      'type': 'task',
      'id': task.id,
      'title': task.title,
      'completed': task.completed,
      'priority': task.priority,
      'created': task.created.toIso8601String(),
    });
    
    await _saveBeadsToLocal();
    await _syncWithSupabase();
  }
  
  /// Update a task in the Beads tree
  Future<void> updateTask(Task task) async {
    final root = _beadsTree['root'] as Map<String, dynamic>;
    final children = root['children'] as List<dynamic>;
    
    final index = children.indexWhere((child) => child['id'] == task.id);
    if (index != -1) {
      children[index] = {
        'type': 'task',
        'id': task.id,
        'title': task.title,
        'completed': task.completed,
        'priority': task.priority,
        'created': task.created.toIso8601String(),
      };
      
      await _saveBeadsToLocal();
      await _syncWithSupabase();
    }
  }
  
  /// Delete a task from the Beads tree
  Future<void> deleteTask(String taskId) async {
    final root = _beadsTree['root'] as Map<String, dynamic>;
    final children = root['children'] as List<dynamic>;
    
    children.removeWhere((child) => child['id'] == taskId);
    
    await _saveBeadsToLocal();
    await _syncWithSupabase();
  }
  
  /// Get the top 3 priority tasks
  List<Task> getTopThreeTasks() {
    final tasks = getTasks();
    tasks.sort((a, b) {
      // Sort by: not completed first, then by priority, then by created date
      if (a.completed != b.completed) {
        return a.completed ? 1 : -1;
      }
      if (a.priority != b.priority) {
        return b.priority.compareTo(a.priority);
      }
      return a.created.compareTo(b.created);
    });
    
    return tasks.take(3).toList();
  }
}
