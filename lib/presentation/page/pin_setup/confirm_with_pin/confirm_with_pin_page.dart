import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/pin_setup/confirm_with_pin/confirm_with_pin_page_cubit.dart';
import 'package:logpass_me/presentation/page/pin_setup/confirm_with_pin/confirm_with_pin_page_state.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/pin_field.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';

class ConfirmWithPinPage extends HookWidget {
  final String title;
  final String button;

  const ConfirmWithPinPage({
    required this.title,
    required this.button,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ConfirmWithPinPageCubit>();
    final state = useCubitBuilder(cubit);
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    useCubitListener<ConfirmWithPinPageCubit, ConfirmWithPinPageState>(cubit, (cubit, state, context) {
      state.maybeMap(
        codeValidated: (_) => AutoRouter.of(context).pop(true),
        orElse: () {},
      );
    });

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.smallTitle(
        leading: NavigationButton.close(),
        title: title,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimens.m),
              Text(
                'To proceed please input your current PIN code',
                style: typography.body1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimens.l),
              PinField(
                onPinChanged: cubit.updateCode,
                pinErrorText: state.maybeMap(
                  idle: (state) => state.validCode ?  null : LocaleKeys.common_wrongCode.tr(),
                  orElse: () => null,
                ),
              ),
              const Spacer(),
              _Button(content: button, state: state, cubit: cubit),
              const SizedBox(height: AppDimens.m),
            ],
          ),
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final String content;
  final ConfirmWithPinPageState state;
  final ConfirmWithPinPageCubit cubit;

  const _Button({
    required this.content,
    required this.state,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return state.maybeMap(
      idle: (state) => CustomRectangularButton.filled(
        text: content,
        onPressed: state.validCode && state.validLength ? () => cubit.validate() : null,
      ),
      orElse: () => const Loader(),
    );
  }
}
