import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/home/home_page.dart';
import 'package:logpass_me/presentation/page/main/main_page_cubit.dart';
import 'package:logpass_me/presentation/page/service_list/service_list_page.dart';
import 'package:logpass_me/presentation/page/settings/settings_page.dart';
import 'package:logpass_me/presentation/page/your_data/your_data_page.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/info_snackbar.dart';

class MainPage extends HookWidget {
  const MainPage({Key? key}) : super(key: key);

  void _cubitListener(
    MainPageCubit cubit,
    MainPageState state,
    BuildContext context,
    AppThemeColors colors,
    AppTypography typography,
  ) {
    state.maybeWhen(
      error: (message) {},
      showAction: (action) {
        showInformationSnackBar(
          context: context,
          colors: colors,
          typography: typography,
          message: tr(LocaleKeys.main_new_action),
          onTapAction: () {
            AutoRouter.of(context).push(AuthorizePageRoute(authorizationAttemptId: action.actionId));
          },
        );
      },
      orElse: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<MainPageCubit>();
    final colors = useAppThemeColors();
    final typography = useAppTypography();
    final index = useState(0);

    useCubitListener<MainPageCubit, MainPageState>(
      cubit,
      (cubit, state, context) => _cubitListener(cubit, state, context, colors, typography),
    );

    final locale = EasyLocalization.of(context)?.locale;
    final key = ValueKey(locale);

    useEffect(() {
      cubit.init();
      return;
    }, [cubit]);

    return Scaffold(
      key: key,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: IndexedStack(
              index: index.value,
              children: const [
                HomePage(),
                ServiceListPage(),
                YourDataPage(),
                SettingsPage(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: colors.bottomBarBackground,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: typography.info2.copyWith(color: colors.bottomBarActiveText),
        unselectedLabelStyle: typography.info2.copyWith(color: colors.bottomBarInactiveText),
        selectedItemColor: colors.bottomBarActiveText,
        unselectedItemColor: colors.bottomBarInactiveText,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcon.home,
              color: colors.bottomBarInactiveText,
            ),
            activeIcon: SvgPicture.asset(
              AppIcon.home,
              color: colors.bottomBarActiveText,
            ),
            label: tr(LocaleKeys.bottomBarNavigation_home),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcon.services,
              color: colors.bottomBarInactiveText,
            ),
            activeIcon: SvgPicture.asset(
              AppIcon.services,
              color: colors.bottomBarActiveText,
            ),
            label: tr(LocaleKeys.bottomBarNavigation_services),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcon.yourData,
              color: colors.bottomBarInactiveText,
            ),
            activeIcon: SvgPicture.asset(
              AppIcon.yourData,
              color: colors.bottomBarActiveText,
            ),
            label: tr(LocaleKeys.bottomBarNavigation_data),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcon.settings,
              color: colors.bottomBarInactiveText,
            ),
            activeIcon: SvgPicture.asset(
              AppIcon.settings,
              color: colors.bottomBarActiveText,
            ),
            label: tr(LocaleKeys.bottomBarNavigation_settings),
          ),
        ],
        currentIndex: index.value,
        onTap: (newIndex) => index.value = newIndex,
      ),
    );
  }
}
