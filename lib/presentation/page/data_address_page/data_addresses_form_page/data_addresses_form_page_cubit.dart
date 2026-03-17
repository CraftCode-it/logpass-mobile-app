import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/country_code/country_code.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';
import 'package:logpass_me/domain/user_data/exception/duplicated_entry_exception.dart';
import 'package:logpass_me/domain/user_data/use_case/add_address_use_case.dart';
import 'package:logpass_me/domain/user_data/use_case/update_address_use_case.dart';
import 'package:logpass_me/presentation/utils/uuid.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'data_addresses_form_page_cubit.freezed.dart';

part 'data_addresses_form_page_state.dart';

@injectable
class DataAddressesFormPageCubit extends Cubit<DataAddressesFormPageState> {
  final AddAddressUseCase _addAddressUseCase;
  final UpdateAddressUseCase _updateAddressUseCase;

  String _name = '';
  String _street = '';
  String _buildingNumber = '';
  String? _apartmentNumber;
  String _postCode = '';
  String _city = '';
  String _country = '';
  Address? _oldAddress;

  bool get _editMode => _oldAddress != null;

  bool get _canSave =>
      _name.isNotEmpty &&
      _street.isNotEmpty &&
      _buildingNumber.isNotEmpty &&
      _postCode.isNotEmpty &&
      _city.isNotEmpty &&
      _country.isNotEmpty;

  bool get _areSomeFieldsFilled =>
      _name.isNotEmpty ||
      _street.isNotEmpty ||
      _buildingNumber.isNotEmpty ||
      _postCode.isNotEmpty ||
      _city.isNotEmpty ||
      _country.isNotEmpty ||
      _apartmentNumberIsFilled;

  bool get _apartmentNumberIsFilled {
    if (_apartmentNumber != null) {
      return _apartmentNumber!.isNotEmpty;
    }
    return false;
  }

  DataAddressesFormPageCubit(
    this._addAddressUseCase,
    this._updateAddressUseCase,
  ) : super(const DataAddressesFormPageState.idle(false, false));

  void init(Address? address) {
    if (address == null) {
      return;
    }
    _oldAddress = address;

    _name = address.name;
    _street = address.street;
    _buildingNumber = address.buildingNumber;
    _apartmentNumber = address.apartmentNumber;
    _postCode = address.postCode;
    _city = address.city;
    _country = address.country;
    _emitIdleState();
  }

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

  void countyChanged(CountryCode value) {
    _country = value.country.trim();
    _emitIdleState();
  }

  Future<void> saveAddress() async {
    emit(const DataAddressesFormPageState.loading());

    try {
      final address = _createAddress();
      if (_editMode) {
        await _updateAddressUseCase(_oldAddress!, address);
      } else {
        await _addAddressUseCase(address);
      }

      emit(DataAddressesFormPageState.savedSuccessful());
    } on GeneralConnectionError catch (e) {
      emit(DataAddressesFormPageState.connectionError(e));
    } on DuplicatedEntryException catch (_) {
      emit(DataAddressesFormPageState.duplicatedEntry());
      emit(const DataAddressesFormPageState.idle(false, false));
    } catch (e, s) {
      Fimber.e('Failed to save Address', ex: e, stacktrace: s);
    }
  }

  Address _createAddress() => Address(
        name: _name,
        street: _street,
        buildingNumber: _buildingNumber,
        postCode: _postCode,
        city: _city,
        country: _country,
        apartmentNumber: _apartmentNumber,
        uuid: uuid.v4(),
        isDefault: _oldAddress?.isDefault ?? false,
      );

  void _emitIdleState() => emit(DataAddressesFormPageState.idle(_canSave, _areSomeFieldsFilled));
}
