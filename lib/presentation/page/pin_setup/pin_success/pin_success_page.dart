import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_image.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';

class PinSuccessPage extends HookWidget {
  final PageRouteInfo route;

  const PinSuccessPage({required this.route, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    return Scaffold(
      backgroundColor: AppColors.success100,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimens.xl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
              child: Text(
                LocaleKeys.pinSuccess_header,
                style: typography.h7.copyWith(color: colors.textSpecial),
              ).tr(),
            ),
            Expanded(
              child: Image.asset(
                AppImage.placeholder,
                alignment: Alignment.centerRight,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
              width: double.infinity,
              child: CustomRectangularButton.filled(
                text: tr(LocaleKeys.common_continue),
                onPressed: () => AutoRouter.of(context).navigate(route),
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
