import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/presentation/post_sign_up/post_signup_screen.dart';
import 'package:agri_flutter/services/firebase_auth.dart';
import 'package:agri_flutter/presentation/home_view.dart';
import 'package:agri_flutter/presentation/signup_view.dart';
import 'package:agri_flutter/services/local_storage/post_sign_up.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:agri_flutter/utils/navigation/navigation_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../core/image.dart';
import '../core/widgets/BaseStateFullWidget.dart';
import '../customs_widgets/custom_snackbar.dart';
import '../providers/password_provider.dart';
import 'forget_password.dart';

class LoginView extends BaseStatefulWidget {
  const LoginView({super.key});

  static const String route = "/login";

  @override
  State<LoginView> createState() => _LoginViewState();

  @override
  String get routeName => route;

  @override
  Route buildRoute() {
    return materialRoute();
  }
}

class _LoginViewState extends State<LoginView> {
  //controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //focusnode
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();

  //formkey
  final _formkey = GlobalKey<FormState>();

  //firebase
  final FireBaseAuth _fireBaseAuth = FireBaseAuth();

  // Initialize FirebaseAuth
  Future<void> loginUser() async {
    if (_formkey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      showLoading(context);

      try {
        // ✅ Attempt to sign in
        User? user = await _fireBaseAuth.login(email, password);

        if (user != null) {
          Navigator.of(context).pop();

          FocusScope.of(context).unfocus();
          // Check if this is the first login post-signup
          bool hasCompletedPostSignup =
              await LocalStorageService.hasCompletedPostSignup();

          if (!hasCompletedPostSignup) {
            print("First login detected, navigating to PostSignupScreen...");
            NavigationUtils.replaceWith(const PostSignupScreen());
          } else {
            print("Returning user, navigating to HomeView...");
            NavigationUtils.goToHome();
          }
        }
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();
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
        FocusScope.of(context).unfocus();

        showCustomSnackBar(context, errorMessage);
      } catch (e) {
        FocusScope.of(context).unfocus();
        Navigator.of(context).pop();

        showCustomSnackBar(context, "Error: ${e.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor(context: context).surface,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Form(
                  key: _formkey,

                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //logo
                        Image.asset(
                          ImageConst.logo,
                          width: 150.w,
                          height: 150.h,
                        ),
                        SizedBox(height: 50.h),

                        //welcome back text
                        headLine1(
                          "Welcome back",
                          color: themeColor(context: context).primary,
                        ),
                        SizedBox(height: 24.h),

                        //email
                        CustomFormField(
                          textInputAction: TextInputAction.next,
                          focusNode: _focusNodeEmail,
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
                              focusNode: _focusNodePassword,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.text,
                              hintText: 'Enter your password',
                              label: 'Password',
                              textEditingController: _passwordController,
                              obscureText: isObscure,
                              isPasswordField: true,
                              maxLine: 1,
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
                        SizedBox(height: 20.h),

                        //forgot password
                        InkWell(
                          onTap: () {
                            NavigationUtils.goTo(ForgotPasswordScreen());
                          },
                          child: buttonText(
                            "Forgot password",
                            color: themeColor(context: context).primary,
                          ),
                        ),
                        SizedBox(height: 14.h),

                        //signin
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            bodyText("Don't have an account?"),
                            SizedBox(width: 5.w),

                            InkWell(
                              onTap: () {
                                NavigationUtils.goTo(SignupView());
                              },
                              child: buttonText(
                                "Sign up",
                                color: themeColor(context: context).primary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),

                        //signin button
                        CustomButton(
                          onClick: loginUser, // Use the updated login function
                          buttonName: 'Sign In',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            footer(context: context),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    super.dispose();
  }
}
