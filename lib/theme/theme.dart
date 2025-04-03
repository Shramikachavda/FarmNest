import 'package:agri_flutter/core/color_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF5BA377),
    scaffoldBackgroundColor: Colors.white,

    //appbar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
      iconTheme: IconThemeData(color: Colors.black),
    ),

    //input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xff4EA673)),
        borderRadius: BorderRadius.circular(12),
      ),
      hintStyle: TextStyle(color: Color(0xFFB3B3B3)),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      labelStyle: TextStyle(color: Colors.black),
      suffixIconColor: Colors.black,
    ),

    //textTheme
    textTheme: GoogleFonts.latoTextTheme(
      TextTheme(
        //  bodyLarge: TextStyle(color: Colors.black, fontSize: 32),
        //  bodySmall: TextStyle(color: Colors.black, fontSize: 16),
        // bodyMedium: TextStyle(color: Colors.black, fontSize: 18),
      ),
    ),

    //Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF5BA377),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),

    //bottom navigation bar theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFEAF5E3),
      // Light grey background
      elevation: 10, // Adds shadow effect
      selectedItemColor: Color(0xFF5BA377), // Color of selected item
      unselectedItemColor: Colors.black54, // Color of unselected item
    ),

    //radio button
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ColorConst.green; // Selected color
        }
        return Colors.grey; // Default color
      }),
    ),

    //colorschema
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF5BA377), // Green
      secondary: Color(0xffC1E7B8),
      surface: Colors.white,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      surfaceBright: Colors.black12,
    ),

    //flot
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: ColorConst.green,
      foregroundColor: ColorConst.black54,

      splashColor: ColorConst.black54,
    ),

    //dia
    dialogTheme: DialogTheme(
      backgroundColor: Colors.white, // Light mode background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
    ),

    //card
    cardTheme: CardTheme(
      color: Color(0xFFEAF5E3),
      shadowColor: Colors.grey.shade300,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF5BA377),
    scaffoldBackgroundColor: Colors.black,

    //appbar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 0,
    ),

    //input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xff4EA673)),
        borderRadius: BorderRadius.circular(12),
      ),
      hintStyle: TextStyle(color: Color(0xFFB3B3B3)),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      labelStyle: TextStyle(color: Colors.white),
      suffixIconColor: Colors.white,
    ),

    //textTheme
    textTheme: GoogleFonts.latoTextTheme(
      TextTheme(
        //   bodyLarge: TextStyle(color: Colors.white, fontSize: 32),
        //  bodySmall: TextStyle(color: Colors.white, fontSize: 16),
        // bodyMedium: TextStyle(color: Colors.white, fontSize: 18),
      ),
    ),

    //elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF5BA377),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      ),
    ),

    //bottom navigation bar theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E), // Dark grey/black background
      elevation: 10, // Adds shadow effect
      selectedItemColor: Colors.greenAccent, // Highlighted item color
      unselectedItemColor: Colors.grey, // Dimmed color for unselected items
    ),

    //radio button
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ColorConst.green; // Selected color
        }
        return Colors.grey; // Default color
      }),
      //  overlayColor: WidgetStateProperty.all(Colors.blue),
    ),

    //color schema
    colorScheme: const ColorScheme.dark(
      primary: Color(0xff026666),
      surface: Colors.black54,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      surfaceBright: Colors.white10,
    ),

    //flot
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: ColorConst.green,
      foregroundColor: ColorConst.white,
      splashColor: ColorConst.white,
    ),

    dialogTheme: DialogTheme(
      backgroundColor: Colors.grey[900], // Dark mode background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
    ),

    //card
    cardTheme: CardTheme(
      // color: Colors.grey.shade900,
      color: Color(0xFF1E1E1E),
      shadowColor: Colors.black87,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}


