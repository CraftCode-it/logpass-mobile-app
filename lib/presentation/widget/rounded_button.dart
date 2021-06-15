import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

class CustomRectangularButton extends HookWidget {
  final String text;
  final Function()? onPressed;
  final bool filled;

  const CustomRectangularButton._({
    required this.text,
    required this.onPressed,
    required this.filled,
    Key? key,
  }) : super(key: key);

  factory CustomRectangularButton.filled({
    required String text,
    required Function()? onPressed,
  }) {
    return CustomRectangularButton._(
      text: text,
      onPressed: onPressed,
      filled: true,
    );
  }

  factory CustomRectangularButton.outlined({
    required String text,
    required Function()? onPressed,
  }) {
    return CustomRectangularButton._(
      text: text,
      onPressed: onPressed,
      filled: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(
          color: onPressed == null ? colors.primary40 : colors.primary100,
          width: 1.5,
        ),
      ),
      elevation: 0,
      disabledTextColor: colors.primary20,
      height: AppDimens.buttonHeight,
      onPressed: onPressed,
      color: _getFillColor(colors),
      disabledColor: colors.primary40,
      child: Text(
        text,
        style: typography.h8.copyWith(
          color: _getTextColor(colors),
        ),
      ),
    );
  }

  Color _getTextColor(AppThemeColors colors) {
    if (filled) {
      return colors.secondary;
    } else {
      return colors.primary100;
    }
  }

  Color _getFillColor(AppThemeColors colors) {
    if (filled) {
      return colors.primary100;
    } else {
      return colors.background;
    }
  }
}
