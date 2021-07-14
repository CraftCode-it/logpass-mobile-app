import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/service_details/agreement_list/agreement_list_view.dart';
import 'package:logpass_me/presentation/page/service_details/service_details_page_cubit.dart';
import 'package:logpass_me/presentation/page/service_details/service_details_page_state.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/session_list_view.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:logpass_me/presentation/widget/service_header.dart';
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
    final colors = useAppThemeColors();
    final messengerController = useMessengerController();

    useEffect(() {
      cubit.initialize(service);
    }, [cubit]);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.smallTitle(
        title: LocaleKeys.serviceDetails_title.tr(),
        leading: NavigationButton.back(),
        trailing: IconButton(
          onPressed: () => AutoRouter.of(context).push(HistoricalSessionListPageRoute(service: service)),
          icon: SvgPicture.asset(
            AppIcon.history,
            color: colors.buttonFill,
          ),
        ),
      ).copyWith(
        predefinedBackground: colors.secondaryBackground,
      ),
      body: SafeArea(
        child: state.maybeMap(
          initializing: (_) => const Loader(),
          idle: (state) => _Content(
            cubit: cubit,
            state: state,
            tabController: tabController,
            messengerController: messengerController,
          ),
          processing: (state) => _ProcessingContent(state: state),
          orElse: () => const SizedBox(),
        ),
      ),
    );
  }
}

class _Content extends HookWidget {
  final ServiceDetailsPageCubit cubit;
  final ServiceDetailsPageStateIdle state;
  final TabController tabController;
  final MessengerController messengerController;

  const _Content({
    required this.cubit,
    required this.state,
    required this.tabController,
    required this.messengerController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tabSize = (screenWidth - AppDimens.l * 2) / 2;
    final tabIndicatorPadding = (tabSize - AppDimens.tabBarIndicatorSize) / 2;
    final colors = useAppThemeColors();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ServiceHeader(
              name: state.service.name,
              logoPath: state.service.logo,
              serviceUrl: state.service.url,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: AppDimens.xxl,
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: AppDimens.tabBarUnderlineWeight,
                    color: colors.tabBarUnderline,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                    child: TabBar(
                      controller: tabController,
                      indicator: UnderlineTabIndicator(
                        borderSide: const BorderSide(
                          width: AppDimens.tabBarIndicatorWeight,
                          color: AppColors.success100,
                        ),
                        insets: EdgeInsets.symmetric(horizontal: tabIndicatorPadding),
                      ),
                      tabs: [
                        Tab(
                          text: tr(LocaleKeys.serviceDetails_sessionsTab),
                        ),
                        Tab(
                          text: tr(LocaleKeys.serviceDetails_agreementsTab),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                child: SessionListViewKeepingState(
                  service: state.service,
                  messengerController: messengerController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                child: AgreementListView(
                  service: state.service,
                  onBackFromDetails: () {
                    cubit.refreshServiceData();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProcessingContent extends StatelessWidget {
  final ServiceDetailsPageStateProcessing state;

  const _ProcessingContent({
    required this.state,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ServiceHeader(
          name: state.service.name,
          logoPath: state.service.logo,
          serviceUrl: state.service.url,
        ),
        const Expanded(
          child: Loader(),
        ),
      ],
    );
  }
}
