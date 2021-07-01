import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/settings/settings_page_cubit.dart';
import 'package:logpass_me/presentation/page/settings/settings_page_state.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/dark_mode_switch/dark_mode_switch_row.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:logpass_me/presentation/widget/navigation_row.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';
import 'package:logpass_me/presentation/widget/separator.dart';

class SettingsPage extends HookWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SettingsPageCubit>();
    final colors = useAppThemeColors();
    final messengerController = useMessengerController();

    useCubitListener<SettingsPageCubit, SettingsPageState>(cubit, (cubit, state, context) {
      state.maybeMap(
        loggingOut: (_) {
          showDialog(
            context: context,
            builder: (context) => Container(
              width: double.infinity,
              height: double.infinity,
              child: const Material(
                color: Colors.white24,
                child: Loader(),
              ),
            ),
            barrierDismissible: false,
          );
        },
        orElse: () {},
      );
    });

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.bigTitle(title: LocaleKeys.settings_title.tr()),
      body: SafeArea(
        child: Messenger(
          controller: messengerController,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l, vertical: AppDimens.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                NavigationRow.withIcon(
                  AppIcon.device,
                  LocaleKeys.settings_devices.tr(),
                  () => AutoRouter.of(context).push(const DeviceListPageRoute()),
                ),
                Separator.light(),
                NavigationRow.withIcon(
                  AppIcon.security,
                  LocaleKeys.settings_security.tr(),
                  () => AutoRouter.of(context).push(const SecuritySettingsPageRoute()),
                ),
                Separator.light(),
                const SizedBox(height: AppDimens.xc),
                const DarkModeSwitchRow(),
                Separator.light(),
                NavigationRow.titled(
                  LocaleKeys.settings_language.tr(),
                  () => AutoRouter.of(context).push(const LanguagePageRoute()),
                ),
                Separator.light(),
                NavigationRow.titled(
                  LocaleKeys.settings_terms.tr(),
                  () => AutoRouter.of(context).push(const TermsAndConditionsPageRoute()),
                ),
                Separator.light(),
                NavigationRow.titled(
                  LocaleKeys.settings_help.tr(),
                  () => AutoRouter.of(context).push(const NeedHelpPageRoute()),
                ),
                Separator.light(),
                const SizedBox(height: AppDimens.xc),
                CustomRectangularButton.outlined(
                  text: LocaleKeys.settings_logout.tr(),
                  onPressed: () => cubit.logOut(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
