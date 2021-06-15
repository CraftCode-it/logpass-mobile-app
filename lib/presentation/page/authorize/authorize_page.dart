import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/page/authorize/authorize_page_cubit.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';

class AuthorizePage extends HookWidget {
  final String authorizationAttemptId;

  const AuthorizePage(this.authorizationAttemptId);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<AuthorizePageCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(() {
      cubit.init(authorizationAttemptId);
    }, [cubit]);

    return Scaffold(
      body: state.maybeWhen(
        idle: (canProceed) {
          return _PageContent();
        },
        loading: () => const Loader(),
        orElse: () => const SizedBox(),
      ),
    );
  }
}

class _PageContent extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppDimens.xxl),
            SizedBox(
              width: double.infinity,
              child: Text(
                'Authorize operation',
                textAlign: TextAlign.center,
                style: typography.primary.copyWith(fontSize: AppDimens.ml),
              ).tr(),
            ),
            const SizedBox(height: AppDimens.xxl),
            RoundedButton(
              text: 'Confirm',
              onPressed: () {},
            ),
            const SizedBox(height: AppDimens.xl),
            RoundedButton(
              text: 'Reject',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
