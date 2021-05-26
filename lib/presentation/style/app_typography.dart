import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';

class AppTypography {
  final AppThemeColors _colors;

  AppTypography(this._colors);

  TextStyle get primary => TextStyle(fontSize: 16, color: _colors.primaryText);
}

AppTypography useAppTypography() {
  final colors = useAppThemeColors();
  return useMemoized(() => AppTypography(colors), [colors]);
}
