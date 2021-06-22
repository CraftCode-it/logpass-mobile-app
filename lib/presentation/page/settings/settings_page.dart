import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/page/settings/settings_navigation_row.dart';
import 'package:logpass_me/presentation/page/settings/settings_page_cubit.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/dark_mode_switch/dark_mode_switch_row.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';
import 'package:logpass_me/presentation/widget/separator.dart';

class SettingsPage extends HookWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SettingsPageCubit>();
    final colors = useAppThemeColors();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.bigTitle(title: 'Settings'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l, vertical: AppDimens.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SettingsNavigationRow.withIcon(AppIcon.device, 'Your devices', () {}),
              const _Divider(),
              SettingsNavigationRow.withIcon(AppIcon.security, 'Security', () {}),
              const _Divider(),
              const SizedBox(height: AppDimens.xc),
              const DarkModeSwitchRow(),
              const _Divider(),
              SettingsNavigationRow.titled('Language', () {}),
              const _Divider(),
              SettingsNavigationRow.titled('Terms&Condition', () {}),
              const _Divider(),
              SettingsNavigationRow.titled('Help', () {}),
              const _Divider(),
              const SizedBox(height: AppDimens.xc),
              CustomRectangularButton.outlined(
                text: 'Log out',
                onPressed: () => cubit.logOut(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Separator.light(),
    );
  }
}
