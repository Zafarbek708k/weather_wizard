import 'dart:developer';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';


const String _spLocalKey = "app_local";

enum LangCodes { uz, ru, en, ja, ar }

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('uz', 'UZ')) {
    _loadLocale();
  }

  /// Load locale from SharedPreferences
  Future<void> _loadLocale() async {
    final sp = await SharedPreferences.getInstance();
    final appLocal = sp.getString(_spLocalKey);
    if (appLocal != null && appLocal.isNotEmpty) {
      emit(_getLocaleFromCode(appLocal));
      log("Loaded locale from SharedPreferences: $appLocal");
    }
  }

  /// Change and save the locale
  Future<void> changeLocale(LangCodes langCode) async {
    final newLocale = _getLocaleFromCode(langCode.name);
    emit(newLocale);
    log("Locale changed to: ${langCode.name}");

    final sp = await SharedPreferences.getInstance();
    await sp.setString(_spLocalKey, langCode.name);
    log("Locale saved to SharedPreferences: ${langCode.name}");
  }

  /// Helper method to get Locale from LangCodes
  Locale _getLocaleFromCode(String code) {
    switch (code) {
      case "ru":
        return const Locale("ru", "RU");
      case "en":
        return const Locale("en", "US");
      case "ja":
        return const Locale("ja", "JP");
      case "ar":
        return const Locale("ar", "SA");
      case "uz":
      default:
        return const Locale("uz", "UZ");
    }
  }
}
