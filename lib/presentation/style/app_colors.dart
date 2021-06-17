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
  static const snackBarText = secondary;
  static const snackBarSuccessBackground = success100;
  static const snackBarErrorBackground = error100;

  static const primary100 = Color(0xFF191933);
  static const primary97 = Color(0xFF1F1F38);
  static const primary95 = Color(0xFF25253D);
  static const primary90 = Color(0xFF303047);
  static const primary80 = Color(0xFF47475C);
  static const primary70 = Color(0xFF5E5E70);
  static const primary60 = Color(0xFF757585);
  static const primary50 = Color(0xFF8C8C99);
  static const primary40 = Color(0xFFA3A3AD);
  static const primary30 = Color(0xFFBABAC2);
  static const primary20 = Color(0xFFD1D1D6);
  static const primary10 = Color(0xFFE8E8EB);
  static const primary05 = Color(0xFFF4F4F5);
  static const primary02 = Color(0xFFF9F9FA);

  static const success100 = Color(0xFF14CA89);
  static const success90 = Color(0xFF2CCF95);
  static const success80 = Color(0xFF43D5A1);
  static const success70 = Color(0xFF5BDAAC);
  static const success60 = Color(0xFF72DFB8);
  static const success50 = Color(0xFF8AE4C4);
  static const success40 = Color(0xFF82E3C0);
  static const success30 = Color(0xFFB9EFDC);
  static const success20 = Color(0xFFD0F4E7);
  static const success10 = Color(0xFFE8FAF3);

  static const error100 = Color(0xFFFC264C);
  static const error90 = Color(0xFFFC3C5E);
  static const error80 = Color(0xFFFC5170);
  static const error70 = Color(0xFFFD6782);
  static const error60 = Color(0xFFFD7D94);
  static const error50 = Color(0xFFFD92A5);
  static const error40 = Color(0xFFFEA8B7);
  static const error30 = Color(0xFFFEBEC9);
  static const error20 = Color(0xFFFED4DB);
  static const error10 = Color(0xFFFFE9ED);

  static const secondary = Colors.white;

  // Light mode

  static const backgroundLight = secondary;
  static const primaryTextLight = primary100;
  static const textInvertedLight = secondary;
  static const secondaryTextLight = primary70;
  static const inactiveTextLight = primary20;
  static const labelTextLight = primary40;

  static const inputHintLight = primary40;
  static const inputInactiveHintLight = primary20;
  static const inputLabelLight = primary40;
  static const inputBorderLight = primary20;
  static const inputFocusedBorderLight = primary100;
  static const inputInactiveBorderLight = primary20;
  static const inputTextLight = primary100;
  static const inputTextInactiveLight = primary20;

  static const buttonOutlinedFillLight = secondary;
  static const buttonFillLight = primary100;
  static const buttonFillInactiveLight = primary20;
  static const buttonFilledTextLight = secondary;
  static const buttonFilledInactiveTextLight = secondary;

  static const buttonOutlinedLight = primary100;
  static const buttonOutlinedInactiveLight = primary20;
  static const buttonOutlinedTextLight = primary100;
  static const buttonOutlinedTextInactiveLight = primary20;

  static const dividerDarkLight = Color(0xFFAAABC4);
  static const dividerMediumLight = Color(0xFFAAABC4);
  static const dividerLightLight = Color(0xFFCFD0DD);

  // Dark mode

  static const backgroundDark = primary100;
  static const primaryTextDark = primary10;
  static const textInvertedDark = primary10;
  static const secondaryTextDark = primary30;
  static const lightTextDark = primary40;
  static const labelTextDark = primary60;

  static const inputHintDark = primary60;
  static const inputInactiveHintDark = primary80;
  static const inputLabelDark = primary60;
  static const inputBorderDark = primary80;
  static const inputFocusedBorderDark = primary10;
  static const inputInactiveBorderDark = primary60;
  static const inputTextDark = primary10;
  static const inputTextInactiveDark = primary80;

  static const buttonFillDark = primary10;
  static const buttonFillInactiveDark = primary90;
  static const buttonFilledTextDark = primary100;
  static const buttonFilledInactiveTextDark = primary80;

  static const buttonOutlinedFillDark = primary100;
  static const buttonOutlinedDark = primary10;
  static const buttonOutlinedInactiveDark = primary90;
  static const buttonOutlinedTextDark = primary10;
  static const buttonOutlinedTextInactiveDark = primary90;

  static const dividerDarkDark = Color(0xFFAAABC4);
  static const dividerMediumDark = Color(0xFFAAABC4);
  static const dividerLightDark = Color(0xFFCFD0DD);
}

abstract class AppThemeColors {
  Color get text;

  Color get textSpecial;

  Color get secondaryText;

  Color get lightText;

  Color get labelText;

  Color get inputHint;

  Color get inputInactiveHint;

  Color get inputLabel;

  Color get inputBorder;

  Color get inputFocusedBorder;

  Color get inputInactiveBorder;

  Color get inputText;

  Color get inputInactiveText;

  Color get buttonFill;

  Color get buttonFillInactive;

  Color get buttonFilledText;

  Color get buttonFilledInactiveText;

  Color get buttonOutlinedFill;

  Color get buttonOutlined;

  Color get buttonOutlinedInactive;

  Color get buttonOutlinedText;

  Color get buttonOutlinedInactiveText;

  Color get dividerDark;

  Color get dividerMedium;

  Color get dividerLight;

  Color get background;

  Color get secondaryBackground;

