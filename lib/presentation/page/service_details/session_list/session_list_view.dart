import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/session_list_view_cubit.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/session_list_view_state.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/session_row.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';

class SessionListViewKeepingState extends StatefulWidget {
  final Service service;

  const SessionListViewKeepingState({required this.service, Key? key}) : super(key: key);

  @override
  _SessionListViewKeepingStateState createState() => _SessionListViewKeepingStateState();
}

class _SessionListViewKeepingStateState extends State<SessionListViewKeepingState> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SessionListView(service: widget.service);
  }

  @override
  bool get wantKeepAlive => true;
}

class SessionListView extends HookWidget {
  final Service service;

  const SessionListView({
    required this.service,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SessionListViewCubit>();
    final state = useCubitBuilder(cubit);

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
      empty: (_) => _Empty(cubit: cubit),
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
                    ),
                    childCount: state.sessions.length,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (state.activeSessions) ...[
          RoundedButton(
            text: 'End all sessions',
            onPressed: () {},
          ),
          const SizedBox(height: AppDimens.xxxl),
        ],
      ],
    );
  }
}

class _Empty extends StatelessWidget {
  final SessionListViewCubit cubit;

  const _Empty({
    required this.cubit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => cubit.loadFirstPage(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: AppDimens.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Text('You have no active sessions for this service.'),
            SizedBox(height: AppDimens.s),
            Text('Go to :ICON: to preview past ones.'),
          ],
        ),
      ),
    );
  }
}
