import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';

class AppTypography {
  final AppThemeColors _colors;

  AppTypography(this._colors);

  TextStyle get h1 => TextStyle(
        fontSize: 36,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
        color: _colors.text,
      );

  TextStyle get h2 => TextStyle(
        fontSize: 36,
        letterSpacing: 0,
        fontWeight: FontWeight.w500,
        color: _colors.text,
      );

  TextStyle get h3 => TextStyle(
        fontSize: 24,
        letterSpacing: 0,
        fontWeight: FontWeight.w500,
        color: _colors.text,
      );

  TextStyle get h4 => TextStyle(
        fontSize: 24,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
        color: _colors.text,
      );

  TextStyle get h5 => TextStyle(
        fontSize: 20,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
        color: _colors.text,
      );

  TextStyle get h6 => TextStyle(
        fontSize: 20,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
        color: _colors.text,
      );

  TextStyle get h7 => TextStyle(
        fontSize: 18,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
        color: _colors.text,
      );

  TextStyle get h8 => TextStyle(
        fontSize: 16,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
        color: _colors.text,
      );

  TextStyle get h9 => TextStyle(
        fontSize: 16,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
        color: _colors.text,
      );

  TextStyle get body1 => TextStyle(
        fontSize: 14,
        height: 1.7,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
        color: _colors.text,
      );

  TextStyle get body2 => TextStyle(
        fontSize: 14,
        height: 1.7,
        letterSpacing: 0,
        fontWeight: FontWeight.w500,
        color: _colors.text,
      );

  TextStyle get body3 => TextStyle(
        fontSize: 14,
        height: 1.7,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
        color: _colors.text,
      );

  TextStyle get info1 => TextStyle(
        fontSize: 12,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
        color: _colors.text,
      );

  TextStyle get info2 => TextStyle(
        fontSize: 12,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
        color: _colors.text,
      );

  TextStyle get input => TextStyle(
        fontSize: 10,
        letterSpacing: 0,
        fontWeight: FontWeight.w500,
        color: _colors.text,
      );
}

AppTypography useAppTypography() {
  final colors = useAppThemeColors();
  return useMemoized(() => AppTypography(colors), [colors]);
}
