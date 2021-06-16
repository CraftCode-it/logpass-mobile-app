import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

void showConnectionErrorSnackBar({
  required GeneralConnectionError error,
  required BuildContext context,
  required AppThemeColors colors,
  required AppTypography typography,
}) {
  final contentText = error.when(
    noConnection: () => tr(LocaleKeys.error_noConnection),
    timeout: () => tr(LocaleKeys.error_timeout),
    somethingWentWrong: () => tr(LocaleKeys.error_somethingWentWrong)
  );

  final snackBar = SnackBar(
    backgroundColor: AppColors.snackBarErrorBackground,
    content: Text(
      contentText,
      style: typography.snackBar,
      textAlign: TextAlign.center,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
