// home_screen.dart - Consumer implementation
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TaskFilter _currentFilter = TaskFilter.all;

  void _addTask() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'New Task',
      description: 'Task added via provider',
      priority: Priority.medium,
    );

    taskProvider.addTask(newTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              return Badge(
                label: Text('${taskProvider.activeTaskCount}'),
                child: IconButton(
                  icon: const Icon(Icons.task),
                  onPressed: () {},
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Statistics Row
          Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '${taskProvider.totalTaskCount}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${taskProvider.activeTaskCount}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          'Active',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${taskProvider.completedTaskCount}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          'Completed',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: _currentFilter == TaskFilter.all,
                    onSelected: (_) {
                      setState(() {
                        _currentFilter = TaskFilter.all;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Active'),
                    selected: _currentFilter == TaskFilter.active,
                    onSelected: (_) {
                      setState(() {
                        _currentFilter = TaskFilter.active;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // Tasks List
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                final tasks = taskProvider.filterTasks(filter: _currentFilter);

                if (tasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          _currentFilter == TaskFilter.completed
                              ? 'No completed tasks'
                              : 'No tasks found',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: task.isCompleted,
                            onChanged: (_) {
                              taskProvider.toggleTaskCompletion(task.id);
                            },
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: Text(task.description),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  task.isFavorite
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: task.isFavorite ? Colors.amber : null,
                                ),
                                onPressed: () {
                                  taskProvider.toggleTaskFavorite(task.id);
                                },
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: task.priorityColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  task.priorityString,
                                  style: TextStyle(
                                    color: task.priorityColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
