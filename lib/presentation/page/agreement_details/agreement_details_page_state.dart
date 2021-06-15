import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/service/data/service_agreement.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';

part 'agreement_details_page_state.freezed.dart';

@freezed
class AgreementDetailsPageState with _$AgreementDetailsPageState {
  @Implements(BuildState)
  factory AgreementDetailsPageState.initializing() = _AgreementDetailsPageStateInitializing;

  @Implements(BuildState)
  factory AgreementDetailsPageState.loadingPdf(ServiceAgreement agreement) = _AgreementDetailsPageStateLoadingPdf;

  @Implements(BuildState)
  factory AgreementDetailsPageState.idle(PdfDocument? pdfDocument, ServiceAgreement agreement) =
      _AgreementDetailsPageStateIdle;

  @Implements(BuildState)
  factory AgreementDetailsPageState.processing(PdfDocument? pdfDocument, ServiceAgreement agreement) =
      _AgreementDetailsPageStateProcessing;

  factory AgreementDetailsPageState.connectionError(GeneralConnectionError error) =
      _AgreementDetailsPageStateConnectionError;
}
