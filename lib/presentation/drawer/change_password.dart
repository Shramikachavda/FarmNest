import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/customs_widgets/custom_snackbar.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/presentation/home_page_view/home_page.dart';
import 'package:agri_flutter/providers/password_provider.dart';
import 'package:agri_flutter/services/firebase_auth.dart';
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
  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final FireBaseAuth _auth = FireBaseAuth();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Change your password"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20.h),

              CustomFormField(
                keyboardType: TextInputType.text,
                hintText: 'Enter your email',
                label: 'email',
                textEditingController: _email,

                icon: Icon(Icons.email),

                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Enter your email'
                            : null,
              ),
              SizedBox(height: 24.h),
              Selector<PasswordProvider, bool>(
                selector: (context, provider) => provider.isObscure,
                builder: (context, isObscure, child) {
                  return CustomFormField(
                    keyboardType: TextInputType.text,
                    hintText: 'Enter your password',
                    label: 'Current password',
                    textEditingController: _currentPassword,
                    obscureText: isObscure,
                    isPasswordField: true,

                    icon: Icon(
                      isObscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onTogglePassword:
                        () => context.read<PasswordProvider>().toggleObscure(),
                    validator:
                        (value) =>
                            (value == null || value.isEmpty)
                                ? 'Password cannot be empty'
                                : null,
                  );
                },
              ),
              SizedBox(height: 24.h),
              Selector<PasswordProvider, bool>(
                selector: (context, provider) => provider.isObscure,
                builder: (context, isObscure, child) {
                  return CustomFormField(
                    keyboardType: TextInputType.text,
                    hintText: 'Enter your new password',
                    label: 'New password',
                    textEditingController: _newPassword,
                    obscureText: isObscure,
                    isPasswordField: true,

                    icon: Icon(
                      isObscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onTogglePassword:
                        () => context.read<PasswordProvider>().toggleObscure(),
                    validator:
                        (value) =>
                            (value == null || value.isEmpty)
                                ? 'Password cannot be empty'
                                : null,
                  );
                },
              ),
              SizedBox(height: 24.h),
              CustomButton(
                onClick: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_newPassword.text.trim() ==
                        _currentPassword.text.trim()) {
                      showCustomSnackBar(
                        context,
                        "New password can't be same as current",
                      );
                      return;
                    }

                    await _auth
                        .reAuthenticateAndChangePassword(
                          email: _email.text.trim(),
                          oldPassword: _currentPassword.text.trim(),
                          newPassword: _newPassword.text.trim(),
                        )
                        .then((value) {
                          showCustomSnackBar(
                            context,
                            "Password has been changed",
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        });
                  }
                },
                buttonName: "Change password",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
