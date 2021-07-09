part of 'agreement_content_preview_page_cubit.dart';

@freezed
class AgreementContentPreviewPageState with _$AgreementContentPreviewPageState {
  @Implements(BuildState)
  const factory AgreementContentPreviewPageState.loading() = _AgreementContentPreviewPageStateLoading;

  @Implements(BuildState)
  const factory AgreementContentPreviewPageState.idle(PdfController pdfDocument) = _AgreementContentPreviewPageStateIdle;

  @Implements(BuildState)
  const factory AgreementContentPreviewPageState.error() = _AgreementContentPreviewPageStateError;

  factory AgreementContentPreviewPageState.connectionError(GeneralConnectionError error) =
      _AgreementContentPreviewPageStateConnectionError;
}
