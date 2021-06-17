import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/domain/service/data/service_agreement.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/session_date_formatter.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

class AgreementRow extends HookWidget {
  final ServiceAgreement agreement;

  const AgreementRow({required this.agreement, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    return InkWell(
      onTap: () => AutoRouter.of(context).push(AgreementDetailsPageRoute(serviceAgreement: agreement)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(agreement.isAccepted ? AppIcon.checkSuccess : AppIcon.checkError),
              const SizedBox(width: AppDimens.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      agreement.isRequired
                          ? tr(LocaleKeys.agreementRow_required)
                          : tr(LocaleKeys.agreementRow_optional),
                      style: typography.info2.copyWith(color: colors.secondaryText),
                    ),
                    const SizedBox(height: AppDimens.xs),
                    Text(
                      agreement.name,
                      style: typography.body3,
                    ),
                    if (agreement.isAccepted) ...[
                      const SizedBox(height: AppDimens.xs),
                      Text(
                        LocaleKeys.agreementRow_agreedOn,
                        style: typography.info2.copyWith(color: colors.secondaryText),
                      ).tr(
                        args: [
                          SessionDateFormatter.formatDateTime(agreement.updatedAt),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              SvgPicture.asset(
                AppIcon.chevronRight,
                color: colors.buttonFill,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
