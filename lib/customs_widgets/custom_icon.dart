import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget customIcon(BuildContext context, String icon) {
  final theme = Theme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;
  final iconColor = isDarkMode ? Colors.white : Colors.black;
  return Image.asset(icon, width: 24.sp, height: 24.sp, color: iconColor);
}

Widget customIconButton(BuildContext context, String icon, VoidCallback onTap) {
  final theme = Theme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;

  return Container(
    padding: EdgeInsets.all(10.r), // 🏆 Responsive Padding
    decoration: BoxDecoration(
      color:
          isDarkMode
              ? Colors.grey[800]
              : Colors.grey[300], // 🌗 Adaptive Background
      borderRadius: BorderRadius.circular(12.r), // 🟢 Rounded Corners
    ),
    child: IconButton(
      onPressed: onTap,
      icon: Image.asset(
        icon,
        width: 24.sp,
        height: 24.sp,
        color:
            isDarkMode ? Colors.white : Colors.black, // 🌙 Adaptive Icon Color
      ),
    ),
  );
}
