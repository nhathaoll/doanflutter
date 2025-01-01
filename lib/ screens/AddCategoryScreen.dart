import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/CategoryController.dart';
import '../models/category.dart';

class AddCategoryScreen extends StatelessWidget {
  final CategoryController categoryController = Get.find();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _colorController,
              decoration: InputDecoration(labelText: 'Color (Hex Code)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final newCategory = Category(
                  name: _nameController.text,
                  color: _colorController.text,
                  createdDate: DateTime.now(),
                );
                await categoryController.addCategory(newCategory);
                Navigator.pop(context);
              },
              child: Text('Save Category'),
            ),
          ],
        ),
      ),
    );
  }
}
