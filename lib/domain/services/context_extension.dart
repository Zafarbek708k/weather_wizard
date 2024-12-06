export "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'package:flutter/material.dart';
import 'package:weather_wizard/feature/core/style/text_style.dart';
import 'context_extension.dart';

extension CustomContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  ThemeData get theme => Theme.of(this);
  ColorScheme get appTheme => Theme.of(this).colorScheme; // Theme.of(context).colorScheme
  AppTextStyle get appTextStyle => AppTextStyle(this);
  AppLocalizations get localized => AppLocalizations.of(this)!;
}
