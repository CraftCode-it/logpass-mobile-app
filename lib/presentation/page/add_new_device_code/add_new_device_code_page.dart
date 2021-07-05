import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/add_new_device_code/add_new_device_code_page_cubit.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/custom_scaffold.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';

class AddNewDeviceCodePage extends HookWidget {
  const AddNewDeviceCodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<AddNewDeviceCodePageCubit>();
    final state = useCubitBuilder(cubit);
    final typography = useAppTypography();
    final messengerController = useMessengerController();

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return CustomScaffold(
      onTryAgain: () => cubit.loadCode(),
      showErrorPage: state.maybeMap(
        error: (_) => true,
        orElse: () => false,
      ),
      appBar: CustomAppBar.smallTitle(
        leading: NavigationButton.back(),
        title: LocaleKeys.addNewDeviceCode_title.tr(),
      ),
      body: SafeArea(
        child: Messenger(
          controller: messengerController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppDimens.m),
                    Text(
                      LocaleKeys.addNewDeviceCode_content.tr(),
                      style: typography.body2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimens.xxxc),
                    _Step(stepNumber: 1, description: LocaleKeys.addNewDeviceCode_steps_1.tr()),
                    const SizedBox(height: AppDimens.m),
                    _Step(stepNumber: 2, description: LocaleKeys.addNewDeviceCode_steps_2.tr()),
                    const SizedBox(height: AppDimens.m),
                    _Step(stepNumber: 3, description: LocaleKeys.addNewDeviceCode_steps_3.tr()),
                    const SizedBox(height: AppDimens.xxl),
                  ],
                ),
              ),
              _Code(
                messengerController: messengerController,
                code: state.maybeMap(
                  idle: (state) => state.code,
                  orElse: () => null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step extends HookWidget {
  final int stepNumber;
  final String description;

  const _Step({
    required this.stepNumber,
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${stepNumber.toString()}. ',
            style: typography.h8,
          ),
          TextSpan(
            text: description,
            style: typography.body1,
          ),
        ],
      ),
    );
  }
}

class _Code extends HookWidget {
  final MessengerController messengerController;
  final String? code;

  const _Code({
    required this.messengerController,
    this.code,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    final code = this.code;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimens.m,
      ),
      color: colors.secondaryBackground,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _content(colors, typography, code),
      ),
    );
  }

  Widget _content(AppThemeColors colors, AppTypography typography, String? code) {
    if (code != null) {
      return GestureDetector(
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: code));
          messengerController.showInfo(LocaleKeys.common_copied.tr());
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppDimens.s),
            Text(code, style: typography.h1),
            const SizedBox(height: AppDimens.m),
            Text(
              LocaleKeys.addNewDeviceCode_copy.tr(),
              style: typography.info2.copyWith(color: colors.secondaryText),
            ),
          ],
        ),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimens.l),
        child: Loader(),
      );
    }
  }
}
