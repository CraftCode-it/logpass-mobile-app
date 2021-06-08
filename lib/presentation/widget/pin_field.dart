import 'package:flutter/material.dart';
import 'package:logpass_me/presentation/page/pin_setup/app_pin_config.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:pinput/pin_put/pin_put.dart';

class PinField extends StatelessWidget {
  final Function(String pin) onPinChanged;
  final bool autoFocus;

  const PinField({
    required this.onPinChanged,
    this.autoFocus = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PinPut(
      onChanged: onPinChanged,
      fieldsCount: appPinLength,
      fieldsAlignment: MainAxisAlignment.center,
      autofocus: autoFocus,
      eachFieldMargin: const EdgeInsets.symmetric(horizontal: AppDimens.s),
      selectedFieldDecoration: _inputBorder(),
      followingFieldDecoration: _inputBorder(),
      submittedFieldDecoration: _inputBorder(),
    );
  }

  BoxDecoration _inputBorder() {
    return const BoxDecoration(
      border: Border(
        bottom: BorderSide(),
      ),
    );
  }
}
