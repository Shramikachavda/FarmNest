import 'package:flutter/material.dart';

class ColorConst {
  static const Color green = Color(0xFF5BA377);
  static const Color lightGreen = Color(0xffC1E7B8);
  static const Color midGreen = Color(0xff026666);
  static const Color darkGreen = Color(0xff013237);
  static const Color gray = Color(0xffA9ABBD);
  static const Color black54 = Colors.black54;
  static const Color white = Colors.white;

  static const Color themeBasedColor =
    (   Brightness == Brightness.dark) ? Colors.black : Colors.white;
}
