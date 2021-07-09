import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/domain/device/device.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/presentation/page/authorize/trust_level_confirmation/trust_level_confirmation_page_cubit.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:logpass_me/presentation/widget/service_header.dart';
import 'package:logpass_me/presentation/widget/trust_level_indicator.dart';
import 'package:logpass_me/presentation/utils/device_utils.dart';

const _trustIndicatorSize = 40.0;
const _trustIndicatorFontSize = 16.0;

class TrustLevelConfirmationPage extends HookWidget {
  final Service service;
  final int initialTrustLevel;
  final int requiredTrustLevel;
  final Function(int) onPagePop;

  const TrustLevelConfirmationPage({
    required this.service,
    required this.initialTrustLevel,
    required this.requiredTrustLevel,
    required this.onPagePop,
  });

  void _callOnPagePop(TrustLevelConfirmationPageState state) {
    final reachedTrustLevel = state.maybeMap(
      idle: (state) => state.currentTrustLevel,
      orElse: () {},
    );
    if (reachedTrustLevel != null) onPagePop.call(reachedTrustLevel);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<TrustLevelConfirmationPageCubit>();
    final state = useCubitBuilder(cubit);
    final colors = useAppThemeColors();
    final messnegerController = useMessengerController();

    useEffect(() {
      cubit.init(initialTrustLevel, requiredTrustLevel);
    }, [cubit]);

    return WillPopScope(
      onWillPop: () {
        _callOnPagePop(state);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: CustomAppBar.smallTitle(
          title: LocaleKeys.trustLevelConfirmation_title.tr(),
          leading: NavigationButton.back(
            customAction: () {
              _callOnPagePop(state);
              AutoRouter.of(context).pop();
            },
          ),
        ),
        body: SafeArea(
          child: Messenger(
            controller: messnegerController,
            child: _Content(
              state: state,
              service: service,
            ),
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final TrustLevelConfirmationPageState state;
  final Service service;

  const _Content({
    required this.state,
    required this.service,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ServiceHeader(
          name: service.name,
          logoPath: service.logo,
          serviceUrl: service.url,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            child: state.maybeMap(
              idle: (state) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppDimens.l),
                  _TrustLevelInformation(state.currentTrustLevel),
                  const SizedBox(height: AppDimens.xc),
                  Expanded(
                    child: _DevicesList(
                      availableDevices: state.availableDevices,
                      unavailableDevices: state.unavailableDevices,
                    ),
                  ),
                ],
              ),
              loading: (_) => const Loader(),
              orElse: () {},
            ),
          ),
        ),
      ],
    );
  }
}

class _TrustLevelInformation extends HookWidget {
  final int currentTrustLevel;

  const _TrustLevelInformation(this.currentTrustLevel);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return Column(
      children: [
        Text(
          LocaleKeys.trustLevelConfirmation_requiresHigherLevel.tr(),
          textAlign: TextAlign.center,
          style: typography.h8,
        ),
        const SizedBox(height: AppDimens.l),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LocaleKeys.trustLevelConfirmation_currentLevel.tr(),
              style: typography.body2,
            ),
            const SizedBox(width: AppDimens.m),
            TrustLevelIndicator(
              trustLevel: currentTrustLevel,
              indicatorSize: _trustIndicatorSize,
              fontSize: _trustIndicatorFontSize,
            ),
          ],
        )
      ],
    );
  }
}

class _DevicesList extends HookWidget {
  final List<Device> availableDevices;
  final List<Device> unavailableDevices;

  const _DevicesList({
    required this.availableDevices,
    required this.unavailableDevices,
  });

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return Column(
      children: [
        Text(
          LocaleKeys.trustLevelConfirmation_confirmOnDevices.tr(),
          textAlign: TextAlign.center,
          style: typography.body2,
        ),
        const SizedBox(height: AppDimens.m),
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _DeviceRow(device: availableDevices[index], isAvailable: true),
                  childCount: availableDevices.length,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: AppDimens.xl),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _DeviceRow(device: unavailableDevices[index], isAvailable: false),
                    childCount: unavailableDevices.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DeviceRow extends HookWidget {
  final bool isAvailable;
  final Device device;

  const _DeviceRow({
    required this.device,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    return InkWell(
      onTap: isAvailable ? () {} : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.l),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colors.dividerLight,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: AppDimens.m),
            SvgPicture.asset(
              device.getIconPath(),
              color: colors.buttonFill,
            ),
            const SizedBox(width: AppDimens.m),
            Expanded(
              child: Text(
                device.name,
                style: typography.body3.copyWith(color: isAvailable ? colors.text : colors.labelText),
              ),
            ),
            const SizedBox(width: AppDimens.m),
            TrustLevelIndicator(
              trustLevel: device.trustLevel,
              borderColor: isAvailable ? colors.text : colors.labelText,
            ),
          ],
        ),
      ),
    );
  }
}
