import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/guardian/guardian_approval_page.dart';
import 'package:logpass_me/presentation/page/home/home_page.dart';
import 'package:logpass_me/presentation/page/main/main_page_cubit.dart';
import 'package:logpass_me/presentation/page/service_list/service_list_page.dart';
import 'package:logpass_me/presentation/page/settings/settings_page.dart';
import 'package:logpass_me/presentation/page/identity/identity_page.dart';
import 'package:logpass_me/presentation/page/wallet/wallet_home/wallet_home_page.dart';
import 'package:logpass_me/presentation/routing/main_router.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/hooks/app_life_cycyle_observer_hook.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/logout/guard_widget.dart';

@RoutePage()
class MainPage extends HookWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<MainPageCubit>();
    final colors = useAppThemeColors();
    final typography = useAppTypography();
    final index = useState(0);

    useCubitListener<MainPageCubit, MainPageState>(
      cubit,
      (cubit, state, context) => _cubitListener(cubit, state, context),
    );

    final locale = EasyLocalization.of(context)?.locale;
    final key = ValueKey(locale);

    useEffect(() {
      cubit.init();
      return;
    }, [cubit]);

    useAppLifecycleStateListener((current, previous, ctx) {
      if (current == AppLifecycleState.resumed &&
          previous == AppLifecycleState.paused) {
        if (index.value == 2) {
          WalletHomePage.reloadNotifier.value++;
        }
      }
    }, context: context);

    return Scaffold(
      key: key,
      body: GuardWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: IndexedStack(
                index: index.value,
                children: const [
                  HomePage(),
                  ServiceListPage(),
                  WalletHomePage(),
                  IdentityPage(),
                  SettingsPage(),
                ],
              ),
            ),
          ],
        ),
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
              colorFilter: ColorFilter.mode(colors.bottomBarInactiveText, BlendMode.srcIn),
            ),
            activeIcon: SvgPicture.asset(
              AppIcon.homeActive,
              colorFilter: ColorFilter.mode(colors.bottomBarActiveText, BlendMode.srcIn),
            ),
            label: tr(LocaleKeys.bottomBarNavigation_home),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcon.services,
              colorFilter: ColorFilter.mode(colors.bottomBarInactiveText, BlendMode.srcIn),
            ),
            activeIcon: SvgPicture.asset(
              AppIcon.servicesActive,
              colorFilter: ColorFilter.mode(colors.bottomBarActiveText, BlendMode.srcIn),
            ),
            label: tr(LocaleKeys.bottomBarNavigation_services),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined,
              color: colors.bottomBarInactiveText,
            ),
            activeIcon: Icon(Icons.account_balance_wallet,
              color: colors.bottomBarActiveText,
            ),
            label: tr(LocaleKeys.bottomBarNavigation_wallet),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcon.yourData,
              colorFilter: ColorFilter.mode(colors.bottomBarInactiveText, BlendMode.srcIn),
            ),
            activeIcon: SvgPicture.asset(
              AppIcon.yourDataActive,
              colorFilter: ColorFilter.mode(colors.bottomBarActiveText, BlendMode.srcIn),
            ),
            label: tr(LocaleKeys.bottomBarNavigation_data),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcon.settings,
              colorFilter: ColorFilter.mode(colors.bottomBarInactiveText, BlendMode.srcIn),
            ),
            activeIcon: SvgPicture.asset(
              AppIcon.settingsActive,
              colorFilter: ColorFilter.mode(colors.bottomBarActiveText, BlendMode.srcIn),
            ),
            label: tr(LocaleKeys.bottomBarNavigation_settings),
          ),
        ],
        currentIndex: index.value,
        onTap: (newIndex) {
          index.value = newIndex;
          if (newIndex == 2) {
            WalletHomePage.reloadNotifier.value++;
          }
        },
      ),
    );
  }

  void _cubitListener(
    MainPageCubit cubit,
    MainPageState state,
    BuildContext context,
  ) {
    state.maybeWhen(
      error: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
      openAction: (action) {
        action.actionType.when(
          authorize: () => AutoRouter.of(context).push(
            AuthorizeRoute(incomingAction: action),
          ),
          confirm: () => AutoRouter.of(context).push(const ConfirmRoute()),
          updateAccount: () {},
          refreshUserCode: () {},
          logpassVerify: () {
            final requestId = action.actionId;
            if (requestId != null) {
              final params = action.queryParameters;
              AutoRouter.of(context).push(
                VerificationRequestRoute(
                  requestId: requestId,
                  verifierName: params?['verifier'],
                  requestType: params?['request_type'],
                  minAge: int.tryParse(params?['min_age'] ?? '18') ?? 18,
                  allowGuardian: params?['allow_guardian'] == 'true',
                ),
              ).then((result) {
                if (result == true) {
                  HomePage.reloadActivityNotifier.value++;
                }
              });
            }
          },
          guardianPairing: () {
            final requestId = action.actionId;
            if (requestId != null) {
              final params = action.queryParameters;
              AutoRouter.of(context).push(
                GuardianApprovalRoute(
                  requestId: requestId,
                  approvalType: GuardianApprovalType.pairing,
                  guardianName: params?['guardian_name'] ?? '',
                  guardianPhone: params?['guardian_phone'],
                ),
              );
            }
          },
          guardianAuthRequest: () {
            final requestId = action.actionId;
            if (requestId != null) {
              final params = action.queryParameters;
              AutoRouter.of(context).push(
                GuardianApprovalRoute(
                  requestId: requestId,
                  approvalType: GuardianApprovalType.authRequest,
                  minorName: params?['minor_name'] ?? 'Nieznany',
                  minorPhone: params?['minor_phone'],
                  serviceName: params?['service_name'],
                  action: params?['action'],
                  expiresInSeconds:
                      int.tryParse(params?['expires_in_seconds'] ?? '300') ?? 300,
                ),
              );
            }
          },
          guardianAuthResult: () {},
        );
      },
      orElse: () {},
    );
  }
}
