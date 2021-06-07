import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/page/home/home_cubit.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/one_time_code_container/one_time_code_container.dart';

class HomePage extends HookWidget {
  bool _shouldBuild(HomeState state) => state is LoadInProgress || state is Idle || state is Error;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<HomeCubit>();
    final state = useCubitBuilder(cubit, buildWhen: _shouldBuild);

    useEffect(() {
      cubit.init();
      return;
    }, [cubit]);

    return Scaffold(
      body: state.maybeWhen(
        idle: (pendingActions) => _HomePageContent(pendingActions),
        orElse: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class _HomePageContent extends HookWidget {
  // TODO: refactor in accordance to backend
  final List<String> pendingActions;

  const _HomePageContent(this.pendingActions);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: AppDimens.xxl),
          SizedBox(
            width: double.infinity,
            child: Text(
              LocaleKeys.common_appName,
              textAlign: TextAlign.center,
              style: typography.primary.copyWith(fontSize: AppDimens.l),
            ).tr(),
          ),
          const SizedBox(height: AppDimens.xxl),
          OneTimeCodeContainer(),
        ],
      ),
    );
  }
}
