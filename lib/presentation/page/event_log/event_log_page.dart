import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/domain/event_log/past_event.dart';
import 'package:logpass_me/domain/incoming_actions/action_type.dart';
import 'package:logpass_me/exports.dart';
import 'package:logpass_me/presentation/page/event_log/event_log_page_cubit.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
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
          idle: (state) => _EventsContent(events: state.events),
          loading: (_) => const Loader(),
          orElse: () => const SizedBox.shrink(),
        ),
      ),
      onErrorActionTapped: () => cubit.load(),
      showErrorPage: state.maybeMap(
        error: (_) => true,
        orElse: () => false,
      ),
    );
  }
}

class _EventsContent extends StatelessWidget {
  final List<PastEvent> events;

  const _EventsContent({
    required this.events,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.l,
        vertical: AppDimens.m,
      ),
      itemBuilder: (context, index) => _EventRow(pastEvent: events[index]),
      separatorBuilder: (context, index) => const SizedBox(height: AppDimens.l),
      itemCount: events.length,
    );
  }
}

class _EventRow extends HookWidget {
  final PastEvent pastEvent;

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
            Image.network(
              pastEvent.logo,
              height: AppDimens.l,
              width: AppDimens.l,
            ),
            const SizedBox(width: AppDimens.l),
            SvgPicture.asset(
              AppIcon.security,
              color: colors.buttonFill,
            ),
            const SizedBox(width: AppDimens.l),
            Text(
              _getActionName(pastEvent.actionType),
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

  String _getActionName(ActionType type) {
    return type.when(
      authorize: () => LocaleKeys.pastEvents_actionLabel_authorize.tr(),
      confirm: () => LocaleKeys.pastEvents_actionLabel_confirm.tr(),
      updateAccount: () => LocaleKeys.pastEvents_actionLabel_update.tr(),
    );
  }
}
