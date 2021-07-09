import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/domain/device/device.dart';
import 'package:logpass_me/domain/model/device_type.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/separator.dart';
import 'package:logpass_me/presentation/widget/trust_level_indicator.dart';

class DeviceRow extends HookWidget {
  final Device device;
  final Function() onMorePressed;

  const DeviceRow({
    required this.device,
    required this.onMorePressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimens.l),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                device.getIconPath(),
                color: colors.buttonFill,
              ),
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
                onPressed: onMorePressed,
              ),
            ],
          ),
        ),
        Separator.light(),
      ],
    );
  }
}
