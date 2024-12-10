import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_wizard/domain/services/context_extension.dart';
import 'package:weather_wizard/feature/core/route/app_route_name.dart';
import 'package:weather_wizard/feature/widgets/custom_fade_animation.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Timer? _timer;

  Future<void> init() async {
    _timer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        context.go(AppRouteName.main);
      }
    });
  }

  @override
  void didChangeDependencies() async{
    await init();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appTheme.primary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: CustomFadeAnimation(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 300, child: SvgPicture.asset("assets/svg/weather.svg")),
                Text(context.localized.welcome, style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.w600, fontSize: 24)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
