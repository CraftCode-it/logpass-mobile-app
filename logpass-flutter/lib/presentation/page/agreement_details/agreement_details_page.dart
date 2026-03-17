import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/service/data/service_agreement.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/agreement_details/agreement_details_page_cubit.dart';
import 'package:logpass_me/presentation/page/agreement_details/agreement_details_page_state.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/session_date_formatter.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/error_snackbar.dart';
import 'package:logpass_me/presentation/widget/labeled_text.dart';
import 'package:logpass_me/presentation/widget/logpass_dialog.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class AgreementDetailsPage extends HookWidget {
  final ServiceAgreement serviceAgreement;

  const AgreementDetailsPage({required this.serviceAgreement, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<AgreementDetailsPageCubit>();
    final state = useCubitBuilder(cubit);
    final messengerController = useMessengerController();

    useCubitListener<AgreementDetailsPageCubit, AgreementDetailsPageState>(
      cubit,
      (cubit, state, context) => _listener(cubit, state, context, messengerController),
    );

    useEffect(() {
      cubit.initialize(serviceAgreement);
    }, [cubit]);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar.smallTitle(
        title: LocaleKeys.agreementDetails_title.tr(),
        leading: NavigationButton.back(),
      ),
      body: state.maybeMap(
        initializing: (_) => const Loader(),
        loadingPdf: (state) => _Content(
          controller: null,
          agreement: state.agreement,
          cubit: cubit,
          messengerController: messengerController,
        ),
        idle: (state) => _Content(
          controller: state.pdfController,
          agreement: state.agreement,
          cubit: cubit,
          messengerController: messengerController,
        ),
        processing: (state) => _Content(
          controller: state.pdfController,
          agreement: state.agreement,
          processing: true,
          cubit: cubit,
          messengerController: messengerController,
        ),
        orElse: () => const SizedBox(),
      ),
    );
  }

  void _listener(
    AgreementDetailsPageCubit cubit,
    AgreementDetailsPageState state,
    BuildContext context,
    MessengerController controller,
  ) {
    state.maybeMap(
      connectionError: (state) => controller.showError(
        getConnectionErrorString(state.error),
      ),
      confirmed: (_) => controller.showInfo(
        LocaleKeys.agreementDetails_agreementConfirmed.tr(),
      ),
      revoked: (_) => controller.showInfo(
        LocaleKeys.agreementDetails_agreementRevoked.tr(),
      ),
      orElse: () {},
    );
  }
}

class _Content extends HookWidget {
  final PdfController? controller;
  final ServiceAgreement agreement;
  final MessengerController messengerController;
  final bool processing;
  final AgreementDetailsPageCubit cubit;

  const _Content({
    required this.controller,
    required this.agreement,
    required this.cubit,
    required this.messengerController,
    this.processing = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final controller = this.controller;

    return Column(
      children: [
        Expanded(
          child: Messenger(
            floating: true,
            controller: messengerController,
            child: controller == null
                ? const Loader()
                : PdfView(
                    controller: controller,
                    documentLoader: const Loader(),
                    scrollDirection: Axis.vertical,
                  ),
          ),
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
                  if (processing)
                    const Loader()
                  else if (agreement.isAccepted)
                    CustomRectangularButton.outlined(
                      text: tr(LocaleKeys.agreementDetails_revokeAction),
                      onPressed: () => _revokeAgreement(context),
                      fillColor: colors.secondaryBackground,
                    )
                  else
                    CustomRectangularButton.filled(
                      text: tr(LocaleKeys.agreementDetails_confirmAction),
                      onPressed: cubit.confirmAgreement,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _revokeAgreement(BuildContext context) async {
    if (agreement.isRequired) {
      final revokeAccepted = await showTwoOptionsDialog(
        context,
        LocaleKeys.agreementDetails_revokeAgreementDialogTitle.tr(),
        LocaleKeys.agreementDetails_revokeAgreementDialogContent.tr(),
        LocaleKeys.agreementDetails_revokeAgreementDialogTopAction.tr(),
        LocaleKeys.agreementDetails_revokeAgreementDialogBottomAction.tr(),
      );
      if (revokeAccepted) {
        await cubit.revokeAgreement();
      }
    } else {
      await cubit.revokeAgreement();
    }
  }
}
