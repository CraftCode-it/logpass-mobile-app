import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

void showInformationSnackBar({
  required BuildContext context,
  required AppThemeColors colors,
  required AppTypography typography,
  required String message,
  VoidCallback? onTapAction,
}) {
  final snackBar = SnackBar(
    backgroundColor: Colors.transparent,
    padding: const EdgeInsets.all(AppDimens.zero),
    content: Container(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.m, horizontal: AppDimens.l),
      color: AppColors.success100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            message,
            style: typography.input.copyWith(color: colors.textSpecial),
            textAlign: TextAlign.center,
          ),
          if (onTapAction != null)
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                onTapAction();
              },
              child: Text(
                tr(LocaleKeys.main_open_action_label),
                style: typography.input.copyWith(color: colors.textSpecial),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
