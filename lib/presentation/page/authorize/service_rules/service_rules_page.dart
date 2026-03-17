import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/domain/service/data/service_agreement.dart';
import 'package:logpass_me/presentation/page/authorize/service_rules/service_rules_page_cubit.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/custom_checkbox.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';
import 'package:logpass_me/presentation/widget/service_header.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';

const _arrowIconSize = 24.0;

@RoutePage()
class ServiceRulesPage extends HookWidget {
  final Service service;
  final List<ServiceAgreement> agreements;
  final Function(List<ServiceAgreement>) onPagePop;

  const ServiceRulesPage({
    required this.agreements,
    required this.service,
    required this.onPagePop,
  });

  void _callOnPagePop(ServiceRulesPageState state) {
    final agreements = state.maybeMap(
      idle: (state) => [...state.requiredAgreements, ...state.optionalAgreements],
      orElse: () {},
    );
    if (agreements != null) onPagePop.call(agreements);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ServiceRulesPageCubit>();
    final state = useCubitBuilder(cubit);
    final colors = useAppThemeColors();

    useEffect(() {
      cubit.init(agreements);
    }, [cubit]);

    return WillPopScope(
      onWillPop: () {
        _callOnPagePop(state);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: CustomAppBar.smallTitle(
          title: LocaleKeys.authorize_serviceRulesTitle.tr(),
          leading: NavigationButton.back(
            customAction: () {
              _callOnPagePop(state);
              AutoRouter.of(context).pop();
            },
          ),
        ),
        body: state.maybeWhen(
          idle: (
            requiredAgreements,
            optionalAgreements,
            allAccepted,
          ) =>
              _Content(
            requiredAgreements,
            optionalAgreements,
            service,
            onAcceptanceChanged: cubit.updateAgreements,
            allAgreementsAccepted: allAccepted,
            acceptAllAgreements: cubit.acceptAllAgreements,
          ),
          loading: () => const Loader(),
          orElse: () => const SizedBox(),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final List<ServiceAgreement> requiredAgreements;
  final List<ServiceAgreement> optionalAgreements;
  final Service service;
  final Function(ServiceAgreement, bool) onAcceptanceChanged;
  final bool allAgreementsAccepted;
  final VoidCallback acceptAllAgreements;

  const _Content(
    this.requiredAgreements,
    this.optionalAgreements,
    this.service, {
    required this.onAcceptanceChanged,
    required this.allAgreementsAccepted,
    required this.acceptAllAgreements,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          ServiceHeader(
            name: service.name,
            logoPath: service.logo,
            serviceUrl: service.url,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: AppDimens.l,
                left: AppDimens.l,
                right: AppDimens.l,
                bottom: AppDimens.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      child: CustomScrollView(
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return _AgreementCheckboxRow(
                                  requiredAgreements[index],
                                  onAcceptanceChanged,
                                );
                              },
                              childCount: requiredAgreements.length,
                            ),
                          ),
                          const SliverToBoxAdapter(child: SizedBox(height: AppDimens.xc)),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return _AgreementCheckboxRow(
                                  optionalAgreements[index],
                                  onAcceptanceChanged,
                                );
                              },
                              childCount: optionalAgreements.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!allAgreementsAccepted) ...[
                    const SizedBox(height: AppDimens.l),
                    CustomRectangularButton.filled(
                      text: LocaleKeys.authorize_acceptAllRules.tr(),
                      onPressed: acceptAllAgreements,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AgreementCheckboxRow extends HookWidget {
  final ServiceAgreement agreement;
  final Function(ServiceAgreement, bool) onAcceptanceChanged;

  const _AgreementCheckboxRow(
    this.agreement,
    this.onAcceptanceChanged,
  );

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    return InkWell(
      onTap: () => AutoRouter.of(context).push(AgreementContentPreviewPageRoute(serviceAgreement: agreement)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.m),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colors.dividerLight,
            ),
          ),
        ),
        child: Row(
          children: [
            CustomCheckbox(
              onValueChanged: (value) => onAcceptanceChanged(agreement, value),
              initialValue: agreement.isAccepted,
            ),
            const SizedBox(width: AppDimens.l),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildAgreementTitle(typography),
                  ),
                  SvgPicture.asset(
                    AppIcon.chevronRight,
                    colorFilter: ColorFilter.mode(colors.text, BlendMode.srcIn),
                    width: _arrowIconSize,
                    height: _arrowIconSize,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgreementTitle(AppTypography typography) {
    return Row(
      children: [
        if (agreement.isRequired)
          Text(
            '* ',
            style: typography.body3.copyWith(color: AppColors.requiredElementColor),
          ),
        Expanded(
          child: Text(
            agreement.name,
            style: typography.body3,
          ),
        ),
      ],
    );
  }
}
