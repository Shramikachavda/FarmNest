import 'package:agri_flutter/core/color_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onClick;
  final String buttonName;
  final Color buttonColor;
  final Color textColor;

  const CustomButton({
    super.key,
    required this.onClick,
    required this.buttonName,
    this.buttonColor = ColorConst.green, // Default
    this.textColor = Colors.white, // Default
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor, // Use theme color
          //padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.r),
          ),
        ),
        child: Text(
          buttonName,
          style: TextStyle(fontSize: 16, color: textColor),
        ),
      ),
    );
  }
}
