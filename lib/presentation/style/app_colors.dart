import 'dart:ui';

import 'package:flutter_hooks/flutter_hooks.dart';

late AppThemeColors _appThemeColors;

class _AppColors {
  // Light
  static const backgroundLight = Color(0x00E5E5E5);
  static const primaryTextLight = Color(0x00676983);

  // Dark
  static const backgroundDark = Color(0x00676983);
  static const primaryTextDark = Color(0x00FFFFFF);
}

abstract class AppThemeColors {
  Color get background;

  Color get primaryText;
}

class LightThemeColors implements AppThemeColors {
  @override
  Color get background => _AppColors.backgroundLight;

  @override
  Color get primaryText => _AppColors.primaryTextLight;
}

class DarkThemeColors implements AppThemeColors {
  @override
  Color get background => _AppColors.backgroundDark;

  @override
  Color get primaryText => _AppColors.primaryTextDark;
}

AppThemeColors useAppThemeColors() {
  return useMemoized(() => _appThemeColors, [_appThemeColors]);
}
