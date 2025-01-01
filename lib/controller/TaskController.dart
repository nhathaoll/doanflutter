import 'package:get/get.dart';
import '../databasehelper/db.dart';
import '../models/task.dart';
import '../models/category.dart';

class TaskController extends GetxController {
  var tasks = <Task>[].obs;
  var categories = <Category>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
    loadCategories();
  }

  Future<void> loadTasks() async {
    final tasksList = await DatabaseHelper().getTasks();
    tasks.assignAll(tasksList);
  }

  Future<void> loadCategories() async {
    final categoriesList = await DatabaseHelper().getCategories();
    categories.assignAll(categoriesList);
  }

  Future<void> addTask(Task task) async {
    await DatabaseHelper().insertTask(task);
    loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await DatabaseHelper().deleteTask(id);
    loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await DatabaseHelper().updateTask(task);
    loadTasks();
  }

  Category? getCategoryById(int id) {
    return categories.firstWhereOrNull((category) => category.id == id);
  }

  List<Task> getTasksByCategory(int categoryId) {
    return tasks
        .where((task) => task.categoryId == categoryId && !task.isCompleted)
        .toList();
  }

  List<Task> getCompletedTasks() {
    return tasks.where((task) => task.isCompleted).toList();
  }

  List<Task> getUnfinishedTasks() {
    final now = DateTime.now();
    return tasks
        .where((task) => !task.isCompleted && task.deadline.isBefore(now))
        .toList();
  }
}
