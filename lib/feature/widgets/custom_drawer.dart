import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_wizard/domain/services/context_extension.dart';
import 'package:weather_wizard/feature/core/setting/locale_cubit.dart';
import 'package:weather_wizard/feature/core/setting/theme_cubit.dart';

class CustomMainDrawer extends StatelessWidget {
  const CustomMainDrawer({super.key});

  final MethodChannel channel = const MethodChannel("urlLaunching");

  // Method to open a URL in the browser
  Future<void> openUrlInBrowser(String url) async {
    try {
      final result = await channel.invokeMethod('openUrlInBrowser', {'url': url});
      log(result); // Handle success (URL_OPENED)
    } on PlatformException catch (e) {
      log("Failed to open URL: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: context.appTheme.primary,
      child: Padding(
        padding: REdgeInsets.symmetric(horizontal: 12, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  onPressed: () => context.read<LocaleCubit>().changeLocale(LangCodes.uz),
                  shape: const StadiumBorder(side: BorderSide(color: Colors.greenAccent)),
                  child: const Text("Uz"),
                ),
                MaterialButton(
                  onPressed: () => context.read<LocaleCubit>().changeLocale(LangCodes.ru),
                  shape: const StadiumBorder(side: BorderSide(color: Colors.greenAccent)),
                  child: const Text("Ru"),
                ),
                MaterialButton(
                  onPressed: () => context.read<LocaleCubit>().changeLocale(LangCodes.en),
                  shape: const StadiumBorder(side: BorderSide(color: Colors.greenAccent)),
                  child: const Text("En"),
                ),
              ],
            ),
            MaterialButton(
              onPressed: () async => context.read<ThemeCubit>().toggleTheme(),
              minWidth: double.infinity,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9), side: BorderSide(color: context.appTheme.secondary)),
              child: Text(context.localized.switchTheme, style: TextStyle(color: context.appTheme.secondary)),
            ),


            const Spacer(),
            InkWell(
              onTap: () async => await openUrlInBrowser("https://github.com/Zafarbek708k"),
              child: const Text("GitHub", style: TextStyle(color: Colors.lightBlueAccent, fontSize: 18)),
            ),
            const Divider(),
            InkWell(
              onTap: () async => await openUrlInBrowser("https://www.linkedin.com/in/zafarbek-karimov"),
              child: const Text("LinkedIn", style: TextStyle(color: Colors.lightBlueAccent, fontSize: 18)),
            ),
            const Divider(),
            const Text("Created by Zafarbek Karimov", style: TextStyle(color: Colors.lightBlueAccent, fontSize: 18)),
            const SizedBox(height: 50)
          ],
        ),
      ),
    );
  }
}
