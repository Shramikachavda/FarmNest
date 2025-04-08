import 'package:agri_flutter/theme/theme.dart';
import 'package:agri_flutter/theme/util.dart';
import 'package:agri_flutter/utils/text_style_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget footer({required BuildContext context}) {
  final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
     return isKeyboardOpen ? Container() :


   Align(
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
              "By continuing, you conform you've read and agree to our",
              textAlign: TextAlign.center,

            ),
            InkWell(
              onTap: () {
                // Handle Terms of Service tap
              },
              child: captionStyleText(
                "Terms Of Service",
                color: themeColor(context: context).primary,
              ),
            ),
            captionStyleText(" and "),
            InkWell(
              onTap: () {
                // Handle Privacy Policy tap
              },
              child: captionStyleText(
                "Privacy Policy",
                color: themeColor(context: context).primary,
              ),
            ),
          ],
        ),
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
        borderSide: BorderSide(color: themeColor().outline),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: themeColor().outline),
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

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding:  EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("Loading...", style: TextStyle(fontSize: 16)),
          ],
        ),
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

// Small text (Font size: 14)
Widget smallText(String text, {Color? color, TextAlign? textAlign}) => Text(
  text,
  textAlign: textAlign,
  style: AppTextStyles.bodySmallStyle.copyWith(color: color),
);

//font 12
Widget captionStyleText(String text, {Color? color, TextAlign? textAlign}) =>
    Text(
      text,
      overflow : TextOverflow.ellipsis ,
      textAlign: textAlign,
      style: AppTextStyles.captionStyle.copyWith(color: color),
    );

//font 16 error
Widget errorText(String text) => Text(text, style: AppTextStyles.errorStyle);

//24 semi bold
Widget bodyBoldMediumText(String text, {Color? color}) =>
    Text(text, style: AppTextStyles.headline2Style);

//18 normal
Widget bodyMediumText(String text, {Color? color}) =>
    Text(text, style: AppTextStyles.bodyLargeStyle);

//bodylarge 32
Widget bodyLargeText(String text, {Color? color}) =>
    Text(text, style: AppTextStyles.bodylargeStyle.copyWith(color: color));

//button text
Widget buttonText(String text, {Color? color}) =>
    Text(text, style: AppTextStyles.buttonStyle.copyWith(color: color));

// 16  normal
Widget bodyText(String text, {Color? color}) =>
    Text(text,   overflow : TextOverflow.ellipsis, style: AppTextStyles.bodyStyle.copyWith(color: color) , );

//extension
extension StringNullableExtension on String? {
  String orEmpty() {
    return this ?? "";
  }
}
