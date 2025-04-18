import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/services/location.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../models/post_sign_up/farm_detail.dart';
import '../../providers/map.dart';

class SelectBoundaryScreen extends StatefulWidget {
  const SelectBoundaryScreen({super.key});

  @override
  State<SelectBoundaryScreen> createState() => _SelectBoundaryScreenState();
}

class _SelectBoundaryScreenState extends State<SelectBoundaryScreen> {
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _boundaryController = TextEditingController();
  final FocusNode _focusNodeSearch = FocusNode();
  final FocusNode _focusNodeBoundary = FocusNode();
  final LocationService _locationService = LocationService();
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadInitialData() async {
    await _getCurrentLocation();
    await _centerMapOnBoundary();
  }

  Future<void> _getCurrentLocation() async {
    final location = await _locationService.fetchLocation();
    if (location != null) {
      _currentLocation = LatLng(location.latitude ?? 0 , location.longitude ?? 0);
    }
  }

  Future<void> _centerMapOnBoundary() async {
    final boundaryProvider = Provider.of<BoundaryProvider>(context, listen: false);
    if (boundaryProvider.selectedBoundary.isNotEmpty) {
      final bounds = _calculateBounds(boundaryProvider.selectedBoundary);
      await _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      _updateBoundaryCoordinates(boundaryProvider.selectedBoundary);
    } else if (_currentLocation != null) {
      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 15),
      );
    }
  }

  LatLngBounds _calculateBounds(List<LatLng> points) {
    double minLat = points[0].latitude;
    double maxLat = points[0].latitude;
    double minLng = points[0].longitude;
    double maxLng = points[0].longitude;

    for (var point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Future<void> _searchLocation(String locationName) async {
    if (locationName.isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress(locationName);
      if (locations.isNotEmpty) {
        final location = locations.first;
        await _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(location.latitude, location.longitude),
            17,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Location not found: $e")),
      );
    }
  }

  void _updateBoundaryCoordinates(List<LatLng> points) {
    final coordinates = points
        .map((point) =>
    '[${point.latitude.toStringAsFixed(6)}, ${point.longitude.toStringAsFixed(6)}]')
        .join(', ');
    _boundaryController.text = coordinates;
  }

  @override
  Widget build(BuildContext context) {
    final boundaryProvider = Provider.of<BoundaryProvider>(context);

    return FutureBuilder(
      future: _loadInitialData(),
      builder: (context, snapshot) {


        return Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                mapType: MapType.satellite,
                initialCameraPosition: CameraPosition(
                  target: _currentLocation ?? const LatLng(0, 0),
                  zoom: 15,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                markers: boundaryProvider.selectedBoundary
                    .map(
                      (point) => Marker(
                    markerId: MarkerId(point.toString()),
                    position: point,
                  ),
                )
                    .toSet(),
                polygons: {
                  if (boundaryProvider.selectedBoundary.length >= 3)
                    Polygon(
                      polygonId: const PolygonId('boundary'),
                      points: boundaryProvider.selectedBoundary,
                      strokeColor: Colors.green,
                      strokeWidth: 2,
                      fillColor: themeColor(context: context).primary,
                    ),
                },
                onTap: (LatLng position) async {
                  boundaryProvider.addPoint(position);
                  _updateBoundaryCoordinates(boundaryProvider.selectedBoundary);
                },
              ),
              Positioned(
                top: 40.h,
                left: 16.w,
                right: 16.w,
                child: Material(
                  borderRadius: BorderRadius.circular(12.r),
                  child: CustomFormField(
                    hintText: 'Search location...',
                    keyboardType: TextInputType.text,
                    label: "Search location",
                    textEditingController: _searchController,
                    focusNode: _focusNodeSearch,
                    textInputAction: TextInputAction.search,
                    icon: IconButton(
                      onPressed: () {
                        _searchLocation(_searchController.text);
                        FocusScope.of(context).unfocus();
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomSheet: Container(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomFormField(
                  readOnly: true,
                  hintText: 'Select boundaries from map',
                  keyboardType: TextInputType.text,
                  label: "Farm Boundaries",
                  textEditingController: _boundaryController,
                  focusNode: _focusNodeBoundary,
                  textInputAction: TextInputAction.done,
                  icon: const Icon(Icons.map),
                ),
                SizedBox(height: 24.h),
                CustomButton(
                  onClick: () {
                    if (boundaryProvider.selectedBoundary.length >= 4) {
                      final List<LatLongData> boundary = boundaryProvider.selectedBoundary.map((e) {
                        return LatLongData(lat: e.latitude, lng: e.longitude);
                      }).toList();

                      Navigator.pop(context, boundary);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Select at least 4 boundary points"),
                        ),
                      );
                    }
                  },
                  buttonName: "Save and proceed",
                ),
              ],
            ),
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 80.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton.extended(
                  onPressed: () {
                    boundaryProvider.clearBoundary();
                    _boundaryController.clear();
                    _centerMapOnBoundary();
                  },
                  label: const Text("Refresh"),
                  icon: const Icon(Icons.refresh),
                ),
                FloatingActionButton.extended(
                  onPressed: () async {
                    await _getCurrentLocation();
                    if (_currentLocation != null) {
                      await _mapController?.animateCamera(
                        CameraUpdate.newLatLngZoom(_currentLocation!, 15),
                      );
                    }
                  },
                  label: const Text("Current Location"),
                  icon: const Icon(Icons.my_location),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    _boundaryController.dispose();
    _focusNodeSearch.dispose();
    _focusNodeBoundary.dispose();
    super.dispose();
  }
}