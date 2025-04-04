import "package:agri_flutter/theme/util.dart";
import "package:agri_flutter/utils/text_style_utils.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

ColorScheme themeColor({BuildContext? context}) {
  return Theme.of(context ?? globalContext).colorScheme;
}

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

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff96efb6),
      surfaceTint: Color(0xff80d9a1),
      onPrimary: Color(0xff002c17),
      primaryContainer: Color(0xff6dc58f),
      onPrimaryContainer: Color(0xff002f18),
      secondary: Color(0xffc5e4cb),
      onSecondary: Color(0xff112b1a),
      secondaryContainer: Color(0xff87a48d),
      onSecondaryContainer: Color(0xff001306),
      tertiary: Color(0xffffd4b3),
      onTertiary: Color(0xff3d1e00),
      tertiaryContainer: Color(0xffc2834a),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5448),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff101411),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd4dfd4),
      outline: Color(0xffaab5aa),
      outlineVariant: Color(0xff889389),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dd),
      inversePrimary: Color(0xff00532f),
      primaryFixed: Color(0xff9cf6bc),
      onPrimaryFixed: Color(0xff001508),
      primaryFixedDim: Color(0xff80d9a1),
      onPrimaryFixedVariant: Color(0xff003f23),
      secondaryFixed: Color(0xffcbead1),
      onSecondaryFixed: Color(0xff001508),
      secondaryFixedDim: Color(0xffb0ceb5),
      onSecondaryFixedVariant: Color(0xff223c2a),
      tertiaryFixed: Color(0xffffdcc2),
      onTertiaryFixed: Color(0xff1f0c00),
      tertiaryFixedDim: Color(0xffffb77a),
      onTertiaryFixedVariant: Color(0xff552c00),
      surfaceDim: Color(0xff101411),
      surfaceBright: Color(0xff414641),
      surfaceContainerLowest: Color(0xff050806),
      surfaceContainerLow: Color(0xff1a1f1b),
      surfaceContainer: Color(0xff242925),
      surfaceContainerHigh: Color(0xff2f342f),
      surfaceContainerHighest: Color(0xff3a3f3a),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffbdffd1),
      surfaceTint: Color(0xff80d9a1),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff7cd59d),
      onPrimaryContainer: Color(0xff000f05),
      secondary: Color(0xffd9f8de),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffaccab2),
      onSecondaryContainer: Color(0xff000f05),
      tertiary: Color(0xffffede0),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xfffbb376),
      onTertiaryContainer: Color(0xff160800),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220000),
      surface: Color(0xff101411),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffe8f3e7),
      outlineVariant: Color(0xffbac6bb),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dd),
      inversePrimary: Color(0xff00532f),
      primaryFixed: Color(0xff9cf6bc),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff80d9a1),
      onPrimaryFixedVariant: Color(0xff001508),
      secondaryFixed: Color(0xffcbead1),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffb0ceb5),
      onSecondaryFixedVariant: Color(0xff001508),
      tertiaryFixed: Color(0xffffdcc2),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffffb77a),
      onTertiaryFixedVariant: Color(0xff1f0c00),
      surfaceDim: Color(0xff101411),
      surfaceBright: Color(0xff4c514c),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1c211d),
      surfaceContainer: Color(0xff2d322d),
      surfaceContainerHigh: Color(0xff383d38),
      surfaceContainerHighest: Color(0xff434843),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.background,
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
