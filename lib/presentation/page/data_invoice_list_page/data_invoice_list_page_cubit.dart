import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';
import 'package:logpass_me/domain/user_data/use_case/delete_invoice_data_use_case.dart';
import 'package:logpass_me/domain/user_data/use_case/get_invoice_data_list_use_case.dart';
import 'package:logpass_me/domain/user_data/use_case/set_default_invoice_data_use_case.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'data_invoice_list_page_state.dart';
part 'data_invoice_list_page_cubit.freezed.dart';

@injectable
class DataInvoiceListPageCubit extends Cubit<DataInvoiceListPageState> {
  final GetInvoiceDataListUseCase _getInvoiceDataListUseCase;
  final SetDefaultInvoiceDataUseCase _setDefaultInvoiceDataUseCase;
  final DeleteInvoiceDataUseCase _deleteInvoiceDataUseCase;

  List<InvoiceData> _invoiceDataList = [];

  DataInvoiceListPageCubit(
    this._getInvoiceDataListUseCase,
    this._setDefaultInvoiceDataUseCase,
    this._deleteInvoiceDataUseCase,
  ) : super(DataInvoiceListPageState.loading());

  Future<void> init() async {
    await getInvoiceDataList();
  }

  Future<void> getInvoiceDataList() async {
    emit(DataInvoiceListPageState.loading());

    try {
      final result = await _getInvoiceDataListUseCase();
      _invoiceDataList = result;

      _emitIdleOrEmptyState();
    } on GeneralConnectionError catch (e) {
      emit(DataInvoiceListPageState.connectionError(e));
      emit(DataInvoiceListPageState.empty());
    } catch (e, s) {
      Fimber.e('Failed to load invoice data list', ex: e, stacktrace: s);
    }
  }

  void ensureRemoval(InvoiceData invoiceData) {
    emit(DataInvoiceListPageState.removalConfirmationNeeded(invoiceData));
    _emitIdleOrEmptyState();
  }

  Future<void> deleteInvoiceData(InvoiceData invoiceData) async {
    emit(DataInvoiceListPageState.loading());

    try {
      await _deleteInvoiceDataUseCase(invoiceData);
      await getInvoiceDataList();
      emit(DataInvoiceListPageState.invoiceDataRemoved());
    } on GeneralConnectionError catch (e) {
      emit(DataInvoiceListPageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Failed to delete invoice data', ex: e, stacktrace: s);
    }
  }

  Future<void> setInvoiceDataAsDefault(InvoiceData invoiceData) async {
    emit(DataInvoiceListPageState.loading());

    try {
      await _setDefaultInvoiceDataUseCase(invoiceData);
      await getInvoiceDataList();
    } on GeneralConnectionError catch (e) {
      emit(DataInvoiceListPageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Failed to set invoice data as default', ex: e, stacktrace: s);
    }
  }

  void _emitIdleOrEmptyState() {
    _invoiceDataList.isNotEmpty
        ? emit(DataInvoiceListPageState.idle(_invoiceDataList))
        : emit(DataInvoiceListPageState.empty());
  }
}
