import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/customs_widgets/custom_snackbar.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/models/user_data.dart';
import 'package:agri_flutter/services/firebase_auth.dart';
import 'package:agri_flutter/services/firestore.dart';

import 'package:agri_flutter/presentation/login_view.dart';
import 'package:agri_flutter/services/local_storage/post_sign_up.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:agri_flutter/utils/navigation/navigation_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../core/widgets/BaseStateFullWidget.dart';
import '../providers/password_provider.dart';

class SignupView extends BaseStatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();

  @override
  Route buildRoute() {
    return materialRoute();
  }

  static const String route = "/SignupView";

  @override
  String get routeName => route;
}

class _SignupViewState extends State<SignupView> {
  //formkey
  final _formKey = GlobalKey<FormState>();

  //controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  //focusnode
  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeConfirmPassword = FocusNode();

  //firebase
  final FireBaseAuth _fireBaseAuth = FireBaseAuth();
  final FirestoreService _firestore = FirestoreService();

  //validation
  void _validateAndSignup() async {
    final validate = _formKey.currentState!.validate();

    if (validate) {
      showLoadingDialog(context);
      try {
        User? user = await _fireBaseAuth.signUp(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        print("Verification email sent! Check your inbox.");

        if (user != null) {
          await _firestore.addUser(
            UserModelDb(
              id: user.uid,
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
            ),
          );
          Navigator.of(context).pop();
          print("User added to Firestore, preparing to navigate...");
          showCustomSnackBar(
            context,
            "Verification email sent! Check your inbox.",
          );

          showCustomSnackBar(context, "Signup successful! Please log in.");

          // Ensure post-signup flag is false (redundant with default, but explicit)
          await LocalStorageService.initHive(); // Ensure Hive is initialized
          if (LocalStorageService.hasCompletedPostSignup()) {
            await LocalStorageService.setPostSignupCompleted(); // Reset to false if somehow true
          }
          // Show success message
          print("Navigating to LoginView...");
          // Navigate to Login Screen
          //   NavigationUtils.popUntil(LoginView.route);

          NavigationUtils.replaceWith(const LoginView());
          print("Navigation triggered.");
        }
      } catch (e) {
        Navigator.of(context).pop();
        // Show error message if signup fails
        showCustomSnackBar(context, "Signup failed: ${e.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: themeColor(context: context).surface,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 24.w, right: 30.w, left: 30.w),
              child: SingleChildScrollView(
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 40.h),

                      bodyLargeText(
                        "Create your account",
                        color: themeColor(context: context).primary,
                      ),

                      //sign in
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          bodyText("Already have an account?"),

                          TextButton(
                            onPressed: () {
                              NavigationUtils.popUntil(LoginView.route);
                            },
                            child: buttonText(
                              "Sign in",
                              color: themeColor(context: context).primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),

                      //name
                      CustomFormField(
                        focusNode: _focusNodeName,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        hintText: 'Enter your full name',
                        label: 'Full Name',
                        textEditingController: _nameController,
                        icon: Icon(Icons.person),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.h),

                      //email
                      CustomFormField(
                        focusNode: _focusNodeEmail,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        hintText: 'Enter your email address',
                        label: 'Email Address',
                        textEditingController: _emailController,
                        icon: Icon(Icons.email),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(
                            r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$",
                          ).hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.h),

                      //password
                      // Password Field
                      Selector<PasswordProvider, bool>(
                        selector: (context, provider) => provider.isObscure,
                        builder: (context, isObscure, child) {
                          return CustomFormField(
                            textInputAction: TextInputAction.next,
                            focusNode: _focusNodePassword,
                            keyboardType: TextInputType.text,
                            hintText: 'Enter your password',
                            label: 'Password',
                            textEditingController: _passwordController,
                            obscureText: isObscure,
                            isPasswordField: true,

                            icon: Icon(
                              isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onTogglePassword:
                                () =>
                                    context
                                        .read<PasswordProvider>()
                                        .toggleObscure(),
                            validator:
                                (value) =>
                                    (value == null || value.isEmpty)
                                        ? 'Password cannot be empty'
                                        : null,
                          );
                        },
                      ),
                      SizedBox(height: 24.h),

                      // Confirm Password Field
                      Selector<ConfirmPasswordProvider, bool>(
                        selector: (context, provider) => provider.isObscure,
                        builder: (context, isObscure, child) {
                          return CustomFormField(
                            focusNode: _focusNodeConfirmPassword,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            hintText: 'Confirm your password',
                            label: 'Confirm Password',
                            textEditingController: _confirmPasswordController,
                            obscureText: isObscure,
                            isPasswordField: true,

                            icon: Icon(
                              isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onTogglePassword:
                                () =>
                                    context
                                        .read<ConfirmPasswordProvider>()
                                        .toggleObscure(),
                            validator:
                                (value) =>
                                    (value == null ||
                                            value != _passwordController.text)
                                        ? 'Passwords do not match'
                                        : null,
                          );
                        },
                      ),
                      SizedBox(height: 24.h),

                      //signup buttom
                      CustomButton(
                        onClick: _validateAndSignup,
                        buttonName: 'Sign up',
                        buttonColor: themeColor(context: context).surface,
                        textColor: themeColor(context: context).surface,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          footer(context: context),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _focusNodeName.dispose();
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    _focusNodeConfirmPassword.dispose();
    super.dispose();
  }
}
