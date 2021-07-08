import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';

class FullscreenError extends HookWidget {
  final Function() onTryAgain;

  const FullscreenError({
    required this.onTryAgain,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimens.xl),
            Text(
              LocaleKeys.error_page_header,
              style: typography.h2.copyWith(color: colors.textSpecial),
            ).tr(),
            const SizedBox(height: AppDimens.l),
            Text(
              LocaleKeys.error_page_content,
              style: typography.h7.copyWith(color: colors.textSpecial),
            ).tr(),
            Expanded(
              child: SvgPicture.asset(
                brightness == Brightness.light ? AppIcon.failureLight : AppIcon.failureDark,
                alignment: Alignment.center,
              ),
            ),
            const SizedBox(height: AppDimens.l),
            Container(
              width: double.infinity,
              child: CustomRectangularButton.filled(
                text: tr(LocaleKeys.error_page_action),
                onPressed: onTryAgain,
                fillColor: AppColors.secondary,
                textColor: AppColors.primary100,
              ),
            ),
            const SizedBox(height: AppDimens.l),
          ],
        ),
      ),
    );
  }
}
