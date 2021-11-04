import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';
import 'package:logpass_me/domain/user_data/exception/duplicated_entry_exception.dart';
import 'package:logpass_me/domain/user_data/use_case/add_invoice_data_use_case.dart';
import 'package:logpass_me/presentation/utils/uuid.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'data_invoice_list_form_page_cubit.freezed.dart';

part 'data_invoice_list_form_page_state.dart';

@injectable
class DataInvoiceListFormPageCubit extends Cubit<DataInvoiceListFormPageState> {
  final AddInvoiceDataUseCase _addInvoiceDataUseCase;

  String _name = '';
  String _surname = '';
  String _street = '';
  String _buildingNumber = '';
  String? _apartmentNumber;
  String _postCode = '';
  String _city = '';
  String? _taxId;

  bool get _canSave =>
      _name.isNotEmpty && _street.isNotEmpty && _buildingNumber.isNotEmpty && _postCode.isNotEmpty && _city.isNotEmpty;

  bool get _areSomeFieldsFilled =>
      _name.isNotEmpty ||
      _surname.isNotEmpty ||
      _street.isNotEmpty ||
      _buildingNumber.isNotEmpty ||
      _postCode.isNotEmpty ||
      _city.isNotEmpty ||
      _apartmentNumberIsFilled ||
      _taxIdIsFilled;

  bool get _apartmentNumberIsFilled {
    if (_apartmentNumber != null) {
      return _apartmentNumber!.isNotEmpty;
    }
    return false;
  }

  bool get _taxIdIsFilled {
    if (_taxId != null) {
      return _taxId!.isNotEmpty;
    }
    return false;
  }

  DataInvoiceListFormPageCubit(this._addInvoiceDataUseCase)
      : super(const DataInvoiceListFormPageState.idle(false, false));

  void nameChanged(String value) {
    _name = value.trim();
    _emitIdleState();
  }

  void streetChanged(String value) {
    _street = value.trim();
    _emitIdleState();
  }

  void buildingNumberChanged(String value) {
    _buildingNumber = value.trim();
    _emitIdleState();
  }

  void postCodeChanged(String value) {
    _postCode = value.trim();
    _emitIdleState();
  }

  void apartmentNumberChanged(String value) {
    _apartmentNumber = value.trim();
    _emitIdleState();
  }

  void cityChanged(String value) {
    _city = value.trim();
    _emitIdleState();
  }

  void surnameChanged(String value) {
    _surname = value.trim();
    _emitIdleState();
  }

  void taxIdChanged(String value) {
    _taxId = value.trim();
    _emitIdleState();
  }

  Future<void> saveInvoiceData() async {
    emit(const DataInvoiceListFormPageState.loading());

    try {
      final invoiceData = _createInvoiceData();
      await _addInvoiceDataUseCase(invoiceData);

      emit(DataInvoiceListFormPageState.savedSuccessful());
    } on GeneralConnectionError catch (e) {
      emit(DataInvoiceListFormPageState.connectionError(e));
    } on DuplicatedEntryException catch (_) {
      emit(DataInvoiceListFormPageState.duplicatedEntry());
      emit(const DataInvoiceListFormPageState.idle(false, false));
    } catch (e, s) {
      Fimber.e('Failed to save Invoice Data', ex: e, stacktrace: s);
    }
  }

  InvoiceData _createInvoiceData() => InvoiceData(
        name: _name,
        surname: _surname,
        street: _street,
        buildingNumber: _buildingNumber,
        postCode: _postCode,
        city: _city,
        taxId: _taxId,
        apartmentNumber: _apartmentNumber,
        uuid: uuid.v4(),
      );

  void _emitIdleState() => emit(DataInvoiceListFormPageState.idle(_canSave, _areSomeFieldsFilled));
}
