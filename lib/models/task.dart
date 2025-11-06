import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable()
class Task {
  final String id;
  final String title;
  final bool completed;
  final int priority;
  final DateTime created;
  
  Task({
    required this.id,
    required this.title,
    this.completed = false,
    this.priority = 0,
    DateTime? created,
  }) : created = created ?? DateTime.now();
  
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
  
  Task copyWith({
    String? id,
    String? title,
    bool? completed,
    int? priority,
    DateTime? created,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      priority: priority ?? this.priority,
      created: created ?? this.created,
    );
  }
}
