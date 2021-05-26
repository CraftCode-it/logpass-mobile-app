import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

late AppThemeColors _appThemeColors;

class AppColors {
  // Light
  static const primaryLight = Color(0xFF2233AA);
  static const backgroundLight = Color(0xFFE5E5E5);
  static const primaryTextLight = Color(0xFF676983);

  // Dark
  static const primaryDark = Color(0xFF2233AA);
  static const backgroundDark = Color(0xFF676983);
  static const primaryTextDark = Color(0xFFFFFFFF);
}

abstract class AppThemeColors {
  Color get primary;

  Color get primaryText;
}

class LightThemeColors implements AppThemeColors {
  @override
  Color get primary => AppColors.primaryLight;

  @override
  Color get primaryText => AppColors.primaryTextLight;
}

class DarkThemeColors implements AppThemeColors {
  @override
  Color get primary => AppColors.primaryDark;

  @override
  Color get primaryText => AppColors.primaryTextDark;
}

void updateAppThemeColors(Brightness brightness) {
  switch (brightness) {
    case Brightness.dark:
      _appThemeColors = DarkThemeColors();
      break;
    case Brightness.light:
      _appThemeColors = LightThemeColors();
      break;
  }
}

AppThemeColors useAppThemeColors() {
  return useMemoized(() => _appThemeColors, [_appThemeColors]);
}
