import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/domain/app_security/app_security_type.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/security_settings/security_settings_page_cubit.dart';
import 'package:logpass_me/presentation/page/security_settings/security_settings_page_state.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/custom_switch.dart';
import 'package:logpass_me/presentation/widget/logpass_dialog.dart';
import 'package:logpass_me/presentation/widget/separator.dart';

class SecuritySettingsPage extends HookWidget {
  const SecuritySettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SecuritySettingsPageCubit>();
    final state = useCubitBuilder(cubit);
    final colors = useAppThemeColors();

    useCubitListener<SecuritySettingsPageCubit, SecuritySettingsPageState>(
      cubit,
      (cubit, state, context) => _listener(
        cubit,
        state,
        context,
      ),
    );

    useEffect(() {
      cubit.initialize();
    }, [cubit]);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.smallTitle(
        leading: NavigationButton.back(),
        title: LocaleKeys.securitySettings_title.tr(),
      ),
      body: SafeArea(
        child: state.maybeMap(
          idle: (state) => _Content(
            securityType: state.appSecurityType,
            cubit: cubit,
          ),
          orElse: () => const Loader(),
        ),
      ),
    );
  }

  void _listener(
    SecuritySettingsPageCubit cubit,
    SecuritySettingsPageState state,
    BuildContext context,
  ) {
    state.maybeMap(
      setCode: (state) => _setCode(cubit, context, state.type),
      confirmWithCode: (state) => _confirmWithCode(cubit, context, state.type),
      orElse: () {},
    );
  }

  Future<void> _setCode(SecuritySettingsPageCubit cubit, BuildContext context, AppSecurityType type) async {
    final success = await AutoRouter.of(context).push(const NewPinPageRoute());
    if (success == true) {
      await cubit.applySecurityChange(type);
      await AutoRouter.of(context).push(PinSuccessPageRoute(route: const SecuritySettingsPageRoute()));
    }
  }

  Future<void> _confirmWithCode(
    SecuritySettingsPageCubit cubit,
    BuildContext context,
    AppSecurityType type,
  ) async {
    if (type == AppSecurityType.none) {
      final deactivate = await showTwoOptionsDialog(
        context,
        LocaleKeys.securitySettings_turnOffSecurity_title.tr(),
        LocaleKeys.securitySettings_turnOffSecurity_content.tr(),
        LocaleKeys.securitySettings_turnOffSecurity_action.tr(),
        LocaleKeys.common_back.tr(),
      );
      if (!deactivate) {
        cubit.cancelAction();
        return;
      }
    }

    final success = await AutoRouter.of(context).push(
      ConfirmWithPinPageRoute(
        title: type == AppSecurityType.none
            ? LocaleKeys.securitySettings_deactivatePinTitle.tr()
            : LocaleKeys.securitySettings_deactivateBiometricsTitle.tr(),
        button: LocaleKeys.common_deactivate.tr(),
      ),
    );
    if (success == true) {
      await cubit.applySecurityChange(type);
    }
  }
}

class _Content extends HookWidget {
  final SecuritySettingsPageCubit cubit;
  final AppSecurityType securityType;

  const _Content({
    required this.cubit,
    required this.securityType,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SwitchRow(
            icon: AppIcon.biometricSmall,
            content: LocaleKeys.securitySettings_biometrics.tr(),
            value: securityType == AppSecurityType.biometric,
            onChange: (value) => cubit.invokeBiometricChange(),
          ),
          Separator.light(),
          _SwitchRow(
            icon: AppIcon.pinCode,
            content: LocaleKeys.securitySettings_pin.tr(),
            value: securityType != AppSecurityType.none,
            onChange: (value) => cubit.invokePinCodeChange(),
          ),
          if (securityType != AppSecurityType.none)
            InkWell(
              onTap: () => _changePinCode(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppDimens.s),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        LocaleKeys.securitySettings_changePin.tr(),
                        style: typography.body2.copyWith(color: colors.secondaryText),
                      ),
                    ),
                    SvgPicture.asset(AppIcon.chevronRight),
                  ],
                ),
              ),
            ),
          Separator.light(),
        ],
      ),
    );
  }

  Future<void> _changePinCode(BuildContext context) async {
    final correctPinCode = await AutoRouter.of(context).push(
      ConfirmWithPinPageRoute(
        title: LocaleKeys.securitySettings_changePinCode_title.tr(),
        button: LocaleKeys.securitySettings_changePinCode_action.tr(),
      ),
    );

    if (correctPinCode == true) {
      final pinCodeSet = await AutoRouter.of(context).push(const NewPinPageRoute());

      if (pinCodeSet == true) {
        await AutoRouter.of(context).push(PinSuccessPageRoute(route: const SecuritySettingsPageRoute()));
      }
    }
  }
}

class _SwitchRow extends HookWidget {
  final String icon;
  final String content;
  final bool value;
  final Function(bool value) onChange;

  const _SwitchRow({
    required this.icon,
    required this.content,
    required this.value,
    required this.onChange,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.l),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            color: colors.buttonFill,
          ),
          const SizedBox(width: AppDimens.m),
          Expanded(
            child: Text(
              content,
              style: typography.body3,
            ),
          ),
          CustomSwitch(
            value: value,
            onChange: onChange,
          ),
        ],
      ),
    );
  }
}
