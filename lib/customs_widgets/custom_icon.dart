import 'package:agri_flutter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget customIcon(BuildContext context, String icon) {
  return SvgPicture.asset(icon, width: 20.sp, height: 20.sp);
}

Widget customIconButton({
  required BuildContext context,
  required VoidCallback onTap,
  Icon? assetIcon,
  String? icon,
}) {
  return Container(
    height: 40.h,
    width: 40.h,

    decoration: BoxDecoration(
      color: themeColor().onSurfaceVariant,
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: IconButton(
      onPressed: onTap,
      icon:
          assetIcon ??
          (icon != null
              ? Image.asset(icon, width: 20.sp, height: 20.sp)
              : const SizedBox()), // fallback if nothing passed
    ),
  );
}

//icon button with round

Widget customRoundIconButton({ required BuildContext context , required IconData icon, required VoidCallback onPressed}) {
  return Container(
    width: 30.w,
    height: 30.w,
    decoration: BoxDecoration(
      color: themeColor(context : context).secondaryContainer,
      borderRadius: BorderRadius.circular(40.r),
    ),
    child: Center(
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 20.sp),
        onPressed: onPressed,
      ),
    ),
  );
}


