import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/service_details/agreement_list/agreement_row.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';

class AgreementListView extends StatelessWidget {
  final Service service;

  const AgreementListView({required this.service, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(top: AppDimens.m),
            itemBuilder: (context, index) => AgreementRow(agreement: service.agreements[index]),
            separatorBuilder: (context, index) => const SizedBox(height: AppDimens.m),
            itemCount: service.agreements.length,
          ),
        ),
        if (service.agreements.isNotEmpty) ...[
          CustomRectangularButton.outlined(
            text: tr(LocaleKeys.agreementList_revokeAllAction),
            onPressed: () {},
          ),
        ],
      ],
    );
  }
}
