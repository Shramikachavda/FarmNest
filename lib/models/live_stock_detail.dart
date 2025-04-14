import 'package:uuid/uuid.dart';

class LiveStockDetail {
  final String id;
  final String liveStockName;
  final String liveStockType;
  final String gender;
  final int age;
  final DateTime vaccinatedDate;
  final String? aiRecommendations;
  final String purpose;


  LiveStockDetail({
    String? id,
    required this.liveStockName,
    required this.liveStockType,
    required this.gender,
    required this.age,
    required this.vaccinatedDate,
    this.aiRecommendations,
    required  this.purpose ,
  }) : id = id ?? const Uuid().v4();


  factory LiveStockDetail.fromMap(Map<String, dynamic> map) {
    return LiveStockDetail(
      purpose:map['purpose'] ,
      aiRecommendations:   map['aiRecommendations'] as String?,
      id: map['id'] ?? const Uuid().v4(), // Ensure ID is always available
      liveStockName: map['liveStockName'] ?? '',
    liveStockType: map['liveStockType'] ?? '',
      gender: map['gender'] ?? '',
      age: map['age'] ?? 0,
      vaccinatedDate: DateTime.parse(map['vaccinatedDate'] ?? DateTime.now().toIso8601String()), // Handle date conversion
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'liveStockName': liveStockName,
      'liveStockType': liveStockType,
      'gender': gender,
      'age': age,
      'vaccinatedDate': vaccinatedDate.toIso8601String(),
    "purpose" : purpose ,
      'aiRecommendations': aiRecommendations,


    };
  }


  LiveStockDetail copyWith({
    String? liveStockName,
    String? liveStockLive,
    String? gender,
    int? age,
    DateTime? vaccinatedDate,
    String? purpose ,
    String? aiRecommendations
  }) {
    return LiveStockDetail(
      id: id, // Keep the same ID
      liveStockName: liveStockName ?? this.liveStockName,
      liveStockType: liveStockLive ?? this.liveStockType,
      purpose: purpose ?? this.purpose,
      aiRecommendations: aiRecommendations ?? this.aiRecommendations ,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      vaccinatedDate: vaccinatedDate ?? this.vaccinatedDate,
    );
  }

}
