import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/CategoryController.dart';
import '../controller/TaskController.dart';
import '../models/task.dart';
import 'AddCategoryScreen.dart';
import 'AddTaskScreen.dart';

class TaskScreen extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());
  final CategoryController categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            tooltip: 'Add Category',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCategoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Obx(
        () {
          if (categoryController.categories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (taskController.tasks.isEmpty) {
            return const Center(
              child: Text('No tasks available'),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            children: [
              _buildExpandableContainer(
                title: 'Missing Tasks',
                child: _buildTaskSection(
                  taskController.getUnfinishedTasks(),
                  'No missing tasks',
                ),
              ),
              _buildExpandableContainer(
                title: 'Tasks by Category',
                child: Column(
                  children: categoryController.categories.map((category) {
                    final tasks =
                        taskController.getTasksByCategory(category.id!);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Card(
                        elevation: 4.0,
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ExpansionTile(
                          collapsedBackgroundColor: Colors.white,
                          tilePadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          title: Text(
                            category.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          children: tasks.isEmpty
                              ? [
                                  const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      'No tasks in this category',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ]
                              : tasks.map(
                                  (task) {
                                    return Container(
                                      color: _getPriorityColor(task.priority),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: ListTile(
                                        title: Text(task.title),
                                        subtitle:
                                            Text('Deadline: ${task.deadline}'),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Checkbox(
                                              value: task.isCompleted,
                                              onChanged: (bool? value) {
                                                if (value == true) {
                                                  taskController.updateTask(
                                                    Task(
                                                      id: task.id,
                                                      title: task.title,
                                                      deadline: task.deadline,
                                                      categoryId:
                                                          task.categoryId,
                                                      priority: task.priority,
                                                      isCompleted:
                                                          value ?? false,
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () {
                                                taskController
                                                    .deleteTask(task.id!);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              _buildExpandableContainer(
                title: 'Completed Tasks',
                child: _buildTaskSection(
                  taskController.getCompletedTasks(),
                  'No completed tasks',
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.white;
      case 2:
        return Colors.yellow[100]!;
      case 3:
        return Colors.orange[100]!;
      case 4:
        return Colors.red[100]!;
      default:
        return Colors.white;
    }
  }

  Widget _buildExpandableContainer(
      {required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          child,
        ],
      ),
    );
  }

  Widget _buildTaskSection(List<Task> tasks, String emptyMessage) {
    if (tasks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            emptyMessage,
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      );
    }

    return Column(
      children: tasks.map((task) {
        final category = categoryController.getCategoryById(task.categoryId);
        return Container(
          color: _getPriorityColor(task.priority),
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            title: Text(task.title),
            subtitle: Text(
                'Category: ${category?.name ?? 'Unknown'}\nDeadline: ${task.deadline}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                taskController.deleteTask(task.id!);
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}
