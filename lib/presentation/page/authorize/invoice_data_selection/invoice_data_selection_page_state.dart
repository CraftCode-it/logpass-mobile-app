part of 'invoice_data_selection_page_cubit.dart';

@freezed
class InvoiceDataSelectionPageState with _$InvoiceDataSelectionPageState {
  @Implements(BuildState)
  const factory InvoiceDataSelectionPageState.idle(
    List<InvoiceData> invoiceData,
    InvoiceData invoiceDatas,
  ) = _InvoiceDataSelectionPageStateIdle;

  @Implements(BuildState)
  factory InvoiceDataSelectionPageState.loading() = _InvoiceDataSelectionPageStateLoading;

  @Implements(BuildState)
  factory InvoiceDataSelectionPageState.empty() = _InvoiceDataSelectionPageStateEmpty;

  factory InvoiceDataSelectionPageState.connectionError(GeneralConnectionError error) =
      _InvoiceDataSelectionPageStateConnectionError;
}
