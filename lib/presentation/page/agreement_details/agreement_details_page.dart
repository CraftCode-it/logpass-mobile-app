import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/service/data/service_agreement.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/agreement_details/agreement_details_page_cubit.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/session_date_formatter.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/labeled_text.dart';
import 'package:logpass_me/presentation/widget/pdf/pdf_list_view.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';

class AgreementDetailsPage extends HookWidget {
  final ServiceAgreement serviceAgreement;

  const AgreementDetailsPage({required this.serviceAgreement, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<AgreementDetailsPageCubit>();
    final state = useCubitBuilder(cubit);
    final typography = useAppTypography();

    useEffect(() {
      cubit.initialize(serviceAgreement);
    }, [cubit]);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: NavigationButton.back(),
        centerTitle: true,
        title: Text(
          LocaleKeys.agreementDetails_title,
          style: typography.h8,
        ).tr(),
      ),
      body: state.maybeMap(
        initializing: (_) => const Loader(),
        loadingPdf: (state) => _Content(document: null, agreement: state.agreement),
        idle: (state) => _Content(document: state.pdfDocument, agreement: state.agreement),
        processing: (state) => _Content(
          document: state.pdfDocument,
          agreement: state.agreement,
          processing: true,
        ),
        orElse: () => const SizedBox(),
      ),
    );
  }
}

class _Content extends HookWidget {
  final PdfDocument? document;
  final ServiceAgreement agreement;
  final bool processing;

  const _Content({
    required this.document,
    required this.agreement,
    this.processing = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final document = this.document;

    return Column(
      children: [
        Expanded(
          child: document == null ? const Loader() : PdfListView(document: document),
        ),
        Container(
          padding: const EdgeInsets.all(AppDimens.m),
          color: colors.secondaryBackground,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LabeledText(
                        label: tr(LocaleKeys.agreementDetails_type),
                        text: agreement.isRequired
                            ? tr(LocaleKeys.agreementDetails_typeRequired)
                            : tr(LocaleKeys.agreementDetails_typeOptional),
                      ),
                      LabeledText(
                        label: tr(LocaleKeys.agreementDetails_agreedOn),
                        text: agreement.isAccepted ? SessionDateFormatter.formatDateTime(agreement.updatedAt) : '-',
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.m),
                  if (agreement.isAccepted)
                    CustomRectangularButton.outlined(
                      text: tr(LocaleKeys.agreementDetails_revokeAction),
                      onPressed: () {},
                    )
                  else
                    CustomRectangularButton.filled(
                      text: tr(LocaleKeys.agreementDetails_confirmAction),
                      onPressed: () {},
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
