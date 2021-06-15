import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

class InputField extends HookWidget {
  final String label;
  final String hint;
  final String? error;
  final bool enabled;
  final TextEditingController? controller;
  final Function(String text) onChanged;
  final TextInputType? inputType;

  const InputField({
    required this.label,
    required this.hint,
    required this.onChanged,
    this.enabled = true,
    this.error,
    this.controller,
    this.inputType,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    return TextField(
      controller: controller,
      enabled: enabled,
      onChanged: onChanged,
      keyboardType: inputType,
      style: typography.h9.copyWith(color: enabled ? colors.primary100 : colors.primary20),
      decoration: InputDecoration(
        errorStyle: typography.input.copyWith(color: colors.error100),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        hintText: hint,
        labelText: label,
        errorText: error,
        hintStyle: typography.h9.copyWith(color: enabled ? colors.primary40 : colors.primary20),
        labelStyle: typography.h9.copyWith(color: colors.primary40),
        enabledBorder: inputFieldBorder(colors.primary40),
        focusedBorder: inputFieldBorder(colors.primary100),
        errorBorder: inputFieldBorder(colors.error100),
        focusedErrorBorder: inputFieldBorder(colors.error100),
        disabledBorder: inputFieldBorder(colors.primary20),
        errorMaxLines: 2,
      ),
    );
  }
}

OutlineInputBorder inputFieldBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(
      width: 1.0,
      color: color,
      style: BorderStyle.solid,
    ),
  );
}
