import 'package:auto_route/auto_route.dart';
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

class PinSuccessPage extends HookWidget {
  final PageRouteInfo route;
  final String title;

  const PinSuccessPage({required this.route, required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    LocaleKeys.pinSuccess_set.tr();
    LocaleKeys.pinSuccess_changed.tr();

    return Scaffold(
      backgroundColor: AppColors.success100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimens.xl),
              Text(
                title,
                style: typography.h7.copyWith(color: colors.textSpecial),
              ).tr(),
              Expanded(
                child: SvgPicture.asset(
                  brightness == Brightness.light ? AppIcon.successLight : AppIcon.successDark,
                  alignment: Alignment.center,
                ),
              ),
              const SizedBox(height: AppDimens.l),
              Container(
                width: double.infinity,
                child: CustomRectangularButton.filled(
                  text: tr(LocaleKeys.common_continue),
                  onPressed: () => AutoRouter.of(context).navigate(route),
                  borderColor: Colors.transparent,
                  fillColor: AppColors.secondary,
                  textColor: AppColors.primary100,
                ),
              ),
              const SizedBox(height: AppDimens.l),
            ],
          ),
        ),
      ),
    );
  }
}
