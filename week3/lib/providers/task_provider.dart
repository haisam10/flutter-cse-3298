// task_provider.dart - Central state management
import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [
    Task(
      id: 1,
      title: 'Complete Week 3 Lab',
      description: 'Provider implementation & CRUD ops',
      isCompleted: false,
      priority: Priority.high,
      isFavorite: false,
    ),
    // More initial tasks...
  ];

  List<Task> get tasks => _tasks;

  List<Task> get activeTasks =>
      _tasks.where((task) => !task.isCompleted).toList();

  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

  List<Task> get favoriteTasks =>
      _tasks.where((task) => task.isFavorite).toList();

  List<Task> getHighPriorityTasks() =>
      _tasks.where((task) => task.priority == Priority.high).toList();

  // CRUD Operations
  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(int id, Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  void deleteTask(int id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void toggleTaskCompletion(int id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        isCompleted: !_tasks[index].isCompleted,
      );
      notifyListeners();
    }
  }

  void toggleTaskFavorite(int id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        isFavorite: !_tasks[index].isFavorite,
      );
      notifyListeners();
    }
  }

  // Filtering
  List<Task> filterTasks({TaskFilter filter = TaskFilter.all}) {
    switch (filter) {
      case TaskFilter.all:
        return _tasks;
      case TaskFilter.active:
        return activeTasks;
      case TaskFilter.completed:
        return completedTasks;
      case TaskFilter.favorites:
        return favoriteTasks;
      case TaskFilter.highPriority:
        return getHighPriorityTasks();
    }
  }

  // Statistics
  int get totalTaskCount => _tasks.length;

  int get completedTaskCount => completedTasks.length;

  int get activeTaskCount => activeTasks.length;

  double get completionPercentage =>
      _tasks.isEmpty ? 0 : (completedTaskCount / totalTaskCount) * 100;
}

enum TaskFilter { all, active, completed, favorites, highPriority }
