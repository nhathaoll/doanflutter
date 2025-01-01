import 'package:get/get.dart';
import '../databasehelper/db.dart';
import '../models/category.dart';

class CategoryController extends GetxController {
  var categories = <Category>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    final categoriesList = await DatabaseHelper().getCategories();
    categories.assignAll(categoriesList);
  }

  Future<void> addCategory(Category category) async {
    await DatabaseHelper().insertCategory(category);
    loadCategories();
  }

  Future<void> deleteCategory(int id) async {
    await DatabaseHelper().deleteCategory(id);
    loadCategories();
  }

  Category? getCategoryById(int id) {
    return categories.firstWhereOrNull((category) => category.id == id);
  }
}
