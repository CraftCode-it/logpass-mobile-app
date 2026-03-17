import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';
import 'package:logpass_me/domain/user_data/use_case/delete_address_use_case.dart';
import 'package:logpass_me/domain/user_data/use_case/get_user_addresses_use_case.dart';
import 'package:logpass_me/domain/user_data/use_case/set_default_address_use_case.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'data_addresses_page_state.dart';
part 'data_addresses_page_cubit.freezed.dart';

@injectable
class DataAddressesPageCubit extends Cubit<DataAddressesPageState> {
  final GetUserAddressesUseCase _getUserAddressesUseCase;
  final SetDefaultAddressUseCase _setDefaultAddressUseCase;
  final DeleteAddressUseCase _deleteAddressUseCase;

  List<Address> _addressList = [];

  DataAddressesPageCubit(
    this._getUserAddressesUseCase,
    this._setDefaultAddressUseCase,
    this._deleteAddressUseCase,
  ) : super(DataAddressesPageState.loading());

  Future<void> init() async {
    await getAddressList();
  }

  Future<void> getAddressList() async {
    emit(DataAddressesPageState.loading());

    try {
      final result = await _getUserAddressesUseCase();
      _addressList = result;

      _emitIdleOrEmptyState();
    } on GeneralConnectionError catch (e) {
      emit(DataAddressesPageState.connectionError(e));
      emit(DataAddressesPageState.empty());
    } catch (e, s) {
      Fimber.e('Failed to load address list', ex: e, stacktrace: s);
    }
  }

  void ensureRemoval(Address address) {
    emit(DataAddressesPageState.removalConfirmationNeeded(address));
    _emitIdleOrEmptyState();
  }

  Future<void> deleteAddress(Address address) async {
    emit(DataAddressesPageState.loading());

    try {
      await _deleteAddressUseCase(address);

      await getAddressList();
      emit(DataAddressesPageState.addressRemoved());
    } on GeneralConnectionError catch (e) {
      emit(DataAddressesPageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Failed to delete address', ex: e, stacktrace: s);
    }
  }

  Future<void> setAddressAsDefault(Address address) async {
    emit(DataAddressesPageState.loading());

    try {
      await _setDefaultAddressUseCase(address);
      await getAddressList();
    } on GeneralConnectionError catch (e) {
      emit(DataAddressesPageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Failed to set address as default', ex: e, stacktrace: s);
    }
  }

  void _emitIdleOrEmptyState() {
    _addressList.isNotEmpty ? emit(DataAddressesPageState.idle(_addressList)) : emit(DataAddressesPageState.empty());
  }
}
