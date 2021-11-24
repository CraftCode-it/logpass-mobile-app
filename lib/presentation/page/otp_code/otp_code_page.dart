import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
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
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/done_keyboard_button.dart';
import 'package:logpass_me/presentation/widget/error_snackbar.dart';
import 'package:logpass_me/presentation/widget/input_field.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';
import 'package:logpass_me/presentation/widget/timed_wrapper/timed_wrapper.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
    final otpReceivedCode = useState('');
    final colors = useAppThemeColors();
    final typography = useAppTypography();
    final otpCodeController = useTextEditingController();
    final messengerController = useMessengerController();

    useCubitListener<OTPCodePageCubit, OTPCodePageState>(
      cubit,
      (cubit, state, context) => _cubitListener(
        cubit,
        state,
        context,
        messengerController,
        otpReceivedCode,
      ),
    );

    useEffect(() {
      otpCodeController.addListener(() {
        cubit.updateCode(otpCodeController.text);
      });
    });

    useEffect(() {
      cubit.initialize(verification);
    }, [cubit]);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.smallTitle(
        title: LocaleKeys.otpCode_title.tr(),
        leading: NavigationButton.back(),
      ),
      body: SafeArea(
        child: Messenger(
          controller: messengerController,
          withActionHandler: false,
          child: KeyboardVisibilityBuilder(
            builder: (_, isKeyboardVisible) {
              return Stack(
                children: [
                  SingleChildScrollView(
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
                        _CodeField(
                          state: state,
                          cubit: cubit,
                          otpCodeController: otpCodeController,
                        ),
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
                  if (isKeyboardVisible && Platform.isIOS)
                    Positioned(
                      bottom: AppDimens.zero,
                      right: AppDimens.zero,
                      left: AppDimens.zero,
                      child: DoneKeyboardButton(),
                    ),

                  if (isKeyboardVisible && Platform.isAndroid)... [
                    Positioned(
                      bottom: AppDimens.zero,
                      right: AppDimens.zero,
                      left: AppDimens.zero,
                      child: ReceivedCodeKeyboardButton(
                        otpReceivedCode: otpReceivedCode.value,
                        onCodeClick: (code) {
                          otpCodeController.text = code;
                          otpCodeController.selection = TextSelection.fromPosition(
                              TextPosition(offset: code.length)
                          );
                        },
                      ),
                    ),
                  ]
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _cubitListener(
    OTPCodePageCubit cubit,
    OTPCodePageState state,
    BuildContext context,
    MessengerController controller,
    ValueNotifier<String> otpCodeNotifier,
  ) {
    state.maybeMap(
      connectionError: (state) => controller.showError(
        getConnectionErrorString(state.error),
      ),
      success: (state) {
        AutoRouter.of(context).pushAndPopUntil(
          const LoginSuccessPageRoute(),
          predicate: (route) => false,
        );
      },
      tooManyAttempts: (state) => controller.showError(state.message),
      otpAutofill: (state) => otpCodeNotifier.value = state.code,
      resendSuccess: (_) => controller.showInfo(
        tr(LocaleKeys.otpCode_codeResendSuccess),
      ),
      accountAlreadyExists: (state) {
        AutoRouter.of(context).replaceAll([const LoginResetPageRoute()]);
      },
      orElse: () {},
    );
  }
}

class _CodeField extends HookWidget {
  final OTPCodePageCubit cubit;
  final OTPCodePageState state;
  final TextEditingController otpCodeController;

  const _CodeField({
    required this.cubit,
    required this.state,
    required this.otpCodeController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mask = useMemoized(() => MaskTextInputFormatter(mask: '###-###'));

    return state.maybeMap(
      idle: (state) => _buildCodeField(true, mask, error: state.codeError),
      verifying: (state) => _buildCodeField(false, mask),
      resending: (state) => _buildCodeField(false, mask),
      orElse: () => _buildCodeField(false, mask),
    );
  }

  Widget _buildCodeField(bool enabled, MaskTextInputFormatter mask, {String? error}) => InputField(
        label: tr(LocaleKeys.otpCode_codeLabel),
        hint: LocaleKeys.addNewDevice_codeHint.tr(),
        onChanged: cubit.updateCode,
        enabled: enabled,
        inputType: TextInputType.phone,
        error: error,
        formatters: [mask],
        controller: otpCodeController,
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
      verifying: (_) => const Loader(),
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
      resending: (_) => const Loader(),
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

class ReceivedCodeKeyboardButton extends HookWidget {
  final String otpReceivedCode;
  final Function(String code) onCodeClick;

  const ReceivedCodeKeyboardButton({
    required this.otpReceivedCode,
    required this.onCodeClick,
  });

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();
    final separateIndex = useMemoized(() => OTPCodePageCubit.otpCodeLength ~/ 2);

    return otpReceivedCode.isNotEmpty ? Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(
          top: BorderSide(
            color: colors.dividerLight,
          ),
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateColor.resolveWith(
                  (states) => colors.text.withOpacity(0.15),
            ),
          ),
          onPressed: () {
            final formattedCode = otpReceivedCode.substring(0, separateIndex) + '-'
                + otpReceivedCode.substring(separateIndex, otpReceivedCode.length);
            onCodeClick(formattedCode);
          },
          child: Text(
            otpReceivedCode,
            style: typography.info1,
          ),
        ),
      ),
    ) : const SizedBox();
  }
}
