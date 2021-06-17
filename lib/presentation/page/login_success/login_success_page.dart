import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_image.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';

class LoginSuccessPage extends HookWidget {
  const LoginSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    useEffect(() {
      Future.delayed(const Duration(seconds: 3)).then((_) {
        AutoRouter.of(context).replaceAll(
          [
            const MainPageRoute(),
            const GetSaferPageRoute(),
          ],
        );
      });
    }, []);

    return Scaffold(
      backgroundColor: AppColors.success100,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimens.xl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
              child: Text(
                LocaleKeys.loginSuccess_header,
                style: typography.h2.copyWith(color: colors.textSpecial),
              ).tr(),
            ),
            const SizedBox(height: AppDimens.l),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
              child: Text(
                LocaleKeys.loginSuccess_info,
                style: typography.h7.copyWith(color: colors.textSpecial),
              ).tr(),
            ),
            Expanded(
              child: Image.asset(
                AppImage.placeholder,
                alignment: Alignment.bottomRight,
              ),
            ),
            const SizedBox(height: AppDimens.xc),
            Padding(
              padding: const EdgeInsets.only(left: AppDimens.xxl),
              child: SvgPicture.asset(
                AppIcon.logo,
                height: AppDimens.logoHeight,
              ),
            ),
            const SizedBox(height: AppDimens.l),
          ],
        ),
      ),
    );
  }
}
