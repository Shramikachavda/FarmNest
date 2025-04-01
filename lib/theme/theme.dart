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
