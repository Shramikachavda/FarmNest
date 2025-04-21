import 'package:agri_flutter/presentation/html_footer.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:agri_flutter/theme/util.dart';
import 'package:agri_flutter/utils/comman.dart';
import 'package:agri_flutter/utils/text_style_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget footer({required BuildContext context}) {
  final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
  return isKeyboardOpen
      ? Container()
      : Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            bodyMediumText("Farmnest"),
            const SizedBox(height: 6),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                captionStyleText(
                  "By continuing, you confirm you've read and agree to our ",
                  textAlign: TextAlign.center,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => const HtmlViewerScreen(
                              title: "Terms of Service",
                              assetPath: "assets/html/terms.html",
                            ),
                      ),
                    );
                  },
                  child: captionStyleText(
                    "Terms Of Service",
                    color: themeColor(context: context).primary,
                  ),
                ),
                captionStyleText(" and "),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => const HtmlViewerScreen(
                              title: "Privacy Policy",
                              assetPath: "assets/html/privacy_policy.html",
                            ),
                      ),
                    );
                  },
                  child: captionStyleText(
                    "Privacy Policy",
                    color: themeColor(context: context).primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
          ],
        ),
      );
}

Widget customText(String text, Color color, double size) {
  return Text(text, style: TextStyle(fontSize: size, color: color));
}

// drop dwon

Widget reusableDropdown<T>({
  required String label,
  required T? selectedValue,
  required List<T> items,
  required ValueChanged<T?> onChanged,

}) {
  return DropdownButtonFormField<T>(
    value: selectedValue,
    isExpanded: true,
    isDense: true,
    decoration: InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color:themeColor().outline),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color:themeColor().outline),
        borderRadius: BorderRadius.circular(12),
      ),
      labelText: label,

      //   labelStyle: TextStyle(fontSize: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
    ),
    items:
        items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(item.toString().split('.').last), // Extract enum name
          );
        }).toList(),
    onChanged: onChanged,
  );
}

/*Future<void> showLoading(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                showLoading(context),
                SizedBox(height: 20),
                Text("Loading...", style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
  );
}*/

Widget showLoading(BuildContext context) {
  return Center(
    child: Container(
      height: 150.h,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(color: themeColor(context: context).surfaceContainerHighest  , borderRadius: BorderRadius.circular(20.h)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: CircularProgressIndicator()),
          bodyText("Loading")
        ].separator(SizedBox(height: 10.h,)).toList(),
      ),
    ),
  );
}

//

Future customNavigation(BuildContext context, Widget newPath) {
  return Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (context) => newPath));
}

//bold and 32
Widget headLine1(String text, {Color? color, TextAlign? textAlign}) => Text(
  text,
  textAlign: textAlign,
  style: AppTextStyles.headline1Style.copyWith(color: color),
);

//semi bold and  24
Widget headLine2(String text, {Color? color, TextAlign? textAlign}) => Text(
  text,
  textAlign: textAlign,
  style: AppTextStyles.headline2Style.copyWith(color: color),
);

//semi bold  22
Widget headLine3(String text, {Color? color, TextAlign? textAlign}) => Text(
  text,
  textAlign: textAlign,
  style: AppTextStyles.bodySemiLargeStyle.copyWith(color: color),
);

//semi bold  22
Widget bodySemiLargeBoldText(
  String text, {
  Color? color,
  TextAlign? textAlign,
}) => Text(
  text,
  textAlign: textAlign,
  style: AppTextStyles.bodySemiLargeBoldStyle.copyWith(color: color),
);

//semi bold  22
Widget bodySemiLargeExtraBoldText(
  String text, {
  Color? color,
  TextAlign? textAlign,
}) => Text(
  text,
  textAlign: textAlign,
  style: AppTextStyles.bodySemiLargeExtraBoldStyle.copyWith(color: color),
);

// Small text (Font size: 14)
Widget smallText(String text, {Color? color, TextAlign? textAlign}) => Text(
  text,
  textAlign: textAlign,
  style: AppTextStyles.bodySmallStyle.copyWith(color: color),
);

//font 12
Widget captionStyleText(String text, {Color? color, TextAlign? textAlign  , int? maxLine }) =>
    Text(
      text,maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style: AppTextStyles.captionStyle.copyWith(color: color),
    );

//font 16 error
Widget errorText(String text) =>
    Text(text, textAlign: TextAlign.center, style: AppTextStyles.errorStyle);

//24 semi bold
Widget bodyBoldMediumText(String text, {Color? color}) =>
    Text(text, style: AppTextStyles.headline2Style);

//18 normal
Widget bodyMediumText(
  String text, {
  Color? color,
  bool? softWrap,
  int? maxLine,
}) => Text(
  text,
  maxLines: maxLine,
  softWrap: softWrap,
  overflow: TextOverflow.ellipsis,
  style: AppTextStyles.bodyLargeStyle.copyWith(color: color),
);

//18 bold semi
Widget bodyMediumBoldText(
  String text, {
  Color? color,
  bool? softWrap,
  int? maxLine,
}) => Text(
  text,
  maxLines: maxLine,
  softWrap: softWrap,
  overflow: TextOverflow.ellipsis,
  style: AppTextStyles.bodyBoldLargeStyle.copyWith(color: color),
);

//bodylarge 32
Widget bodyLargeText(String text, {Color? color}) =>
    Text(text, style: AppTextStyles.bodylargeStyle.copyWith(color: color));

//button text
Widget buttonText(String text, {Color? color}) =>
    Text(text, style: AppTextStyles.buttonStyle.copyWith(color: color));

// 16  normal
Widget bodyText(String text, {Color? color, int? maxLine}) => Text(
  text,
  overflow: TextOverflow.ellipsis,
  maxLines: maxLine,
  style: AppTextStyles.bodyStyle.copyWith(color: color),
);

//extension
extension StringNullableExtension on String? {
  String orEmpty() {
    return this ?? "";
  }
}
