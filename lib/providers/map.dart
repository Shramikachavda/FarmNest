



import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/post_sign_up/farm_detail.dart';
import '../services/firestore.dart';

class BoundaryProvider with ChangeNotifier {
  final List<LatLng> _selectedBoundary = [];

  List<LatLng> get selectedBoundary => _selectedBoundary;

  void addPoint(LatLng point) {
    _selectedBoundary.add(point);
    notifyListeners();
  }

  void updateAllPoints(List<LatLng> newPoints) {
    _selectedBoundary
      ..clear()
      ..addAll(newPoints);
    notifyListeners();
  }

  Future<void> updateFarmBoundary(String farmId) async {
    try {
      // Convert LatLng to LatLongData for Firestore update
      List<LatLongData> latLongDataList = _selectedBoundary.map((latLng) {
        return LatLongData(
          lat: latLng.latitude,
          lng: latLng.longitude,
        );
      }).toList();

      // Call your existing Firestore class to update the boundary
      await FirestoreService().updateFarmBoundary(farmId, latLongDataList);

      print('Farm boundary updated successfully!');
    } catch (e) {
      print('Error updating farm boundary: $e');
    }
  }
  void clearBoundary() {
    _selectedBoundary.clear();
    notifyListeners();
  }

  List<double> toLatLngListDouble() {
    return _selectedBoundary.expand((latlng) => [latlng.latitude, latlng.longitude]).toList();
  }
}
