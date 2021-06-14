import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:logpass_me/domain/service/data/service_agreement.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/session_date_formatter.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/widget/separator.dart';

class AgreementRow extends StatelessWidget {
  final ServiceAgreement agreement;

  const AgreementRow({required this.agreement, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            agreement.isRequired ? tr(LocaleKeys.agreementRow_required) : tr(LocaleKeys.agreementRow_optional),
          ),
          const SizedBox(height: AppDimens.s),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.check_circle),
              const SizedBox(width: AppDimens.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      agreement.name,
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (agreement.isAccepted) ...[
                      const SizedBox(height: AppDimens.s),
                      const Text(
                        LocaleKeys.agreementRow_agreedOn,
                        style: TextStyle(fontSize: 12),
                      ).tr(
                        args: [
                          SessionDateFormatter.formatDateTime(agreement.createdAt),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
          const SizedBox(height: AppDimens.s),
          Separator.light(),
        ],
      ),
    );
  }
}
