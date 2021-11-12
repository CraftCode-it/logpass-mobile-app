import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/user_data/default_data.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/widget/logpass_dialog.dart';
import 'package:logpass_me/presentation/widget/logpass_dialog_base.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';

Future<void> showMore<T extends DefaultData>(
  BuildContext context,
  T object,
  ValueChanged<T> onRemoveCallback,
  ValueChanged<T> onSetDefaultCallback,
  ValueChanged<T> onEditCallback,
) async {
  final isDefault = object.isDefault;

  await showModalBottomSheet(
    context: context,
    builder: (context) {
      return LogpassDialogBase(
        child: CustomContentDialog(
          widgets: [
            _EditDataAsDefaultDialogContent(object, onEditCallback),
            if (!isDefault) _SetDataAsDefaultDialogContent(object, onSetDefaultCallback),
            _RemoveDataDialogContent(object, onRemoveCallback, isOptionFilled: isDefault),
          ],
        ),
      );
    },
  );
}

class _SetDataAsDefaultDialogContent<T extends DefaultData> extends HookWidget {
  final T object;
  final Function(T) onSetDefaultCallback;

  const _SetDataAsDefaultDialogContent(
    this.object,
    this.onSetDefaultCallback,
  );

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();

    return CustomRectangularButton.filled(
      text: LocaleKeys.yourData_setDefaultOption.tr(),
      fillColor: AppColors.success100,
      borderColor: AppColors.success100,
      textColor: colors.textSpecial,
      onPressed: () {
        AutoRouter.of(context).pop();
        onSetDefaultCallback(object);
      },
      leadingIconPath: AppIcon.star,
    );
  }
}

class _RemoveDataDialogContent<T extends DefaultData> extends HookWidget {
  final T object;
  final Function(T) onRemoveCallback;
  final bool isOptionFilled;

  const _RemoveDataDialogContent(
    this.object,
    this.onRemoveCallback, {
    this.isOptionFilled = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();

    return isOptionFilled
        ? CustomRectangularButton.filled(
            text: LocaleKeys.yourData_removeOption.tr(),
            fillColor: AppColors.error100,
            borderColor: AppColors.error100,
            textColor: colors.textSpecial,
            onPressed: () {
              AutoRouter.of(context).pop();
              onRemoveCallback(object);
            },
            leadingIconPath: AppIcon.bin,
          )
        : CustomRectangularButton.outlined(
            text: LocaleKeys.yourData_removeOption.tr(),
            fillColor: colors.dialogBackground,
            onPressed: () {
              AutoRouter.of(context).pop();
              onRemoveCallback(object);
            },
          );
  }
}

class _EditDataAsDefaultDialogContent<T extends DefaultData> extends HookWidget {
  final T object;
  final ValueChanged<T> onCopyCallback;

  const _EditDataAsDefaultDialogContent(
    this.object,
    this.onCopyCallback,
  );

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();

    return CustomRectangularButton.filled(
      text: LocaleKeys.yourData_edit.tr(),
      fillColor: AppColors.success100,
      borderColor: AppColors.success100,
      textColor: colors.textSpecial,
      onPressed: () {
        AutoRouter.of(context).pop();
        onCopyCallback(object);
      },
      leadingIconPath: AppIcon.copy,
    );
  }
}
