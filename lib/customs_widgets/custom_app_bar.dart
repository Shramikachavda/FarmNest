import 'package:agri_flutter/core/image.dart';
import 'package:agri_flutter/customs_widgets/custom_icon.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:agri_flutter/utils/text_style_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    Key? key,
    this.title,
    this.showBackButton = true,
    this.actions,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,

      leadingWidth: 80.w,
      leading:
          showBackButton
              ? InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 24.w, top: 16.h, right: 16.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      color: themeColor().primary,
                      child: customIcon(context, ImageConst.icBack),
                    ),
                  ),
                ),
              )
              : null,
      centerTitle: true,
      title: Text(title ?? "", style: AppTextStyles.bodyLargeStyle),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
