import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/presentation/page/session_list/service_list_page_cubit.dart';
import 'package:logpass_me/presentation/page/session_list/service_list_page_state.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/error_snackbar.dart';
import 'package:logpass_me/presentation/widget/separator.dart';

class ServiceListPage extends HookWidget {
  const ServiceListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ServiceListPageCubit>();
    final state = useCubitBuilder(cubit);
    final color = useAppThemeColors();
    final typography = useAppTypography();
    final scrollController = useScrollController();

    useCubitListener<ServiceListPageCubit, ServiceListPageState>(
      cubit,
      (cubit, state, context) => _listener(cubit, state, context, color, typography),
    );

    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.offset > scrollController.position.maxScrollExtent - 250) {
          cubit.loadNextPage();
        }
      });
    }, [scrollController]);

    useEffect(() {
      cubit.loadFirstPage();
    }, [cubit]);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Services'),
      ),
      body: _Content(
        cubit: cubit,
        state: state,
        scrollController: scrollController,
      ),
    );
  }

  void _listener(
    ServiceListPageCubit cubit,
    ServiceListPageState state,
    BuildContext context,
    AppThemeColors colors,
    AppTypography typography,
  ) {
    state.maybeMap(
      connectionError: (state) => showConnectionErrorSnackBar(
        error: state.error,
        context: context,
        colors: colors,
        typography: typography,
      ),
      orElse: () {},
    );
  }
}

class _Content extends StatelessWidget {
  final ServiceListPageCubit cubit;
  final ServiceListPageState state;
  final ScrollController scrollController;

  const _Content({
    required this.cubit,
    required this.state,
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return state.maybeMap(
      idle: (state) => _ContentList(
        cubit: cubit,
        state: state,
        scrollController: scrollController,
      ),
      empty: (_) => const _ContentEmpty(),
      loading: (_) => const Loader(),
      orElse: () => const SizedBox(),
    );
  }
}

class _ContentEmpty extends StatelessWidget {
  const _ContentEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'You have no connected services.',
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ContentList extends StatelessWidget {
  final ServiceListPageCubit cubit;
  final ServiceListPageStateIdle state;
  final ScrollController scrollController;

  const _ContentList({
    required this.cubit,
    required this.state,
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if (state.activeServices.isNotEmpty) ...[
          const _ServicesHeader(text: 'With active sessions'),
          _ServiceList(services: state.activeServices, active: true),
        ],
        if (state.otherServices.isNotEmpty) ...[
          const _ServicesHeader(text: 'Other services'),
          _ServiceList(services: state.otherServices, active: false),
        ],
        if (state.loadingMore) const SliverToBoxAdapter(child: Loader()),
      ],
    );
  }
}

class _ServiceList extends StatelessWidget {
  final List<Service> services;
  final bool active;

  const _ServiceList({
    required this.services,
    required this.active,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _ServiceRow(
          service: services[index],
          active: active,
        ),
        childCount: services.length,
      ),
    );
  }
}

class _ServicesHeader extends StatelessWidget {
  final String text;

  const _ServicesHeader({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Separator.dark(),
        Text(text),
      ],
    );
  }
}

class _ServiceRow extends StatelessWidget {
  final Service service;
  final bool active;

  const _ServiceRow({
    required this.service,
    required this.active,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDimens.m),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(service.logo),
                Expanded(
                  child: Text(service.name),
                ),
                if (active)
                  Text(
                    '${service.tokens.activeCount} sessions',
                    style: const TextStyle(fontSize: 12),
                  ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
        Separator.light(),
      ],
    );
  }
}
