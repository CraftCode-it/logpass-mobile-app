import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/presentation/page/service_details/service_details_page_cubit.dart';
import 'package:logpass_me/presentation/page/service_details/service_details_page_state.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';
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
        title: Text('Service details'),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.m),
          _ServiceHeader(service: state.service),
          TabBar(
            controller: tabController,
            tabs: [],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [],
            ),
          ),
          RoundedButton(
            text: 'End all sessions',
            onPressed: () => cubit.endAllSessions(),
          ),
          const SizedBox(height: AppDimens.xxxl),
        ],
      ),
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
