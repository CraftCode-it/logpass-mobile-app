import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/presentation/page/entry/entry_page_cubit.dart';
import 'package:logpass_me/presentation/page/entry/entry_page_state.dart';
import 'package:logpass_me/presentation/routing/main_router.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

@RoutePage()
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
      backgroundColor: AppColors.backgroundDark,
      body: state.maybeMap(
        idle: (_) => const Loader(),
        orElse: () => const SizedBox(),
      ),
    );
  }

  void _listener(EntryPageCubit cubit, EntryPageState state, BuildContext context) {
    state.maybeMap(
      onboarding: (_) async {
        await _precacheOnboardingImages(context);
        await AutoRouter.of(context).replace(OnboardingRoute());
      },
      home: (_) => AutoRouter.of(context).replace(const MainRoute()),
      securedLogin: (_) => AutoRouter.of(context).replace(const SecuredLoginRoute()),
      orElse: () {},
    );
  }

  Future<void> _precacheOnboardingImages(BuildContext context) async {
    final brightness = Theme.of(context).brightness;

    final assets = brightness == Brightness.light
        ? [AppIcon.onboarding1Light, AppIcon.onboarding2Light, AppIcon.onboarding3Light]
        : [AppIcon.onboarding1Dark, AppIcon.onboarding2Dark, AppIcon.onboarding3Dark];

    for (final asset in assets) {
      final loader = SvgAssetLoader(asset);
      await svg.cache
          .putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
    }
  }
}
