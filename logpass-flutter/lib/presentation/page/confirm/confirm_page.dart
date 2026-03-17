import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';

class ConfirmPage extends HookWidget {
  const ConfirmPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final messengerController = useMessengerController();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.smallTitleOnly(
        title: LocaleKeys.confirm_title.tr(),
      ),
      body: SafeArea(
        child: Messenger(
          controller: messengerController,
          child: const _PageContent(''),
        ),
      ),
    );
  }
}

class _PageContent extends HookWidget {
  final String confirmMessage;

  const _PageContent(this.confirmMessage);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.m),
          Text(
            LocaleKeys.confirm_header.tr(),
            textAlign: TextAlign.center,
            style: typography.body2,
          ),
          const SizedBox(height: AppDimens.xxl),
          Text(
            confirmMessage,
            textAlign: TextAlign.center,
            style: typography.body3,
          ),
          const Spacer(),
          CustomRectangularButton.filled(
            text: LocaleKeys.authorize_confirm_button.tr(),
            onPressed: () => AutoRouter.of(context).pop(),
          ),
          const SizedBox(height: AppDimens.l),
          CustomRectangularButton.outlined(
            text: LocaleKeys.authorize_reject_button.tr(),
            onPressed: () => AutoRouter.of(context).pop(),
          ),
          const SizedBox(height: AppDimens.xl),
        ],
      ),
    );
  }
}
