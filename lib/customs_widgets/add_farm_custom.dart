import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/drop_down_value.dart';
import '../models/post_sign_up/farm_detail.dart';
import '../presentation/post_sign_up/draw_boundary.dart';
import 'custom_button.dart';
import 'custom_form_field.dart';

Widget buildAddFarmForm({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required Function(VoidCallback fn) setState,
  required TextEditingController fieldNameController,
  required TextEditingController boundaryController,
  required TextEditingController cropDetailsController,
  required TextEditingController fieldSizeController,
  required TextEditingController stateController,
  required TextEditingController locationController,
  required FocusNode focusNodeName,
  required FocusNode focusNodeBoundary,
  required FocusNode focusNodeCropDetail,
  required FocusNode focusNodeFieldSize,
  required FocusNode focusNodeState,
  required FocusNode focusNodeLocation,
  required Function() onSubmit,
  required List<LatLongData> farmBoundaries,
  required void Function(List<LatLongData>) onBoundarySelected,
  required dynamic selectedOwnership,
  required Function(dynamic) onOwnershipChanged,
  required dynamic selectedFarmer,
  required Function(dynamic) onFarmerChanged,
  required String Function(List<LatLongData>) formatBoundary,
})
 {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 24.w),
    child: Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [  SizedBox(height: 12.h),
          Text("Add Farms Field Location", style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 12.h),
          Text(
            "This detailed information will help our soil tester partner reach your farm easily.",
            maxLines: 3,
          ),
          SizedBox(height: 24.h),

          /// Field Name
          CustomFormField(
            focusNode: focusNodeName,
            textInputAction: TextInputAction.next,
            hintText: 'Enter your farm field name',
            keyboardType: TextInputType.text,
            label: 'Field Name',
            textEditingController: fieldNameController,
            validator: (value) => value == null || value.trim().isEmpty ? 'Please enter field name' : null,
          ),
          SizedBox(height: 24.h),

          /// Ownership
          reusableDropdown(
            label: 'Ownership Type',
            selectedValue: selectedOwnership,
            items: FarmOwnershipType.values,
            onChanged: onOwnershipChanged,
          ),
          SizedBox(height: 24.h),

          /// Farm Boundaries
          CustomFormField(
            focusNode: focusNodeBoundary,
            hintText: 'Select boundaries from map',
            label: 'Farm Boundaries',
            textEditingController: boundaryController,
            readOnly: true,
            icon: IconButton(
              onPressed: () async {
                final List<LatLongData> boundary = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SelectBoundaryScreen(),
                  ),
                );
                setState(() {
                  onBoundarySelected(boundary);
                  boundaryController.text = formatBoundary(boundary);
                  boundaryController.selection = TextSelection.fromPosition(
                    TextPosition(offset: boundaryController.text.length),
                  );
                });
              },
              icon: const Icon(Icons.map),
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 24.h),

          /// Crop Details
          CustomFormField(
            focusNode: focusNodeCropDetail,
            textInputAction: TextInputAction.next,
            hintText: 'Crop details cultivating in field',
            keyboardType: TextInputType.text,
            label: 'Crop Details',
            textEditingController: cropDetailsController,
            validator: (value) => value == null || value.trim().isEmpty ? 'Please enter crop details' : null,
          ),
          SizedBox(height: 24.h),

          /// Field Size
          CustomFormField(
            focusNode: focusNodeFieldSize,
            textInputAction: TextInputAction.next,
            hintText: 'Field size in sq.m',
            keyboardType: TextInputType.number,
            label: 'Field Size',
            textEditingController: fieldSizeController,
            validator: (value) => value == null || value.trim().isEmpty ? 'Please enter field size' : null,
          ),
          SizedBox(height: 24.h),

          /// State
          CustomFormField(
            focusNode: focusNodeState,
            textInputAction: TextInputAction.next,
            hintText: 'State where the field is situated',
            keyboardType: TextInputType.text,
            label: 'State',
            textEditingController: stateController,
            validator: (value) => value == null || value.trim().isEmpty ? 'Please enter state' : null,
          ),
          SizedBox(height: 24.h),

          /// Location Description
          CustomFormField(
            focusNode: focusNodeLocation,
            textInputAction: TextInputAction.done,
            hintText: 'Description to reach your field',
            keyboardType: TextInputType.text,
            label: 'Location Description',
            textEditingController: locationController,
            validator: (value) => value == null || value.trim().isEmpty ? 'Please enter location description' : null,
          ),
          SizedBox(height: 24.h),

          /// Farmers Allocated
          reusableDropdown(
            label: 'Farmers Allocated',
            selectedValue: selectedFarmer,
            items: FarmersAllocated.values,
            onChanged: onFarmerChanged,
          ),
          SizedBox(height: 24.h),

          /// Submit Button
          CustomButton(
            onClick: onSubmit,
            buttonName: "Save and Proceed",
          ),
          SizedBox(height: 24.h),
        ],
      ),
    ),
  );
}
