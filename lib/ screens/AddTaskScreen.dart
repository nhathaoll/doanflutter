import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/TaskController.dart';
import '../controller/CategoryController.dart';
import '../models/task.dart';
import '../models/category.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController taskController = Get.find();
  final CategoryController categoryController = Get.put(CategoryController());
  final TextEditingController _titleController = TextEditingController();
  Category? _selectedCategory;
  DateTime? _selectedDeadline;
  String? _selectedPriority;

  @override
  void initState() {
    super.initState();
    categoryController.loadCategories();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? DateTime.now(),
      firstDate: DateTime.now(), // Prevent selecting past dates
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDeadline) {
      setState(() {
        _selectedDeadline = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Deadline (YYYY-MM-DD)',
                hintText: _selectedDeadline != null
                    ? _selectedDeadline!.toLocal().toString().split(' ')[0]
                    : 'Select Deadline',
              ),
              onTap: () => _selectDate(context),
            ),
            Obx(() {
              if (categoryController.categories.isEmpty) {
                return CircularProgressIndicator();
              }
              return DropdownButton<Category>(
                value: _selectedCategory,
                hint: Text('Select Category'),
                onChanged: (Category? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                items: categoryController.categories.map((Category category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
              );
            }),
            DropdownButton<String>(
              value: _selectedPriority,
              hint: Text('Select Priority'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPriority = newValue;
                });
              },
              items: <String>['Not Important', 'Low', 'Medium', 'High']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_selectedCategory == null ||
                    _selectedDeadline == null ||
                    _selectedPriority == null) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                if (_selectedDeadline!.isBefore(DateTime.now())) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('You cannot choose a past date')),
                  );
                  return;
                }

                final newTask = Task(
                  title: _titleController.text,
                  deadline: _selectedDeadline!,
                  categoryId: _selectedCategory!.id!,
                  priority: _priorityToInt(_selectedPriority!),
                  isCompleted: false,
                );
                await taskController.addTask(newTask);
                Navigator.pop(context);
              },
              child: Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }

  int _priorityToInt(String priority) {
    switch (priority) {
      case 'Not Important':
        return 1;
      case 'Low':
        return 2;
      case 'Medium':
        return 3;
      case 'High':
        return 4;
      default:
        return 1;
    }
  }
}
