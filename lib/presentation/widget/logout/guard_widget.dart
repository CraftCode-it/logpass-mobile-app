import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/exports.dart';
import 'package:logpass_me/presentation/routing/main_router.dart';
import 'package:logpass_me/presentation/widget/hooks/app_life_cycyle_observer_hook.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/logout/guard_widget_cubit.dart';
import 'package:logpass_me/presentation/widget/logout/guard_widget_state.dart';

class GuardWidget extends HookWidget {
  final Widget child;

  const GuardWidget({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<GuardWidgetCubit>();
    useCubitListener(cubit, _logoutCubitListener,
        listenWhen: (state) => state is GuardWidgetStateLogout || state is GuardWidgetStateSecuredLogin);

    useAppLifecycleStateListener((currentAppDState, previousAppState, ctx) {
      if (currentAppDState == AppLifecycleState.resumed && previousAppState == AppLifecycleState.paused) {
        cubit.appResumed();
      }
      if (currentAppDState == AppLifecycleState.paused) {
        cubit.appPaused();
      }
    }, context: context);

    useEffect(() {
      cubit.init();
      return null;
    }, [cubit]);

    return child;
  }

  void _logoutCubitListener(
    GuardWidgetCubit cubit,
    GuardWidgetState state,
    BuildContext context,
  ) {
    state.maybeMap(
      logout: (sate) => _navigateOnLogout(context),
      securedLogin: (sate) => _navigateOnSecure(context),
      orElse: () {},
    );
  }

  void _navigateOnLogout(BuildContext context) {
    AutoRouter.of(context).replaceAll([
      OnboardingRoute(logoutMessage: LocaleKeys.logoutSuccess_info.tr())
    ]);
  }

  void _navigateOnSecure(BuildContext context) {
    AutoRouter.of(context).push(const SecuredLoginRoute());
  }
}
