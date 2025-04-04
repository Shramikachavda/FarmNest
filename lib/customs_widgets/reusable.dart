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

//bold and 32
Widget headLine1(String text , {Color? color,TextAlign? textAlign}) => Text(text,
    textAlign: textAlign,
    style: AppTextStyles.headline1Style.copyWith(color: color));

//semi bold and  24
Widget headLine2(String text , {Color? color,TextAlign? textAlign}) => Text(text,
    textAlign: textAlign,
    style: AppTextStyles.headline2Style.copyWith(color: color));

//semi bold  22
Widget headLine3(String text , {Color? color,TextAlign? textAlign} ) => Text(text ,
  textAlign: textAlign,
  style: AppTextStyles.bodySemiLargeStyle.copyWith(color: color),);

// Small text (Font size: 14)
Widget smallText(String text, {Color? color,TextAlign? textAlign}) => Text(text,
    textAlign: textAlign,
    style: AppTextStyles.bodySmallStyle.copyWith(color: color,));

//font 12
Widget captionStyleText(String text, {Color? color,TextAlign? textAlign}) => Text(text,
    textAlign: textAlign,
    style: AppTextStyles.captionStyle.copyWith(color: color,));

//font 16 error
Widget errorText(String text) => Text(text, style: AppTextStyles.errorStyle);

//24 semi bold
Widget bodyLargeBoldText(String text , {Color? color}) => Text(text, style: AppTextStyles.headline2Style);

//18 normal
Widget bodyLargeText(String text , {Color? color}) => Text(text, style: AppTextStyles.bodyLargeStyle);




// 16  normal
Widget bodyText(String text , {Color? color}) => Text(text, style: AppTextStyles.bodyStyle.copyWith(color: color));







//extension
extension StringNullableExtension on String? {
  String orEmpty() {
    return this ?? "";
  }
}