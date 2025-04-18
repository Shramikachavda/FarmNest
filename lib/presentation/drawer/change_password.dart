
import
'package:agri_flutter/customs_widgets/custom_app_bar.dart' show CustomAppBar;
import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/customs_widgets/custom_snackbar.dart';


import 'package:agri_flutter/presentation/home_page_view/home_page_screen.dart';
import 'package:agri_flutter/providers/password_provider.dart';
import 'package:agri_flutter/providers/user_provider.dart';
import 'package:agri_flutter/services/firebase_auth.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/BaseStateFullWidget.dart';

class ChangePassword extends BaseStatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();

  static const String route = "/ChangePassword";

  @override
  String get routeName => route;

  @override
  Route buildRoute() {
    return materialRoute();
  }
}

class _ChangePasswordState extends State<ChangePassword> {
  // TextEditingControllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // FocusNodes
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodeCurrentPassword = FocusNode();
  final FocusNode _focusNodeNewPassword = FocusNode();
  final FocusNode _focusNodeConfirmPassword = FocusNode();

  final FireBaseAuth _auth = FireBaseAuth();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController.text =  context
        .read<UserProvider>().userEmail;


  
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text("Confirm Password Change"),
                content: const Text(
                  "Are you sure you want to change your password?",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Confirm"),
                  ),
                ],
              ),
        ) ??
        false;
  }

  Future<void> _sendVerificationEmail(User user) async {
    try {
      await user.sendEmailVerification();
      showCustomSnackBar(
        context,
        "Verification email sent to ${user.email}. Please verify and try again.",
      );
    } catch (e) {
      showCustomSnackBar(context, "Failed to send verification email: $e");
    }
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Additional validations
    if (newPassword == currentPassword) {
      showCustomSnackBar(
        context,
        "New password can't be the same as the current password",
      );
      return;
    }
    if (newPassword != confirmPassword) {
      showCustomSnackBar(context, "New password and confirmation do not match");
      return;
    }
    if (newPassword.length < 6) {
      showCustomSnackBar(context, "New password must be at least 6 characters");
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      showCustomSnackBar(context, "No user is logged in");
      return;
    }
    if (user.email != email) {
      showCustomSnackBar(context, "Email does not match the logged-in user");
      return;
    }

    // Check email verification
    await user.reload(); // Refresh user data
    if (!user.emailVerified) {
      await _sendVerificationEmail(user);
      return;
    }

    // Show confirmation dialog
    final confirmed = await _showConfirmationDialog();
    if (!confirmed) {
      showCustomSnackBar(context, "Password change cancelled");
      return;
    }

    try {
      await _auth.reAuthenticateAndChangePassword(
        email: email,
        oldPassword: currentPassword,
        newPassword: newPassword,
      );

      if (!mounted) return;
      showCustomSnackBar(context, "Password has been changed successfully");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePageScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String errorMessage;
      switch (e.code) {
        case 'wrong-password':
          errorMessage = "Current password is incorrect";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email format";
          break;
        case 'email-mismatch':
          errorMessage = "Email does not match the logged-in user";
          break;
        case 'no-user':
          errorMessage = "No user is logged in";
          break;
        case 'email-not-verified':
          errorMessage =
              "Please verify your email before changing your password";
          break;
        case 'too-many-requests':
          errorMessage = "Too many requests. Try again later";
          break;
        default:
          errorMessage = "Failed to change password: ${e.message}";
      }
      showCustomSnackBar(context, errorMessage);
    } catch (e) {
      if (!mounted) return;
      showCustomSnackBar(context, "An unexpected error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor(context: context).surface,
      appBar: CustomAppBar(title: "Change Your Password"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                CustomFormField(
                  readOnly: true,
                  focusNode: _focusNodeEmail,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Your email',
                  label: 'Email',
                  textEditingController: _emailController,
                  icon: const Icon(Icons.email),
     
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email cannot be empty';
                    }
                    if (!RegExp(
                      r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$",
                    ).hasMatch(value)) {
                      return 'Invalid email format';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),
                Selector<PasswordProvider, bool>(
                  selector: (context, provider) => provider.isObscure,
                  builder: (context, isObscure, child) {
                    return CustomFormField(
                      focusNode: _focusNodeCurrentPassword,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      hintText: 'Enter your current password',
                      label: 'Current Password',
                      textEditingController: _currentPasswordController,
                      obscureText: isObscure,
                      isPasswordField: true,
                      maxLine: 1,
                      icon: Icon(
                        isObscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onTogglePassword:
                          () =>
                              context.read<PasswordProvider>().toggleObscure(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Current password cannot be empty';
                        }
                        return null;
                      },
                    );
                  },
                ),
                SizedBox(height: 24.h),
                Selector<ConfirmPasswordProvider, bool>(
                  selector: (context, provider) => provider.isObscure,
                  builder: (context, isObscure, child) {
                    return CustomFormField(
                      focusNode: _focusNodeNewPassword,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      hintText: 'Enter your new password',
                      label: 'New Password',
                      textEditingController: _newPasswordController,
                      obscureText: isObscure,
                      isPasswordField: true,
                      maxLine: 1,
                      icon: Icon(
                        isObscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onTogglePassword:
                          () =>
                              context
                                  .read<ConfirmPasswordProvider>()
                                  .toggleObscure(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'New password cannot be empty';
                        }
                        return null;
                      },
                    );
                  },
                ),
                SizedBox(height: 24.h),
                Selector<ConfirmPasswordProvider, bool>(
                  selector: (context, provider) => provider.isObscure,
                  builder: (context, isObscure, child) {
                    return CustomFormField(
                      focusNode: _focusNodeConfirmPassword,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      hintText: 'Confirm your new password',
                      label: 'Confirm New Password',
                      textEditingController: _confirmPasswordController,
                      obscureText: isObscure,
                      isPasswordField: true,
                      maxLine: 1,
                      icon: Icon(
                        isObscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onTogglePassword:
                          () =>
                              context
                                  .read<ConfirmPasswordProvider>()
                                  .toggleObscure(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your new password';
                        }
                        return null;
                      },
                    );
                  },
                ),
                SizedBox(height: 24.h),
                CustomButton(
                  onClick: _changePassword,
                  buttonName: "Change Password",
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
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _focusNodeEmail.dispose();
    _focusNodeCurrentPassword.dispose();
    _focusNodeNewPassword.dispose();
    _focusNodeConfirmPassword.dispose();
    super.dispose();
  }
}
