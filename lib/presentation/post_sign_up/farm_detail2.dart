import 'package:agri_flutter/core/drop_down_value.dart';
import 'package:agri_flutter/core/widgets/BaseStateFullWidget.dart';
import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/models/post_sign_up/farm_detail.dart';
import 'package:agri_flutter/presentation/home_page_view/home_page.dart';
import 'package:agri_flutter/providers/post_sign_up_providers/default_farmer_address.dart';
import 'package:agri_flutter/services/firestore.dart';
import 'package:agri_flutter/services/local_storage/post_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'post_signup_screen.dart'; // Import for PostSignupNotifier

class AddFarmFieldLocationScreen extends BaseStatefulWidget {
  const AddFarmFieldLocationScreen({super.key});

  @override
  State<AddFarmFieldLocationScreen> createState() =>
      _AddFarmFieldLocationScreenState();

  @override
  Route buildRoute() => materialRoute();

  static const String route = "/AddFarmFieldLocationScreen";

  @override
  String get routeName => route;
}

class _AddFarmFieldLocationScreenState
    extends State<AddFarmFieldLocationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fieldNameController = TextEditingController();
  final TextEditingController _cropDetailsController = TextEditingController();
  final TextEditingController _fieldSizeController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _locationDescriptionController =
      TextEditingController();

  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeCropDetail = FocusNode();
  final FocusNode _focusNodeFieldSize = FocusNode();
  final FocusNode _focusNodeState = FocusNode();
  final FocusNode _focusNodeBoundary = FocusNode();
  final FocusNode _focusNodeLocation = FocusNode();

  FarmOwnershipType selctedOwnerShip = FarmOwnershipType.family;
  FarmersAllocated selectedFarmer = FarmersAllocated.one;
  List<double> _farmBoundaries = [];

  final FirestoreService _firestoreService = FirestoreService();

  Future<void> _submitFarmDetails() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _firestoreService.addFarm(
          FarmDetail(
            fieldName: _fieldNameController.text.trim(),
            ownershipType: selctedOwnerShip.name,
            farmBoundaries: _farmBoundaries,

            cropDetails: _cropDetailsController.text.trim(),
            fieldSize: double.tryParse(_fieldSizeController.text.trim()) ?? 0.0,
            state: _stateController.text.trim(),
            locationDescription: _locationDescriptionController.text.trim(),
            farmersAllocated: selectedFarmer.name,
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Farm details saved successfully")),
        );
final postSignupNotifier = context.read<PostSignupNotifier>();
await LocalStorageService.setPostSignupCompleted(); // to mark flow done
postSignupNotifier.completeSignupAndNavigate();

        // Signal to move to PostScreenDone
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("❌ Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              bodyLargeText("Add Farms Field Location"),
              SizedBox(height: 24.h),
              bodyText(
                "This detailed information will help our soil tester partner reach your farm easily.",
              ),
              SizedBox(height: 24.h),
              CustomFormField(
                focusNode: _focusNodeName,
                textInputAction: TextInputAction.next,
                hintText: 'Enter your farm field name',
                keyboardType: TextInputType.text,
                label: 'Field Name',
                textEditingController: _fieldNameController,
                validator:
                    (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Please enter field name'
                            : null,
              ),
              SizedBox(height: 24.h),
              reusableDropdown<FarmOwnershipType>(
                label: 'Ownership Type',
                selectedValue: selctedOwnerShip,
                items: FarmOwnershipType.values,
                onChanged: (FarmOwnershipType? value) {
                  setState(() {
                    selctedOwnerShip = value!;
                  });
                },
              ),
              SizedBox(height: 24.h),
              CustomFormField(
                focusNode: _focusNodeBoundary,

                hintText: 'Select boundaries from map',
                label: 'Farm Boundaries',
                textEditingController: TextEditingController(
                  text:
                      _farmBoundaries.isNotEmpty
                          ? _farmBoundaries.join(', ')
                          : '',
                ),
              /*  validator:
                    (value) =>
                        _farmBoundaries.isEmpty
                            ? 'Please select boundaries'
                            : null, */
                icon: IconButton(
                  onPressed: () async {
                    // TODO: Replace with your map picking logic
                    // Simulate boundaries like [22.5726, 88.3639]
                    final result = await Navigator.push<List<double>>(
                      context,
                      MaterialPageRoute(builder: (_) => HomePage()),
                    );

                    if (result != null) {
                      setState(() {
                        _farmBoundaries = result;
                      });
                    }
                  },
                  icon: Icon(Icons.map),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),

              SizedBox(height: 24.h),
              CustomFormField(
                focusNode: _focusNodeCropDetail,
                textInputAction: TextInputAction.next,
                hintText: 'Crop details cultivating in field',
                keyboardType: TextInputType.text,
                label: 'Crop Details',
                textEditingController: _cropDetailsController,
                validator:
                    (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Please enter crop details'
                            : null,
              ),
              SizedBox(height: 24.h),
              CustomFormField(
                focusNode: _focusNodeFieldSize,
                textInputAction: TextInputAction.next,
                hintText: 'Field size in sq.m',
                keyboardType: TextInputType.number,
                label: 'Field Size',
                textEditingController: _fieldSizeController,
                validator:
                    (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Please enter field size'
                            : null,
              ),
              SizedBox(height: 24.h),
              CustomFormField(
                focusNode: _focusNodeState,
                textInputAction: TextInputAction.next,
                hintText: 'State where the field is situated',
                keyboardType: TextInputType.text,
                label: 'State',
                textEditingController: _stateController,
                validator:
                    (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Please enter state'
                            : null,
              ),
              SizedBox(height: 24.h),
              CustomFormField(
                focusNode: _focusNodeLocation,
                textInputAction: TextInputAction.done,
                hintText: 'Description to reach your field',
                keyboardType: TextInputType.text,
                label: 'Location Description',
                textEditingController: _locationDescriptionController,
                validator:
                    (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Please enter location description'
                            : null,
              ),
              SizedBox(height: 24.h),
              reusableDropdown<FarmersAllocated>(
                label: 'Farmers Allocated',
                selectedValue: selectedFarmer,
                items: FarmersAllocated.values,
                onChanged: (FarmersAllocated? value) {
                  setState(() {
                    selectedFarmer = value!;
                  });
                },
              ),
              SizedBox(height: 24.h),
              CustomButton(
                onClick: _submitFarmDetails,
                buttonName: "Save and Proceed",
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fieldNameController.dispose();
    _cropDetailsController.dispose();
    _fieldSizeController.dispose();
    _stateController.dispose();
    _locationDescriptionController.dispose();

    _focusNodeName.dispose();
    _focusNodeCropDetail.dispose();
    _focusNodeFieldSize.dispose();
    _focusNodeState.dispose();
    _focusNodeBoundary.dispose();
    _focusNodeLocation.dispose();
    super.dispose();
  }
}
