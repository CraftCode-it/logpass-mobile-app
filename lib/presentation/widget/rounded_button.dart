import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

class RoundedButton extends HookWidget {
  final String text;
  final Function() onPressed;

  const RoundedButton({
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    return MaterialButton(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimens.buttonBorder),
        ),
      ),
      height: AppDimens.buttonHeight,
      onPressed: onPressed,
      color: colors.primaryButton,
      child: Text(
        text,
        style: typography.button,
      ),
    );
  }
}
