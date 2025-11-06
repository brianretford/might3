import 'package:flutter_test/flutter_test.dart';
import 'package:might3/models/task.dart';

void main() {
  group('Task Model Tests', () {
    test('Task can be created with required fields', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
      );
      
      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.completed, false);
      expect(task.priority, 0);
    });
    
    test('Task can be created with all fields', () {
      final now = DateTime.now();
      final task = Task(
        id: '1',
        title: 'Test Task',
        completed: true,
        priority: 5,
        created: now,
      );
      
      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.completed, true);
      expect(task.priority, 5);
      expect(task.created, now);
    });
    
    test('Task.copyWith creates new task with updated fields', () {
      final original = Task(
        id: '1',
        title: 'Original',
        completed: false,
        priority: 1,
      );
      
      final updated = original.copyWith(
        title: 'Updated',
        completed: true,
      );
      
      expect(updated.id, '1');
      expect(updated.title, 'Updated');
      expect(updated.completed, true);
      expect(updated.priority, 1);
    });
    
    test('Task can be serialized to JSON', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        completed: true,
        priority: 3,
      );
      
      final json = task.toJson();
      
      expect(json['id'], '1');
      expect(json['title'], 'Test Task');
      expect(json['completed'], true);
      expect(json['priority'], 3);
      expect(json['created'], isA<String>());
    });
    
    test('Task can be deserialized from JSON', () {
      final json = {
        'id': '1',
        'title': 'Test Task',
        'completed': true,
        'priority': 3,
        'created': DateTime.now().toIso8601String(),
      };
      
      final task = Task.fromJson(json);
      
      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.completed, true);
      expect(task.priority, 3);
    });
  });
}
