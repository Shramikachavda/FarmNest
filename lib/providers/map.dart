import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BoundaryProvider with ChangeNotifier {
  final List<LatLng> _selectedBoundary = [];

  List<LatLng> get selectedBoundary => _selectedBoundary;

  void addPoint(LatLng point) {
    _selectedBoundary.add(point);
    notifyListeners();
  }

  void clearBoundary() {
    _selectedBoundary.clear();
    notifyListeners();
  }

  List<double> toLatLngListDouble() {
    return _selectedBoundary.expand((latlng) => [latlng.latitude, latlng.longitude]).toList();
  }
}
