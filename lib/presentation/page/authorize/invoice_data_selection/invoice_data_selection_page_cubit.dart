import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';
import 'package:logpass_me/domain/user_data/use_case/get_invoice_data_list_use_case.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'invoice_data_selection_page_state.dart';
part 'invoice_data_selection_page_cubit.freezed.dart';

@injectable
class InvoiceDataSelectionPageCubit extends Cubit<InvoiceDataSelectionPageState> {
  final GetInvoiceDataListUseCase _getInvoiceDataListUseCase;

  List<InvoiceData>? _invoiceDataList;
  InvoiceData? _selectedInvoiceData;

  InvoiceDataSelectionPageCubit(
    this._getInvoiceDataListUseCase,
  ) : super(InvoiceDataSelectionPageState.loading());

  Future<void> init(InvoiceData? invoiceData) async {
    _selectedInvoiceData = invoiceData;

    await _loadInvoiceDatas();
  }

  void selectInvoiceData(InvoiceData invoiceData) {
    _selectedInvoiceData = invoiceData;
    _emitIdleState();
  }

  Future<void> _loadInvoiceDatas() async {
    try {
      _invoiceDataList = await _getInvoiceDataListUseCase();
      _selectedInvoiceData ??= _invoiceDataList?.first;

      _emitIdleState();
    } on GeneralConnectionError catch (e) {
      emit(InvoiceDataSelectionPageState.connectionError(e));
      emit(InvoiceDataSelectionPageState.empty());
    } catch (e, s) {
      Fimber.e('Fetching list failed', ex: e, stacktrace: s);
      emit(InvoiceDataSelectionPageState.empty());
    }
  }

  void _emitIdleState() {
    if (_invoiceDataList != null && _selectedInvoiceData != null) {
      emit(InvoiceDataSelectionPageState.idle(_invoiceDataList!, _selectedInvoiceData!));
    }
  }
}
