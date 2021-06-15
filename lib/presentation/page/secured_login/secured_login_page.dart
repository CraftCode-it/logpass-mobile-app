import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:logpass_me/domain/app_security/app_security_type.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/secured_login/secured_login_page_cubit.dart';
import 'package:logpass_me/presentation/page/secured_login/secured_login_page_state.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/pin_field.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';

class SecuredLoginPage extends HookWidget {
  const SecuredLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SecuredLoginPageCubit>();
    final state = useCubitBuilder(cubit);
    final pinFieldController = useTextEditingController();

    useCubitListener<SecuredLoginPageCubit, SecuredLoginPageState>(
      cubit,
      (cubit, state, context) => _listener(cubit, state, context, pinFieldController),
    );
    useEffect(() {
      cubit.initialize();
    }, [cubit]);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: KeyboardVisibilityBuilder(
            builder: (context, keyboardVisible) => _Content(
              state: state,
              cubit: cubit,
              keyboardVisible: keyboardVisible,
            ),
          ),
        ),
      ),
    );
  }

  void _listener(
    SecuredLoginPageCubit cubit,
    SecuredLoginPageState state,
    BuildContext context,
    TextEditingController pinController,
  ) {
    state.maybeMap(
      wrongPin: (_) => pinController.clear(),
      validated: (_) => AutoRouter.of(context).replaceAll([const MainPageRoute()]),
      orElse: () {},
    );
  }
}

class _Content extends HookWidget {
  final SecuredLoginPageState state;
  final SecuredLoginPageCubit cubit;
  final bool keyboardVisible;

  const _Content({
    required this.state,
    required this.cubit,
    required this.keyboardVisible,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _NeedHelpButton(),
        const Spacer(flex: 3),
        Text(
          LocaleKeys.common_appName,
          textAlign: TextAlign.center,
          style: typography.primary,
        ).tr(),
        const SizedBox(height: AppDimens.xl),
        _AuthorizationOptionsContainer(
          state: state,
          cubit: cubit,
          keyboardVisible: keyboardVisible,
        ),
        const Spacer(flex: 2),
        if (_shouldShowDoneKeyboardButton())
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: const Text('Done'),
            ),
          ),
        if (!keyboardVisible) ...[
          Text(
            LocaleKeys.securedLogin_logoutInfo,
            textAlign: TextAlign.center,
            style: typography.primary,
          ).tr(),
          const SizedBox(height: AppDimens.m),
          CustomRectangularButton.outlined(
            text: tr(LocaleKeys.common_logout),
            onPressed: () {},
          ),
          const SizedBox(height: AppDimens.l),
        ],
      ],
    );
  }

  bool _shouldShowDoneKeyboardButton() => keyboardVisible && Platform.isIOS;
}

class _NeedHelpButton extends StatelessWidget {
  const _NeedHelpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: const Text(LocaleKeys.securedLogin_needHelp).tr(),
      ),
    );
  }
}

class _AuthorizationOptionsContainer extends HookWidget {
  final SecuredLoginPageState state;
  final SecuredLoginPageCubit cubit;
  final bool keyboardVisible;

  const _AuthorizationOptionsContainer({
    required this.state,
    required this.cubit,
    required this.keyboardVisible,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final type = state.maybeMap(
      idle: (state) => state.type,
      orElse: () => null,
    );

    if (type == null) return const Loader();

    final pinError = state.maybeMap(
      idle: (state) => state.pinCodeError ? tr(LocaleKeys.securedLogin_pinCodeInvalid) : null,
      orElse: () => null,
    );

    final typography = useAppTypography();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          LocaleKeys.securedLogin_pinCodeInfo,
          textAlign: TextAlign.center,
          style: typography.primary,
        ).tr(),
        const SizedBox(height: AppDimens.c),
        PinField(
          onPinChanged: cubit.updatePinCode,
          autoFocus: type == AppSecurityType.code,
        ),
        if (pinError != null) ...[
          const SizedBox(height: AppDimens.s),
          Text(
            pinError,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.redAccent),
          ),
        ],
        const SizedBox(height: AppDimens.xl),
        if (_shouldShowBiometrics(type)) _OptionalBiometricsContainer(cubit: cubit),
      ],
    );
  }

  bool _shouldShowBiometrics(AppSecurityType type) => type == AppSecurityType.biometric && !keyboardVisible;
}

class _OptionalBiometricsContainer extends HookWidget {
  final SecuredLoginPageCubit cubit;

  const _OptionalBiometricsContainer({
    required this.cubit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          LocaleKeys.securedLogin_biometricInfo,
          textAlign: TextAlign.center,
          style: typography.primary,
        ).tr(),
        const SizedBox(height: AppDimens.s),
        IconButton(
          onPressed: cubit.useBiometrics,
          icon: const Icon(Icons.fingerprint),
        ),
      ],
    );
  }
}
