import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:logpass_me/domain/user_data/default_data.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/logpass_dialog.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

Future<void> showMore<T extends DefaultData>(
  BuildContext context,
  T object,
  AppTypography typography,
  AppThemeColors colors,
  Function(T) onRemoveCallback,
  Function(T) onSetDefaultCallback,
) async {
  if (object.isDefault) {
    await showCustomContentDialog(
      context,
      [
        CustomRectangularButton.filled(
          text: LocaleKeys.yourData_removeOption.tr(),
          fillColor: AppColors.error100,
          borderColor: AppColors.error100,
          onPressed: () {
            AutoRouter.of(context).pop();
            onRemoveCallback(object);
          },
          leadingIconPath: AppIcon.bin,
        ),
      ],
      colors,
    );
  } else {
    await showCustomContentDialog(
      context,
      [
        CustomRectangularButton.filled(
          text: LocaleKeys.yourData_setDefaultOption.tr(),
          fillColor: AppColors.success100,
          borderColor: AppColors.success100,
          onPressed: () {
            AutoRouter.of(context).pop();
            onSetDefaultCallback(object);
          },
          leadingIconPath: AppIcon.star,
        ),
        CustomRectangularButton.outlined(
          text: LocaleKeys.yourData_removeOption.tr(),
          onPressed: () {
            AutoRouter.of(context).pop();
            onRemoveCallback(object);
          },
        ),
      ],
      colors,
    );
  }
}
