import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/service/data/service_with_tokens.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/service_list/service_list_page_cubit.dart';
import 'package:logpass_me/presentation/page/service_list/service_list_page_state.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/error_snackbar.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:logpass_me/presentation/widget/separator.dart';

class ServiceListPage extends HookWidget {
  const ServiceListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ServiceListPageCubit>();
    final state = useCubitBuilder(cubit);
    final colors = useAppThemeColors();
    final scrollController = useScrollController();
    final messengerController = useMessengerController();

    final screenHeight = MediaQuery.of(context).size.height;

    useCubitListener<ServiceListPageCubit, ServiceListPageState>(
      cubit,
      (cubit, state, context) => _listener(cubit, state, context, messengerController),
    );

    useEffect(() {
      scrollController.addListener(() {
        final position = scrollController.position;

        if (position.maxScrollExtent - position.pixels < screenHeight) {
          cubit.loadNextPage();
        }
      });
    }, [scrollController]);

    useEffect(() {
      cubit.initialize();
    }, [cubit]);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.bigTitle(
        title: LocaleKeys.serviceList_title.tr(),
      ),
      body: Messenger(
        controller: messengerController,
        child: _Content(
          cubit: cubit,
          state: state,
          scrollController: scrollController,
        ),
      ),
    );
  }

  void _listener(
    ServiceListPageCubit cubit,
    ServiceListPageState state,
    BuildContext context,
    MessengerController controller,
  ) {
    state.maybeMap(
      connectionError: (state) => controller.showError(
        getConnectionErrorString(state.error),
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
      empty: (_) => _ContentEmpty(cubit: cubit),
      loading: (_) => const Loader(),
      orElse: () => const SizedBox(),
    );
  }
}

class _ContentEmpty extends HookWidget {
  final ServiceListPageCubit cubit;

  const _ContentEmpty({required this.cubit, Key? key}) : super(key: key);

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
              LocaleKeys.serviceList_noServices,
              textAlign: TextAlign.center,
              style: typography.body1.copyWith(color: colors.secondaryText),
            ).tr(),
          ),
        ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: RefreshIndicator(
        onRefresh: () => cubit.loadFirstPage(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverPadding(
              padding: EdgeInsets.only(top: AppDimens.l),
            ),
            if (state.activeServices.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: _ServicesHeader(text: tr(LocaleKeys.serviceList_activeHeader)),
              ),
              _ServiceList(services: state.activeServices, active: true),
            ],
            if (state.otherServices.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: _ServicesHeader(text: tr(LocaleKeys.serviceList_otherHeader)),
              ),
              _ServiceList(services: state.otherServices, active: false),
            ],
            if (state.loadingMore)
              const SliverPadding(
                padding: EdgeInsets.symmetric(vertical: AppDimens.m),
                sliver: SliverToBoxAdapter(
                  child: Loader(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ServiceList extends StatelessWidget {
  final List<ServiceWithTokens> services;
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

class _ServicesHeader extends HookWidget {
  final String text;

  const _ServicesHeader({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return Text(
      text,
      textAlign: TextAlign.center,
      style: typography.h8,
    );
  }
}

class _ServiceRow extends HookWidget {
  final ServiceWithTokens service;
  final bool active;

  const _ServiceRow({
    required this.service,
    required this.active,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            AutoRouter.of(context).push(ServiceDetailsPageRoute(service: service.service));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDimens.m),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  service.service.logo,
                  width: AppDimens.serviceImageIconSize,
                  height: AppDimens.serviceImageIconSize,
                ),
                const SizedBox(width: AppDimens.l),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        service.service.name,
                        style: typography.body3,
                      ),
                      if (active) ...[
                        const SizedBox(height: AppDimens.xs),
                        Text(
                          LocaleKeys.serviceList_session,
                          style: typography.info2.copyWith(color: AppColors.success100),
                        ).plural(service.tokens.activeCount),
                      ],
                    ],
                  ),
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
