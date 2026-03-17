import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/custom_scaffold.dart';

const _indicatorSize = 40.0;

class TrustLevelPage extends HookWidget {
  const TrustLevelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return CustomScaffold(
      appBar: CustomAppBar.smallTitle(
        leading: NavigationButton.back(),
        title: LocaleKeys.trustLevel_title.tr(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.m, horizontal: AppDimens.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              LocaleKeys.trustLevel_header.tr(),
              style: typography.h6,
            ),
            const SizedBox(height: AppDimens.l),
            Text(
              LocaleKeys.trustLevel_content.tr(),
              style: typography.body1,
            ),
            const SizedBox(height: AppDimens.xxl),
            _Level(level: 1, info: LocaleKeys.trustLevel_levelDescription_1.tr()),
            const SizedBox(height: AppDimens.l),
            _Level(level: 2, info: LocaleKeys.trustLevel_levelDescription_2.tr()),
            const SizedBox(height: AppDimens.l),
            _Level(level: 3, info: LocaleKeys.trustLevel_levelDescription_3.tr()),
          ],
        ),
      ),
      onErrorActionTapped: () {},
    );
  }
}

class _Level extends HookWidget {
  final int level;
  final String info;

  const _Level({
    required this.level,
    required this.info,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: _indicatorSize,
          height: _indicatorSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: colors.buttonFill,
            ),
          ),
          child: Center(
            child: Text(
              level.toString(),
              style: typography.h9,
            ),
          ),
        ),
        const SizedBox(width: AppDimens.xl),
        Flexible(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: LocaleKeys.trustLevel_level.tr(args: [level.toString()]), style: typography.body3),
                TextSpan(text: ' - ', style: typography.body1),
                TextSpan(text: info, style: typography.body1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
