import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class FarmDetail {
  final String id;
  final String fieldName;
  final String ownershipType;
  final String cropDetails;
  final double fieldSize;
  final String state;
  final String locationDescription;
  final String farmersAllocated;
  final List<LatLongData> farmBoundaries;
  String? aiResponse;

  FarmDetail({
    String? id,
    required this.fieldName,
    required this.ownershipType,
    required this.cropDetails,
    required this.fieldSize,
    required this.state,
    required this.locationDescription,
    required this.farmersAllocated,
    required this.farmBoundaries,
    this.aiResponse ,
  }) : id = id ?? const Uuid().v4();

  factory FarmDetail.fromJson(Map<String, dynamic> json, {String? docId}) {
    return FarmDetail(
      id: docId ?? json['id'] ?? const Uuid().v4(),
      fieldName: json['fieldName'] ?? '',
      ownershipType: json['ownershipType'] ?? '',
      cropDetails: json['cropDetails'] ?? '',
      fieldSize: (json['fieldSize'] ?? 0).toDouble(),
      state: json['state'] ?? '',
      locationDescription: json['locationDescription'] ?? '',
      farmersAllocated: json['farmersAllocated'] ?? '',
      aiResponse: json['aiResponse'],
      farmBoundaries:
          json['farmBoundaries'] == null
              ? []
              : List<LatLongData>.from(
                json['farmBoundaries'].map((x) => LatLongData.fromJson(x)),
              ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fieldName': fieldName,
      'ownershipType': ownershipType,
      'cropDetails': cropDetails,
      'fieldSize': fieldSize,
      'state': state,
      'locationDescription': locationDescription,
      'farmersAllocated': farmersAllocated,
      'farmBoundaries': farmBoundaries.map((x) => x.toJson()).toList(),
      'aiResponse':aiResponse
    };
  }
}

class LatLongData {
  final double? lat;
  final double? lng;

  LatLongData({required this.lat, required this.lng});

  factory LatLongData.fromJson(Map<String, dynamic> json) => LatLongData(
    lat: json['lat']?.toDouble() ?? 0.0,
    lng: json['lng']?.toDouble() ?? 0.0,
  );

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};

  LatLng toLatLng() => LatLng(lat ?? 0.0, lng ?? 0.0);
}
