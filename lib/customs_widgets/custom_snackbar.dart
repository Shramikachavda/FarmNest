import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 2), // Optional: Set duration
      backgroundColor: Colors.amber, // Optional: Customize background color
      behavior: SnackBarBehavior.floating, // Optional: Floating style
    ),
  );
}
