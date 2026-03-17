import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/utils/text_utils.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';

class NeedHelpButton extends HookWidget {
  const NeedHelpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => AutoRouter.of(context).push(const NeedHelpPageRoute()),
        child: Text(
          LocaleKeys.securedLogin_needHelp,
          style: typography.info1,
        ).tr().withUnderline(colors.text),
      ),
    );
  }
}
