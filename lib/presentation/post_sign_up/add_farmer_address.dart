import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/models/farmer_address.dart';
import 'package:agri_flutter/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../customs_widgets/custom_form_field.dart';

class AddFarmerAddress extends StatefulWidget {
  const AddFarmerAddress({super.key});

  @override
  State<AddFarmerAddress> createState() => _AddFarmerAddressState();
}

class _AddFarmerAddressState extends State<AddFarmerAddress> {
  //text editing controller
  final TextEditingController _name = TextEditingController();
  final TextEditingController _address1 = TextEditingController();
  final TextEditingController _address2 = TextEditingController();
  final TextEditingController _landMark = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();

  //focusnode
  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeAddress1 = FocusNode();
  final FocusNode _focusNodeAddress2 = FocusNode();
  final FocusNode _focusNodeLandMark = FocusNode();
  final FocusNode _focusNodePhoneNumber = FocusNode();



  //firestore
  final FirestoreService _firestoreService = FirestoreService();
  //form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //validation

  void submit() async{
    if(_formKey.currentState!.validate()){
    await  _firestoreService.addFamerAddress(
      FarmerAddress(
          name: _name.text,
          addressLine1: _address1.text,
          addressLine2: _address2.text,
          phoneNum: int.parse(_phoneNumber.text),
        ),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: SingleChildScrollView(
          child: Form(
            key:_formKey ,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 24.h),
                bodyLargeText("Add Farmer Details"),

                SizedBox(height: 24.h),
                bodyText(
                  "This detailed address will help you manage and track resources allocated.",
                ),

                SizedBox(height: 24.h),
                CustomFormField(
textInputAction: TextInputAction.next,
                  focusNode: _focusNodeName,
                  hintText: "Enter Farmer name",
                  keyboardType: TextInputType.text,
                  label: 'Farmer name',
                  textEditingController: _name,

                  validator: (value) {
                    if (_name.text.isNotEmpty) {
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
                    if (_name.text.isNotEmpty) {
                      return "Enter yor address";
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
                    if (_name.text.isNotEmpty) {
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
                    if (_name.text.isNotEmpty) {
                      return "Enter your landmark";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 24.h),
                CustomFormField(
                  icon: Icon(Icons.phone) ,
                  textInputAction: TextInputAction.done,
                  focusNode: _focusNodePhoneNumber,
                  hintText: "98xxxxxxxxx00",
                  keyboardType: TextInputType.phone,
                  label: 'Contact Number',
                  textEditingController: _phoneNumber,

                  validator: (value) {
                    if (_name.text.isNotEmpty) {
                      return "Enter your phone number";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 24.h),
                bodyText(
                  "Save your farmer's information so you can keep track of the farm they are assigned to.",
                ),

                SizedBox(height: 24.h),
                CustomButton(
                  onClick: () {
                    submit();

                  },
                  buttonName: "Save And Proceed",
                ),
              ],
            ),
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
    _name.dispose();
    _address1.dispose();
    _address2.dispose();
    _landMark.dispose();
    _phoneNumber.dispose();
  }
}
