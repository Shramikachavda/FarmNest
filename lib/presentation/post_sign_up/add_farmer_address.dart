import 'package:agri_flutter/core/widgets/BaseStateFullWidget.dart';
import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/models/post_sign_up/farmer_address.dart';
import 'package:agri_flutter/providers/post_sign_up_providers/default_farmer_address.dart';
import 'package:agri_flutter/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'post_signup_screen.dart'; // Import for PostSignupNotifier

class AddFarmerAddress extends BaseStatefulWidget {
  const AddFarmerAddress({super.key});

  @override
  State<AddFarmerAddress> createState() => _AddFarmerAddressState();

  @override
  Route buildRoute() => materialRoute();

  static const String route = "/AddFarmerAddress";

  @override
  String get routeName => route;
}

class _AddFarmerAddressState extends State<AddFarmerAddress> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _address1 = TextEditingController();
  final TextEditingController _address2 = TextEditingController();
  final TextEditingController _landMark = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();

  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeAddress1 = FocusNode();
  final FocusNode _focusNodeAddress2 = FocusNode();
  final FocusNode _focusNodeLandMark = FocusNode();
  final FocusNode _focusNodePhoneNumber = FocusNode();

  final FirestoreService _firestoreService = FirestoreService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _firestoreService.addFamerAddress(
          FarmerAddress(
            name: _name.text.trim(),
            addressLine1: _address1.text.trim(),
            addressLine2: _address2.text.trim(),
            phoneNum: int.parse(_phoneNumber.text.trim()),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Farmer address saved successfully")),
        );


      final postSignupNotifier = context.read<PostSignupNotifier>();
      postSignupNotifier.nextPage();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Error: $e")),
        );
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

              bodyLargeText("Add Farmer Details"),
              SizedBox(height: 10.h),
              bodyText("This detailed address will help you manage and track resources allocated."),
              SizedBox(height: 24.h),
              CustomFormField(
                textInputAction: TextInputAction.next,
                focusNode: _focusNodeName,
                hintText: "Enter Farmer name",
                keyboardType: TextInputType.text,
                label: 'Farmer name',
                textEditingController: _name,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter your name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.h),
              CustomFormField(
                textInputAction: TextInputAction.next,
                focusNode: _focusNodeAddress1,
                hintText: "House / Flat / Block No.",
                keyboardType: TextInputType.text,
                label: 'Address Line 1',
                textEditingController: _address1,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter your address";
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.h),
              CustomFormField(
                textInputAction: TextInputAction.next,
                focusNode: _focusNodeAddress2,
                hintText: "Apartment / Road / Area",
                keyboardType: TextInputType.text,
                label: 'Address Line 2',
                textEditingController: _address2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter your address";
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.h),
              CustomFormField(
                textInputAction: TextInputAction.next,
                focusNode: _focusNodeLandMark,
                hintText: "Pick your address",
                keyboardType: TextInputType.text,
                label: 'Landmark Address',
                textEditingController: _landMark,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter your landmark";
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.h),
              CustomFormField(
                icon: Icon(Icons.phone),
                textInputAction: TextInputAction.done,
                focusNode: _focusNodePhoneNumber,
                hintText: "98xxxxxxxxx00",
                keyboardType: TextInputType.phone,
                label: 'Contact Number',
                textEditingController: _phoneNumber,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter your phone number";
                  } else if (!RegExp(r'^\d{10,}$').hasMatch(value.trim())) {
                    return "Enter a valid phone number";
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.h),
              bodyText("Save your farmer's information for tracking."),
              SizedBox(height: 24.h),
              CustomButton(
                onClick: _submit,
                buttonName: "Save And Proceed",
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _address1.dispose();
    _address2.dispose();
    _landMark.dispose();
    _phoneNumber.dispose();
    _focusNodeName.dispose();
    _focusNodeAddress1.dispose();
    _focusNodeAddress2.dispose();
    _focusNodeLandMark.dispose();
    _focusNodePhoneNumber.dispose();
    super.dispose();
  }
}