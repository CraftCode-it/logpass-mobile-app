import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';
import 'package:logpass_me/presentation/widget/separator.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';

class LoginResetPage extends HookWidget {
  const LoginResetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.smallTitle(
        title: LocaleKeys.loginReset_title.tr(),
      ),
      body: SafeArea(
        child: _Content(),
      ),
    );
  }
}

class _Content extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.m),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.s),
            child: Text(
              LocaleKeys.loginReset_description.tr(),
              style: typography.body2,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppDimens.xxl),
          Separator.light(),
          const Spacer(flex: 1),
          Text(
            LocaleKeys.loginReset_header.tr(),
            style: typography.h6,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimens.xxl),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.s),
            child: Text(
              LocaleKeys.loginReset_newDeviceDescription.tr(),
              style: typography.body1,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppDimens.m),
          CustomRectangularButton.filled(
            text: LocaleKeys.loginReset_newDeviceButton.tr(),
            onPressed: () => AutoRouter.of(context).push(const AddNewDevicePageRoute()),
          ),
          const SizedBox(height: AppDimens.xxl),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.s),
            child: Text(
              LocaleKeys.loginReset_resetAccountDescription.tr(),
              style: typography.body1,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppDimens.m),
          CustomRectangularButton.outlined(
            text: LocaleKeys.loginReset_resetAccountButton.tr(),
            onPressed: () => AutoRouter.of(context).push(const ResetAccountPageRoute()),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
