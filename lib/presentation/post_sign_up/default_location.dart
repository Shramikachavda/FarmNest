import 'package:agri_flutter/core/widgets/BaseStateFullWidget.dart';
import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/models/post_sign_up/default_farmer_address.dart';
import 'package:agri_flutter/providers/post_sign_up_providers/default_farmer_address.dart';
import 'package:agri_flutter/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'post_signup_screen.dart'; // Import for PostSignupNotifier

class DefaultFarmAddress extends BaseStatefulWidget {
  const DefaultFarmAddress({super.key});

  @override
  State<DefaultFarmAddress> createState() => _DefaultFarmAddressState();

  @override
  Route buildRoute() => materialRoute();

  static const String route = "/Default";

  @override
  String get routeName => route;
}

class _DefaultFarmAddressState extends State<DefaultFarmAddress> {
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

  final FirestoreService _firestoreService = FirestoreService();

  Future<void> _submitAddress() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _firestoreService.addDefaultLocation(
          DefaultFarmerAddress(
            address1: _address1.text.trim(),
            address2: _address2.text.trim(),
            contactNumber: int.tryParse(_phoneNumber.text.trim()) ?? 0,
            name: _address3.text.trim(), // Using address3 as name
            landmark: _landmarkAddress.text.trim(),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Address saved successfully")),
        );
   // ✅ Move to next page using Provider
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
              SizedBox(height: 40.h),
              bodyLargeText("Create your default address"),
              SizedBox(height: 24.h),
              bodyText("A detailed address will help our delivery partner reach you easily."),
              SizedBox(height: 24.h),
              CustomFormField(
                hintText: "House / Flat / Block No.",
                keyboardType: TextInputType.text,
                label: "Address Line 1",
                textEditingController: _address1,
                focusNode: _focusNodeAddress1,
                textInputAction: TextInputAction.next,
                validator: (value) => value == null || value.isEmpty ? 'Enter address line 1' : null,
              ),
              SizedBox(height: 24.h),
              CustomFormField(
                hintText: "Apartment / Road / Area",
                keyboardType: TextInputType.text,
                label: "Address Line 2",
                textEditingController: _address2,
                focusNode: _focusNodeAddress2,
                textInputAction: TextInputAction.next,
                validator: (value) => value == null || value.isEmpty ? 'Enter address line 2' : null,
              ),
              SizedBox(height: 24.h),
              CustomFormField(
                hintText: "City / State / PIN",
                keyboardType: TextInputType.text,
                label: "Address Line 3",
                textEditingController: _address3,
                focusNode: _focusNodeAddress3,
                textInputAction: TextInputAction.next,
                validator: (value) => value == null || value.isEmpty ? 'Enter city/state/pin' : null,
              ),
              SizedBox(height: 24.h),
              CustomFormField(
                hintText: "Pick your address",
                keyboardType: TextInputType.text,
                label: "Landmark Address",
                textEditingController: _landmarkAddress,
                focusNode: _focusNodeLandmark,
                textInputAction: TextInputAction.next,
                validator: (value) => value == null || value.isEmpty ? 'Enter landmark' : null,
              ),
              SizedBox(height: 24.h),
              CustomFormField(
                hintText: "98xxxxxxxxx00",
                keyboardType: TextInputType.phone,
                label: "Contact Number",
                textEditingController: _phoneNumber,
                focusNode: _focusNodePhoneNumber,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter contact number';
                  if (value.length < 10) return 'Enter valid phone number';
                  return null;
                },
              ),
              SizedBox(height: 24.h),
              bodyText("Your products will be delivered to this address."),
              SizedBox(height: 24.h),
              CustomButton(onClick: _submitAddress, buttonName: "Save and Proceed"),
              SizedBox(height: 24.h),
            ],
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