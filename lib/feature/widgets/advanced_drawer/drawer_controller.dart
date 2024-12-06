

import 'package:flutter/material.dart';

/// Advanced Drawer Controller that manage drawer state.
class AdvancedDrawerController extends ValueNotifier<AdvancedDrawerValue> {
  /// Creates controller with initial drawer state. (Hidden by default)
  AdvancedDrawerController([AdvancedDrawerValue? value])
      : super(value ?? AdvancedDrawerValue.hidden());

  /// Shows drawer.
  void showDrawer() {
    value = AdvancedDrawerValue.visible();
    notifyListeners();
  }

  /// Hides drawer.
  void hideDrawer() {
    value = AdvancedDrawerValue.hidden();
    notifyListeners();
  }

  /// Toggles drawer.
  void toggleDrawer() {
    if (value.visible) {
      return hideDrawer();
    }

    return showDrawer();
  }
}


/// AdvancedDrawer state value.
class AdvancedDrawerValue {
  const AdvancedDrawerValue({
    this.visible = false,
  });

  /// Indicates whether drawer visible or not.
  final bool visible;

  /// Create a value with hidden state.
  factory AdvancedDrawerValue.hidden() {
    return const AdvancedDrawerValue();
  }

  /// Create a value with visible state.
  factory AdvancedDrawerValue.visible() {
    return const AdvancedDrawerValue(
      visible: true,
    );
  }
}