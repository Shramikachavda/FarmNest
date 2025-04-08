import 'package:agri_flutter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget customIcon(BuildContext context, String icon) {
  return SvgPicture.asset(icon, width: 24.sp, height: 24.sp);
}

Widget customIconButton(BuildContext context, String icon, VoidCallback onTap) {
  return Container(
    padding: EdgeInsets.all(10.r),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: IconButton(
      onPressed: onTap,
      icon: Image.asset(
        icon,
        width: 24.sp,
        height: 24.sp,
      ),
    ),
  );
}
