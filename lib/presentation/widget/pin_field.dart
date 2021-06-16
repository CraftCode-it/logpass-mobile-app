import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/page/pin_setup/app_pin_config.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:pinput/pin_put/pin_put.dart';

class PinField extends HookWidget {
  final Function(String pin) onPinChanged;
  final bool autoFocus;

  const PinField({
    required this.onPinChanged,
    this.autoFocus = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    return PinPut(
      onChanged: onPinChanged,
      fieldsCount: appPinLength,
      fieldsAlignment: MainAxisAlignment.center,
      autofocus: autoFocus,
      eachFieldMargin: const EdgeInsets.symmetric(horizontal: AppDimens.s),
      selectedFieldDecoration: _inputBorder(colors),
      followingFieldDecoration: _inputBorder(colors),
      submittedFieldDecoration: _inputBorder(colors),
      eachFieldPadding: const EdgeInsets.all(AppDimens.m),
      textStyle: typography.h9,
      eachFieldWidth: AppDimens.xxl,
      obscureText: '*',
    );
  }

  BoxDecoration _inputBorder(AppThemeColors colors) {
    return BoxDecoration(
      border: Border.all(
        color: colors.primary70,
        width: 1.0,
      ),
    );
  }
}
