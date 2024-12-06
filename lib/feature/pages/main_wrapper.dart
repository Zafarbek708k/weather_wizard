import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_wizard/domain/services/context_extension.dart';
import 'package:weather_wizard/feature/widgets/advanced_drawer/advanced_drawer.dart';
import 'package:weather_wizard/feature/widgets/advanced_drawer/drawer_controller.dart';
import 'package:weather_wizard/feature/widgets/custom_drawer.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      controller: AdvancedDrawerController(),
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16))),
      backdropColor: context.appTheme.primary,
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueGrey, Colors.blueGrey.withOpacity(0.2)],
          ),
        ),
      ),
      drawer: const CustomMainDrawer(),
      child: Scaffold(
        body: widget.navigationShell,
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(splashColor: Colors.transparent, highlightColor: Colors.transparent),
          child: DecoratedBox(
            decoration: const BoxDecoration(border: Border.symmetric(vertical: BorderSide(color: Colors.black, width: 5))),
            child: BottomNavigationBar(
              selectedLabelStyle: context.appTextStyle.bodyMedium,
              unselectedLabelStyle: context.appTextStyle.bodyMedium,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              unselectedFontSize: 8,
              // Adjust sizes
              selectedFontSize: 10,
              unselectedItemColor: context.appTheme.secondary,
              selectedItemColor: Colors.blue,
              elevation: 0,
              backgroundColor: context.appTheme.secondaryContainer,
              currentIndex: widget.navigationShell.currentIndex,
              showUnselectedLabels: true,
              items: [
                BottomNavigationBarItem(icon: const Icon(Icons.home_max), label: context.localized.home),
                BottomNavigationBarItem(icon: const Icon(Icons.favorite_border), label: context.localized.favorite),
                BottomNavigationBarItem(icon: const Icon(Icons.person_2_outlined), label: context.localized.author),
              ],
              onTap: (index) => _onItemTapped(index),
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}