  Color get bottomBarBackground;

  Color get bottomBarActiveText;

  Color get bottomBarInactiveText;

  Color get logo;

  Color get logoSpecial;

  Color get tabBarUnderline;

  Color get darkBackground;
}

class LightThemeColors implements AppThemeColors {
  @override
  Color get text => AppColors.primaryTextLight;

  @override
  Color get textSpecial => AppColors.textInvertedLight;

  @override
  Color get secondaryText => AppColors.secondaryTextLight;

  @override
  Color get lightText => AppColors.inactiveTextLight;

  @override
  Color get labelText => AppColors.labelTextLight;

  @override
  Color get inputHint => AppColors.inputHintLight;

  @override
  Color get inputInactiveHint => AppColors.inputInactiveHintLight;

  @override
  Color get inputLabel => AppColors.inputLabelLight;

  @override
  Color get inputBorder => AppColors.inputBorderLight;

  @override
  Color get inputFocusedBorder => AppColors.inputFocusedBorderLight;

  @override
  Color get inputInactiveBorder => AppColors.inputInactiveBorderLight;

  @override
  Color get inputText => AppColors.inputTextLight;

  @override
  Color get inputInactiveText => AppColors.inputTextInactiveLight;

  @override
  Color get buttonFill => AppColors.buttonFillLight;

  @override
  Color get buttonFillInactive => AppColors.buttonFillInactiveLight;

  @override
  Color get buttonFilledText => AppColors.buttonFilledTextLight;

  @override
  Color get buttonFilledInactiveText => AppColors.buttonFilledInactiveTextLight;

  @override
  Color get buttonOutlinedFill => AppColors.buttonOutlinedFillLight;

  @override
  Color get buttonOutlined => AppColors.buttonOutlinedLight;

  @override
  Color get buttonOutlinedInactive => AppColors.buttonOutlinedInactiveLight;

  @override
  Color get buttonOutlinedText => AppColors.buttonOutlinedTextLight;

  @override
  Color get buttonOutlinedInactiveText => AppColors.buttonOutlinedTextInactiveLight;

  @override
  Color get dividerDark => AppColors.dividerDarkLight;

  @override
  Color get dividerMedium => AppColors.dividerMediumLight;

  @override
  Color get dividerLight => AppColors.dividerLightLight;

  @override
  Color get background => AppColors.backgroundLight;

  @override
  Color get secondaryBackground => AppColors.primary02;

  @override
  Color get bottomBarBackground => AppColors.primary02;

  @override
  Color get bottomBarActiveText => AppColors.primary100;

  @override
  Color get bottomBarInactiveText => AppColors.primary40;

  @override
  Color get logo => AppColors.primary100;

  @override
  Color get logoSpecial => AppColors.secondary;

  @override
  Color get tabBarUnderline => AppColors.primary05;

  @override
  Color get darkBackground => AppColors.primary100;
}

class DarkThemeColors implements AppThemeColors {
  @override
  Color get text => AppColors.primaryTextDark;

  @override
  Color get textSpecial => AppColors.textInvertedDark;

  @override
  Color get secondaryText => AppColors.secondaryTextDark;

  @override
  Color get lightText => AppColors.lightTextDark;

  @override
  Color get labelText => AppColors.labelTextDark;

  @override
  Color get inputHint => AppColors.inputHintDark;

  @override
  Color get inputInactiveHint => AppColors.inputInactiveHintDark;

  @override
  Color get inputLabel => AppColors.inputLabelDark;

  @override
  Color get inputBorder => AppColors.inputBorderDark;

  @override
  Color get inputFocusedBorder => AppColors.inputFocusedBorderDark;

  @override
  Color get inputInactiveBorder => AppColors.inputInactiveBorderDark;

  @override
  Color get inputText => AppColors.inputTextDark;

  @override
  Color get inputInactiveText => AppColors.inputTextInactiveDark;

  @override
  Color get buttonFill => AppColors.buttonFillDark;

  @override
  Color get buttonFillInactive => AppColors.buttonFillInactiveDark;

  @override
  Color get buttonFilledText => AppColors.buttonFilledTextDark;

  @override
  Color get buttonFilledInactiveText => AppColors.buttonFilledInactiveTextDark;

  @override
  Color get buttonOutlinedFill => AppColors.buttonOutlinedFillDark;

  @override
  Color get buttonOutlined => AppColors.buttonOutlinedDark;

  @override
  Color get buttonOutlinedInactive => AppColors.buttonOutlinedInactiveDark;

  @override
  Color get buttonOutlinedText => AppColors.buttonOutlinedTextDark;

  @override
  Color get buttonOutlinedInactiveText => AppColors.buttonOutlinedTextInactiveDark;

  @override
  Color get dividerDark => AppColors.dividerDarkDark;

  @override
  Color get dividerMedium => AppColors.dividerMediumDark;

  @override
  Color get dividerLight => AppColors.dividerLightDark;

  @override
  Color get background => AppColors.backgroundDark;

  @override
  Color get secondaryBackground => AppColors.primary97;

  @override
  Color get bottomBarBackground => AppColors.primary97;

  @override
  Color get bottomBarActiveText => AppColors.primary10;

  @override
  Color get bottomBarInactiveText => AppColors.primary60;

  @override
  Color get logo => AppColors.primary10;

  @override
  Color get logoSpecial => AppColors.primary10;

  @override
  Color get tabBarUnderline => AppColors.primary95;

  @override
  Color get darkBackground => AppColors.primary97;
}
