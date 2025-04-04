
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/theme.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onClick;
  final String buttonName;
  final Color? buttonColor;
  final Color? textColor;

  CustomButton({
    super.key,
    required this.onClick,
    required this.buttonName,
    this.buttonColor, // Default
    this.textColor, // Default
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.r),
          ),
        ),
        child: Text(
          buttonName,
        ),
      ),
    );
  }
}
