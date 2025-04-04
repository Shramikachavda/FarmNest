import 'package:agri_flutter/theme/theme.dart';
import 'package:agri_flutter/utils/shared_prefs_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// app_theme_event.dart
abstract class AppThemeEvent {}

class ToggleTheme extends AppThemeEvent {}

class AppThemeState {
  final ThemeMode themeMode;

  AppThemeState({required this.themeMode});
}

class AppThemeBloc extends Bloc<AppThemeEvent, AppThemeState> {
  AppThemeBloc._(ThemeMode initialMode)
      : super(AppThemeState(themeMode: initialMode)) {
    on<ToggleTheme>((event, emit) async {
      final isDark = state.themeMode == ThemeMode.dark;
      final newTheme = isDark ? ThemeMode.light : ThemeMode.dark;
      await SpUtil.setThemeMode(newTheme);
      emit(AppThemeState(themeMode: newTheme));
    });
  }

  static Future<AppThemeBloc> create() async {
    final savedTheme = await SpUtil.getThemeMode();
    return AppThemeBloc._(savedTheme);
  }
}
