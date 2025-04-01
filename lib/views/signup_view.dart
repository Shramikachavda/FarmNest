import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/services/firebase_auth.dart';
import 'package:agri_flutter/services/hive_user_service.dart';
import 'package:agri_flutter/views/login_view.dart';
import 'package:flutter/material.dart';

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
        final user = await _fireBaseAuth.signUp(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (user != null) {
          // ✅ Store user's name in Hive using UID as key
          await _hiveService.saveUserName(user.uid, _nameController.text.trim());

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
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: customText("Create your account", textColor, 32),
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      customText("Already have an account?", textColor, 16),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginView(),
                            ),
                          );
                        },
                        child: customText("Sign in", theme.primaryColor, 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CustomFormField(
                    keyboardType: TextInputType.text,
                    hintText: 'Enter your full name',
                    label: 'Full Name',
                    textEditingController: _nameController,
                    icon: Icon(Icons.person, color: theme.iconTheme.color),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter your full name' : null,
                  ),
                  CustomFormField(
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Enter your email address',
                    label: 'Email Address',
                    textEditingController: _emailController,
                    icon: Icon(Icons.email, color: theme.iconTheme.color),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  CustomFormField(
                    keyboardType: TextInputType.visiblePassword,
                    hintText: 'Enter your password',
                    label: 'Password',
                    textEditingController: _passwordController,
                    icon: Icon(Icons.lock, color: theme.iconTheme.color),
                    obscureText: true,
                    validator: (value) =>
                        (value == null || value.length < 6) ? 'Password must be at least 6 characters' : null,
                  ),
                  CustomFormField(
                    keyboardType: TextInputType.visiblePassword,
                    hintText: 'Confirm your password',
                    label: 'Confirm Password',
                    textEditingController: _confirmPasswordController,
                    icon: Icon(Icons.lock, color: theme.iconTheme.color),
                    obscureText: true,
                    validator: (value) =>
                        (value == null || value != _passwordController.text) ? 'Passwords do not match' : null,
                  ),
                  CustomButton(
                    onClick: _validateAndSignup,
                    buttonName: 'Sign up',
                    buttonColor: theme.primaryColor,
                    textColor: textColor,
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
