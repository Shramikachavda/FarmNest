import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/customs_widgets/custom_snackbar.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/core/drop_down_value.dart';
import 'package:agri_flutter/models/crop_details.dart';

import 'package:agri_flutter/providers/farm_state_provider.dart/crop_details_provider.dart';
import 'package:agri_flutter/services/firestore_event_expense.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class CropDetailView extends StatefulWidget {
  final String? cropId; // Optional cropId parameter

  const CropDetailView({super.key, this.cropId});

  @override
  State<CropDetailView> createState() => _CropDetailViewState();
}

class _CropDetailViewState extends State<CropDetailView> {
  final _cropNameController = TextEditingController();
  GrowthStage? selectedStage;
  final _seedDateController = TextEditingController();
  final _harvestDateController = TextEditingController();
  final _addressOneController = TextEditingController();
  final _addressTwoController = TextEditingController();
  PesticideType? selectedPesticide;
  FertilizerType? selectedFertilizer;

  final dateFormat = DateFormat("dd-MM-yyyy");
  final FirestoreService _firestoreService = FirestoreService();

  // Fetch and set the data if cropId exists
  @override
  void initState() {
    super.initState();
    if (widget.cropId != null) {
      _loadCropDetails();
    }
  }

  Future<void> _loadCropDetails() async {
    final cropProvider = Provider.of<CropDetailsProvider>(
      context,
      listen: false,
    );
    final crop = cropProvider.allCropList.firstWhere(
      (crop) => crop.id == widget.cropId,
    );
    _cropNameController.text = crop.cropName;
    selectedStage = GrowthStage.values.firstWhere(
      (e) => e.name == crop.growthStage,
    );
    _seedDateController.text = dateFormat.format(crop.startDate);
    _harvestDateController.text = dateFormat.format(crop.harvesDate);
    _addressOneController.text = crop.location;
    _addressTwoController.text = crop.location2;
    selectedFertilizer = FertilizerType.values.firstWhere(
      (e) => e.name == crop.fertilizer,
    );
    selectedPesticide = PesticideType.values.firstWhere(
      (e) => e.name == crop.pesticide,
    );
  }

  DateTime? parseDate(String dateText) {
    try {
      return dateFormat.parse(dateText);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cropProvider = Provider.of<CropDetailsProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CustomFormField(
              hintText: "Enter Crop Name",
              keyboardType: TextInputType.text,
              label: 'Crop Name',
              textEditingController: _cropNameController,
              icon: Icon(Icons.grass),
              validator: (p0) {
                if (p0 == null || p0.isEmpty) {
                  return "Please enter Crop name";
                }
                return null;
              },
            ),
            reusableDropdown<GrowthStage>(
              label: "Growth Stage",
              selectedValue: selectedStage,
              items: GrowthStage.values,
              onChanged: (newValue) {
                setState(() {
                  selectedStage = newValue;
                });
              },
            ),
            CustomFormField(
              textEditingController: _seedDateController,
              label: "Seeding Date",
              hintText: "DD-MM-YYYY",
              keyboardType: TextInputType.none,
              isDatePicker: true,
            ),
            CustomFormField(
              textEditingController: _harvestDateController,
              label: "Harvest Date",
              hintText: "DD-MM-YYYY",
              keyboardType: TextInputType.none,
              isDatePicker: true,
            ),
            CustomFormField(
              hintText: "Enter farm location",
              keyboardType: TextInputType.text,
              label: 'Farm Location 1',
              textEditingController: _addressOneController,
              icon: Icon(Icons.location_on),
            ),
            CustomFormField(
              hintText: "Enter additional location",
              keyboardType: TextInputType.text,
              label: 'Farm Location 2',
              textEditingController: _addressTwoController,
              icon: Icon(Icons.location_on),
            ),
            reusableDropdown<FertilizerType>(
              label: "Fertilizer",
              selectedValue: selectedFertilizer,
              items: FertilizerType.values,
              onChanged: (newValue) {
                setState(() {
                  selectedFertilizer = newValue;
                });
              },
            ),
            reusableDropdown<PesticideType>(
              label: "Pesticide",
              selectedValue: selectedPesticide,
              items: PesticideType.values,
              onChanged: (newValue) {
                setState(() {
                  selectedPesticide = newValue;
                });
              },
            ),
            CustomButton(
              onClick: () {
                if (widget.cropId != null) {
                  // If cropId exists, update the crop details
                  cropProvider
                      .updateCrop(
                        _firestoreService.userId,
                        CropDetails(
                          id: widget.cropId!,
                          cropName: _cropNameController.text,
                          growthStage: selectedStage?.name ?? "Unknown",
                          startDate:
                              parseDate(_seedDateController.text) ??
                              DateTime.now(),
                          harvesDate:
                              parseDate(_harvestDateController.text) ??
                              DateTime.now(),
                          location: _addressOneController.text,
                          location2: _addressTwoController.text,
                          fertilizer: selectedFertilizer?.name ?? "None",
                          pesticide: selectedPesticide?.name ?? "None",
                        ),
                      )
                      .then((value) {
                        showCustomSnackBar(
                          context,
                          " Crop updated successfully",
                        );
                      });
                } else {
                  // If no cropId, add a new crop

                  cropProvider
                      .addCrop(
                        CropDetails(
                          cropName: _cropNameController.text,
                          growthStage: selectedStage?.name ?? "Unknown",
                          startDate:
                              parseDate(_seedDateController.text) ??
                              DateTime.now(),
                          harvesDate:
                              parseDate(_harvestDateController.text) ??
                              DateTime.now(),
                          location: _addressOneController.text,
                          location2: _addressTwoController.text,
                          fertilizer: selectedFertilizer?.name ?? "None",
                          pesticide: selectedPesticide?.name ?? "None",
                        ),
                      )
                      .then((value) {
                        showCustomSnackBar(context, " Crop added successfully");
                      });
                }
              },
              buttonName:
                  widget.cropId == null ? 'Save Details' : 'Update Details',
            ),
          ],
        ),
      ),
    );
  }
}
