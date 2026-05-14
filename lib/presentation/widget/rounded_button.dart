import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

const _leadingIconSize = 20.0;

class CustomRectangularButton extends HookWidget {
  final String text;
  final Function()? onPressed;
  final Color? fillColor;
  final Color? borderColor;
  final Color? textColor;
  final bool filled;
  final double? height;
  final TextStyle? textStyle;
  final String? leadingIconPath;

  const CustomRectangularButton._({
    required this.text,
    required this.onPressed,
    required this.filled,
    this.fillColor,
    this.borderColor,
    this.textColor,
    this.height,
    this.textStyle,
    this.leadingIconPath,
    Key? key,
  }) : super(key: key);

  factory CustomRectangularButton.filled({
    required String text,
    required Function()? onPressed,
    Color? fillColor,
    Color? borderColor,
    Color? textColor,
    double? height,
    TextStyle? textStyle,
    String? leadingIconPath,
  }) {
    return CustomRectangularButton._(
      text: text,
      onPressed: onPressed,
      filled: true,
      fillColor: fillColor,
      borderColor: borderColor,
      textColor: textColor,
      height: height,
      textStyle: textStyle,
      leadingIconPath: leadingIconPath,
    );
  }

  factory CustomRectangularButton.outlined({
    required String text,
    required Function()? onPressed,
    Color? fillColor,
    Color? borderColor,
    Color? textColor,
    double? height,
    TextStyle? textStyle,
    String? leadingIconPath,
  }) {
    return CustomRectangularButton._(
      text: text,
      onPressed: onPressed,
      filled: false,
      fillColor: fillColor,
      borderColor: borderColor,
      textColor: textColor,
      height: height,
      textStyle: textStyle,
      leadingIconPath: leadingIconPath,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    final style = textStyle ?? typography.h8;

    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(
          color: onPressed == null ? colors.buttonOutlinedInactive : (borderColor ?? colors.buttonOutlined),
          width: 1.5,
        ),
      ),
      elevation: 0,
      disabledTextColor: filled ? colors.buttonFilledInactiveText : colors.buttonOutlinedInactiveText,
      height: height ?? AppDimens.buttonHeight,
      onPressed: onPressed,
      color: _getFillColor(colors),
      disabledColor: _getDisabledFillColor(colors),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leadingIconPath != null) ...[
            SvgPicture.asset(
              leadingIconPath!,
              colorFilter: ColorFilter.mode(_getTextColor(colors), BlendMode.srcIn),
              width: _leadingIconSize,
              height: _leadingIconSize,
            ),
            const SizedBox(width: AppDimens.m),
          ],
          Text(
            text,
            style: style.copyWith(
              color: _getTextColor(colors),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTextColor(AppThemeColors colors) {
    final textColor = this.textColor;
    if (textColor != null) return textColor;

    if (filled) {
      return onPressed == null ? colors.buttonFilledInactiveText : colors.buttonFilledText;
    } else {
      return onPressed == null ? colors.buttonOutlinedInactiveText : colors.buttonOutlinedText;
    }
  }

  Color _getFillColor(AppThemeColors colors) {
    final fillColor = this.fillColor;
    if (fillColor != null) return fillColor;

    if (filled) {
      return colors.buttonFill;
    } else {
      return colors.buttonOutlinedFill;
    }
  }

  Color _getDisabledFillColor(AppThemeColors colors) {
    if (filled) {
      return colors.buttonFillInactive;
    } else {
      return colors.buttonOutlinedFill;
    }
  }
}
