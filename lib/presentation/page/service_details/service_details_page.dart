import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/service_details/agreement_list/agreement_list_view.dart';
import 'package:logpass_me/presentation/page/service_details/service_details_page_cubit.dart';
import 'package:logpass_me/presentation/page/service_details/service_details_page_state.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/session_list_view.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceDetailsPage extends HookWidget {
  final Service service;

  const ServiceDetailsPage({
    required this.service,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ServiceDetailsPageCubit>();
    final state = useCubitBuilder(cubit);
    final tabController = useTabController(initialLength: 2);

    useEffect(() {
      cubit.initialize(service);
    }, [cubit]);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(LocaleKeys.serviceDetails_title).tr(),
        actions: [
          IconButton(
            onPressed: () => AutoRouter.of(context).push(HistoricalSessionListPageRoute(service: service)),
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: SafeArea(
        child: state.maybeMap(
          initializing: (_) => const Loader(),
          idle: (state) => _Content(
            cubit: cubit,
            state: state,
            tabController: tabController,
          ),
          endingAllSessions: (state) => _EndingSessionsContent(state: state),
          orElse: () => const SizedBox(),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final ServiceDetailsPageCubit cubit;
  final ServiceDetailsPageStateIdle state;
  final TabController tabController;

  const _Content({
    required this.cubit,
    required this.state,
    required this.tabController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimens.m),
              _ServiceHeader(service: state.service),
              const SizedBox(height: AppDimens.m),
              TabBar(
                controller: tabController,
                tabs: [
                  Tab(text: tr(LocaleKeys.serviceDetails_sessionsTab)),
                  Tab(text: tr(LocaleKeys.serviceDetails_agreementsTab)),
                ],
              )
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                child: SessionListViewKeepingState(service: state.service),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                child: AgreementListView(service: state.service),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EndingSessionsContent extends StatelessWidget {
  final ServiceDetailsPageStateEndingAllSessions state;

  const _EndingSessionsContent({
    required this.state,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.m),
          _ServiceHeader(service: state.service),
          const Expanded(
            child: Loader(),
          ),
        ],
      ),
    );
  }
}

class _ServiceHeader extends StatelessWidget {
  final Service service;

  const _ServiceHeader({
    required this.service,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await launch(service.url);
      },
      child: Container(
        height: 52,
        decoration: ShapeDecoration(
          shape: Border.all(
            color: Colors.grey,
          ),
        ),
        padding: const EdgeInsets.all(AppDimens.s),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(service.logo),
            const SizedBox(width: AppDimens.m),
            Text(service.name),
          ],
        ),
      ),
    );
  }
}
