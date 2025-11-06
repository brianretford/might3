import 'dart:convert';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

/// Service to share data with iOS widgets using app groups
class WidgetService {
  static final WidgetService instance = WidgetService._internal();
  WidgetService._internal();
  
  static const String _topTasksKey = 'top_tasks';
  
  /// Update the tasks that will be displayed in the iOS widget
  Future<void> updateWidgetTasks(List<Task> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Convert tasks to JSON format for the iOS widget
      final tasksJson = tasks.take(3).map((task) => {
        'id': task.id,
        'title': task.title,
        'completed': task.completed,
      }).toList();
      
      // Save to shared preferences
      await prefs.setString(_topTasksKey, jsonEncode(tasksJson));
      
      // On iOS, this would also trigger a widget update via WidgetKit
      // For now, widgets will poll for updates
    } catch (e) {
      developer.log('Error updating widget tasks: $e', name: 'WidgetService');
    }
  }
  
  /// Get tasks for widget display
  Future<List<Map<String, dynamic>>> getWidgetTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? tasksJson = prefs.getString(_topTasksKey);
      
      if (tasksJson != null) {
        final List<dynamic> decoded = jsonDecode(tasksJson);
        return decoded.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      developer.log('Error getting widget tasks: $e', name: 'WidgetService');
    }
    
    return [];
  }
}