//
/*

import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff006d3f),
      surfaceTint: Color(0xff006d3f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff6dc58f),
      onPrimaryContainer: Color(0xff00502e),
      secondary: Color(0xff4a6550),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff87a48d),
      onSecondaryContainer: Color(0xff203a28),
      tertiary: Color(0xff663602),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff824d19),
      onTertiaryContainer: Color(0xffffc697),
      error: Color(0xff98000a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffbc211e),
      onErrorContainer: Color(0xffffd2cc),
      surface: Color(0xfff6fbf4),
      onSurface: Color(0xff181d19),
      onSurfaceVariant: Color(0xff3f4941),
      outline: Color(0xff6f7a70),
      outlineVariant: Color(0xffbec9bf),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322d),
      inversePrimary: Color(0xff80d9a1),
      primaryFixed: Color(0xff9cf6bc),
      onPrimaryFixed: Color(0xff002110),
      primaryFixedDim: Color(0xff80d9a1),
      onPrimaryFixedVariant: Color(0xff00522f),
      secondaryFixed: Color(0xffcbead1),
      onSecondaryFixed: Color(0xff062011),
      secondaryFixedDim: Color(0xffb0ceb5),
      onSecondaryFixedVariant: Color(0xff324d3a),
      tertiaryFixed: Color(0xffffdcc2),
      onTertiaryFixed: Color(0xff2e1500),
      tertiaryFixedDim: Color(0xffffb77a),
      onTertiaryFixedVariant: Color(0xff6b3b06),
      surfaceDim: Color(0xffd7dbd5),
      surfaceBright: Color(0xfff6fbf4),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f5ee),
      surfaceContainer: Color(0xffebefe8),
      surfaceContainerHigh: Color(0xffe5e9e3),
      surfaceContainerHighest: Color(0xffdfe4dd),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003f23),
      surfaceTint: Color(0xff006d3f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff1e7c4d),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff223c2a),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff58735f),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff552c00),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff824d19),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740005),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffbc211e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff6fbf4),
      onSurface: Color(0xff0e120f),
      onSurfaceVariant: Color(0xff2e3931),
      outline: Color(0xff4a554c),
      outlineVariant: Color(0xff657067),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322d),
      inversePrimary: Color(0xff80d9a1),
      primaryFixed: Color(0xff1e7c4d),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff006239),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff58735f),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff405b47),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff99602b),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff7c4814),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc3c8c1),
      surfaceBright: Color(0xfff6fbf4),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f5ee),
      surfaceContainer: Color(0xffe5e9e3),
      surfaceContainerHigh: Color(0xffdaded8),
      surfaceContainerHighest: Color(0xffced3cc),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff00341b),
      surfaceTint: Color(0xff006d3f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff005530),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff183120),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff354f3c),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff462300),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff6e3d08),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff6fbf4),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff242e27),
      outlineVariant: Color(0xff414c43),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322d),
      inversePrimary: Color(0xff80d9a1),
      primaryFixed: Color(0xff005530),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003b20),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff354f3c),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff1e3827),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff6e3d08),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff502900),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb5bab4),
      surfaceBright: Color(0xfff6fbf4),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeef2eb),
      surfaceContainer: Color(0xffdfe4dd),
      surfaceContainerHigh: Color(0xffd1d6cf),
      surfaceContainerHighest: Color(0xffc3c8c1),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff88e1a9),
      surfaceTint: Color(0xff80d9a1),
      onPrimary: Color(0xff00391f),
      primaryContainer: Color(0xff6dc58f),
      onPrimaryContainer: Color(0xff00502e),
      secondary: Color(0xffb0ceb5),
      onSecondary: Color(0xff1c3624),
      secondaryContainer: Color(0xff87a48d),
      onSecondaryContainer: Color(0xff203a28),
      tertiary: Color(0xffffb77a),
      onTertiary: Color(0xff4c2700),
      tertiaryContainer: Color(0xff824d19),
      onTertiaryContainer: Color(0xffffc697),
      error: Color(0xffffb4aa),
      onError: Color(0xff690004),
      errorContainer: Color(0xffbc211e),
      onErrorContainer: Color(0xffffd2cc),
      surface: Color(0xff101411),
      onSurface: Color(0xffdfe4dd),
      onSurfaceVariant: Color(0xffbec9bf),
      outline: Color(0xff88948a),
      outlineVariant: Color(0xff3f4941),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dd),
      inversePrimary: Color(0xff006d3f),
      primaryFixed: Color(0xff9cf6bc),
      onPrimaryFixed: Color(0xff002110),
      primaryFixedDim: Color(0xff80d9a1),
      onPrimaryFixedVariant: Color(0xff00522f),
      secondaryFixed: Color(0xffcbead1),
      onSecondaryFixed: Color(0xff062011),
      secondaryFixedDim: Color(0xffb0ceb5),
      onSecondaryFixedVariant: Color(0xff324d3a),
      tertiaryFixed: Color(0xffffdcc2),
      onTertiaryFixed: Color(0xff2e1500),
      tertiaryFixedDim: Color(0xffffb77a),
      onTertiaryFixedVariant: Color(0xff6b3b06),
      surfaceDim: Color(0xff101411),
      surfaceBright: Color(0xff353a36),
      surfaceContainerLowest: Color(0xff0b0f0c),
      surfaceContainerLow: Color(0xff181d19),
      surfaceContainer: Color(0xff1c211d),
      surfaceContainerHigh: Color(0xff262b27),
      surfaceContainerHighest: Color(0xff313632),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

*/
