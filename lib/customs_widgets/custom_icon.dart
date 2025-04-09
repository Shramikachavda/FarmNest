import 'package:agri_flutter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget customIcon(BuildContext context, String icon) {
  return SvgPicture.asset(icon, width: 24.sp, height: 24.sp);
}

Widget customIconButton({ required BuildContext context,   required VoidCallback onTap  , Icon? assetIcon  , String? icon,}) {
  return Container(
 height: 40.h,
    width: 40.h,

    decoration: BoxDecoration(
      color: themeColor().onSurfaceVariant,
      borderRadius: BorderRadius.circular(12.r),
    ),
    child:IconButton(
      onPressed: onTap,
      icon:assetIcon  ??
          (icon != null
              ? Image.asset(
            icon,
            width: 24.sp,
            height: 24.sp,
          )
              : const SizedBox()), // fallback if nothing passed
    ),
  );
}
