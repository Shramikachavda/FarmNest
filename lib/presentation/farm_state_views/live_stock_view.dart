import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/customs_widgets/custom_snackbar.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/core/drop_down_value.dart';
import 'package:agri_flutter/models/live_stock_detail.dart';
import 'package:agri_flutter/providers/farm_state_provider.dart/liveStock_provider.dart';
import 'package:agri_flutter/services/firestore_event_expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class LiveStockDetailView extends StatefulWidget {
  final String? livestockId; // Optional livestockId parameter

  const LiveStockDetailView({super.key, this.livestockId});

  @override
  State<LiveStockDetailView> createState() => _LiveStockDetailViewState();
}

class _LiveStockDetailViewState extends State<LiveStockDetailView> {
  final _livestockNameController = TextEditingController();
  LivestockType? selectedLivestockType;
  final _ageController = TextEditingController();
  final _vaccinationDateController = TextEditingController();
  Gender? selectedGender;
  final FirestoreService _firestoreService = FirestoreService();

  final dateFormat = DateFormat("dd-MM-yyyy");

  // Fetch and set the data if livestockId exists
  @override
  void initState() {
    super.initState();
    if (widget.livestockId != null) {
      _loadLivestockDetails();
    }
  }

  Future<void> _loadLivestockDetails() async {
    final livestockProvider = Provider.of<LivestockProvider>(
      context,
      listen: false,
    );
    final livestock = livestockProvider.liveStockList.firstWhere(
      (item) => item.id == widget.livestockId,
    );
    _livestockNameController.text = livestock.liveStockName;
    selectedLivestockType = LivestockType.values.firstWhere(
      (e) => e.name == livestock.liveStockLive,
    );
    _ageController.text = livestock.age.toString();
    _vaccinationDateController.text = dateFormat.format(
      livestock.vaccinatedDate,
    );
    selectedGender = Gender.values.firstWhere(
      (e) => e.name == livestock.gender,
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
    final livestockProvider = Provider.of<LivestockProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CustomFormField(
              hintText: "Enter Livestock Name",
              keyboardType: TextInputType.text,
              label: 'Livestock Name',
              textEditingController: _livestockNameController,
              icon: Icon(Icons.pets),
              validator: (p0) {
                if (p0 == null || p0.isEmpty) {
                  return "Please enter Livestock name";
                }
                return null;
              },
            ),
            reusableDropdown<LivestockType>(
              label: "Livestock Type",
              selectedValue: selectedLivestockType,
              items: LivestockType.values,
              onChanged: (newValue) {
                setState(() {
                  selectedLivestockType = newValue;
                });
              },
            ),
            reusableDropdown<Gender>(
              label: "Gender",
              selectedValue: selectedGender,
              items: Gender.values,
              onChanged: (newValue) {
                setState(() {
                  selectedGender = newValue;
                });
              },
            ),
            CustomFormField(
              hintText: "Enter Age",
              keyboardType: TextInputType.number,
              label: 'Age',
              textEditingController: _ageController,
              icon: Icon(Icons.numbers),
            ),
            CustomFormField(
              textEditingController: _vaccinationDateController,
              label: "Vaccination Date",
              hintText: "DD-MM-YYYY",
              keyboardType: TextInputType.none,
              isDatePicker: true,
            ),
            CustomButton(
              onClick: () {
                if (widget.livestockId != null) {
                  // If livestockId exists, update the livestock details
                  livestockProvider.updateLivestock(
                    _firestoreService.userId,
                    LiveStockDetail(
                      id: widget.livestockId!,
                      liveStockName: _livestockNameController.text,
                      liveStockLive: selectedLivestockType?.name ?? "Unknown",
                      gender: selectedGender?.name ?? "Unknown",
                      age: int.tryParse(_ageController.text) ?? 0,
                      vaccinatedDate:
                          parseDate(_vaccinationDateController.text) ??
                          DateTime.now(),
                    ),
                  ).then((value) {
                        showCustomSnackBar(
                          context,
                          " Livestock updated successfully",
                        );
                      });
                } else {
                  // If no livestockId, add a new livestock
                  livestockProvider.addLiveStock(
                    LiveStockDetail(
                      liveStockName: _livestockNameController.text,
                      liveStockLive: selectedLivestockType?.name ?? "Unknown",
                      gender: selectedGender?.name ?? "Unknown",
                      age: int.tryParse(_ageController.text) ?? 0,
                      vaccinatedDate:
                          parseDate(_vaccinationDateController.text) ??
                          DateTime.now(),
                    ),
                  ) .then((value) {
                        showCustomSnackBar(
                          context,
                          " Livestock added successfully",
                        );
                      });
                }
              },
              buttonName:
                  widget.livestockId == null
                      ? 'Save Details'
                      : 'Update Details',
            ),
          ],
        ),
      ),
    );
  }
}
