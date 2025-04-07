import 'package:agri_flutter/core/widgets/BaseStateFullWidget.dart';
import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultFarmAddress extends BaseStatefulWidget {
  const DefaultFarmAddress({super.key});

  @override
  State<DefaultFarmAddress> createState() => _DefaultFarmAddressState();

  @override
  Route buildRoute() {
    return materialRoute();
  }

  static const String route = "/Default";

  @override
  String get routeName => route;
}

class _DefaultFarmAddressState extends State<DefaultFarmAddress> {
  //textEditingController
  final TextEditingController _address1 = TextEditingController();
  final TextEditingController _address2 = TextEditingController();
  final TextEditingController _address3 = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _landmarkAddress = TextEditingController();

  //focusNode
  final FocusNode _focusNodeaddress1 = FocusNode();
  final FocusNode _focusNodeaddress2 = FocusNode();
  final FocusNode _focusNodeaddress3 = FocusNode();
  final FocusNode _focusNodePhoneNumber = FocusNode();
  final FocusNode _focusNodeLandmark = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              bodyLargeText("Create your default address"),

              SizedBox(height: 24.h),
              bodyText(
                "A detailed address will help our delivery partner reach you easily.",
              ),

              SizedBox(height: 24.h),
              CustomFormField(
                hintText: "House / Flat / Block No.",
                keyboardType: TextInputType.text,
                label: "Address Line 1",
                textEditingController: _address1,
                focusNode: _focusNodeaddress1,
                textInputAction: TextInputAction.next,
              ),

              SizedBox(height: 24.h),
              CustomFormField(
                hintText: "Apartment / Road / Area",
                keyboardType: TextInputType.text,
                label: "Address Line 2",
                textEditingController: _address2,
                focusNode: _focusNodeaddress2,
                textInputAction: TextInputAction.next,
              ),

              SizedBox(height: 24.h),
              CustomFormField(
                hintText: "City / State / PIN",
                keyboardType: TextInputType.text,
                label: "Address Line 3",
                textEditingController: _address3,
                focusNode: _focusNodeaddress3,
                textInputAction: TextInputAction.next,
              ),

              SizedBox(height: 24.h),
              CustomFormField(
                hintText: "Pick your address",
                keyboardType: TextInputType.text,
                label: "Landmark Address",
                textEditingController: _landmarkAddress,
                focusNode: _focusNodeLandmark,
                textInputAction: TextInputAction.next,
              ),

              SizedBox(height: 24.h),
              CustomFormField(
                hintText: "98xxxxxxxxx00",
                keyboardType: TextInputType.phone,
                label: "Contact Number",
                textEditingController: _phoneNumber,
                focusNode: _focusNodePhoneNumber,
                textInputAction: TextInputAction.done,
              ),

              SizedBox(height: 24.h),
              bodyText(
                "Your products will be delivered to this address, which will also be utilised for effective agricultural field maintenance. ",
              ),

              SizedBox(height: 24.h),
              CustomButton(onClick: () {}, buttonName: "Save and Proceed"),
            ],
          ),
        ),
      ),
    );
  }
}
