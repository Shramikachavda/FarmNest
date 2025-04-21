import 'package:agri_flutter/core/image.dart';
import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/presentation/login_view.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:agri_flutter/utils/navigation/navigation_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/widgets/BaseStateFullWidget.dart';
import '../customs_widgets/custom_button.dart';
import '../customs_widgets/custom_form_field.dart';
import '../customs_widgets/custom_snackbar.dart';
import '../services/firebase_auth.dart';

class ForgotPasswordScreen extends BaseStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();

  @override
  Route buildRoute() {
    return materialRoute();
  }

  static const String route = "/ForgotPasswordScreen";

  @override
  String get routeName => route;
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _focusNodeEmail = FocusNode();
  final FireBaseAuth _fireBaseAuth = FireBaseAuth();

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      showCustomSnackBar(context, "Please enter your email!");
      return;
    }

    if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(email)) {
      showCustomSnackBar(context, "Enter a valid email address!");
      return;
    }

   showLoading(context);

    try {
      bool success = await _fireBaseAuth.sendPasswordResetEmail(email);

      if (!mounted) return;

      Navigator.pop(context); // Close loading dialog

      if (success) {
        showCustomSnackBar(
          context,
          "Password reset email sent! Check your inbox",
        );
        NavigationUtils.popUntil(LoginView.route);
      } else {
        showCustomSnackBar(context, "No account found with this email.");
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = "Invalid email format.";
          break;
        case 'too-many-requests':
          errorMessage = "Too many requests. Try again later.";
          break;
        default:
          errorMessage = "Failed to send reset email: ${e.message}";
      }
      showCustomSnackBar(context, errorMessage);
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog
      showCustomSnackBar(context, "An unexpected error occurred: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: themeColor(context: context).surface,
      appBar: CustomAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 12.h),

                    headLine2("Forgot Password"),
                    Center(
                      child: Image.asset(
                        ImageConst.password,
                        height: 200,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    bodyMediumText("Enter your registered email address"),
                    SizedBox(height: 20.h),
                    CustomFormField(
                      maxLine: 1,
                      focusNode: _focusNodeEmail,
                      textInputAction: TextInputAction.done,
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
                  ],
                ),
              ),
            ),
          ),

          footer(context: context),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _focusNodeEmail.dispose();
    super.dispose();
  }
}
