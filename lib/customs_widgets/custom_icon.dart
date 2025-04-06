import 'package:agri_flutter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget customIcon(BuildContext context, String icon) {
  return SvgPicture.asset(icon, width: 24.sp, height: 24.sp);
}

Widget customIconButton(BuildContext context, String icon, VoidCallback onTap) {
  final theme = themeColor();
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
