import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:weather_wizard/application/favorite_bloc/favorite_bloc.dart';
import 'package:weather_wizard/application/home_bloc/home_bloc.dart';
import 'package:weather_wizard/domain/services/context_extension.dart';
import 'package:weather_wizard/feature/core/route/app_route.dart';
import 'package:weather_wizard/feature/core/setting/locale_cubit.dart';
import 'package:weather_wizard/feature/core/setting/theme_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  static void run() => runApp(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ThemeCubit()),
            BlocProvider(create: (_) => LocaleCubit()),
            BlocProvider(create: (_) => HomeBloc()),
            BlocProvider(create: (_) => FavoriteBloc()),
          ],
          child: const App(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, widget) => KeyboardDismisser(
        gestures: const [GestureType.onTap, GestureType.onDoubleTap],
        child: BlocBuilder<ThemeCubit, ThemeData>(
          builder: (BuildContext context, ThemeData theme) {
            return BlocBuilder<LocaleCubit, Locale>(
              builder: (context, locale) {
                return MaterialApp.router(
                  title: "Weather Wizard",
                  supportedLocales: AppLocalizations.supportedLocales,
                  localizationsDelegates: AppLocalizations.localizationsDelegates,
                  debugShowCheckedModeBanner: false,
                  theme: theme,
                  locale: locale,
                  routerConfig: AppRouter.router,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
