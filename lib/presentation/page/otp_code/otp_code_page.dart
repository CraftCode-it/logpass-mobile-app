import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/auth/sign_up/sign_up_verification.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/otp_code/otp_code_page_cubit.dart';
import 'package:logpass_me/presentation/page/otp_code/otp_code_page_state.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';
import 'package:logpass_me/presentation/widget/timed_wrapper/timed_wrapper.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';

class OTPCodePage extends HookWidget {
  final SignUpVerification verification;

  const OTPCodePage({
    required this.verification,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<OTPCodePageCubit>();
    final state = useCubitBuilder(cubit);

    useCubitListener(cubit, _cubitListener);

    useEffect(() {
      cubit.initialize(verification);
    }, [cubit]);

    return Scaffold(
      appBar: AppBar(
        title: const Text(LocaleKeys.otpCode_title).tr(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimens.xl),
            const Text(
              LocaleKeys.otpCode_info,
              textAlign: TextAlign.center,
            ).tr(),
            const SizedBox(height: AppDimens.xl),
            _CodeField(cubit: cubit, state: state),
            const SizedBox(height: AppDimens.xxl),
            _VerifyButton(state: state, cubit: cubit),
            const SizedBox(height: AppDimens.xl),
            const Text(
              LocaleKeys.otpCode_resendInfo,
              textAlign: TextAlign.center,
            ).tr(),
            const SizedBox(height: AppDimens.s),
            _ResendButton(cubit: cubit, state: state),
          ],
        ),
      ),
    );
  }

  void _cubitListener(OTPCodePageCubit cubit, OTPCodePageState state, BuildContext context) {
    state.maybeMap(
      error: (state) {}, // TODO error handling
      success: (state) {
        AutoRouter.of(context).pushAndPopUntil(
          const LoginSuccessPageRoute(),
          predicate: (route) => false,
        );
      },
      orElse: () {},
    );
  }
}

class _CodeField extends StatelessWidget {
  final OTPCodePageCubit cubit;
  final OTPCodePageState state;

  const _CodeField({
    required this.state,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return state.maybeMap(
      idle: (state) => _buildCodeField(state.code, true),
      verifying: (state) => _buildCodeField(state.code, false),
      resending: (state) => _buildCodeField(state.code, false),
      orElse: () => _buildCodeField('', false),
    );
  }

  Widget _buildCodeField(String code, bool enabled) => PinFieldAutoFill(
        codeLength: OTPCodePageCubit.otpCodeLength,
        currentCode: code,
        onCodeChanged: enabled ? cubit.updateCode : null,
      );
}

class _VerifyButton extends StatelessWidget {
  final OTPCodePageCubit cubit;
  final OTPCodePageState state;

  const _VerifyButton({
    required this.state,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return state.maybeMap(
      verifying: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
      orElse: () => _buildButton(),
    );
  }

  Widget _buildButton() {
    final isActive = state.maybeMap(
      idle: (state) => state.valid,
      orElse: () => false,
    );

    return RoundedButton(
      text: tr(LocaleKeys.common_verify),
      onPressed: isActive ? () => cubit.verify() : null,
    );
  }
}

class _ResendButton extends StatelessWidget {
  final OTPCodePageCubit cubit;
  final OTPCodePageState state;

  const _ResendButton({
    required this.state,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return state.maybeMap(
      idle: (state) => TimedWrapper(
        builder: (timePassed) => _buildButton(timePassed),
        timestamp: state.resendAvailabilityTimestamp,
      ),
      resending: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
      orElse: () => _buildButton(false),
    );
  }

  Widget _buildButton(bool enabled) {
    return RoundedButton(
      text: tr(LocaleKeys.otpCode_resendAction),
      onPressed: enabled ? () => cubit.resendCode() : null,
    );
  }
}
