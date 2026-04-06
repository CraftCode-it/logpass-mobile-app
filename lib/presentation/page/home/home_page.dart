import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/core/di/di_config.dart';
import 'package:logpass_me/data/activity/activity_api_data_source.dart';
import 'package:logpass_me/domain/activity/service_activity.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/exports.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/home/home_cubit.dart';
import 'package:logpass_me/presentation/routing/main_router.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/utils/date_time_utils.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:logpass_me/presentation/widget/one_time_code_container/one_time_code_container.dart';

const _arrowIconSize = 24.0;
const _pendingItemIconSize = 20.0;
const _buttonBorderWidth = 1.5;
const _smallerSizePhoneThreshold = 672.0;

@RoutePage()
class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  static final reloadActivityNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<HomeCubit>();
    final state = useCubitBuilder(cubit);
    final messengerController = useMessengerController();
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallSize = useMemoized(() {
      return screenHeight <= _smallerSizePhoneThreshold;
    }, []);

    useCubitListener<HomeCubit, HomeState>(
      cubit,
      (cubit, state, context) => _cubitListener(cubit, state, context, messengerController),
    );

    useEffect(() {
      cubit.init();
      return;
    }, [cubit]);

    return _HomePageContent(
      cubit: cubit,
      state: state,
      messengerController: messengerController,
      isSmallSize: isSmallSize,
    );
  }

  void _cubitListener(HomeCubit cubit, HomeState state, BuildContext context, MessengerController controller) {
    state.maybeWhen(
      codeCopied: () => controller.showInfo(LocaleKeys.home_codeCopied.tr()),
      orElse: () {},
    );
  }
}

class _HomePageContent extends HookWidget {
  final HomeCubit cubit;
  final HomeState state;
  final MessengerController messengerController;
  final bool isSmallSize;

  const _HomePageContent({
    required this.cubit,
    required this.state,
    required this.messengerController,
    required this.isSmallSize,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final overlayStyle =
        isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: isSmallSize
            ? null
            : CustomAppBar.smallLogo(
                systemUiOverlayStyle: overlayStyle,
                logoColor: colors.logoSpecial,
                trailing: IconButton(
                  icon: Icon(Icons.qr_code_scanner, color: colors.logoSpecial),
                  tooltip: LocaleKeys.qrScan_title.tr(),
                  onPressed: () => AutoRouter.of(context).push(const QrScanRoute()),
                ),
              ).copyWith(
                predefinedBackground: colors.codeContainerBackground,
              ),
        body: Messenger(
          controller: messengerController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              OneTimeCodeContainer(
                onCopyCallback: cubit.emitCopyInformation,
                messengerController :messengerController
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                        child: _PendingActions(cubit, state, isSmallSize),
                      ),
                    ),
                    _PastEventsButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PendingActions extends HookWidget {
  final HomeCubit cubit;
  final HomeState state;
  final bool isSmallSize;

  const _PendingActions(this.cubit, this.state, this.isSmallSize);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: isSmallSize ? AppDimens.m : AppDimens.xxl),
          Text(
            LocaleKeys.home_pendingActionsLabel.tr(),
            style: typography.h8,
          ),
          SizedBox(height: isSmallSize ? AppDimens.zero : AppDimens.s),
          state.maybeWhen(
            idle: (pendingActions) => _PendingItemsList(pendingActions, cubit),
            orElse: () => const SizedBox.shrink(),
            loadInProgress: () => const Loader(),
          ),
          const SizedBox(height: AppDimens.l),
          const _RecentActivitySection(),
          const SizedBox(height: AppDimens.l),
        ],
      ),
    );
  }
}

class _PendingItemsList extends HookWidget {
  final HomeCubit cubit;
  final List<IncomingAction> pendingActions;

  const _PendingItemsList(this.pendingActions, this.cubit);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return pendingActions.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _PendingItem(pendingActions[index], (action) {
                cubit.removeAction(action);
              });
            },
            itemCount: pendingActions.length,
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDimens.m),
            child: Text(
              LocaleKeys.home_pendingActionsEmpty,
              textAlign: TextAlign.start,
              style: typography.body1.copyWith(color: colors.secondaryText),
            ).tr(),
          );
  }
}

class _PendingItem extends HookWidget {
  final IncomingAction action;
  final Function(IncomingAction action) onRemove;

  const _PendingItem(this.action, this.onRemove);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();
    final countDownValue = useState('');

    final tickerProvider = useSingleTickerProvider();

    useEffect(() {
      final ticker = tickerProvider.createTicker((_) {
        _verifyExpirationActionTime(countDownValue);
      });

      ticker.start();

      return ticker.dispose;
    }, [tickerProvider, countDownValue]);

