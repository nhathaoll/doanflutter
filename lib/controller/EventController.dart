import 'package:get/get.dart';
import '../models/event.dart';
import '../databasehelper/db.dart';
import '../helper/NotificationHelper.dart';
import 'dart:async';

class EventController extends GetxController {
  var events = <Event>[].obs;
  Timer? _eventCheckTimer;

  @override
  void onInit() {
    super.onInit();
    loadEvents();
    startEventCheck();
  }

  Future<void> loadEvents() async {
    final eventsList = await DatabaseHelper().getEvents();
    events.assignAll(eventsList);
  }

  List<Event> getEventsForDay(DateTime day) {
    return events.where((event) => isSameDay(event.dateTime, day)).toList();
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> addEvent(Event event) async {
    await DatabaseHelper().insertEvent(event);
    loadEvents();
  }

  Future<void> updateEvent(Event event) async {
    await DatabaseHelper().updateEvent(event);
    loadEvents();
  }

  Future<void> deleteEvent(int id) async {
    await DatabaseHelper().deleteEvent(id);
    loadEvents();
  }

  void startEventCheck() {
    _eventCheckTimer?.cancel(); // Hủy nếu đã tồn tại
    _eventCheckTimer = Timer.periodic(
      Duration(hours: 1),
      (timer) async {
        final now = DateTime.now();
        final upcomingEvents = events.where((event) {
          final timeLeft = event.dateTime.difference(now).inHours;
          return !event.isCompleted && timeLeft <= 24 && timeLeft > 0;
        }).toList();

        for (var event in upcomingEvents) {
          await NotificationHelper.showNotification(
            id: event.id!,
            title: "Upcoming Event!",
            body:
                "Event '${event.title}' is happening soon at ${event.dateTime}.",
          );
        }
      },
    );
  }

  @override
  void onClose() {
    _eventCheckTimer?.cancel(); // Dọn dẹp khi Controller bị đóng
    super.onClose();
  }
}
