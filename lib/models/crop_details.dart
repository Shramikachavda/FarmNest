import 'package:uuid/uuid.dart';

var uuid = Uuid(); // UUID instance

class CropDetails {
  final String id; // Unique ID for each crop
  final String cropName;
  final String growthStage;
  final DateTime startDate;
  final DateTime harvesDate;
  final String location;
  final String location2;
  final String fertilizer;
  final String pesticide;

  /// 🔹 Constructor with UUID generation
  CropDetails({
    String? id, // Make ID optional
    required this.cropName,
    required this.growthStage,
    required this.startDate,
    required this.harvesDate,
    required this.location,
    required this.location2,
    required this.fertilizer,
    required this.pesticide,
  }) : id = id ?? uuid.v4(); // Generate UUID if not provided

  /// 🔹 Convert object to Map (for Firebase, Hive, or local storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include ID in the map
      'cropName': cropName,
      'growthStage': growthStage,
      'startDate': startDate.toIso8601String(), // Store as ISO string
      'harvesDate': harvesDate.toIso8601String(),
      'location': location,
      'location2': location2,
      'fertilizer': fertilizer,
      'pesticide': pesticide,
    };
  }

  /// 🔹 Create object from Map
  factory CropDetails.fromMap(Map<String, dynamic> map) {
    return CropDetails(
      id: map['id'], // Use existing ID
      cropName: map['cropName'] ?? '',
      growthStage: map['growthStage'] ?? '',
      startDate: DateTime.parse(map['startDate']),
      harvesDate: DateTime.parse(map['harvesDate']),
      location: map['location'] ?? '',
      location2: map['location2'] ?? '',
      fertilizer: map['fertilizer'] ?? '',
      pesticide: map['pesticide'] ?? '',
    );
  }

  /// 🔹 Convert object to JSON string
  String toJson() => toMap().toString();

  /// 🔹 Create object from JSON string
  factory CropDetails.fromJson(Map<String, dynamic> json) {
    return CropDetails.fromMap(json);
  }

  /// ✅ CopyWith method for easy updates
  CropDetails copyWith({
    String? cropName,
    String? growthStage,
    DateTime? startDate,
    DateTime? harvesDate,
    String? location,
    String? location2,
    String? fertilizer,
    String? pesticide,
  }) {
    return CropDetails(
      id: id, // Keep the same ID
      cropName: cropName ?? this.cropName,
      growthStage: growthStage ?? this.growthStage,
      startDate: startDate ?? this.startDate,
      harvesDate: harvesDate ?? this.harvesDate,
      location: location ?? this.location,
      location2: location2 ?? this.location2,
      fertilizer: fertilizer ?? this.fertilizer,
      pesticide: pesticide ?? this.pesticide,
    );
  }
}
