import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

class LabeledText extends HookWidget {
  final String label;
  final String text;

  const LabeledText({
    required this.label,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.s),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: typography.info2.copyWith(color: colors.secondaryText),
          ),
          const SizedBox(height: AppDimens.xs),
          Text(
            text,
            style: typography.body3,
          ),
        ],
      ),
    );
  }
}
