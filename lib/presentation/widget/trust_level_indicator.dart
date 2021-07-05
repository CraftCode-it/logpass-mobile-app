import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

const _indicatorSize = 26.0;
const _borderWidth = 1.0;
const _customFontSize = 12.0;

class TrustLevelIndicator extends HookWidget {
  final int trustLevel;

  const TrustLevelIndicator({
    required this.trustLevel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return Container(
      width: _indicatorSize,
      height: _indicatorSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: _borderWidth,
          color: colors.buttonFill,
        ),
      ),
      child: Center(
        child: Text(
          trustLevel.toString(),
          style: typography.body1.copyWith(fontSize: _customFontSize),
        ),
      ),
    );
  }
}
