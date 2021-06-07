import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/get_safer/get_safer_cubit.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';

class GetSaferPage extends HookWidget {
  const GetSaferPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<GetSaferCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(() {
      cubit.initialize();
    }, [cubit]);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(LocaleKeys.getSafer_title).tr(),
      ),
      body: SafeArea(
        child: state.map(
          loading: (_) => const Center(
            child: CircularProgressIndicator(),
          ),
          idle: (state) => _Body(withBiometrics: state.withBiometrics),
        ),
      ),
    );
  }
}

class _Body extends HookWidget {
  final bool withBiometrics;

  const _Body({required this.withBiometrics, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.m),
          Text(
            LocaleKeys.getSafer_info,
            textAlign: TextAlign.center,
            style: typography.primary,
          ).tr(),
          Spacer(),
          Text(
            LocaleKeys.getSafer_biometricInfo,
            textAlign: TextAlign.center,
            style: typography.primary,
          ).tr(),
          const SizedBox(height: AppDimens.m),
          RoundedButton(
            text: tr(LocaleKeys.getSafer_biometricAction),
            onPressed: () {},
          ),
          const SizedBox(height: AppDimens.xl),
          Text(
            LocaleKeys.getSafer_codeInfo,
            textAlign: TextAlign.center,
            style: typography.primary,
          ).tr(),
          const SizedBox(height: AppDimens.m),
          RoundedButton(
            text: tr(LocaleKeys.getSafer_biometricAction),
            onPressed: () {},
          ),
          const SizedBox(height: AppDimens.c),
          RoundedButton(
            text: tr(LocaleKeys.getSafer_skipAction),
            onPressed: () => AutoRouter.of(context).popUntilRoot(),
          ),
        ],
      ),
    );
  }
}
