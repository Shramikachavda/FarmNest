import 'package:agri_flutter/theme/theme.dart';
import 'package:flutter/material.dart';

//saved fontSizes used in styles
const double headline1FontSize = 32;
const double headline2FontSize = 24;
const double titleFontSize = 22;
const double bodyLargeFontSize = 18;
const double bodyFontSize = 16;
const double bodySmallFontSize = 14;
const double captionFontSize = 12;
const double buttonFontSize = 16;

class AppTextStyles {
  //32
  static const TextStyle headline1Style = TextStyle(
    fontSize: headline1FontSize,
    fontWeight: FontWeight.bold,
  );

  //32
  static const TextStyle bodylargeStyle = TextStyle(
    fontSize: headline1FontSize,
  );

  //24
  static const TextStyle headline2Style = TextStyle(
    fontSize: headline2FontSize,
    fontWeight: FontWeight.w600,
  );

  //22
  static const TextStyle titleStyle = TextStyle(
    fontSize: titleFontSize,
    fontWeight: FontWeight.w600,
  );

  //22 semi bold
  static const TextStyle bodySemiLargeBoldStyle = TextStyle(
    fontSize: titleFontSize,
    fontWeight: FontWeight.w900,
  );

  //18 semi bold
  static const TextStyle bodySemiLargeExtraBoldStyle = TextStyle(
    fontSize: bodyLargeFontSize,
    fontWeight: FontWeight.w900,
  );

  //18 semi bold
  static const TextStyle bodySemiLargeStyle = TextStyle(
    fontSize: bodyLargeFontSize,
    fontWeight: FontWeight.w600,
  );

  //18
  static const TextStyle bodyLargeStyle = TextStyle(
    fontSize: bodyLargeFontSize,
    fontWeight: FontWeight.normal,
  );

  //16
  static const TextStyle bodyStyle = TextStyle(
    fontSize: bodyFontSize,
    fontWeight: FontWeight.normal,
  );

  //14
  static const TextStyle bodySmallStyle = TextStyle(
    fontSize: bodySmallFontSize,
    fontWeight: FontWeight.normal,
  );

  //12
  static const TextStyle captionStyle = TextStyle(
    fontSize: captionFontSize,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );

  //16
  static const TextStyle buttonStyle = TextStyle(
    fontSize: buttonFontSize,
    fontWeight: FontWeight.w500,
  );

  static TextStyle errorStyle = TextStyle(
    fontSize: bodyFontSize,
    fontWeight: FontWeight.normal,
    color: themeColor().error,
  );
}
