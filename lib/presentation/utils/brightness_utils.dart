import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logpass_me/domain/theme/theme_brightness.dart';

extension BrightnessSwitch on ThemeBrightness {
  Brightness toBrightness() {
    switch (this) {
      case ThemeBrightness.light:
        return Brightness.light;
      case ThemeBrightness.dark:
        return Brightness.dark;
      case ThemeBrightness.system:
        return WidgetsBinding.instance!.window.platformBrightness;
    }
  }
}
