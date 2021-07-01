import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:logpass_me/presentation/widget/navigation_row.dart';
import 'package:logpass_me/presentation/widget/need_help_button.dart';
import 'package:logpass_me/presentation/widget/separator.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';

class YourDataPage extends HookWidget {
  const YourDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final messengerController = useMessengerController();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.bigTitle(
        title: LocaleKeys.yourData_title.tr(),
        trailing: const NeedHelpButton(),
      ),
      body: Messenger(
        controller: messengerController,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l, vertical: AppDimens.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NavigationRow.withIcon(
                AppIcon.personalData,
                LocaleKeys.yourData_personalData.tr(),
                () => AutoRouter.of(context).push(const DataPersonalPageRoute()),
              ),
              Separator.light(),
              NavigationRow.withIcon(
                AppIcon.email,
                LocaleKeys.yourData_emails.tr(),
                () => AutoRouter.of(context).push(const DataEmailsPageRoute()),
              ),
              Separator.light(),
              NavigationRow.withIcon(
                AppIcon.address,
                LocaleKeys.yourData_addresses.tr(),
                () => AutoRouter.of(context).push(const DataAddressesPageRoute()),
              ),
              Separator.light(),
              NavigationRow.withIcon(AppIcon.invoiceData, LocaleKeys.yourData_invoiceData.tr(), () {}),
              Separator.light(),
            ],
          ),
        ),
      ),
    );
  }
}
