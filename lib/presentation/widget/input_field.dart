import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

class InputField extends HookWidget {
  final String label;
  final String? hint;
  final String? error;
  final bool enabled;
  final TextEditingController? controller;
  final Function(String text) onChanged;
  final TextInputType? inputType;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? formatters;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final String? initialValue;

  const InputField({
    required this.label,
    required this.onChanged,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
    this.hint,
    this.error,
    this.controller,
    this.inputType,
    this.focusNode,
    this.formatters,
    this.textInputAction,
    this.initialValue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    return TextFormField(
      controller: controller,
      enabled: enabled,
      onChanged: onChanged,
      keyboardType: inputType,
      style: typography.h9.copyWith(color: enabled ? colors.inputText : colors.inputInactiveText),
      focusNode: focusNode,
      textInputAction: textInputAction,
      inputFormatters: formatters,
      textCapitalization: textCapitalization,
      initialValue: initialValue,
      decoration: InputDecoration(
        errorStyle: typography.input.copyWith(color: AppColors.error100),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        hintText: hint,
        labelText: label,
        errorText: error,
        hintStyle: typography.h9.copyWith(color: enabled ? colors.inputHint : colors.inputInactiveHint),
        labelStyle: typography.h9.copyWith(color: colors.inputLabel),
        enabledBorder: inputFieldBorder(colors.inputBorder),
        focusedBorder: inputFieldBorder(colors.inputFocusedBorder),
        errorBorder: inputFieldBorder(AppColors.error100),
        focusedErrorBorder: inputFieldBorder(AppColors.error100),
        disabledBorder: inputFieldBorder(colors.inputInactiveBorder),
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
