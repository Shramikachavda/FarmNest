import 'package:agri_flutter/core/image.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/theme.dart';
import '../utils/text_style_utils.dart';

class CustomOnboard extends StatelessWidget {
  const CustomOnboard({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor().surface,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(ImageConst.logoName, width: 140.w, height: 140.h),
              SizedBox(height: 24.h),
              Container(
                color: themeColor().surface,
                width: 300.w,
                height: 300.h,
                child: Image.asset(image, fit: BoxFit.fill),
              ),
              SizedBox(height: 20.h),
              headLine2(title ,  textAlign: TextAlign.center ,) ,
              SizedBox(height: 20.h),
              smallText(description , textAlign: TextAlign.center)
            ],
          ),
        ),
      ),
    );
  }
}
