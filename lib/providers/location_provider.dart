import 'package:agri_flutter/services/location.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';


class LocationProvider with ChangeNotifier {
  final LocationService _locationRepository = LocationService();
  double? latitude;
  double? longitude;
  String? _currentAddress;



  String? get currentAddress => _currentAddress;

  Future<void> getLocation() async {
    Map<String, double>? location = await _locationRepository.fetchLocation();
    if (location != null &&  location['latitude'] != null &&
    location['longitude'] != null) {
      latitude = location['latitude'];
      longitude = location['longitude'];
      await _fetchAddressFromLatLng(latitude!, longitude!);
      notifyListeners(); // Notify UI when data updates
    }
  }

  Future<void> _fetchAddressFromLatLng(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        _currentAddress = "${placemark.locality}, ${placemark.administrativeArea}";
      }
    } catch (e) {
      print("Error getting address: $e");
    }
  }
}
