import 'package:flutter/material.dart';

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

// Small text (Font size: 14)
Widget smallText(String text) => Text(text, style: TextStyle(fontSize: 14));

Widget smallText16(String text , {Color? color}) => Text(text, style: TextStyle(fontSize: 16));

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

//
Widget semiBoldText24(String text) =>
    Text(text, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600));

// Bold text (Font size: 20, Weight: Bold)
Widget boldText(String text) =>
    Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));

// Bold text (Font size: 24, Weight: Bold)
Widget largeBold(String text) =>
    Text(text, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