    return InkWell(
      onTap: () {
        action.actionType.maybeWhen(
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
                ),
              ).then((result) {
                if (result == true) {
                  HomePage.reloadActivityNotifier.value++;
                }
              });
            }
          },
          orElse: () {},
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.m),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colors.dividerLight,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO: replace with service's logo
            Container(
              width: AppDimens.l,
              height: AppDimens.l,
              color: colors.buttonFill,
            ),
            const SizedBox(width: AppDimens.l),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppIcon.lock,
                        colorFilter: ColorFilter.mode(colors.secondaryText, BlendMode.srcIn),
                        width: _pendingItemIconSize,
                        height: _pendingItemIconSize,
                      ),
                      const SizedBox(width: AppDimens.l),
                      Expanded(
                        child: Text(
                          action.actionType.maybeWhen(
                            authorize: () => LocaleKeys.home_actionTypeAuthorization.tr(),
                            orElse: () => 'Unknown',
                          ),
                          style: typography.body3,
                        ),
                      ),
                      SvgPicture.asset(
                        AppIcon.chevronRight,
                        colorFilter: ColorFilter.mode(colors.text, BlendMode.srcIn),
                        width: _arrowIconSize,
                        height: _arrowIconSize,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.s),
                  Text(
                    LocaleKeys.home_pendingItemTimeLeft.tr(args: [countDownValue.value]),
                    style: typography.info2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _verifyExpirationActionTime(ValueNotifier<String> countDownValue) {
    countDownValue.value = action.expirationTime.toCountdown();

    if(action.isExpired) {
      onRemove(action);
    }
  }
}

class _PastEventsButton extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return SizedBox(
      width: double.infinity,
      height: AppDimens.c,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(colors.buttonOutlinedFill),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(
                color: colors.buttonOutlined,
                width: _buttonBorderWidth,
              ),
            ),
          ),
        ),
        onPressed: () => AutoRouter.of(context).push(const EventLogRoute()),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.home_pastActions.tr(),
                style: typography.h9.copyWith(color: colors.text),
              ),
              SvgPicture.asset(
                AppIcon.chevronRight,
                colorFilter: ColorFilter.mode(colors.text, BlendMode.srcIn),
                width: _arrowIconSize,
                height: _arrowIconSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentActivitySection extends HookWidget {
  const _RecentActivitySection();

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();
    final activities = useState<List<ServiceActivity>>([]);
    final isLoading = useState(true);
    final reloadKey = useValueListenable(HomePage.reloadActivityNotifier);

    useEffect(() {
      isLoading.value = true;
      final dataSource = getIt<ActivityApiDataSource>();
      dataSource.getActivity(limit: 5).then((result) {
        activities.value = result;
        isLoading.value = false;
      }).catchError((_) {
        isLoading.value = false;
      });
      return null;
    }, [reloadKey]);

    if (isLoading.value) return const SizedBox.shrink();
    if (activities.value.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.home_recentActivityLabel.tr(),
          style: typography.h8,
        ),
        const SizedBox(height: AppDimens.s),
        ...activities.value.map(
          (a) => _RecentActivityRow(activity: a, colors: colors, typography: typography),
        ),
        const SizedBox(height: AppDimens.s),
      ],
    );
  }
}

class _RecentActivityRow extends StatelessWidget {
  final ServiceActivity activity;
  final AppThemeColors colors;
  final AppTypography typography;

  const _RecentActivityRow({
    required this.activity,
    required this.colors,
    required this.typography,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.s),
      child: Row(
        children: [
          Container(
            width: AppDimens.l,
            height: AppDimens.l,
            decoration: BoxDecoration(
              color: colors.buttonFill.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _iconForAction(activity.actionType),
              size: 16,
              color: colors.buttonFill,
            ),
          ),
          const SizedBox(width: AppDimens.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.serviceName, style: typography.body3),
                Text(
                  '${_labelForAction(activity.actionType)} · ${_formatDate(activity.createdAt)}',
                  style: typography.info2.copyWith(color: colors.secondaryText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForAction(String actionType) {
    switch (actionType) {
      case 'identity':
        return Icons.person_outlined;
      case 'age_18':
      case 'verification':
        return Icons.verified_user_outlined;
      case 'login':
        return Icons.login_outlined;
      default:
        return Icons.shield_outlined;
    }
  }

  String _labelForAction(String actionType) {
    switch (actionType) {
      case 'identity':
        return LocaleKeys.home_recentActivityActionIdentity.tr();
      case 'age_18':
      case 'verification':
        return LocaleKeys.home_recentActivityActionAge.tr();
      default:
        return LocaleKeys.home_recentActivityActionVerification.tr();
    }
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) {
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return '${dt.day}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
  }
}
