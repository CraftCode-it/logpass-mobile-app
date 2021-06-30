import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/session_list_view_cubit.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/session_list_view_state.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/session_row.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/error_snackbar.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';

void cubitEventListener(
    SessionListViewCubit cubit,
    SessionListViewState state,
    BuildContext context,
    MessengerController controller,
    ) {
  state.maybeMap(
    endedSession: (_) => controller.showInfo(
      tr(LocaleKeys.sessionListView_sessionEnded),
    ),
    connectionError: (state) => controller.showError(
      getConnectionErrorString(state.error),
    ),
    orElse: () {},
  );
}

class SessionListViewKeepingState extends StatefulWidget {
  final Service service;
  final MessengerController messengerController;

  const SessionListViewKeepingState({
    required this.service,
    required this.messengerController,
    Key? key,
  }) : super(key: key);

  @override
  _SessionListViewKeepingStateState createState() => _SessionListViewKeepingStateState();
}

class _SessionListViewKeepingStateState extends State<SessionListViewKeepingState> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SessionListView(
      service: widget.service,
      messengerController: widget.messengerController,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SessionListView extends HookWidget {
  final Service service;
  final MessengerController messengerController;

  const SessionListView({
    required this.service,
    required this.messengerController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SessionListViewCubit>();
    final state = useCubitBuilder(cubit);
    final scrollController = useScrollController();

    useCubitListener<SessionListViewCubit, SessionListViewState>(
      cubit,
      (cubit, state, context) => cubitEventListener(
        cubit,
        state,
        context,
        messengerController,
      ),
    );

    final screenHeight = MediaQuery.of(context).size.height;

    useEffect(() {
      scrollController.addListener(() {
        final position = scrollController.position;

        if (position.maxScrollExtent - position.pixels < screenHeight) {
          cubit.loadNextPage();
        }
      });
    }, [scrollController]);

    useEffect(() {
      cubit.initialize(true, service);
    }, [cubit]);

    return SessionListBuilder(cubit: cubit, state: state);
  }
}

class SessionListBuilder extends StatelessWidget {
  final SessionListViewCubit cubit;
  final SessionListViewState state;

  const SessionListBuilder({
    required this.cubit,
    required this.state,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return state.maybeMap(
      loading: (_) => const Loader(),
      idle: (state) => _Content(cubit: cubit, state: state),
      empty: (state) => _Empty(cubit: cubit, activeSessions: state.activeSessions),
      orElse: () => const SizedBox(),
    );
  }
}

class _Content extends StatelessWidget {
  final SessionListViewCubit cubit;
  final SessionListViewStateIdle state;

  const _Content({
    required this.cubit,
    required this.state,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => cubit.loadFirstPage(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => SessionRow(
                      key: ValueKey(state.sessions[index]),
                      session: state.sessions[index],
                      onExpandedChanged: (expanded) => cubit.changeExpanded(index, expanded),
                      onEndSession: () => cubit.endSession(state.sessions[index]),
                    ),
                    childCount: state.sessions.length,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (state.activeSessions) ...[
          CustomRectangularButton.outlined(
            text: tr(LocaleKeys.sessionListView_endAllSessions),
            onPressed: () {},
          ),
          const SizedBox(height: AppDimens.xl),
        ],
      ],
    );
  }
}

class _Empty extends HookWidget {
  final SessionListViewCubit cubit;
  final bool activeSessions;

  const _Empty({
    required this.cubit,
    required this.activeSessions,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return RefreshIndicator(
      onRefresh: () => cubit.loadFirstPage(),
      child: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: AppDimens.m),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (activeSessions)
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: typography.body1.copyWith(color: colors.secondaryText),
                    children: [
                      TextSpan(
                        text: tr(LocaleKeys.sessionListView_noActiveSessionsStart),
                      ),
                      WidgetSpan(
                        child: SvgPicture.asset(
                          AppIcon.history,
                          color: colors.secondaryText,
                        ),
                      ),
                      TextSpan(
                        text: tr(LocaleKeys.sessionListView_noActiveSessionsEnd),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  LocaleKeys.sessionListView_noHistoricalSessions,
                  style: typography.body1.copyWith(color: colors.secondaryText),
                  textAlign: TextAlign.center,
                ).tr(),
            ],
          ),
        ),
      ),
    );
  }
}
