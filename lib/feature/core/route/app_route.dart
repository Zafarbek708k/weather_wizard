import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_wizard/feature/core/route/app_route_name.dart';
import 'package:weather_wizard/feature/pages/favorite/favorite.dart';
import 'package:weather_wizard/feature/pages/home/home.dart';
import 'package:weather_wizard/feature/pages/initial/splash.dart';
import 'package:weather_wizard/feature/pages/main_wrapper.dart';
import 'package:weather_wizard/feature/pages/profile/profile.dart';
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "shell-key");
final GlobalKey<NavigatorState> _appNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "app-key");
late StatefulNavigationShell _navigatorKey;

class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    navigatorKey: _appNavigatorKey,
    initialLocation: AppRouteName.splash,
    routes: [
      GoRoute(
        path: AppRouteName.splash,
        builder: (context, state) => const Splash(),
      ),
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _appNavigatorKey,
        builder: (context, state, navigationShell) {
          _navigatorKey = navigationShell;
          return MainWrapper(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKey,
            routes: [
              GoRoute(
                path: AppRouteName.main,
                pageBuilder: (context, state) => const CustomTransitionPage(
                  child: HomePage(),
                  transitionsBuilder: _fadeInTransition,
                  transitionDuration: Duration(seconds: 2), // Custom duration
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouteName.favorite,
                pageBuilder: (context, state) => const CustomTransitionPage(
                  child: Favorite(),
                  transitionsBuilder: _slideFromLeftTransition,
                  transitionDuration: Duration(seconds: 2), // Custom duration
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouteName.profile,
                pageBuilder: (context, state) => const CustomTransitionPage(
                  child: Profile(),
                  transitionsBuilder: _scaleTransition,
                  transitionDuration: Duration(seconds: 2), // Custom duration
                ),
              ),
            ],
          ),
        ],
      )
    ],
  );

  // Fade-in transition
  static Widget _fadeInTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return FadeTransition(opacity: animation, child: child);
  }

  // Slide-in from left transition
  static Widget _slideFromLeftTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    const begin = Offset(-1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOut;

    final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    final offsetAnimation = animation.drive(tween);

    return SlideTransition(position: offsetAnimation, child: child);
  }

  // Scale transition
  static Widget _scaleTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return ScaleTransition(scale: animation, child: child);
  }
}

