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
      firstDate: DateTime.now(),
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
        title: const Text('Add Task'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Task Title',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Enter task title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Colors.teal[50],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Deadline',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.teal),
                  ),
                  child: Text(
                    _selectedDeadline != null
                        ? _selectedDeadline!.toLocal().toString().split(' ')[0]
                        : 'Select Deadline',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Obx(() {
                if (categoryController.categories.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return DropdownButtonFormField<Category>(
                  value: _selectedCategory,
                  hint: const Text('Select Category'),
                  onChanged: (Category? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.teal[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  items: categoryController.categories.map((Category category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                );
              }),
              const SizedBox(height: 16),
              const Text(
                'Priority',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                hint: const Text('Select Priority'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPriority = newValue;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                items: <String>['Not Important', 'Low', 'Medium', 'High']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_titleController.text.isEmpty ||
                        _selectedCategory == null ||
                        _selectedDeadline == null ||
                        _selectedPriority == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all fields'),
                        ),
                      );
                      return;
                    }

                    if (_selectedDeadline!.isBefore(DateTime.now())) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('You cannot choose a past date'),
                        ),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Save Task',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
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
