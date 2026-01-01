import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TaskListScreen(),
    );
  }
}

class Task {
  String title;
  bool isCompleted;
  bool isFavorite;

  Task({
    required this.title,
    this.isCompleted = false,
    this.isFavorite = false,
  });
}

enum TaskFilter { all, pending, completed }

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [];
  TaskFilter _currentFilter = TaskFilter.all;

  void _addTask(String title) {
    if (title.isNotEmpty) {
      setState(() {
        _tasks.add(Task(title: title));
      });
    }
  }

  void _toggleCompleted(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  void _toggleFavorite(int index) {
    setState(() {
      _tasks[index].isFavorite = !_tasks[index].isFavorite;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  List<Task> get _filteredTasks {
    switch (_currentFilter) {
      case TaskFilter.all:
        return _tasks;
      case TaskFilter.pending:
        return _tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.completed:
        return _tasks.where((task) => task.isCompleted).toList();
    }
  }

  int get _totalTasks => _tasks.length;
  int get _pendingTasks => _tasks.where((task) => !task.isCompleted).length;
  int get _completedTasks => _tasks.where((task) => task.isCompleted).length;

  void _showAddTaskDialog() {
    final TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Enter task title'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addTask(_controller.text);
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Manager')),
      body: Column(
        children: [
          // Dynamic Stats Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatCard(label: 'Total', count: _totalTasks),
                _StatCard(label: 'Pending', count: _pendingTasks),
                _StatCard(label: 'Completed', count: _completedTasks),
              ],
            ),
          ),
          // Filter Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _FilterButton(
                label: 'All',
                isSelected: _currentFilter == TaskFilter.all,
                onPressed: () =>
                    setState(() => _currentFilter = TaskFilter.all),
              ),
              _FilterButton(
                label: 'Pending',
                isSelected: _currentFilter == TaskFilter.pending,
                onPressed: () =>
                    setState(() => _currentFilter = TaskFilter.pending),
              ),
              _FilterButton(
                label: 'Completed',
                isSelected: _currentFilter == TaskFilter.completed,
                onPressed: () =>
                    setState(() => _currentFilter = TaskFilter.completed),
              ),
            ],
          ),
          // Task List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTasks.length,
              itemBuilder: (context, index) {
                final task = _filteredTasks[index];
                final originalIndex = _tasks.indexOf(task);
                return Dismissible(
                  key: Key(task.title + originalIndex.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _deleteTask(originalIndex),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (_) => _toggleCompleted(originalIndex),
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        task.isFavorite ? Icons.star : Icons.star_border,
                        color: task.isFavorite ? Colors.yellow : null,
                      ),
                      onPressed: () => _toggleFavorite(originalIndex),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int count;

  const _StatCard({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _FilterButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : null,
      ),
      child: Text(label),
    );
  }
}
