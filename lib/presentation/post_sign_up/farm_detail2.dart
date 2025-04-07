/*import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:flutter/material.dart';

class FarmDetail2 extends BaseStatefulWidget {
  const FarmDetail2({super.key});

  @override
  State<FarmDetail2> createState() => _FarmDetail2State();
}

class _FarmDetail2State extends State<FarmDetail2> {
  final TextEditingController _farmController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Column(
          children: [
            CustomFormField(
              hintText: "Enter your farm field name",
              keyboardType: TextInputType.text,
              label: "Field name",
              textEditingController: _farmController,
            ),
          ],
        ),
      ),
    );
  }
} */

import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/widgets/BaseStateFullWidget.dart';

class AddFarmFieldLocationScreen extends BaseStatefulWidget {
  const AddFarmFieldLocationScreen({super.key});

  @override
  State<AddFarmFieldLocationScreen> createState() =>
      _AddFarmFieldLocationScreenState();

  @override
  Route buildRoute() {
    return materialRoute();
  }

  static const String route = "/AddFarmFieldLocationScreen";

  @override
  String get routeName => route;
}

class _AddFarmFieldLocationScreenState
    extends State<AddFarmFieldLocationScreen> {
  final _fieldNameController = TextEditingController();
  final _ownershipTypeController = TextEditingController();
  final _cropDetailsController = TextEditingController();
  final _fieldSizeController = TextEditingController();
  final _stateController = TextEditingController();
  final _locationDescriptionController = TextEditingController();
  final _farmersAllocatedController = TextEditingController();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? _userId = FirebaseAuth.instance.currentUser?.uid;
  bool _isLoading = false;

  // Store selected farm boundaries (list of LatLng)
  List<LatLng> _farmBoundaries = [];
  late GoogleMapController _mapController;
  LatLng _currentPosition = const LatLng(
    20.5937,
    78.9629,
  ); // Default to India center

  // Function to open map for boundary selection
  void _selectFarmBoundaries() {
    showDialog(
      context: context,
      builder:
          (context) =>
          AlertDialog(
            backgroundColor: Colors.black,
            title: const Text(
              "Select Farm Boundaries",
              style: TextStyle(color: Colors.white),
            ),
            content: SizedBox(
              height: 400,
              width: 300,
              child: Stack(
                children: [
                  GoogleMap(
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition,
                      zoom: 10,
                    ),
                    onTap: (position) {
                      setState(() {
                        _farmBoundaries.add(position);
                      });
                    },
                    polygons: {
                      Polygon(
                        polygonId: const PolygonId('farmBoundary'),
                        points: _farmBoundaries,
                        fillColor: Colors.green.withOpacity(0.3),
                        strokeColor: Colors.green,
                        strokeWidth: 2,
                      ),
                    },
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      color: Colors.black54,
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search Store',
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(color: Colors.white),
                        onSubmitted: (value) async {
                          try {
                            List<Location> locations =
                            await locationFromAddress(value);
                            if (locations.isNotEmpty) {
                              final location = locations.first;
                              _currentPosition = LatLng(
                                location.latitude,
                                location.longitude,
                              );
                              _mapController.animateCamera(
                                CameraUpdate.newLatLng(_currentPosition),
                              );
                              setState(() {});
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error searching: $e")),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text("Start Mapping"),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Save And Proceed",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
    );
  }

  // Function to save farm details to Firestore
  Future<void> _saveFarmDetails() async {
    if (_fieldNameController.text.isEmpty ||
        _ownershipTypeController.text.isEmpty ||
        _cropDetailsController.text.isEmpty ||
        _fieldSizeController.text.isEmpty ||
        _stateController.text.isEmpty ||
        _locationDescriptionController.text.isEmpty ||
        _farmersAllocatedController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields.")));
      return;
    }

    if (_userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User not authenticated.")));
      return;
    }

    try {
      setState(() => _isLoading = true);
      await _db.collection('users').doc(_userId).collection('farms').add({
        'fieldName': _fieldNameController.text,
        'ownershipType': _ownershipTypeController.text,
        'cropDetails': _cropDetailsController.text,
        'fieldSize': _fieldSizeController.text,
        'state': _stateController.text,
        'locationDescription': _locationDescriptionController.text,
        'farmersAllocated': _farmersAllocatedController.text,
        'farmBoundaries':
        _farmBoundaries
            .map(
              (latLng) => {'lat': latLng.latitude, 'lng': latLng.longitude},
        )
            .toList(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Farm details saved successfully!")),
      );
      Navigator.pushReplacementNamed(
        context,
        '/next-screen',
      ); // Replace with your route
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to save: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _fieldNameController.dispose();
    _ownershipTypeController.dispose();
    _cropDetailsController.dispose();
    _fieldSizeController.dispose();
    _stateController.dispose();
    _locationDescriptionController.dispose();
    _farmersAllocatedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/home',
                      ); // Replace with your route
                    },
                    child: const Text(
                      "Skip",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  const Text(
                    "3/3",
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              const Text(
                "Add Farms Field Location",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                "This detailed information will help our soil tester partner reach your farm easily.",
                style: TextStyle(color: Colors.white70, fontSize: 14.0),
              ),
              const SizedBox(height: 24.0),
              CustomFormField(
                hintText: 'Enter your farm field name',
                keyboardType: TextInputType.text,
                label: 'Field Name',
                textEditingController: _fieldNameController,
              ),
              const SizedBox(height: 16.0),
              CustomFormField(
                hintText: 'Select the ownership type',
                keyboardType: TextInputType.text,
                label: 'Ownership Type',
                textEditingController: _ownershipTypeController,
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: _selectFarmBoundaries,
                child: IgnorePointer(
                  child: CustomFormField(
                    hintText: 'Select boundaries from map',
                    keyboardType: TextInputType.text,
                    label: 'Farm Boundaries',
                    textEditingController: TextEditingController(
                      text:
                      _farmBoundaries.isNotEmpty
                          ? 'Boundaries selected'
                          : '',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              CustomFormField(
                hintText: 'Crop details cultivating in field',
                keyboardType: TextInputType.text,
                label: 'Crop Details',
                textEditingController: _cropDetailsController,
              ),
              const SizedBox(height: 16.0),
              CustomFormField(
                hintText: 'Field size in sq.m',
                keyboardType: TextInputType.number,
                label: 'Field Size',
                textEditingController: _fieldSizeController,
              ),
              const SizedBox(height: 16.0),
              CustomFormField(
                hintText: 'State where the field is situated',
                keyboardType: TextInputType.text,
                label: 'State',
                textEditingController: _stateController,
              ),
              const SizedBox(height: 16.0),
              CustomFormField(
                hintText: 'Description to reach your field',
                keyboardType: TextInputType.text,
                label: 'Location Description',
                textEditingController: _locationDescriptionController,
              ),
              const SizedBox(height: 16.0),
              CustomFormField(
                hintText: 'Select the farmers allocated',
                keyboardType: TextInputType.text,
                label: 'Farmers Allocated',
                textEditingController: _farmersAllocatedController,
              ),
              const SizedBox(height: 24.0),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                child: ElevatedButton(
                  onPressed: _saveFarmDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 12.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                  child: const Text(
                    "Save And Proceed",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
