import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/radio_button.dart';

class RadioButtonTile extends HookWidget {
  final VoidCallback? onTapAction;
  final String title;
  final String? content;
  final bool isSelected;

  const RadioButtonTile({
    required this.title,
    required this.isSelected,
    this.content,
    this.onTapAction,
  });

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return InkWell(
      onTap: onTapAction,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.m),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colors.dividerLight,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioButton(isSelected: isSelected),
            const SizedBox(width: AppDimens.m),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: isSelected ? typography.body3 : typography.body1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (content != null) ...[
                    const SizedBox(height: AppDimens.s),
                    Text(
                      content!,
                      style: typography.body1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
