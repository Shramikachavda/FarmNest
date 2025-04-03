import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../customs_widgets/custom_button.dart' show CustomButton;
import '../customs_widgets/custom_form_field.dart';
import '../customs_widgets/custom_snackbar.dart' show showCustomSnackBar;
import '../services/firebase_auth.dart' show FireBaseAuth;

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FireBaseAuth _fireBaseAuth = FireBaseAuth();

  void _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showSnackBar("⚠️ Please enter your email!");
      return;
    }
    if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(email)) {

      showCustomSnackBar( context , "Enter a valid email address!");
      return;
    }

    _showLoadingDialog(); // Show loading indicator

    try {
      await _fireBaseAuth.sendPasswordResetEmail(email);

      showCustomSnackBar( context , "Password reset email sent! Check your inbox");
      Navigator.pop(context); // Close loading dialog
      Navigator.pop(context); // Navigate back to login screen
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showSnackBar("❌ Error: ${e.toString()}");
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              "Forgot Password",
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              "Enter your registered email address",
              style: TextStyle(fontSize: 18.sp),
            ),
            SizedBox(height: 40.h),
            CustomFormField(
              hintText: 'Enter your email address',
              keyboardType: TextInputType.emailAddress,
              label: 'Email Address',
              textEditingController: _emailController,
              icon: Icon(Icons.email),
            ),
            SizedBox(height: 35.h),

            CustomButton(
              onClick: _resetPassword,
              buttonName: 'Send Email',
            ),

            Spacer(),
            SizedBox(height: 16),
          ],
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
