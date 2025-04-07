import 'package:google_maps_flutter/google_maps_flutter.dart';

class FarmerAddress {
  final String name;
  final String addressLine1;
  final String addressLine2;
  final LatLng? landMark;
  final int phoneNum;

  FarmerAddress({
    required this.name,
    required this.addressLine1,
    required this.addressLine2,
    this.landMark,
    required this.phoneNum,
  });

  factory FarmerAddress.fromJson(Map<String, dynamic> json) {
    return FarmerAddress(
      name: json['name'] ?? '',
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'] ?? '',
      phoneNum: json['phoneNum'] ?? 0,
      landMark: json['landMark'] != null
          ? LatLng(
        json['landMark']['lat'],
        json['landMark']['lng'],
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'phoneNum': phoneNum,
      'landMark': landMark != null
          ? {
        'lat': landMark!.latitude,
        'lng': landMark!.longitude,
      }
          : null,
    };
  }
}
