import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';

class AppTypography {
  final AppThemeColors _colors;

  AppTypography(this._colors);

  TextStyle get primary => TextStyle(fontSize: 16, color: _colors.primaryText);

  TextStyle get button => TextStyle(fontSize: 18, color: _colors.primaryButtonText);

  TextStyle get error => TextStyle(fontSize: 10, color: _colors.errorText);

  TextStyle get snackBar => const TextStyle(fontSize: 10, color: AppColors.snackBarText);
}

AppTypography useAppTypography() {
  final colors = useAppThemeColors();
  return useMemoized(() => AppTypography(colors), [colors]);
}
