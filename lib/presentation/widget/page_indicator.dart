import 'package:flutter/material.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';

const _size = 12.0;
const _strokeWidth = 1.0;

class PageIndicator extends StatelessWidget {
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;

  const PageIndicator({
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: AppDimens.s),
      height: _size,
      width: _size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? activeColor : inactiveColor,
          width: _strokeWidth,
        ),
        color: isActive ? activeColor : Colors.transparent,
      ),
    );
  }
}
