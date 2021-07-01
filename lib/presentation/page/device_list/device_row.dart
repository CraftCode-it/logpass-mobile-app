import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/domain/device/device.dart';
import 'package:logpass_me/domain/model/device_type.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/trust_level_indicator.dart';

class DeviceRow extends HookWidget {
  final Device device;

  const DeviceRow({
    required this.device,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.l),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _PlatformIcon(deviceType: device.deviceType),
          const SizedBox(width: AppDimens.m),
          TrustLevelIndicator(trustLevel: device.trustLevel),
          const SizedBox(width: AppDimens.m),
          Expanded(
            child: Text(
              device.name,
              style: typography.body3,
            ),
          ),
          const SizedBox(width: AppDimens.l),
          IconButton(
            icon: SvgPicture.asset(
              AppIcon.more,
              color: colors.buttonFill,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _PlatformIcon extends HookWidget {
  final DeviceType deviceType;

  const _PlatformIcon({
    required this.deviceType,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();

    return SvgPicture.asset(
      _getIconPath(),
      color: colors.buttonFill,
    );
  }

  String _getIconPath() {
    switch (deviceType) {
      case DeviceType.mobile:
        return AppIcon.platformMobile;
      case DeviceType.pc:
        return AppIcon.platformPc;
      case DeviceType.tablet:
        return AppIcon.platformTablet;
      case DeviceType.unknown:
        return AppIcon.device;
    }
  }
}
