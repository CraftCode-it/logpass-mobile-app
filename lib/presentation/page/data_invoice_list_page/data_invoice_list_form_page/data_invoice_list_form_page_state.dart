part of 'data_invoice_list_form_page_cubit.dart';

@freezed
class DataInvoiceListFormPageState with _$DataInvoiceListFormPageState {
  @Implements(BuildState)
  const factory DataInvoiceListFormPageState.loading() = _DataInvoiceListFormPageStateLoading;

  @Implements(BuildState)
  const factory DataInvoiceListFormPageState.idle(
    bool canSave,
    bool areSomeFieldsFilled,
  ) = _DataInvoiceListFormPageStateIdle;

  factory DataInvoiceListFormPageState.connectionError(GeneralConnectionError error) =
      _DataInvoiceListFormPageStateConnectionError;

  factory DataInvoiceListFormPageState.savedSuccessful() = _DataInvoiceListFormPageStateSavedSuccessful;
}
