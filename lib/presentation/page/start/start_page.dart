import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/start/start_page_cubit.dart';
import 'package:logpass_me/presentation/page/start/start_page_state.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/checkbox/custom_checkbox.dart';
import 'package:logpass_me/presentation/widget/country_code_picker/country_code_picker.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/error_snackbar.dart';
import 'package:logpass_me/presentation/widget/input_field.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';

class StartPage extends HookWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<StartPageCubit>();
    final state = useCubitBuilder(cubit);
    final phoneNumberController = useTextEditingController();
    final color = useAppThemeColors();
    final typography = useAppTypography();

    useCubitListener<StartPageCubit, StartPageState>(
      cubit,
      (cubit, state, context) => _cubitListener(
        cubit,
        state,
        context,
        color,
        typography,
      ),
    );

    return Scaffold(
      backgroundColor: color.background,
      appBar: AppBar(
        title: Text(
          'Register',
          style: typography.h4,
        ),
        actions: const [
          _NeedHelpButton(),
        ],
      ),
      body: SafeArea(
        child: KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) => GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppDimens.l),
                  _PhoneNumberInput(
                    controller: phoneNumberController,
                    cubit: cubit,
                    state: state,
                  ),
                  const SizedBox(height: AppDimens.xxl),
                  _TermsAndConditionsCheck(cubit: cubit),
                  const SizedBox(height: AppDimens.l),
                  state.maybeMap(
                    processing: (state) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    orElse: () => CustomRectangularButton.filled(
                      text: tr(LocaleKeys.common_next),
                      onPressed: _getNextButtonAction(state, cubit),
                    ),
                  ),
                  const SizedBox(height: AppDimens.l),
                  if (!isKeyboardVisible) ...[
                    const Spacer(),
                    const _RegisterNewDevice(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Function()? _getNextButtonAction(StartPageState state, StartPageCubit cubit) {
    return state.maybeMap(
      idle: (state) => state.isValid ? cubit.register : null,
      orElse: () => null,
    );
  }

  void _cubitListener(
    StartPageCubit cubit,
    StartPageState state,
    BuildContext context,
    AppThemeColors colors,
    AppTypography typography,
  ) {
    state.maybeMap(
      successOTP: (state) {
        AutoRouter.of(context).push(OTPCodePageRoute(verification: state.verification));
      },
      successSignature: (state) {
        AutoRouter.of(context).replaceAll([const LoginSuccessPageRoute()]);
      },
      error: (state) {},
      connectionError: (state) {
        showConnectionErrorSnackBar(
          error: state.error,
          context: context,
          colors: colors,
          typography: typography,
        );
      },
      orElse: () {},
    );
  }
}

class _NeedHelpButton extends HookWidget {
  const _NeedHelpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: Text(
          LocaleKeys.start_helpAction,
          style: typography.info1.copyWith(decoration: TextDecoration.underline),
        ).tr(),
      ),
    );
  }
}

class _PhoneNumberInput extends StatelessWidget {
  final StartPageCubit cubit;
  final TextEditingController controller;
  final StartPageState state;

  const _PhoneNumberInput({
    required this.cubit,
    required this.controller,
    required this.state,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final error = state.maybeMap(
      idle: (state) {
        if (state.formErrors.contains(StartPageError.phoneValidation)) {
          return tr(LocaleKeys.start_phoneNumberFormatError);
        }
      },
      orElse: () => null,
    );

    return Row(
      children: [
        CountryCodePicker(onCountryCodeSelected: cubit.updateCountryCode),
        const SizedBox(width: AppDimens.s),
        Expanded(
          child: InputField(
            controller: controller,
            inputType: TextInputType.phone,
            onChanged: (value) => cubit.updatePhoneNumber(value),
            label: tr(LocaleKeys.common_phoneNumber),
            error: error,
            hint: '000-000-000',
          ),
        ),
      ],
    );
  }
}

class _TermsAndConditionsCheck extends HookWidget {
  final StartPageCubit cubit;

  const _TermsAndConditionsCheck({
    required this.cubit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomCheckbox(
          onValueChanged: cubit.updateTerms,
        ),
        const SizedBox(width: AppDimens.s),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(top: AppDimens.xs),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: tr(LocaleKeys.start_termsAcceptInfo),
                    style: typography.body1,
                  ),
                  TextSpan(
                    text: tr(LocaleKeys.start_termsAcceptHighlight),
                    style: typography.body3.copyWith(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()..onTap = () {}, //TODO open help page
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RegisterNewDevice extends HookWidget {
  const _RegisterNewDevice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          LocaleKeys.start_addNewDeviceInfo,
          textAlign: TextAlign.center,
          style: typography.body1,
        ).tr(),
        const SizedBox(height: AppDimens.l),
        CustomRectangularButton.outlined(
          text: tr(LocaleKeys.start_addNewDeviceAction),
          onPressed: () {}, // TODO open add new device page
        ),
        const SizedBox(height: AppDimens.m),
      ],
    );
  }
}
