import 'package:agri_flutter/models/event_expense.dart';
import 'package:agri_flutter/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EventExpenseProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<EventExpense> _events = [];
  List<EventExpense> _expenses = [];

  List<EventExpense> get events => _events;
  List<EventExpense> get expenses => _expenses;

  /// **Fetch All Events and Expenses from Firestore (One-time Fetch)**
  Future<void> fetchAllData() async {
    try {
      _events = await _firestoreService.getEventsOnce();
      _expenses = await _firestoreService.getExpensesOnce();
      notifyListeners();
    } catch (e) {
      throw Exception("Failed to fetch data: $e");
    }
  }

  /// **Get Combined Events & Expenses List**
  List<EventExpense> get allEventsAndExpenses => [..._events, ..._expenses];

  /// **Get Events & Expenses for a Specific Date**
  List<EventExpense> getEventsAndExpensesForDate(DateTime date) {
    return allEventsAndExpenses
        .where((event) => isSameDay(event.date, date))
        .toList();
  }

  /// **Add Event or Expense**
  Future<void> addEventExpense(EventExpense event) async {
    try {
      if (event.type == "Expense") {
        await _firestoreService.addExpense(event);
      } else {
        await _firestoreService.addEvent(event);
      }
      // Fetch the latest data after adding
      await fetchAllData();
    } catch (e) {
      throw Exception("Failed to add event/expense: $e");
    }
  }

  /// **Remove Event or Expense**
  Future<void> removeEventExpense(EventExpense event) async {
    try {
      if (event.type == "Expense") {
        await _firestoreService.deleteExpense(event.id);
      } else {
        await _firestoreService.deleteEvent(event.id);
      }
      // Fetch the latest data after deleting
      await fetchAllData();
    } catch (e) {
      throw Exception("Failed to remove event/expense: $e");
    }
  }
}