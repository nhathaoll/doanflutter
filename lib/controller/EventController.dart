import 'package:get/get.dart';
import '../models/event.dart';

class EventController extends GetxController {
  var events = <Event>[].obs;

  List<Event> getEventsForDay(DateTime day) {
    return events.where((event) => isSameDay(event.dateTime, day)).toList();
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void addEvent(Event event) {
    events.add(event);
  }
}
