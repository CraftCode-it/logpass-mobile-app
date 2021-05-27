import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

late AppThemeColors _appThemeColors;

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

class AppColors {
  // Light
  static const primaryLight = Color(0xFF2233AA);
  static const secondaryLight = Color(0xFFCFD0DD);
  static const backgroundLight = Color(0xFFE5E5E5);
  static const primaryTextLight = Color(0xFF676983);
  static const buttonEnabledLight = Color(0xFFAAABC4);
  static const buttonEnabledTextLight = Color(0xFFFAF9FC);

  // Dark
  static const primaryDark = Color(0xFF2233AA);
  static const backgroundDark = Color(0xFF676983);
  static const primaryTextDark = Color(0xFFFFFFFF);
}

abstract class AppThemeColors {
  Color get primary;

  Color get secondary;

  Color get primaryText;

  Color get primaryButton;

  Color get primaryButtonText;
}

class LightThemeColors implements AppThemeColors {
  @override
  Color get primary => AppColors.primaryLight;

  @override
  Color get secondary => AppColors.secondaryLight;

  @override
  Color get primaryText => AppColors.primaryTextLight;

  @override
  Color get primaryButton => AppColors.buttonEnabledLight;

  @override
  Color get primaryButtonText => AppColors.buttonEnabledTextLight;
}

class DarkThemeColors implements AppThemeColors {
  @override
  Color get primary => AppColors.primaryDark;

  @override
  Color get secondary => AppColors.secondaryLight;

  @override
  Color get primaryText => AppColors.primaryTextDark;

  @override
  Color get primaryButton => AppColors.buttonEnabledLight;

  @override
  Color get primaryButtonText => AppColors.buttonEnabledTextLight;
}
