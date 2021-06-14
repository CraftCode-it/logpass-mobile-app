import 'package:flutter/material.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

void showInformationSnackBar({
  required BuildContext context,
  required AppThemeColors colors,
  required AppTypography typography,
  VoidCallback? onTapAction,
}) {
  final snackBar = SnackBar(
    backgroundColor: AppColors.primaryDark,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          tr(LocaleKeys.main_new_action),
          style: typography.snackBar,
          textAlign: TextAlign.center,
        ),
        if (onTapAction != null)
          GestureDetector(
            onTap: onTapAction,
            child: Text(
              tr(LocaleKeys.main_open_action_label),
              style: typography.snackBar,
              textAlign: TextAlign.center,
            ),
          ),
      ],
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
