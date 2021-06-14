import 'package:flutter/material.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

// TODO: handle information in accordance to established approach
void showInformationSnackBar({
  required Widget content,
  required BuildContext context,
  required AppThemeColors colors,
  required AppTypography typography,
}) {
  final snackBar = SnackBar(
    backgroundColor: AppColors.primaryDark,
    content: content,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
