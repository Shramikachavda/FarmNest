import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class AddFarmerDetailsScreen extends StatefulWidget {
  const AddFarmerDetailsScreen({super.key});

  @override
  State<AddFarmerDetailsScreen> createState() => _AddFarmerDetailsScreenState();
}

class _AddFarmerDetailsScreenState extends State<AddFarmerDetailsScreen> {
  final _farmerNameController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _landmarkController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final FirebaseFirestore _db =
      FirebaseFirestore.instance; // Firestore instance
  String? _userId =
      FirebaseAuth.instance.currentUser?.uid; // Get current user ID
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Ensure controllers are initialized (though they are by default with TextEditingController)
  }

  // Function to pick location based on landmark
  Future<void> _pickLocationFromLandmark() async {
    if (_landmarkController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a landmark first.")),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);
      List<Location> locations = await locationFromAddress(
        _landmarkController.text,
      );
      if (locations.isNotEmpty) {
        final location = locations.first;
        _addressLine1Controller.text =
            "${location.latitude}, ${location.longitude}";
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No location found for this landmark.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error picking location: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Function to save farmer details to Firestore
  Future<void> _saveFarmerDetails() async {
    if (_farmerNameController.text.isEmpty ||
        _addressLine1Controller.text.isEmpty ||
        _addressLine2Controller.text.isEmpty ||
        _contactNumberController.text.isEmpty) {
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
      await _db.collection('users').doc(_userId).set({
        'farmerName': _farmerNameController.text,
        'addressLine1': _addressLine1Controller.text,
        'addressLine2': _addressLine2Controller.text,
        'landmark': _landmarkController.text,
        'contactNumber': _contactNumberController.text,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Farmer details saved successfully!")),
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
    _farmerNameController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _landmarkController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 24.0,
          ), // Fixed padding
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
                    "2/3",
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              const Text(
                "Add Farmer Details",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                "This detailed address will help you manage and track resources allocated.",
                style: TextStyle(color: Colors.white70, fontSize: 14.0),
              ),
              const SizedBox(height: 24.0),
              CustomFormField(
                hintText: 'Enter your farmer name',
                keyboardType: TextInputType.name,
                label: 'Farmer Name',
                textEditingController: _farmerNameController,
              ),
              const SizedBox(height: 16.0),
              CustomFormField(
                hintText: 'House / Flat / Block No.',
                keyboardType: TextInputType.text,
                label: 'Address Line 1',
                textEditingController: _addressLine1Controller,
              ),
              const SizedBox(height: 16.0),
              CustomFormField(
                hintText: 'Apartment / Road / Area',
                keyboardType: TextInputType.text,
                label: 'Address Line 2',
                textEditingController: _addressLine2Controller,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: CustomFormField(
                      hintText: 'Pick your address',
                      keyboardType: TextInputType.text,
                      label: 'Landmark',
                      textEditingController: _landmarkController,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  IconButton(
                    icon: const Icon(Icons.location_on, color: Colors.green),
                    onPressed: _pickLocationFromLandmark,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              CustomFormField(
                hintText: '+91 98xxxxxxx00',
                keyboardType: TextInputType.phone,
                label: 'Contact Number',
                textEditingController: _contactNumberController,
              ),
              const SizedBox(height: 16.0),
              const Text(
                "Save your farmer's information so you can keep track of the farm they are assigned to.",
                style: TextStyle(color: Colors.white70, fontSize: 12.0),
              ),
              const SizedBox(height: 24.0),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                    onClick: () {
                      _saveFarmerDetails();
                    },
                    buttonName: "Save and Proceed ",
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
