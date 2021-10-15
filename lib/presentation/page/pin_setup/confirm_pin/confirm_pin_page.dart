import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/pin_setup/confirm_pin/confirm_pin_page_cubit.dart';
import 'package:logpass_me/presentation/page/pin_setup/confirm_pin/confirm_pin_page_state.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/pin_field.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';

class ConfirmPinPage extends HookWidget {
  final String pin;

  const ConfirmPinPage({
    required this.pin,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ConfirmPinPageCubit>();
    final state = useCubitBuilder(cubit);
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    useCubitListener(cubit, _listener);

    useEffect(() {
      cubit.initialize(pin);
    }, [cubit]);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.smallTitle(
        title: LocaleKeys.confirmPin_title.tr(),
        leading: NavigationButton.back(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimens.l),
              Text(
                LocaleKeys.confirmPin_info,
                textAlign: TextAlign.center,
                style: typography.body1,
              ).tr(),
              const SizedBox(height: AppDimens.xl),
              Align(
                alignment: Alignment.center,
                child: _PinField(
                  cubit: cubit,
                  state: state,
                ),
              ),
              const Spacer(flex: 1),
              _SaveButton(
                state: state,
                onPressed: cubit.savePin,
              ),
              const SizedBox(height: AppDimens.l),
            ],
          ),
        ),
      ),
    );
  }

  void _listener(ConfirmPinPageCubit cubit, ConfirmPinPageState state, BuildContext context) {
    state.maybeMap(
      pinSaved: (state) => AutoRouter.of(context).pop(true),
      orElse: () {},
    );
  }
}

class _PinField extends HookWidget {
  final ConfirmPinPageState state;
  final ConfirmPinPageCubit cubit;

  const _PinField({
    required this.state,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        PinField(
          onPinChanged: cubit.updatePin,
          pinErrorText: state.maybeMap(
            idle: (state) => state.wrong ? LocaleKeys.common_wrongCode.tr() : null,
            orElse: () => null,
          ),
        ),
        const SizedBox(height: AppDimens.s),
      ],
    );
  }
}

class _SaveButton extends StatelessWidget {
  final ConfirmPinPageState state;
  final Function() onPressed;

  const _SaveButton({
    required this.state,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return state.maybeMap(
      processing: (_) => const Loader(),
      orElse: () => _buildButton(),
    );
  }

  CustomRectangularButton _buildButton() {
    final isActive = state.maybeMap(
      idle: (state) => state.valid && !state.wrong,
      orElse: () => false,
    );

    return CustomRectangularButton.filled(
      text: tr(LocaleKeys.common_save),
      onPressed: isActive ? onPressed : null,
    );
  }
}
