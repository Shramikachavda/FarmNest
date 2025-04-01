import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart'; // Add uuid package for generating unique IDs

class EventExpense {
  final String id;
  final String title;
  final double? amount; // Nullable for events
  final String category;
  final DateTime date;
  final String type; // "Event" or "Expense"
   DateTime? reminder; // New Field for Reminders

  EventExpense({
    String? id,
    required this.title,
    this.amount,
    required this.category,
    required this.date,
     this.reminder,
    required this.type,
  }) : id = id ?? const Uuid().v4(); // Generate a unique ID if not provided

  // Convert EventExpense to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': Timestamp.fromDate(date), // Convert DateTime to Firestore Timestamp
      'type': type,
       'reminder': reminder?.toIso8601String(),
    };
  }

  // Create EventExpense from Firestore JSON
  factory EventExpense.fromJson(Map<String, dynamic> json) {
    return EventExpense(
      id: json['id'],
      title: json['title'],
      amount: json['amount']?.toDouble(),
      category: json['category'],
      date: (json['date'] as Timestamp).toDate(), // Convert Timestamp to DateTime
      type: json['type'],
         reminder: json['reminder'] != null ? DateTime.parse(json['reminder']) : null,
    );
  }
}