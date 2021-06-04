import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

class LoginSuccessPage extends HookWidget {
  const LoginSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    useEffect(() {
      Future.delayed(const Duration(seconds: 3)).then((_) {
        // TODO navigation to main page
        // AutoRouter.of(context).pushAndPopUntil(route, predicate: (route) => false);
      });
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Text(
              LocaleKeys.common_appName,
              style: typography.primary,
              textAlign: TextAlign.center,
            ).tr(),
            const Spacer(),
            Text(
              LocaleKeys.login_success_info,
              style: typography.primary,
              textAlign: TextAlign.center,
            ).tr(),
            const SizedBox(height: AppDimens.xxl),
          ],
        ),
      ),
    );
  }
}
