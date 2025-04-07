class FarmDetail {
  final String fieldName;
  final String ownershipType;
  final String cropDetails;
  final double fieldSize;
  final String state;
  final String locationDescription;
  final String farmersAllocated;
  final List<double> farmBoundaries; // e.g., [lat1, lng1, lat2, lng2, ...]

  FarmDetail({
    required this.fieldName,
    required this.ownershipType,
    required this.cropDetails,
    required this.fieldSize,
    required this.state,
    required this.locationDescription,
    required this.farmersAllocated,
    required this.farmBoundaries,
  });

  factory FarmDetail.fromJson(Map<String, dynamic> json) {
    return FarmDetail(
      fieldName: json['fieldName'] ?? '',
      ownershipType: json['ownershipType'] ?? '',
      cropDetails: json['cropDetails'] ?? '',
      fieldSize: (json['fieldSize'] ?? 0).toDouble(),
      state: json['state'] ?? '',
      locationDescription: json['locationDescription'] ?? '',
      farmersAllocated: json['farmersAllocated'] ?? '',
      farmBoundaries: json['farmBoundaries'] != null
          ? List<double>.from(json['farmBoundaries'].map((e) => e.toDouble()))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fieldName': fieldName,
      'ownershipType': ownershipType,
      'cropDetails': cropDetails,
      'fieldSize': fieldSize,
      'state': state,
      'locationDescription': locationDescription,
      'farmersAllocated': farmersAllocated,
      'farmBoundaries': farmBoundaries,
    };
  }
}
