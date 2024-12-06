import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../style/app_theme.dart';




const String _spThemeKey = "app_theme";

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(_getInitialTheme()) {
    _loadTheme();
  }

  static ThemeData _getInitialTheme() {
    ///WidgetsBinding.instance.platformDispatcher.views.first.physicalSize work for me. you can also try PlatformDispatcher.instance.views.first.physicalSize
    Brightness alfa  =  WidgetsBinding.instance.platformDispatcher.platformBrightness;
    // return WidgetsBinding.instance.window.platformBrightness == Brightness.dark
    //     ? AppThemes.dark()
    //     : AppThemes.light();
    return alfa == Brightness.dark? AppThemes.dark() : AppThemes.light();
  }

  /// Load theme preference from SharedPreferences
  Future<void> _loadTheme() async {
    final sp = await SharedPreferences.getInstance();
    final isLight = sp.getBool(_spThemeKey) ?? (state.brightness == Brightness.light);
    emit(isLight ? AppThemes.light() : AppThemes.dark());
  }

  /// Toggle and save the theme
  Future<void> toggleTheme() async {
    final isCurrentlyLight = state.brightness == Brightness.light;
    final newTheme = isCurrentlyLight ? AppThemes.dark() : AppThemes.light();
    emit(newTheme);

    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_spThemeKey, !isCurrentlyLight);
    log("Theme saved as ${!isCurrentlyLight ? "Dark" : "Light"} in SharedPreferences");
  }
}
