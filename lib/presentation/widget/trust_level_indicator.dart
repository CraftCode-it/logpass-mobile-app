import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

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
      width: 24,
      height: 24,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 1.0,
          color: colors.buttonFill,
        ),
      ),
      child: Center(
        child: Text(
          trustLevel.toString(),
          style: typography.body1.copyWith(height: 1),
        ),
      ),
    );
  }
}
