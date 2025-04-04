import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/services/firebase_auth.dart';
import 'package:agri_flutter/presentation/home_view.dart';
import 'package:agri_flutter/presentation/signup_view.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../core/image.dart' show ImageConst;
import '../customs_widgets/custom_snackbar.dart';
import '../providers/password_provider.dart' show PasswordProvider;
import 'forget_password.dart' show ForgotPasswordScreen;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final FireBaseAuth _fireBaseAuth = FireBaseAuth();

  // Initialize FirebaseAuth
  Future<void> loginUser() async {
    if (_formkey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        // ✅ Attempt to sign in
        User? user = await _fireBaseAuth.login(email, password);

        if (user != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeView()),
          );
        }

        // ✅ Navigate to HomeView only if login is successful
      }
      on FirebaseAuthException catch (e) {

        String errorMessage = "Login failed. Please try again.";

        if (e.code == 'wrong-password') {
          errorMessage = "Incorrect password. Please try again.";
        } else if (e.code == 'user-not-found') {
          errorMessage = "No account found with this email. Please sign up.";
        } else if (e.code == 'user-disabled') {
          errorMessage = "This account has been disabled. Contact support.";
        } else if (e.code == 'invalid-email') {
          errorMessage = "Invalid email format. Please enter a valid email.";
        } else if (e.code == 'too-many-requests') {
          errorMessage = "Too many failed attempts. Please try again later.";
        } else if (e.code == 'network-request-failed') {
          errorMessage = "No internet connection. Please check your network.";
        } else if (e.code == 'user-mismatch') {
          errorMessage = "Email does not match the signed-in user.";
        } else if (e.code == 'operation-not-allowed') {
          errorMessage = "Login with email & password is not enabled.";
        } else if (e.code == 'account-exists-with-different-credential') {
          errorMessage =
              "An account already exists with a different sign-in method.";
        } else {
          errorMessage = "Login failed. Error: ${e.message ?? "Unknown error"}";
        }



          showCustomSnackBar(context , errorMessage) ;



      }catch (e) {
        showCustomSnackBar(context , "Error: ${e.toString()}") ;


      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor().surface,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Form(
                  key: _formkey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //logo
                        Image.asset(ImageConst.logo, width: 180.w, height: 180.h),
                        SizedBox(height: 50.h),

                        //welcome back text
                        headLine1("Welcome back"),
                        SizedBox(height: 24.h),

                        //email
                        CustomFormField(
                          hintText: "Enter Your Email",
                          keyboardType: TextInputType.emailAddress,
                          label: 'Email',
                          textEditingController: _emailController,
                          icon: Icon(Icons.email),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter email";
                            }
                            // Check if the email is valid
                            if (!RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                            ).hasMatch(value)) {
                              return "Enter a valid email address";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24.h),

                        //password
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
                              ),
                              onTogglePassword: () => context.read<PasswordProvider>().toggleObscure(),
                              validator: (value) =>
                              (value == null || value.isEmpty) ? 'Password cannot be empty' : null,
                            );
                          },
                        ),
                        SizedBox(height: 20.h),


                        //forgot password
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text("Forgot password?", style: TextStyle(fontSize: 16 ,   color: themeColor().primary,)),
                        ),
                        SizedBox(height: 14.h),

                        //signin
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            bodyText(
                              "Don't have an account?",
                            ),
                            SizedBox(width: 5.w,) ,

                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SignupView(),
                                  ),
                                );
                              },
                              child: Text("Sign up",)),

                          ],
                        ),
                        SizedBox(height: 20.h),

                        //signin button
                        CustomButton(
                          onClick: loginUser   , // Use the updated login function
                          buttonName: 'Sign In',

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
      ),
    );
  }
}
