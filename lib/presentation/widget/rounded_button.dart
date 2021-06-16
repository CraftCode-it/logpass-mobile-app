import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

class CustomRectangularButton extends HookWidget {
  final String text;
  final Function()? onPressed;
  final Color? fillColor;
  final Color? textColor;
  final bool filled;

  const CustomRectangularButton._({
    required this.text,
    required this.onPressed,
    required this.filled,
    this.fillColor,
    this.textColor,
    Key? key,
  }) : super(key: key);

  factory CustomRectangularButton.filled({
    required String text,
    required Function()? onPressed,
    Color? fillColor,
    Color? textColor,
  }) {
    return CustomRectangularButton._(
      text: text,
      onPressed: onPressed,
      filled: true,
      fillColor: fillColor,
      textColor: textColor,
    );
  }

  factory CustomRectangularButton.outlined({
    required String text,
    required Function()? onPressed,
    Color? fillColor,
    Color? textColor,
  }) {
    return CustomRectangularButton._(
      text: text,
      onPressed: onPressed,
      filled: false,
      fillColor: fillColor,
      textColor: textColor,
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
          color: onPressed == null ? colors.primary40 : (fillColor ?? colors.primary100),
          width: 1.5,
        ),
      ),
      elevation: 0,
      disabledTextColor: colors.primary20,
      height: AppDimens.buttonHeight,
      onPressed: onPressed,
      color: _getFillColor(colors),
      disabledColor: _getDisabledFillColor(colors),
      child: Text(
        text,
        style: typography.h8.copyWith(
          color: _getTextColor(colors),
        ),
      ),
    );
  }

  Color _getTextColor(AppThemeColors colors) {
    final textColor = this.textColor;
    if (textColor != null) return textColor;

    if (filled) {
      return colors.secondary;
    } else {
      if (onPressed == null) return colors.primary40;
      return colors.primary100;
    }
  }

  Color _getFillColor(AppThemeColors colors) {
    final fillColor = this.fillColor;
    if (fillColor != null) return fillColor;

    if (filled) {
      return colors.primary100;
    } else {
      return colors.background;
    }
  }

  Color _getDisabledFillColor(AppThemeColors colors) {
    if (filled) {
      return colors.primary40;
    } else {
      return colors.background;
    }
  }
}
