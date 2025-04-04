import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../customs_widgets/custom_form_field.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          children: [
            CustomFormField(
              hintText: "Enter Your Email",
              keyboardType: TextInputType.emailAddress,
              label: 'Email',
              textEditingController: _name,

              validator: (value) {
                if (_name.text.isNotEmpty) {
                  return "Enter yor name";
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
