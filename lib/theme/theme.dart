import "package:agri_flutter/theme/util.dart";
import "package:agri_flutter/utils/text_style_utils.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";

ColorScheme themeColor({BuildContext? context}) {
  return Theme.of(context ?? globalContext).colorScheme;
}
/*ColorScheme themeColor(BuildContext context) {
  return Theme.of(context).colorScheme;
}*/

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return ColorScheme.fromSeed(
      seedColor:Colors.green ,
      brightness: Brightness.light,
    ).copyWith(
        primary: Color(0xff4EA673)
    );
  }

  static ColorScheme darkScheme() {
     return ColorScheme.fromSeed(
      seedColor:Colors.green ,
      brightness: Brightness.dark,
    ).copyWith(
       primary: Color(0xff4EA673)
     );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,

    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        textStyle: AppTextStyles.bodyLargeStyle.copyWith(
          color: colorScheme.onPrimary
        )
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.outline),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      labelStyle: TextStyle(color: colorScheme.outline),
      suffixIconColor: colorScheme.outline,
    ),
  );

  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
