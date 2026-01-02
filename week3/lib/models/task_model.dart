// task_model.dart - Data model with copyWith
import 'package:flutter/material.dart';

enum Priority { low, medium, high }

class Task {
  final int id;
  final String title;
  final String description;
  final bool isCompleted;
  final Priority priority;
  final bool isFavorite;
  final DateTime? dueDate;
  final DateTime createdAt;
  final String? category;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.priority = Priority.medium,
    this.isFavorite = false,
    this.dueDate,
    DateTime? createdAt,
    this.category,
  }) : createdAt = createdAt ?? DateTime.now();

  // CopyWith method for immutability
  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    Priority? priority,
    bool? isFavorite,
    DateTime? dueDate,
    DateTime? createdAt,
    String? category,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      isFavorite: isFavorite ?? this.isFavorite,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
    );
  }

  // Convert priority to color
  Color get priorityColor {
    switch (priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }

  // Convert priority to string
  String get priorityString {
    switch (priority) {
      case Priority.high:
        return 'HIGH';
      case Priority.medium:
        return 'MEDIUM';
      case Priority.low:
        return 'LOW';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
