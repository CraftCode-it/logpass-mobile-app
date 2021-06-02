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
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/checkbox/custom_checkbox.dart';
import 'package:logpass_me/presentation/widget/country_code_picker/country_code_picker.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';

class StartPage extends HookWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<StartPageCubit>();
    final state = useCubitBuilder(cubit);
    final phoneNumberController = useTextEditingController();
    final typography = useAppTypography();

    useCubitListener(cubit, _cubitListener);

    return Scaffold(
      body: SafeArea(
        child: KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) => GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _NeedHelpButton(),
                  Expanded(
                    child: Center(
                      child: Text(
                        LocaleKeys.common_appName,
                        style: typography.primary,
                      ).tr(),
                    ),
                  ),
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
                    orElse: () => RoundedButton(
                      text: tr(LocaleKeys.common_next),
                      onPressed: _getNextButtonAction(state, cubit),
                    ),
                  ),
                  const SizedBox(height: AppDimens.l),
                  if (!isKeyboardVisible) const _RegisterNewDevice(),
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

  void _cubitListener(StartPageCubit cubit, StartPageState state, BuildContext context) {
    state.maybeMap(
      successOTP: (state) {
        AutoRouter.of(context).push(OTPCodePageRoute(verification: state.verification));
      },
      successSignature: (state) {}, // TODO navigate to home page as we are logged in
      error: (state) {},
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
          style: typography.primary,
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
        const SizedBox(width: AppDimens.m),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            onChanged: (value) => cubit.updatePhoneNumber(value),
            decoration: InputDecoration(
              labelText: tr(LocaleKeys.common_phoneNumber),
              errorText: error,
            ),
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
        Flexible(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: tr(LocaleKeys.start_termsAcceptInfo),
                  style: typography.primary,
                ),
                TextSpan(
                  text: tr(LocaleKeys.start_termsAcceptHighlight),
                  style: typography.primary.copyWith(fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()..onTap = () {}, //TODO open help page
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RegisterNewDevice extends StatelessWidget {
  const _RegisterNewDevice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          LocaleKeys.start_addNewDeviceInfo,
          textAlign: TextAlign.center,
        ).tr(),
        const SizedBox(height: AppDimens.l),
        RoundedButton(
          text: tr(LocaleKeys.start_addNewDeviceAction),
          onPressed: () {}, // TODO open add new device page
        ),
      ],
    );
  }
}
