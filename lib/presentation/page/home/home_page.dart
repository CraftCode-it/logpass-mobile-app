import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/home/home_cubit.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:logpass_me/presentation/widget/one_time_code_container/one_time_code_container.dart';

const _arrowIconSize = 24.0;
const _pendingItemIconSize = 20.0;
const _buttonBorderWidth = 1.5;

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<HomeCubit>();
    final state = useCubitBuilder(cubit);
    final messengerController = useMessengerController();

    useEffect(() {
      cubit.init();
      return;
    }, [cubit]);

    return _HomePageContent(
      cubit: cubit,
      state: state,
      messengerController: messengerController,
    );
  }
}

class _HomePageContent extends HookWidget {
  final HomeCubit cubit;
  final HomeState state;
  final MessengerController messengerController;

  const _HomePageContent({
    required this.cubit,
    required this.state,
    required this.messengerController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.smallLogo(
        logoColor: colors.logoSpecial,
      ).copyWith(
        predefinedBackground: colors.darkBackground,
      ),
      body: Messenger(
        controller: messengerController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OneTimeCodeContainer(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                child: _PendingActions(state),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PendingActions extends HookWidget {
  final HomeState state;

  const _PendingActions(this.state);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.xxl),
          Text(
            LocaleKeys.home_pendingActionsLabel.tr(),
            style: typography.h8,
          ),
          const SizedBox(height: AppDimens.l),
          state.maybeWhen(
            idle: (pendingActions) => _PendingItemsList(pendingActions),
            orElse: () => const SizedBox.shrink(),
            loadInProgress: () => const Loader(),
          ),
          const SizedBox(height: AppDimens.xxl),
          _PastEventsButton(),
          const SizedBox(height: AppDimens.xl),
        ],
      ),
    );
  }
}

class _PendingItemsList extends HookWidget {
  final List<IncomingAction> pendingActions;

  const _PendingItemsList(this.pendingActions);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return pendingActions.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _PendingItem(pendingActions[index]);
            },
            itemCount: pendingActions.length,
          )
        : Text(
            LocaleKeys.home_pendingActionsEmpty,
            textAlign: TextAlign.start,
            style: typography.body1.copyWith(color: colors.secondaryText),
          ).tr();
  }
}

class _PendingItem extends HookWidget {
  final IncomingAction action;

  const _PendingItem(this.action);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return InkWell(
      onTap: () {
        action.actionType.when(
          authorize: () => AutoRouter.of(context).push(AuthorizePageRoute(authorizationAttemptId: action.actionId)),
          confirm: () {},
          updateAccount: () {},
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
                        color: colors.secondaryText,
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
                        color: colors.text,
                        width: _arrowIconSize,
                        height: _arrowIconSize,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.s),
                  // TODO: replace it with remaining time value
                  Text(
                    LocaleKeys.home_pendingItemTimeLeft.tr(args: ['5:00 min']),
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
        onPressed: () {
          // TODO: handle navigation to past events
        },
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
                color: colors.text,
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
