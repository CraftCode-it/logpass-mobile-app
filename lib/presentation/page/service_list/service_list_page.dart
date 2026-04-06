import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/activity/service_activity.dart';
import 'package:logpass_me/domain/service/data/service_with_tokens.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/service_list/service_list_page_cubit.dart';
import 'package:logpass_me/presentation/page/service_list/service_list_page_state.dart';
import 'package:logpass_me/presentation/routing/main_router.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/error_snackbar.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:logpass_me/presentation/widget/need_help_button.dart';
import 'package:logpass_me/presentation/widget/separator.dart';

@RoutePage()
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
      void onScroll() {
        final position = scrollController.position;
        if (position.maxScrollExtent - position.pixels < screenHeight) {
          cubit.loadNextPage();
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController, cubit]);

    useEffect(() {
      cubit.initialize();
    }, [cubit]);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.bigTitle(
        title: LocaleKeys.serviceList_title.tr(),
        trailing: const NeedHelpButton(),
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
            const SliverPadding(padding: EdgeInsets.only(top: AppDimens.m)),
            SliverToBoxAdapter(
              child: _ServicesHeader(text: tr(LocaleKeys.serviceList_activeHeader)),
            ),
            const SliverPadding(padding: EdgeInsets.only(top: AppDimens.l)),
            _ServiceList(services: state.activeServices, active: true),
            const SliverPadding(padding: EdgeInsets.only(top: AppDimens.xxl)),
            if (state.otherServices.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: _ServicesHeader(text: tr(LocaleKeys.serviceList_otherHeader)),
              ),
              const SliverPadding(padding: EdgeInsets.only(top: AppDimens.l)),
              _ServiceList(services: state.otherServices, active: false),
            ],
            if (state.loadingMore)
              const SliverPadding(
                padding: EdgeInsets.symmetric(vertical: AppDimens.m),
                sliver: SliverToBoxAdapter(
                  child: Loader(),
                ),
              ),
            const SliverPadding(padding: EdgeInsets.only(top: AppDimens.xxl)),
            SliverToBoxAdapter(
              child: _ActivityServicesSection(cubit: cubit),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceList extends HookWidget {
  final List<ServiceWithTokens> services;
  final bool active;

  const _ServiceList({
    required this.services,
    required this.active,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return services.isNotEmpty
        ? SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _ServiceRow(
                service: services[index],
                active: active,
              ),
              childCount: services.length,
            ),
          )
        : SliverToBoxAdapter(
            child: Text(
              tr(LocaleKeys.serviceList_noActiveSessions),
              style: typography.body1.copyWith(color: colors.secondaryText),
            ).tr(),
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

class _ActivityServicesSection extends HookWidget {
  final ServiceListPageCubit cubit;

  const _ActivityServicesSection({required this.cubit, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();
    final services = useState<List<ServiceSummary>>([]);
    final isLoading = useState(true);

    useEffect(() {
      cubit.loadActivityServices().then((result) {
        services.value = result;
        isLoading.value = false;
      }).catchError((_) {
        isLoading.value = false;
      });
      return null;
    }, [cubit]);

    if (isLoading.value) {
      return const Padding(
        padding: EdgeInsets.all(AppDimens.m),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (services.value.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: Text(
            LocaleKeys.serviceList_activitySectionHeader.tr(),
            style: typography.h8,
          ),
        ),
        const SizedBox(height: AppDimens.m),
        ...services.value.map(
          (s) => _ActivityServiceRow(summary: s, colors: colors, typography: typography),
        ),
        const SizedBox(height: AppDimens.xxl),
      ],
    );
  }
}

class _ActivityServiceRow extends StatelessWidget {
  final ServiceSummary summary;
  final AppThemeColors colors;
  final AppTypography typography;

  const _ActivityServiceRow({
    required this.summary,
    required this.colors,
    required this.typography,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final initials = summary.serviceName.isNotEmpty
        ? summary.serviceName[0].toUpperCase()
        : '?';

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.l,
        vertical: AppDimens.xs,
      ),
      padding: const EdgeInsets.all(AppDimens.m),
      decoration: BoxDecoration(
        border: Border.all(color: colors.dividerMedium),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: colors.buttonFill,
            child: Text(
              initials,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colors.buttonFilledText,
              ),
            ),
          ),
          const SizedBox(width: AppDimens.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(summary.serviceName, style: typography.body3),
                const SizedBox(height: 2),
                Text(
                  LocaleKeys.serviceList_activitySummary.tr(
                    namedArgs: {
                      'count': summary.actionCount.toString(),
                      'date': _formatDate(summary.lastActivity),
                    },
                  ),
                  style: typography.info2.copyWith(color: colors.secondaryText),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: colors.buttonFill.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Weryfikacja',
                    style: typography.input.copyWith(color: colors.buttonFill),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: colors.secondaryText),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
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
            AutoRouter.of(context).push(ServiceDetailsRoute(service: service.service));
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
