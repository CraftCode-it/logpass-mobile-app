part of 'agreement_content_preview_page_cubit.dart';

@freezed
class AgreementContentPreviewPageState with _$AgreementContentPreviewPageState {
  @Implements(BuildState)
  const factory AgreementContentPreviewPageState.loading() = _AgreementContentPreviewPageStateLoading;

  @Implements(BuildState)
  const factory AgreementContentPreviewPageState.idle(PdfDocument pdfDocument) = _AgreementContentPreviewPageStateIdle;

  factory AgreementContentPreviewPageState.connectionError(GeneralConnectionError error) =
      _AgreementContentPreviewPageStateConnectionError;
}
