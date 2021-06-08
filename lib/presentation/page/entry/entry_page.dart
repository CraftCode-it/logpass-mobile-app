import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/entry/entry_page_cubit.dart';
import 'package:logpass_me/presentation/page/entry/entry_page_state.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

class EntryPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<EntryPageCubit>();
    final state = useCubitBuilder(cubit);

    useCubitListener(cubit, _listener);

    useEffect(
      () {
        cubit.initialize();
        return () {};
      },
      [cubit],
    );

    return Scaffold(
      body: state.maybeMap(
        idle: (_) => const _Idle(),
        orElse: () => const SizedBox(),
      ),
    );
  }

  void _listener(EntryPageCubit cubit, EntryPageState state, BuildContext context) {
    state.maybeMap(
      onboarding: (_) => AutoRouter.of(context).replace(const OnboardingPageRoute()),
      home: (_) => AutoRouter.of(context).replace(const MainPageRoute()),
      securedLogin: (_) => AutoRouter.of(context).replace(const SecuredLoginPageRoute()),
      orElse: () {},
    );
  }
}

class _Idle extends StatelessWidget {
  const _Idle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: const Text(LocaleKeys.common_appName).tr(),
      );
}
