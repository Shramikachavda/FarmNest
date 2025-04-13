import 'package:agri_flutter/core/widgets/BaseStateFullWidget.dart';
import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:agri_flutter/customs_widgets/custom_snackbar.dart';
import 'package:agri_flutter/providers/drawer/address_provider.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:agri_flutter/utils/comman.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../customs_widgets/custom_button.dart';
import '../../customs_widgets/custom_form_field.dart';
import '../../customs_widgets/reusable.dart';
import '../../models/post_sign_up/default_farmer_address.dart';

class AddAddressScreen extends BaseStatefulWidget {
  const AddAddressScreen({Key? key}) : super(key: key);

  @override
  String get routeName => '/addAddress';

  @override
  Route<dynamic> buildRoute() => materialRoute();

  @override
  State<StatefulWidget> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _address1 = TextEditingController();
  final TextEditingController _address2 = TextEditingController();
  final TextEditingController _address3 = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _landmarkAddress = TextEditingController();

  final FocusNode _focusNodeAddress1 = FocusNode();
  final FocusNode _focusNodeAddress2 = FocusNode();
  final FocusNode _focusNodeAddress3 = FocusNode();
  final FocusNode _focusNodePhoneNumber = FocusNode();
  final FocusNode _focusNodeLandmark = FocusNode();

  Future<void> _submitAddress() async {
    if (_formKey.currentState!.validate()) {
      try {
        final address = DefaultFarmerAddress(
          address1: _address1.text.trim(),
          address2: _address2.text.trim(),
          contactNumber: int.tryParse(_phoneNumber.text.trim()) ?? 0,
          name: _address3.text.trim(),
          landmark: _landmarkAddress.text.trim(),
        );

        await Provider.of<AddressProvider>(context, listen: false).addAddress(address);

        showCustomSnackBar(context, "Address saved successfully");
        Navigator.of(context).pop();
      } catch (e) {
        showCustomSnackBar(context, "Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         backgroundColor: themeColor(context: context).surface,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bodyLargeText("Create your address"),
                  bodyText(
                    "A detailed address will help our delivery partner reach you easily.",
                    maxLine: 2,
                  ),
                  CustomFormField(
                    hintText: "Enter your address name",
                    keyboardType: TextInputType.text,
                    label: "Address Name",
                    textEditingController: _address3,
                    focusNode: _focusNodeAddress3,
                    textInputAction: TextInputAction.next,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter city/state/pin' : null,
                  ),
                  CustomFormField(
                    hintText: "House / Flat / Block No.",
                    keyboardType: TextInputType.text,
                    label: "Address Line 1",
                    textEditingController: _address1,
                    focusNode: _focusNodeAddress1,
                    textInputAction: TextInputAction.next,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter address line 1' : null,
                  ),
                  CustomFormField(
                    hintText: "Apartment / Road / Area",
                    keyboardType: TextInputType.text,
                    label: "Address Line 2",
                    textEditingController: _address2,
                    focusNode: _focusNodeAddress2,
                    textInputAction: TextInputAction.next,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter address line 2' : null,
                  ),
                  CustomFormField(
                    hintText: "Pick your address",
                    keyboardType: TextInputType.text,
                    label: "Landmark Address",
                    textEditingController: _landmarkAddress,
                    focusNode: _focusNodeLandmark,
                    textInputAction: TextInputAction.next,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter landmark' : null,
                  ),
                  CustomFormField(
                    hintText: "98xxxxxxxx",
                    keyboardType: TextInputType.phone,
                    label: "Contact Number",
                    textEditingController: _phoneNumber,
                    focusNode: _focusNodePhoneNumber,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter contact number';
                      if (value.length != 10) return 'Enter valid phone number';
                      return null;
                    },
                  ),
                  CustomButton(onClick: _submitAddress, buttonName: "Save"),
                ].separator(SizedBox(height: 24.h)).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _address1.dispose();
    _address2.dispose();
    _address3.dispose();
    _phoneNumber.dispose();
    _landmarkAddress.dispose();
    _focusNodeAddress1.dispose();
    _focusNodeAddress2.dispose();
    _focusNodeAddress3.dispose();
    _focusNodePhoneNumber.dispose();
    _focusNodeLandmark.dispose();
    super.dispose();
  }
}