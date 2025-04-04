import 'package:agri_flutter/theme/theme.dart';
import 'package:agri_flutter/utils/text_style_utils.dart';
import 'package:flutter/material.dart';

Widget footer(){
  return Align(
    alignment: Alignment.bottomCenter,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        bodyLargeText("Farmnest",),
        const SizedBox(height: 6),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            captionStyleText(
                "By continuing, you conform you've read and agree to our",
                textAlign: TextAlign.center,
                color: Colors.black
            ),
            InkWell(
              onTap: () {
                // Handle Terms of Service tap
              },
              child: captionStyleText("Terms Of Service",color: themeColor().primary),
            ),
            Text(" and ", style: TextStyle(fontSize: 14, color: Colors.black)),
            InkWell(
              onTap: () {
                // Handle Privacy Policy tap
              },
              child: captionStyleText("Privacy Policy", color: themeColor().primary),
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

Widget customAlertBox() {
  return AlertDialog(actions: [customText("isvali", Colors.black, 16)]);
}

// drop dwon

Widget reusableDropdown<T>({
  required String label,
  required T? selectedValue,
  required List<T> items,
  required ValueChanged<T?> onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: DropdownButtonFormField<T>(
      value: selectedValue,
      isExpanded: true,
      isDense: true,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff4EA673)),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff4EA673)),
          borderRadius: BorderRadius.circular(12),
        ),
        labelText: label,

        //   labelStyle: TextStyle(fontSize: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 14,
        ),
      ),
      items:
          items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(item.toString().split('.').last), // Extract enum name
            );
          }).toList(),
      onChanged: onChanged,
    ),
  );
}

//
Future customNavigation(BuildContext context, Widget newPath) {
  return Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (context) => newPath));
}

Widget headLine1(String text) => Text(text, style: AppTextStyles.headline1Style);
Widget headLine2(String text) => Text(text, style: AppTextStyles.headline2Style);

// Small text (Font size: 14)
Widget smallText(String text, {Color? color,TextAlign? textAlign}) => Text(text,
    textAlign: textAlign,
    style: AppTextStyles.bodySmallStyle.copyWith(color: color,));

Widget captionStyleText(String text, {Color? color,TextAlign? textAlign}) => Text(text,
    textAlign: textAlign,
    style: AppTextStyles.captionStyle.copyWith(color: color,));

Widget errorText(String text) => Text(text, style: AppTextStyles.errorStyle);

Widget bodyLargeBoldText(String text , {Color? color}) => Text(text, style: AppTextStyles.headline2Style);
Widget bodyLargeText(String text , {Color? color}) => Text(text, style: AppTextStyles.bodyLargeStyle);
Widget bodyText(String text , {Color? color}) => Text(text, style: AppTextStyles.bodyStyle.copyWith(color: color));

// Medium text (Font size: 20)
Widget mediumText(String text  , {Color? color}) => Text(text, style: TextStyle(fontSize: 20));

// Large text (Font size: 24)
Widget largeText(String text) => Text(text, style: TextStyle(fontSize: 24));

//
// Large text (Font size: 28)
Widget largeText28(String text) => Text(text, style: TextStyle(fontSize: 28));

// Semi-bold text (Font size: 20, Weight: Semi-bold)
Widget semiBoldText(String text) =>
    Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600));


Widget semiBoldText24(String text) =>
    Text(text, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600));

// Bold text (Font size: 20, Weight: Bold)
Widget boldText(String text) =>
    Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));

// Bold text (Font size: 24, Weight: Bold)
Widget largeBold(String text) =>
    Text(text, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold));

extension StringNullableExtension on String? {
  String orEmpty() {
    return this ?? "";
  }
}