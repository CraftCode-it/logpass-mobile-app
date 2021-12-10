import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/domain/event_log/event_log.dart';
import 'package:logpass_me/domain/event_log/event_type.dart';
import 'package:logpass_me/exports.dart';
import 'package:logpass_me/presentation/page/event_log/event_log_page_cubit.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/custom_scaffold.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:logpass_me/presentation/widget/separator.dart';

class EventLogPage extends HookWidget {
  const EventLogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<EventLogPageCubit>();
    final state = useCubitBuilder(cubit);
    final messengerController = useMessengerController();

    useEffect(() {
      cubit.initialize();
    }, [cubit]);

    return CustomScaffold(
      appBar: CustomAppBar.smallTitle(
        leading: NavigationButton.back(),
        title: LocaleKeys.pastEvents_title.tr(),
      ),
      body: Messenger(
        controller: messengerController,
        child: state.maybeMap(
          idle: (state) => _EventsContent(
            cubit: cubit,
            events: state.events,
          ),
          empty: (state) => _EmptyEvents(cubit: cubit,),
          loading: (_) => const Loader(),
          orElse: () => const SizedBox.shrink(),
        ),
      ),
      onErrorActionTapped: () => cubit.loadFirstPage(),
      showErrorPage: state.maybeMap(
        error: (_) => true,
        orElse: () => false,
      ),
    );
  }
}

class _EventsContent extends StatelessWidget {
  final List<EventLog> events;
  final EventLogPageCubit cubit;

  const _EventsContent({
    required this.events,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => cubit.loadFirstPage(),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.l,
          vertical: AppDimens.m,
        ),
        itemBuilder: (context, index) => _EventRow(pastEvent: events[index]),
        separatorBuilder: (context, index) => const SizedBox(height: AppDimens.l),
        itemCount: events.length,
      ),
    );
  }
}

class _EventRow extends HookWidget {
  final EventLog pastEvent;

  const _EventRow({
    required this.pastEvent,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    final dateTime = _formatEventDate();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dateTime,
          style: typography.info2.copyWith(
            color: colors.secondaryText,
          ),
        ),
        const SizedBox(height: AppDimens.s),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            pastEvent.logo.maybeMap(
              network: (value) => _NetworkImage(value.url),
              local: (value) => _AssetImage(value.path),
              none: (_) => const SizedBox(),
              orElse: () => const SizedBox(),
            ),
            const SizedBox(width: AppDimens.l),
            SvgPicture.asset(
              AppIcon.security,
              color: colors.buttonFill,
            ),
            const SizedBox(width: AppDimens.l),
            Text(
              _getActionName(pastEvent.eventType),
              style: typography.body3,
            ),
          ],
        ),
        const SizedBox(height: AppDimens.m),
        Separator.light(),
      ],
    );
  }

  String _formatEventDate() {
    final dateFormat = DateFormat();
    dateFormat.add_yMd();
    dateFormat.add_Hm();
    return dateFormat.format(pastEvent.dateTime);
  }

  //TODO add strings for every type
  String _getActionName(EventType type) {
    return type.map(
      loginAttemptCreated: (_) => LocaleKeys.pastEvents_actionLabel_loginAttemptCreated.tr(),
      loginAttemptVerificationFailed: (_) => LocaleKeys.pastEvents_actionLabel_loginAttemptVerificationFailed.tr(),
      loginAttemptVerificationRetry: (_) => LocaleKeys.pastEvents_actionLabel_loginAttemptVerificationRetry.tr(),
      loginAttemptVerificationFinished: (_) => LocaleKeys.pastEvents_actionLabel_loginAttemptVerificationFinished.tr(),
      authorizationAttemptCreated: (_) => LocaleKeys.pastEvents_actionLabel_authorizationAttemptCreated.tr(),
      authorizationAttemptApproved: (_) => LocaleKeys.pastEvents_actionLabel_authorizationAttemptApproved.tr(),
      authorizationAttemptDenied: (_) => LocaleKeys.pastEvents_actionLabel_authorizationAttemptDenied.tr(),
      agreementAccepted: (_) => LocaleKeys.pastEvents_actionLabel_agreementAccepted.tr(),
      agreementRevoked: (_) => LocaleKeys.pastEvents_actionLabel_agreementRevoked.tr(),
      backupEntryCreated: (_) => LocaleKeys.pastEvents_actionLabel_backupEntryCreated.tr(),
      backupEntryUpdated: (_) => LocaleKeys.pastEvents_actionLabel_backupEntryUpdated.tr(),
      backupEntryDeleted: (_) => LocaleKeys.pastEvents_actionLabel_backupEntryDeleted.tr(),
    );
  }
}

class _EmptyEvents extends HookWidget {
  final EventLogPageCubit cubit;

  const _EmptyEvents({required this.cubit, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return RefreshIndicator(
      onRefresh: () => cubit.loadFirstPage(),
      child: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Text(
              LocaleKeys.pastEvents_noEvents,
              textAlign: TextAlign.center,
              style: typography.body1.copyWith(color: colors.secondaryText),
            ).tr(),
          ),
        ),
      ),
    );
  }
}

class _NetworkImage extends HookWidget {
  final String url;

  const _NetworkImage(this.url);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      height: AppDimens.l,
      width: AppDimens.l,
    );
  }
}

class _AssetImage extends HookWidget {
  final String path;

  const _AssetImage(this.path);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      height: AppDimens.l,
      width: AppDimens.l,
    );
  }
}
