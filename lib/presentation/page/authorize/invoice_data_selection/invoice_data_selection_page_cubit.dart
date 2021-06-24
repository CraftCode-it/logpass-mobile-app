import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';
import 'package:logpass_me/domain/user_data/use_case/get_invoice_datas_use_case.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'invoice_data_selection_page_state.dart';
part 'invoice_data_selection_page_cubit.freezed.dart';

@injectable
class InvoiceDataSelectionPageCubit extends Cubit<InvoiceDataSelectionPageState> {
  final GetInvoiceDatasUseCase _getInvoiceDatasUseCase;

  List<InvoiceData>? _invoiceDatas;
  InvoiceData? _selectedInvoiceData;

  InvoiceDataSelectionPageCubit(
    this._getInvoiceDatasUseCase,
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
      _invoiceDatas = await _getInvoiceDatasUseCase();
      _selectedInvoiceData ??= _invoiceDatas?.first;

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
    if (_invoiceDatas != null && _selectedInvoiceData != null) {
      emit(InvoiceDataSelectionPageState.idle(_invoiceDatas!, _selectedInvoiceData!));
    }
  }
}
