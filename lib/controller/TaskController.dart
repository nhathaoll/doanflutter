import 'dart:async';
import 'package:get/get.dart';
import '../databasehelper/db.dart';
import '../helper/NotificationHelper.dart';
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
    startDeadlineCheck(); // Bắt đầu kiểm tra deadline
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

  void startDeadlineCheck() {
    Timer.periodic(Duration(minutes: 5), (timer) async {
      final now = DateTime.now();
      final soonDeadlineTasks = tasks.where((task) {
        final timeLeft = task.deadline.difference(now).inHours;
        return !task.isCompleted && timeLeft <= 24 && timeLeft > 0;
      }).toList();

      for (var task in soonDeadlineTasks) {
        await NotificationHelper.showNotification(
          id: task.id!,
          title: "Task sắp đến hạn!",
          body: "Task '${task.title}' sẽ hết hạn lúc ${task.deadline}.",
        );
      }
    });
  }
}
