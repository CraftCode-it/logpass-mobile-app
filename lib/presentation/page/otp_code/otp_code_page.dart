import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/auth/sign_up/sign_up_verification.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/otp_code/otp_code_page_cubit.dart';
import 'package:logpass_me/presentation/page/otp_code/otp_code_page_state.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/error_snackbar.dart';
import 'package:logpass_me/presentation/widget/info_snackbar.dart';
import 'package:logpass_me/presentation/widget/input_field.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';
import 'package:logpass_me/presentation/widget/timed_wrapper/timed_wrapper.dart';

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
    final colors = useAppThemeColors();
    final typography = useAppTypography();
    final otpCodeController = useTextEditingController();

    useCubitListener<OTPCodePageCubit, OTPCodePageState>(
      cubit,
      (cubit, state, context) => _cubitListener(
        cubit,
        state,
        context,
        otpCodeController,
        colors,
        typography,
      ),
    );

    useEffect(() {
      cubit.initialize(verification);
    }, [cubit]);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.smallTitle(
        title: LocaleKeys.otpCode_title.tr(),
        leading: NavigationButton.back(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimens.xl),
            Text(
              LocaleKeys.otpCode_info,
              textAlign: TextAlign.center,
              style: typography.body1,
            ).tr(),
            const SizedBox(height: AppDimens.xl),
            _CodeField(cubit: cubit, state: state),
            const SizedBox(height: AppDimens.xxl),
            _VerifyButton(state: state, cubit: cubit),
            const SizedBox(height: AppDimens.xl),
            Text(
              LocaleKeys.otpCode_resendInfo,
              textAlign: TextAlign.center,
              style: typography.body1,
            ).tr(),
            const SizedBox(height: AppDimens.s),
            _ResendButton(cubit: cubit, state: state),
          ],
        ),
      ),
    );
  }

  void _cubitListener(
    OTPCodePageCubit cubit,
    OTPCodePageState state,
    BuildContext context,
    TextEditingController otpController,
    AppThemeColors colors,
    AppTypography typography,
  ) {
    state.maybeMap(
      connectionError: (state) => showConnectionErrorSnackBar(
        error: state.error,
        context: context,
        colors: colors,
        typography: typography,
      ),
      success: (state) {
        AutoRouter.of(context).pushAndPopUntil(
          const LoginSuccessPageRoute(),
          predicate: (route) => false,
        );
      },
      otpAutofill: (state) => otpController.text = state.code,
      resendSuccess: (_) => showInformationSnackBar(
        context: context,
        colors: colors,
        typography: typography,
        message: tr(LocaleKeys.otpCode_codeResendSuccess),
      ),
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
      idle: (state) => _buildCodeField(true, error: state.codeError),
      verifying: (state) => _buildCodeField(false),
      resending: (state) => _buildCodeField(false),
      orElse: () => _buildCodeField(false),
    );
  }

  Widget _buildCodeField(bool enabled, {String? error}) => InputField(
        label: tr(LocaleKeys.otpCode_codeLabel),
        hint: '000000',
        onChanged: cubit.updateCode,
        enabled: enabled,
        inputType: TextInputType.phone,
        error: error,
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

    return CustomRectangularButton.filled(
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
    return CustomRectangularButton.outlined(
      text: tr(LocaleKeys.otpCode_resendAction),
      onPressed: enabled ? () => cubit.resendCode() : null,
    );
  }
}
