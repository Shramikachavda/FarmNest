class CropDetails {
  final String id;
  final String cropName;
  final String growthStage;
  final DateTime startDate;
  final DateTime harvestDate;
  final String? location;
  final String fertilizer;
  final String pesticide;
  final String? temperature;
  final String? humidity;
  
  final String? aiRecommendations;

  CropDetails({
    required this.id,
    required this.cropName,
    required this.growthStage,
    required this.startDate,
    required this.harvestDate,
    this.location,
    required this.fertilizer,
    required this.pesticide,
    this.temperature,
    this.humidity,

    this.aiRecommendations,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cropName': cropName,
      'growthStage': growthStage,
      'startDate': startDate.toIso8601String(),
      'harvestDate': harvestDate.toIso8601String(),
      'location': location,
      'fertilizer': fertilizer,
      'pesticide': pesticide,
      'temperature': temperature,
      'humidity': humidity,

      'aiRecommendations': aiRecommendations,
    };
  }

  factory CropDetails.fromMap(Map<String, dynamic> map) {
    return CropDetails(
      id: map['id'] ?? '',
      cropName: map['cropName'] ?? '',
      growthStage: map['growthStage'] ?? '',
      startDate: DateTime.tryParse(map['startDate'] ?? '') ?? DateTime.now(),
      harvestDate:
          DateTime.tryParse(map['harvestDate'] ?? '') ?? DateTime.now(),
      location: map['location'] as String?,
      fertilizer: map['fertilizer'] as String,
      pesticide: map['pesticide'] as String,
      temperature: map['temperature'] as String?,
      humidity: map['humidity'] as String?,

      aiRecommendations: map['aiRecommendations'] as String?,
    );
  }
}
