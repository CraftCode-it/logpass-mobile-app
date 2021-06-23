import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:url_launcher/url_launcher.dart';

const _serviceLogoSize = 40.0;

class ServiceHeader extends HookWidget {
  final String name;
  final String logoPath;
  final String serviceUrl;

  const ServiceHeader({
    required this.name,
    required this.logoPath,
    required this.serviceUrl,
  });

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return GestureDetector(
      onTap: () async {
        await launch(serviceUrl);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: AppDimens.xxl,
          bottom: AppDimens.xxl,
          left: AppDimens.l,
          right: AppDimens.l,
        ),
        color: colors.secondaryBackground,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              logoPath,
              width: _serviceLogoSize,
              height: _serviceLogoSize,
            ),
            const SizedBox(width: AppDimens.m),
            Expanded(
              child: Text(
                name,
                style: typography.h2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
