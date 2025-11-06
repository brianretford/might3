import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import '../services/beads_service.dart';
import '../services/widget_service.dart';
import '../models/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _beadsService = BeadsService.instance;
  final _widgetService = WidgetService.instance;
  List<Task> _topTasks = [];
  final _textController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }
  
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
  
  void _loadTasks() {
    setState(() {
      _topTasks = _beadsService.getTopThreeTasks();
    });
    // Update widget with new tasks
    _widgetService.updateWidgetTasks(_topTasks);
  }
  
  Future<void> _addTask() async {
    if (_textController.text.isEmpty) return;
    
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _textController.text,
      priority: 1,
    );
    
    await _beadsService.addTask(task);
    _textController.clear();
    _loadTasks();
  }
  
  Future<void> _toggleTask(Task task) async {
    final updatedTask = task.copyWith(completed: !task.completed);
    await _beadsService.updateTask(updatedTask);
    _loadTasks();
  }
  
  Future<void> _deleteTask(Task task) async {
    await _beadsService.deleteTask(task.id);
    _loadTasks();
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMacOS = Platform.isMacOS;
    
    return Scaffold(
      backgroundColor: isMacOS 
          ? Colors.black.withOpacity(0.7) 
          : null,
      body: Container(
        decoration: isMacOS ? BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.withOpacity(0.3),
              Colors.purple.withOpacity(0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ) : null,
        margin: isMacOS ? const EdgeInsets.all(8) : null,
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.star_fill,
                      color: Colors.amber,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Top 3 Tasks',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Task input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Add a task...',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (_) => _addTask(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _addTask,
                      icon: const Icon(CupertinoIcons.add_circled_solid),
                      color: Colors.blue,
                      iconSize: 32,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Task list
              Expanded(
                child: _topTasks.isEmpty
                    ? Center(
                        child: Text(
                          'No tasks yet\nAdd your top 3!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _topTasks.length,
                        itemBuilder: (context, index) {
                          final task = _topTasks[index];
                          return _TaskCard(
                            task: task,
                            onToggle: () => _toggleTask(task),
                            onDelete: () => _deleteTask(task),
                          );
                        },
                      ),
              ),
              
              // Footer info
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Powered by Beads + Supabase',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  
  const _TaskCard({
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            task.completed 
                ? CupertinoIcons.check_mark_circled_solid
                : CupertinoIcons.circle,
            color: task.completed ? Colors.green : Colors.white.withOpacity(0.5),
          ),
          onPressed: onToggle,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            color: Colors.white,
            decoration: task.completed ? TextDecoration.lineThrough : null,
            decorationColor: Colors.white.withOpacity(0.5),
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            CupertinoIcons.trash,
            color: Colors.red.withOpacity(0.7),
          ),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
