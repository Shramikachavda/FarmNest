import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/services/firebase_auth.dart';
import 'package:agri_flutter/views/home_view.dart';
import 'package:agri_flutter/views/signup_view.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:flutter/material.dart';

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
      } on FirebaseAuthException catch (e) {
        // ✅ Handle Firebase Authentication errors
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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      } catch (e) {
        // ✅ Handle any other errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get current theme

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Adapt to theme
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Form(
            key: _formkey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/image/farmnest.png",
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 30),

                  // ✅ Email Field with Validation
                  CustomFormField(
                    hintText: "Enter Your Email",
                    keyboardType: TextInputType.emailAddress,
                    label: 'Email',
                    textEditingController: _emailController,
                    icon: Icon(Icons.email, color: theme.iconTheme.color),
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

                  // ✅ Password Field with Validation
                  CustomFormField(
                    hintText: "Enter Your Password",
                    keyboardType: TextInputType.text,
                    label: 'Password',
                    textEditingController: _passwordController,
                    obscureText: true, // Hide password
                    icon: Icon(Icons.lock, color: theme.iconTheme.color),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter password";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {},
                    child: customText(
                      "Forgot Password?",
                      theme.primaryColor,
                      16,
                    ),
                  ),
                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customText(
                        "Don't have an account?",
                        theme.textTheme.bodyMedium!.color!,
                        16,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupView(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ✅ Sign In Button with Firebase Validation
                  CustomButton(
                    onClick: loginUser, // Use the updated login function
                    buttonName: 'Sign In',
                    buttonColor: theme.primaryColor,
                    textColor:
                        Theme.of(context).textTheme.bodyLarge!.color ??
                        Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
