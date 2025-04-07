import 'package:agri_flutter/core/drop_down_value.dart';
import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _fieldNameController = TextEditingController();
  final TextEditingController _cropDetailsController = TextEditingController();
  final TextEditingController _fieldSizeController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _locationDescriptionController = TextEditingController();
  final TextEditingController _farmersAllocatedController = TextEditingController();
  final TextEditingController _farmBoundary = TextEditingController();

  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeCropDetail = FocusNode();
  final FocusNode _focusNodeFieldSize = FocusNode();
  final FocusNode _focusNodeState = FocusNode();
  final FocusNode _focusNodeBoundary = FocusNode();
  final FocusNode _focusNodeLocation = FocusNode();

  FarmOwnershipType selctedOwnerShip = FarmOwnershipType.family;
  FarmersAllocated selectedFarmer = FarmersAllocated.one;

  @override
  void dispose() {
    _fieldNameController.dispose();
    _cropDetailsController.dispose();
    _fieldSizeController.dispose();
    _stateController.dispose();
    _locationDescriptionController.dispose();
    _farmersAllocatedController.dispose();
    _focusNodeName.dispose();
    _focusNodeCropDetail.dispose();
    _focusNodeFieldSize.dispose();
    _focusNodeState.dispose();
    _focusNodeLocation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                bodyLargeText("Add Farms Field Location"),
                SizedBox(height: 24.h),
                bodyText("This detailed information will help our soil tester partner reach your farm easily."),
                SizedBox(height: 24.h),

                CustomFormField(
                  focusNode: _focusNodeName,
                  textInputAction: TextInputAction.next,
                  hintText: 'Enter your farm field name',
                  keyboardType: TextInputType.text,
                  label: 'Field Name',
                  textEditingController: _fieldNameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter field name';
                    }
                    return null;
                  },
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
                  textInputAction: TextInputAction.next,
                  hintText: 'Select boundaries from map',
                  keyboardType: TextInputType.text,
                  label: 'Farm Boundaries',
                  textEditingController: _farmBoundary,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please select boundaries';
                    }
                    return null;
                  },
                  icon: IconButton(
                    onPressed: () {
                      print("Map button tapped");
                    },
                    icon: Icon(Icons.map),
                  ),
                ),

                SizedBox(height: 24.h),

                CustomFormField(
                  focusNode: _focusNodeCropDetail,
                  textInputAction: TextInputAction.next,
                  hintText: 'Crop details cultivating in field',
                  keyboardType: TextInputType.text,
                  label: 'Crop Details',
                  textEditingController: _cropDetailsController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter crop details';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 24.h),

                CustomFormField(
                  focusNode: _focusNodeFieldSize,
                  textInputAction: TextInputAction.next,
                  hintText: 'Field size in sq.m',
                  keyboardType: TextInputType.number,
                  label: 'Field Size',
                  textEditingController: _fieldSizeController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter field size';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 24.h),

                CustomFormField(
                  focusNode: _focusNodeState,
                  textInputAction: TextInputAction.next,
                  hintText: 'State where the field is situated',
                  keyboardType: TextInputType.text,
                  label: 'State',
                  textEditingController: _stateController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter state';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.h),

                CustomFormField(
                  focusNode: _focusNodeLocation,
                  textInputAction: TextInputAction.next,
                  hintText: 'Description to reach your field',
                  keyboardType: TextInputType.text,
                  label: 'Location Description',
                  textEditingController: _locationDescriptionController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter location description';
                    }
                    return null;
                  },
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
                  onClick: () {
                    if (_formKey.currentState!.validate()) {
                      // Proceed with API or save action
                      print("Form Validated. Ready to proceed!");
                    } else {
                      print("Validation failed. Fix errors.");
                    }
                  },
                  buttonName: "Save and Proceed",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
