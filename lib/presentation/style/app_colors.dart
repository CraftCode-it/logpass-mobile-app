import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

late BehaviorSubject<AppThemeColors> _appThemeColorsSubject;

void updateAppThemeColors(Brightness brightness) {
  switch (brightness) {
    case Brightness.dark:
      _appThemeColorsSubject.sink.add(DarkThemeColors());
      break;
    case Brightness.light:
      _appThemeColorsSubject.sink.add(LightThemeColors());
      break;
  }
}

void setupAppThemeColor(Brightness brightness) {
  switch (brightness) {
    case Brightness.dark:
      _appThemeColorsSubject = BehaviorSubject.seeded(DarkThemeColors());
      break;
    case Brightness.light:
      _appThemeColorsSubject = BehaviorSubject.seeded(LightThemeColors());
      break;
  }
}

AppThemeColors useAppThemeColors() {
  final appThemeColors = useStream(_appThemeColorsSubject).data ?? _appThemeColorsSubject.value;
  return appThemeColors;
}

class AppColors {
  static const snackBarText = Color(0xFFFFFFFF);
  static const snackBarSuccessBackground = Color(0xFF14CA89);
  static const snackBarErrorBackground = Color(0xFFFC264C);

  // Light
  static const primaryLight100 = Color(0xFF191933);
  static const primaryLight90 = Color(0xFF303047);
  static const primaryLight80 = Color(0xFF47475C);
  static const primaryLight70 = Color(0xFF5E5E70);
  static const primaryLight60 = Color(0xFF757585);
  static const primaryLight50 = Color(0xFF8C8C99);
  static const primaryLight40 = Color(0xFFA3A3AD);
  static const primaryLight30 = Color(0xFFBABAC2);
  static const primaryLight20 = Color(0xFFD1D1D6);
  static const primaryLight10 = Color(0xFFE8E8EB);
  static const primaryLight05 = Color(0xFFF4F4F5);
  static const primaryLight02 = Color(0xFFF9F9FA);

  static const successLight100 = Color(0xFF14CA89);
  static const successLight90 = Color(0xFF2CCF95);
  static const successLight80 = Color(0xFF43D5A1);
  static const successLight70 = Color(0xFF5BDAAC);
  static const successLight60 = Color(0xFF72DFB8);
  static const successLight50 = Color(0xFF8AE4C4);
  static const successLight40 = Color(0xFF82E3C0);
  static const successLight30 = Color(0xFFB9EFDC);
  static const successLight20 = Color(0xFFD0F4E7);
  static const successLight10 = Color(0xFFE8FAF3);

  static const errorLight100 = Color(0xFFFC264C);
  static const errorLight90 = Color(0xFFFC3C5E);
  static const errorLight80 = Color(0xFFFC5170);
  static const errorLight70 = Color(0xFFFD6782);
  static const errorLight60 = Color(0xFFFD7D94);
  static const errorLight50 = Color(0xFFFD92A5);
  static const errorLight40 = Color(0xFFFEA8B7);
  static const errorLight30 = Color(0xFFFEBEC9);
  static const errorLight20 = Color(0xFFFED4DB);
  static const errorLight10 = Color(0xFFFFE9ED);

  static const secondaryLight = Color(0xFFFFFFFF);
  static const backgroundLight = Color(0xFFFFFFFF);
  static const primaryTextLight = Color(0xFF676983);
  static const buttonEnabledLight = Color(0xFFAAABC4);
  static const buttonEnabledTextLight = Color(0xFFFAF9FC);
  static const errorTextLight = Color(0xFFFF0000);
  static const dividerDarkLight = Color(0xFFAAABC4);
  static const dividerMediumLight = Color(0xFFAAABC4);
  static const dividerLightLight = Color(0xFFCFD0DD);

  // Dark
  static const primaryDark = Color(0xFF2233AA);
  static const backgroundDark = Color(0xFF676983);
  static const primaryTextDark = Color(0xFFFFFFFF);
  static const errorTextDark = Color(0xFFFF0000);
  static const dividerDarkDark = Color(0xFFAAABC4);
  static const dividerMediumDark = Color(0xFFAAABC4);
  static const dividerLightDark = Color(0xFFCFD0DD);
}

abstract class AppThemeColors {
  Color get primary100;

  Color get primary90;

  Color get primary80;

  Color get primary70;

  Color get primary60;

  Color get primary50;

  Color get primary40;

  Color get primary30;

  Color get primary20;

  Color get primary10;

  Color get primary05;

  Color get primary02;

  Color get success100;

  Color get success90;

  Color get success80;

  Color get success70;

  Color get success60;

  Color get success50;

  Color get success40;

  Color get success30;

  Color get success20;

  Color get success10;

  Color get error100;

  Color get error90;

  Color get error80;

  Color get error70;

  Color get error60;

  Color get error50;

  Color get error40;

  Color get error30;

  Color get error20;

  Color get error10;

  Color get secondary;

  Color get primaryText;

  Color get primaryButton;

  Color get primaryButtonText;

  Color get errorText;

  Color get dividerDark;

  Color get dividerMedium;

  Color get dividerLight;

  Color get background;
}

class LightThemeColors implements AppThemeColors {
  @override
  Color get primary100 => AppColors.primaryLight100;

