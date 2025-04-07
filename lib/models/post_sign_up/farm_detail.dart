class FarmDetail {
  final String fieldName;
  final String ownershipType;
  final String cropDetails;
  final double fieldSize;
  final String state;
  final String locationDescription;
  final String farmersAllocated; // Consider int or List<String> if needed
//  final double farmBoundaries;   // Consider using List<LatLng> or a complex object if it's geo-boundary
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
      farmBoundaries: (json['farmBoundaries'] ?? 0).toDouble(),
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
