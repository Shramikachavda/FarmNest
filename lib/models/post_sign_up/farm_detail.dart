import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FarmDetail {
  final String fieldName;
  final String ownershipType;
  final String cropDetails;
  final double fieldSize;
  final String state;
  final String locationDescription;
  final String farmersAllocated;
  final List<LatLongData> farmBoundaries; // e.g., [lat1, lng1, lat2, lng2, ...]

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
    print(json["farmBoundaries"]);
    return FarmDetail(
      fieldName: json['fieldName'] ?? '',
      ownershipType: json['ownershipType'] ?? '',
      cropDetails: json['cropDetails'] ?? '',
      fieldSize: (json['fieldSize'] ?? 0).toDouble(),
      state: json['state'] ?? '',
      locationDescription: json['locationDescription'] ?? '',
      farmersAllocated: json['farmersAllocated'] ?? '',
      farmBoundaries: json["farmBoundaries"] == null ? [] : List<LatLongData>.from(json["farmBoundaries"]!.map((x) => LatLongData.fromJson(x))),
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
      "farmBoundaries": farmBoundaries == null ? [] : List<dynamic>.from(farmBoundaries.map((x) => x.toJson())),
    };
  }

}

class LatLongData {
  double? lng;
  double? lat;

  LatLongData({
    this.lng,
    this.lat,
  });

  factory LatLongData.fromJson(Map<String, dynamic> json) => LatLongData(
    lng: json["lng"]?.toDouble(),
    lat: json["lat"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lng": lng,
    "lat": lat,
  };

  LatLng toLatLng() => LatLng(lat ?? 0.0, lng ?? 0.0);

}
