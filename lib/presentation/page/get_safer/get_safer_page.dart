import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/get_safer/get_safer_cubit.dart';
import 'package:logpass_me/presentation/page/get_safer/get_safer_page_state.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/utils/text_utils.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/logpass_dialog.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';
import 'package:logpass_me/presentation/widget/separator.dart';

class GetSaferPage extends HookWidget {
  const GetSaferPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<GetSaferCubit>();
    final state = useCubitBuilder(cubit);
    final colors = useAppThemeColors();

    useCubitListener(cubit, _listener);

    useEffect(() {
      cubit.initialize();
    }, [cubit]);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.smallTitle(
        title: LocaleKeys.getSafer_title.tr(),
      ),
      body: SafeArea(
        child: state.maybeMap(
          loading: (_) => const Loader(),
          idle: (state) => _Body(
            withBiometrics: state.withBiometrics,
            setPinCodeCallback: () => _setPinCode(context, cubit.setPinSecurity),
            verifyBiometricsCallback: () => cubit.invokeBiometricsSetup(),
          ),
          orElse: () => const Loader(),
        ),
      ),
    );
  }

  Future<void> _setPinCode(BuildContext context, Function() onSuccess) async {
    final success = await AutoRouter.of(context).push(const NewPinPageRoute());
    if (success == true) {
      await onSuccess();
    }
  }

  void _listener(GetSaferCubit cubit, GetSaferPageState state, BuildContext context) {
    state.maybeMap(
      setCodeForBiometrics: (_) => _setPinCode(context, cubit.setBiometricsSecurity),
      success: (_) => AutoRouter.of(context).push(PinSuccessPageRoute(route: const MainPageRoute())),
      orElse: () {},
    );
  }
}

class _Body extends HookWidget {
  final Function() verifyBiometricsCallback;
  final Function() setPinCodeCallback;
  final bool withBiometrics;

  const _Body({
    required this.verifyBiometricsCallback,
    required this.setPinCodeCallback,
    required this.withBiometrics,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.m),
          Text(
            LocaleKeys.getSafer_info,
            textAlign: TextAlign.center,
            style: typography.body2,
          ).tr(),
          const SizedBox(height: AppDimens.xxl),
          Separator.dark(),
          const Spacer(),
          if (withBiometrics) ...[
            _MethodContainer(
              info: tr(LocaleKeys.getSafer_biometricInfo),
              action: tr(LocaleKeys.getSafer_biometricAction),
              onPressed: verifyBiometricsCallback,
              filledButton: true,
            ),
            const SizedBox(height: AppDimens.xl),
            _MethodContainer(
              info: tr(LocaleKeys.getSafer_codeInfoSecondary),
              action: tr(LocaleKeys.getSafer_codeAction),
              onPressed: setPinCodeCallback,
              filledButton: false,
            ),
          ],
          if (!withBiometrics)
            _MethodContainer(
              info: tr(LocaleKeys.getSafer_codeInfoPrimary),
              action: tr(LocaleKeys.getSafer_codeAction),
              onPressed: setPinCodeCallback,
              filledButton: true,
            ),
          const SizedBox(height: AppDimens.c),
          TextButton(
            onPressed: () => _skip(context),
            child: Text(
              tr(LocaleKeys.getSafer_skipAction),
              style: typography.body3,
            ).withUnderline(colors.text),
          ),
        ],
      ),
    );
  }

  Future<void> _skip(BuildContext context) async {
    final shouldSkip = await showTwoOptionsDialog(
      context,
      LocaleKeys.getSafer_skipDialog_title.tr(),
      LocaleKeys.getSafer_skipDialog_content.tr(),
      LocaleKeys.getSafer_skipDialog_action.tr(),
      LocaleKeys.getSafer_skipDialog_backAction.tr(),
    );
    if (shouldSkip) {
      AutoRouter.of(context).popUntilRoot();
    }
  }
}

class _MethodContainer extends HookWidget {
  final String info;
  final String action;
  final Function() onPressed;
  final bool filledButton;

  const _MethodContainer({
    required this.info,
    required this.action,
    required this.onPressed,
    required this.filledButton,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          info,
          textAlign: TextAlign.center,
          style: typography.body1,
        ),
        const SizedBox(height: AppDimens.m),
        if (filledButton)
          CustomRectangularButton.filled(
            text: action,
            onPressed: onPressed,
          )
        else
          CustomRectangularButton.outlined(
            text: action,
            onPressed: onPressed,
          ),
      ],
    );
  }
}
