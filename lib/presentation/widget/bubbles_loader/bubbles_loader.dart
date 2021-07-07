import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_image.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logpass_me/generated/local_keys.g.dart';

class BubblesLoader extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: colors.darkBackground,
          child: SvgPicture.asset(
            AppImage.bubbles,
            alignment: Alignment.centerRight,
          ),
        ),
        Material(
          color: Colors.transparent,
          child: SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.l,
                  vertical: AppDimens.xxl,
                ),
                child: Text(
                  LocaleKeys.bubbleLoader_description.tr(),
                  textAlign: TextAlign.center,
                  style: typography.h9.copyWith(color: colors.textSpecial),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
