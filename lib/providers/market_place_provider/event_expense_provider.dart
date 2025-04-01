import 'package:agri_flutter/models/event_expense.dart';
import 'package:flutter/material.dart';

class EventExpenseProvider with ChangeNotifier {
  //eventExpense map
  final Map<DateTime, List<EventExpense>> _eventExpenseMap = {};



  //add eventexpense
  void addEventExpense(EventExpense eventExpense) {
    if (_eventExpenseMap.containsKey(eventExpense.date)) {
      _eventExpenseMap[eventExpense.date]!.add(eventExpense);
    } else {
      _eventExpenseMap[eventExpense.date] = [eventExpense];
    }
  }

  //delete eventexpense
  void removeEventExpense(EventExpense eventExpense) {
    if (_eventExpenseMap.containsKey(eventExpense.date)) {
      _eventExpenseMap[eventExpense.date]!.remove(eventExpense);
    }
    if (_eventExpenseMap[eventExpense.date]!.isEmpty) {
      _eventExpenseMap.remove(eventExpense.date);
    }
  }
// Update an existing event/expense
void updateExpense(DateTime date, EventExpense updatedEvent) {
  if (_eventExpenseMap.containsKey(date)) {
    List<EventExpense> events = _eventExpenseMap[date]!;

    for (int i = 0; i < events.length; i++) {
      if (events[i].id == updatedEvent.id) {  // Ensure we update the correct event
        events[i] = updatedEvent;
        notifyListeners();  // Notify the UI to update
        return;
      }
    }
  }
}

  //isexpense

  //get event of particular date
  List<EventExpense>? getEventsForDate(DateTime date) {
    return _eventExpenseMap[date];
  }
  //get expense of month

  double getTotalExpenseForDate(DateTime date) {
    return _eventExpenseMap[date]?.fold(
          0,
          (sum, event) => sum! + (event.amount ?? 0),
        ) ??
        0;
  }

  // Get the next two upcoming events
List<EventExpense> getUpcomingEvents() {
  List<EventExpense> allUpcomingEvents = [];

  _eventExpenseMap.forEach((date, events) {
    if (date.isAfter(DateTime.now())) {
      allUpcomingEvents.addAll(events);
    }
  });

  // Sort events by date (earliest first) and take only 2
  allUpcomingEvents.sort((a, b) => a.date.compareTo(b.date));
  return allUpcomingEvents.take(2).toList();
}



 


}
