import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/widget/logpass_dialog_base.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';

enum DeviceMenuItem { changeName, remove }

class DeviceMenu extends HookWidget {
  const DeviceMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();

    return LogpassDialogBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomRectangularButton.filled(
            text: 'Change name',
            onPressed: () => AutoRouter.of(context).pop(DeviceMenuItem.changeName),
          ),
          const SizedBox(height: AppDimens.l),
          CustomRectangularButton.outlined(
            text: 'Remove',
            fillColor: colors.dialogBackground,
            onPressed: () => AutoRouter.of(context).pop(DeviceMenuItem.remove),
          ),
        ],
      ),
    );
  }
}
