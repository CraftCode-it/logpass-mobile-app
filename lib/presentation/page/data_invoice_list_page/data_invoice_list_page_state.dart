part of 'data_invoice_list_page_cubit.dart';

@freezed
class DataInvoiceListPageState with _$DataInvoiceListPageState {
  @Implements<BuildState>()
  factory DataInvoiceListPageState.idle(List<InvoiceData> invoiceDataList) = _DataInvoiceListPageStateIdle;

  @Implements<BuildState>()
  factory DataInvoiceListPageState.loading() = _DataInvoiceListPageStateLoading;

  @Implements<BuildState>()
  factory DataInvoiceListPageState.empty() = _DataInvoiceListPageStateEmpty;

  factory DataInvoiceListPageState.connectionError(GeneralConnectionError error) =
      _DataInvoiceListPageStateConnectionError;

  factory DataInvoiceListPageState.removalConfirmationNeeded(InvoiceData invoiceData) =
      _DataInvoiceListPageStateRemovalConfirmationNeeded;

  factory DataInvoiceListPageState.invoiceDataRemoved() = _DataInvoiceListPageStateInvoiceDataRemoved;
}
