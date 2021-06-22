import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';

const _width = 42.0;
const _height = 24.0;
const _toggleSize = 20.0;
const _padding = 2.0;

class CustomSwitch extends HookWidget {
  final bool value;
  final Function(bool value) onChange;

  const CustomSwitch({
    required this.value,
    required this.onChange,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();

    return FlutterSwitch(
      width: _width,
      height: _height,
      toggleSize: _toggleSize,
      padding: _padding,
      toggleColor: colors.switchToggle,
      activeToggleColor: colors.switchToggle,
      inactiveToggleColor: colors.switchToggle,
      activeColor: AppColors.success100,
      inactiveColor: colors.switchInactiveTrack,
      value: value,
      onToggle: onChange,
    );
  }
}
