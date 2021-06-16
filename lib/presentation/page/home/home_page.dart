import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/home/home_cubit.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/one_time_code_container/one_time_code_container.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';

// TODO: remove after appTypography implementation
const _customFontSize = 12.0;

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<HomeCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(() {
      cubit.init();
      return;
    }, [cubit]);

    return _HomePageContent(cubit, state);
  }
}

class _HomePageContent extends HookWidget {
  final HomeCubit cubit;
  final HomeState state;

  const _HomePageContent(this.cubit, this.state);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.xxl),
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
              const SizedBox(height: AppDimens.ml),
              Expanded(
                child: _PendingActions(state),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PendingActions extends StatelessWidget {
  final HomeState state;

  const _PendingActions(this.state);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _PendingActionsIndicator(),
          const SizedBox(height: AppDimens.m),
          state.maybeWhen(
            idle: (pendingActions) => _PendingItemsList(pendingActions),
            orElse: () => const SizedBox.shrink(),
            loadInProgress: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          const SizedBox(height: AppDimens.s),
          _PastEventsButton(),
          const SizedBox(height: AppDimens.s),
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
            style: typography.primary.copyWith(fontSize: AppDimens.m),
          ).tr();
  }
}

class _PendingItem extends HookWidget {
  final IncomingAction action;

  const _PendingItem(this.action);

  @override
  Widget build(BuildContext context) {
    final appTypography = useAppTypography();
    final appColors = useAppThemeColors();

    return GestureDetector(
      onTap: () {
        action.actionType.when(
          authorize: () => AutoRouter.of(context).push(AuthorizePageRoute(authorizationAttemptId: action.actionId)),
          confirm: () {},
          updateAccount: () {},
        );
      },
      child: Container(
        height: AppDimens.xc,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: appColors.primaryText,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: AppDimens.m,
              height: AppDimens.m,
              color: appColors.primaryButton,
            ),
            const SizedBox(width: AppDimens.m),
            Expanded(
              child: Text(
                action.actionType.maybeWhen(
                  authorize: () => LocaleKeys.home_action_type_authorization.tr(),
                  orElse: () => 'Unknown',
                ),
                style: appTypography.primary,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: appColors.primaryButton,
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
    final appTypography = useAppTypography();
    final appColors = useAppThemeColors();

    return SizedBox(
      width: double.infinity,
      height: AppDimens.c,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(appColors.secondary),
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
                style: appTypography.primary,
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: appColors.primaryText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PendingActionsIndicator extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final appTypography = useAppTypography();
    final appColors = useAppThemeColors();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: AppDimens.one,
          color: appColors.primaryText,
        ),
        const SizedBox(height: AppDimens.xs),
        Text(
          LocaleKeys.home_pendingActionsLabel.tr(),
          style: appTypography.primary.copyWith(
            fontSize: _customFontSize,
          ),
        ),
      ],
    );
  }
}
