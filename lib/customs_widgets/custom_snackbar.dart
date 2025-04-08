import 'package:agri_flutter/theme/theme.dart';
import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 2), // Optional: Set duration
      backgroundColor: themeColor(context: context).primary, // Optional: Customize background color
      behavior: SnackBarBehavior.floating, // Optional: Floating style
    ),
  );
}

