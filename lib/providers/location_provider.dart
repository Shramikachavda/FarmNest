import 'package:agri_flutter/services/location.dart';
import 'package:flutter/material.dart';


class LocationProvider with ChangeNotifier {
  final LocationService _locationRepository = LocationService();
  double? latitude;
  double? longitude;

  Future<void> getLocation() async {
    Map<String, double>? location = await _locationRepository.fetchLocation();
    if (location != null) {
      latitude = location['latitude'];
      longitude = location['longitude'];
      notifyListeners(); // Notify UI when data updates
    }
  }
}