  @override
  Color get primary90 => AppColors.primaryLight90;

  @override
  Color get primary80 => AppColors.primaryLight80;

  @override
  Color get primary70 => AppColors.primaryLight70;

  @override
  Color get primary60 => AppColors.primaryLight60;

  @override
  Color get primary50 => AppColors.primaryLight50;

  @override
  Color get primary40 => AppColors.primaryLight40;

  @override
  Color get primary30 => AppColors.primaryLight30;

  @override
  Color get primary20 => AppColors.primaryLight20;

  @override
  Color get primary10 => AppColors.primaryLight10;

  @override
  Color get primary05 => AppColors.primaryLight05;

  @override
  Color get primary02 => AppColors.primaryLight02;

  @override
  Color get success100 => AppColors.successLight100;

  @override
  Color get success90 => AppColors.successLight90;

  @override
  Color get success80 => AppColors.successLight80;

  @override
  Color get success70 => AppColors.successLight70;

  @override
  Color get success60 => AppColors.successLight60;

  @override
  Color get success50 => AppColors.successLight50;

  @override
  Color get success40 => AppColors.successLight40;

  @override
  Color get success30 => AppColors.successLight30;

  @override
  Color get success20 => AppColors.successLight20;

  @override
  Color get success10 => AppColors.successLight10;

  @override
  Color get error100 => AppColors.errorLight100;

  @override
  Color get error90 => AppColors.errorLight90;

  @override
  Color get error80 => AppColors.errorLight80;

  @override
  Color get error70 => AppColors.errorLight70;

  @override
  Color get error60 => AppColors.errorLight60;

  @override
  Color get error50 => AppColors.errorLight50;

  @override
  Color get error40 => AppColors.errorLight40;

  @override
  Color get error30 => AppColors.errorLight30;

  @override
  Color get error20 => AppColors.errorLight20;

  @override
  Color get error10 => AppColors.errorLight10;

  @override
  Color get secondary => AppColors.secondaryLight;

  @override
  Color get primaryText => AppColors.primaryTextLight;

  @override
  Color get primaryButton => AppColors.buttonEnabledLight;

  @override
  Color get primaryButtonText => AppColors.buttonEnabledTextLight;

  @override
  Color get errorText => AppColors.errorTextLight;

  @override
  Color get dividerDark => AppColors.dividerDarkLight;

  @override
  Color get dividerMedium => AppColors.dividerMediumLight;

  @override
  Color get dividerLight => AppColors.dividerLightLight;

  @override
  Color get background => AppColors.backgroundLight;
}

class DarkThemeColors implements AppThemeColors {
  @override
  Color get primary100 => AppColors.primaryLight100;

  @override
  Color get primary90 => AppColors.primaryLight90;

  @override
  Color get primary80 => AppColors.primaryLight80;

  @override
  Color get primary70 => AppColors.primaryLight70;

  @override
  Color get primary60 => AppColors.primaryLight60;

  @override
  Color get primary50 => AppColors.primaryLight50;

  @override
  Color get primary40 => AppColors.primaryLight40;

  @override
  Color get primary30 => AppColors.primaryLight30;

  @override
  Color get primary20 => AppColors.primaryLight20;

  @override
  Color get primary10 => AppColors.primaryLight10;

  @override
  Color get primary05 => AppColors.primaryLight05;

  @override
  Color get primary02 => AppColors.primaryLight02;

  @override
  Color get success100 => AppColors.successLight100;

  @override
  Color get success90 => AppColors.successLight90;

  @override
  Color get success80 => AppColors.successLight80;

  @override
  Color get success70 => AppColors.successLight70;

  @override
  Color get success60 => AppColors.successLight60;

  @override
  Color get success50 => AppColors.successLight50;

  @override
  Color get success40 => AppColors.successLight40;

  @override
  Color get success30 => AppColors.successLight30;

  @override
  Color get success20 => AppColors.successLight20;

  @override
  Color get success10 => AppColors.successLight10;

  @override
  Color get error100 => AppColors.errorLight100;

  @override
  Color get error90 => AppColors.errorLight90;

  @override
  Color get error80 => AppColors.errorLight80;

  @override
  Color get error70 => AppColors.errorLight70;

  @override
  Color get error60 => AppColors.errorLight60;

  @override
  Color get error50 => AppColors.errorLight50;

  @override
  Color get error40 => AppColors.errorLight40;

  @override
  Color get error30 => AppColors.errorLight30;

  @override
  Color get error20 => AppColors.errorLight20;

  @override
  Color get error10 => AppColors.errorLight10;

  @override
  Color get secondary => AppColors.secondaryLight;

  @override
  Color get primaryText => AppColors.primaryTextDark;

  @override
  Color get primaryButton => AppColors.buttonEnabledLight;

  @override
  Color get primaryButtonText => AppColors.buttonEnabledTextLight;

  @override
  Color get errorText => AppColors.errorTextDark;

  @override
  Color get dividerDark => AppColors.dividerDarkDark;

  @override
  Color get dividerMedium => AppColors.dividerMediumDark;

  @override
  Color get dividerLight => AppColors.dividerLightDark;

  @override
  Color get background => AppColors.backgroundDark;
}
