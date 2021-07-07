import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

const _iconsSize = 24.0;

class UserDataTile extends HookWidget {
  final String title;
  final bool isDefault;
  final VoidCallback? onMoreTapped;
  final String? content;

  const UserDataTile({
    required this.title,
    this.isDefault = false,
    this.onMoreTapped,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return Container(
      padding: const EdgeInsets.only(
        bottom: AppDimens.m,
        left: AppDimens.m,
        right: AppDimens.m,
        top: AppDimens.l,
      ),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: isDefault ? typography.body3 : typography.body1,
                      ),
                    ),
                    if (isDefault) ...[
                      const SizedBox(width: AppDimens.m),
                      SvgPicture.asset(
                        AppIcon.star,
                        color: AppColors.success100,
                        width: _iconsSize,
                        height: _iconsSize,
                      ),
                    ],
                    const SizedBox(width: AppDimens.m),
                    IconButton(
                      padding: const EdgeInsets.all(AppDimens.zero),
                      constraints: const BoxConstraints(),
                      onPressed: onMoreTapped,
                      icon: SvgPicture.asset(
                        AppIcon.more,
                        color: colors.text,
                        width: _iconsSize,
                        height: _iconsSize,
                      ),
                    ),
                  ],
                ),
                if (content != null) ...[
                  const SizedBox(height: AppDimens.s),
                  Text(
                    content!,
                    style: typography.body1,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
