import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/services/firebase_auth.dart';
import 'package:agri_flutter/services/hive_user_service.dart';
import 'package:agri_flutter/presentation/login_view.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/password_provider.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FireBaseAuth _fireBaseAuth = FireBaseAuth();
  final HiveService _hiveService = HiveService();

  void _validateAndSignup() async {
    final validate = _formKey.currentState!.validate();
    if (validate) {
      try {
        User? user = await _fireBaseAuth.signUp(

          _emailController.text.trim(),
          _passwordController.text.trim()
        );



        print("Verification email sent! Check your inbox.");

        if (user != null) {
          // ✅ Store user's name in Hive using UID as key
          await _hiveService.saveUserName(
            user.uid,
            _nameController.text.trim(),
          );

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Signup successful! Please log in.")),
          );

          // Navigate to Login Screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginView()),
          );
        }
      } catch (e) {
        // Show error message if signup fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup failed: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: ThemeData().scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 30.w,right: 24.w,left: 24.w),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 40.h),
                      customText("Create your account", themeColor().primary ,32),

                      //sign in
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          customText("Already have an account?", themeColor().primary , 16),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginView(),
                                ),
                              );
                            },
                            child: customText("Sign in", themeColor().primary, 18),
                          ),
                        ],
                      ),
                       SizedBox(height: 40.h),

                      //name
                      CustomFormField(
                        keyboardType: TextInputType.text,
                        hintText: 'Enter your full name',
                        label: 'Full Name',
                        textEditingController: _nameController,
                        icon: Icon(Icons.person, color: themeColor().primary , ),
                        validator:
                            (value)  {
                             if(value== null || value.isEmpty){
                               return  'Please enter your full name';
                             }
                             return null;
                            }

                      ),
                      SizedBox(height: 24.h),

                      //email
                      CustomFormField(
                        keyboardType: TextInputType.emailAddress,
                        hintText: 'Enter your email address',
                        label: 'Email Address',
                        textEditingController: _emailController,
                        icon: Icon(Icons.email,),
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
                            keyboardType: TextInputType.text,
                            hintText: 'Enter your password',
                            label: 'Password',
                            textEditingController: _passwordController,
                            obscureText: isObscure,
                            isPasswordField: true,

                            icon: Icon(
                              isObscure ? Icons.visibility_off : Icons.visibility,
                              color: themeColor().primary,
                            ),
                            onTogglePassword: () => context.read<PasswordProvider>().toggleObscure(),
                            validator: (value) =>
                            (value == null || value.isEmpty) ? 'Password cannot be empty' : null,
                          );
                        },
                      ),
                      SizedBox(height: 24.h),

                       // Confirm Password Field
                      Selector<ConfirmPasswordProvider, bool>(
                        selector: (context, provider) => provider.isObscure,
                        builder: (context, isObscure, child) {
                          return CustomFormField(
                            keyboardType: TextInputType.text,
                            hintText: 'Confirm your password',
                            label: 'Confirm Password',
                            textEditingController: _confirmPasswordController,
                            obscureText: isObscure,
                            isPasswordField: true,

                            icon: Icon(
                              isObscure ? Icons.visibility_off : Icons.visibility,
                              color: themeColor().primary,
                            ),
                            onTogglePassword: () => context.read<ConfirmPasswordProvider>().toggleObscure(),
                            validator: (value) => (value == null || value != _passwordController.text)
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
                        buttonColor: themeColor().surface,
                        textColor: themeColor().surface,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          footer(),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }
}
