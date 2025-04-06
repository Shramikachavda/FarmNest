import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../customs_widgets/custom_button.dart';
import '../customs_widgets/custom_form_field.dart';
import '../customs_widgets/custom_snackbar.dart';
import '../services/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  //emailcontroller
  final TextEditingController _emailController = TextEditingController();

  //firebase auth
  final FireBaseAuth _fireBaseAuth = FireBaseAuth();

  void _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      showCustomSnackBar(context, "Please enter your email!");
    }

    if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(email)) {
      showCustomSnackBar(context, "Enter a valid email address!");
      return;
    }

    _showLoadingDialog(); // Show loading indicator

    try {
      await _fireBaseAuth.sendPasswordResetEmail(email);

      showCustomSnackBar(
        context,
        "Password reset email sent! Check your inbox",
      );
      Navigator.pop(context); // Close loading dialog
      Navigator.pop(context); // Navigate back to login presentation
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      showCustomSnackBar(context, "Error: ${e.toString()}");
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor().surface,

      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 40.h),

              headLine2("Forgot Password"),
              SizedBox(height: 8.h),

              bodyMediumText("Enter your registered email address"),
              SizedBox(height: 40.h),

              //email addresss
              CustomFormField(
                hintText: 'Enter your email address',
                keyboardType: TextInputType.emailAddress,
                label: 'Email Address',
                textEditingController: _emailController,
                icon: Icon(Icons.email),
              ),
              SizedBox(height: 35.h),

              //button
              CustomButton(onClick: _resetPassword, buttonName: 'Send Email'),

              Spacer(),
              footer(),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
