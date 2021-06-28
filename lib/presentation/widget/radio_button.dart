import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';

const _animationInMiliseconds = 200;
const _radioButtonSize = 24.0;
const _radioBorderSelected = 2.0;
const _radioBorderUnselected = 1.0;
const _radioDotSize = 4.0;

class RadioButton extends HookWidget {
  final bool isSelected;

  const RadioButton({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final drawColor = isSelected ? colors.inputFocusedBorder : colors.inputBorder;

    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: _animationInMiliseconds),
          width: _radioButtonSize,
          height: _radioButtonSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: drawColor,
              width: isSelected ? _radioBorderSelected : _radioBorderUnselected,
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: isSelected ? 1 : 0,
          duration: const Duration(milliseconds: _animationInMiliseconds),
          child: Container(
            width: _radioDotSize,
            height: _radioDotSize,
            decoration: BoxDecoration(
              color: drawColor,
              shape: BoxShape.circle,
              border: Border.all(color: drawColor),
            ),
          ),
        ),
      ],
    );
  }
}
