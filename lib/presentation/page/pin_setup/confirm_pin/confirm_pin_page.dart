import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/pin_setup/confirm_pin/confirm_pin_page_cubit.dart';
import 'package:logpass_me/presentation/page/pin_setup/confirm_pin/confirm_pin_page_state.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
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

    useCubitListener(cubit, _listener);

    useEffect(() {
      cubit.initialize(pin);
    }, [cubit]);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(LocaleKeys.confirmPin_title).tr(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              Text(
                LocaleKeys.confirmPin_info,
                textAlign: TextAlign.center,
                style: typography.primary,
              ).tr(),
              const Spacer(flex: 2),
              PinField(onPinChanged: cubit.updatePin),
              const Spacer(flex: 1),
              _NextButton(
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

class _NextButton extends StatelessWidget {
  final ConfirmPinPageState state;
  final Function() onPressed;

  const _NextButton({
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

  RoundedButton _buildButton() {
    final isActive = state.maybeMap(
      idle: (state) => state.valid,
      orElse: () => false,
    );

    return RoundedButton(
      text: tr(LocaleKeys.common_next),
      onPressed: isActive ? onPressed : null,
    );
  }
}
