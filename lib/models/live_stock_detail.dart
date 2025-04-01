import 'package:uuid/uuid.dart';

class LiveStockDetail {
  final String id;
  final String liveStockName;
  final String liveStockLive;
  final String gender;
  final int age;
  final DateTime vaccinatedDate;

  // ✅ Generate a unique ID using UUID package
  LiveStockDetail({
    String? id, // Allow passing an ID, otherwise generate a new one
    required this.liveStockName,
    required this.liveStockLive,
    required this.gender,
    required this.age,
    required this.vaccinatedDate,
  }) : id = id ?? const Uuid().v4(); // Generate UUID if not provided

  // ✅ Factory Constructor to create object from Map (for Firestore, SQLite, etc.)
  factory LiveStockDetail.fromMap(Map<String, dynamic> map) {
    return LiveStockDetail(
      id: map['id'] ?? const Uuid().v4(), // Ensure ID is always available
      liveStockName: map['liveStockName'] ?? '',
      liveStockLive: map['liveStockLive'] ?? '',
      gender: map['gender'] ?? '',
      age: map['age'] ?? 0,
      vaccinatedDate: DateTime.parse(map['vaccinatedDate'] ?? DateTime.now().toIso8601String()), // Handle date conversion
    );
  }

  // ✅ Convert Object to Map (for Firestore, SQLite, etc.)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'liveStockName': liveStockName,
      'liveStockLive': liveStockLive,
      'gender': gender,
      'age': age,
      'vaccinatedDate': vaccinatedDate.toIso8601String(), // Convert DateTime to String for Firestore
    };
  }

  // ✅ CopyWith method for easy updates
  LiveStockDetail copyWith({
    String? liveStockName,
    String? liveStockLive,
    String? gender,
    int? age,
    DateTime? vaccinatedDate,
  }) {
    return LiveStockDetail(
      id: id, // Keep the same ID
      liveStockName: liveStockName ?? this.liveStockName,
      liveStockLive: liveStockLive ?? this.liveStockLive,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      vaccinatedDate: vaccinatedDate ?? this.vaccinatedDate,
    );
  }

}
