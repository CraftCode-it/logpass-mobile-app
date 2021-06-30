import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/logout/logout_cubit.dart';
import 'package:logpass_me/presentation/widget/logout/logout_state.dart';

class LogoutWidget extends HookWidget {
  final Widget child;

  const LogoutWidget({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<LogoutCubit>();
    useCubitListener(cubit, _logoutCubitListener, listenWhen: (state) => state is LogoutStateLogout);

    useEffect(() {
      cubit.init();
    }, [cubit]);

    return child;
  }

  void _logoutCubitListener(
    LogoutCubit cubit,
    LogoutState state,
    BuildContext context,
  ) {
    state.maybeMap(
      logout: (sate) => _navigateOnLogout(context),
      orElse: () {},
    );
  }

  void _navigateOnLogout(BuildContext context) {
    AutoRouter.of(context).replaceAll([const StartPageRoute()]);
  }
}
