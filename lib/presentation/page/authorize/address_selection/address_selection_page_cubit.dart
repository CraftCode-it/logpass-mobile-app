import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';
import 'package:logpass_me/domain/user_data/use_case/get_user_addresses_use_case.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'address_selection_page_state.dart';
part 'address_selection_page_cubit.freezed.dart';

@injectable
class AddressSelectionPageCubit extends Cubit<AddressSelectionPageState> {
  final GetUserAddressesUseCase _getUserAddressesUseCase;

  List<Address>? _addresses;
  Address? _selectedAddress;

  AddressSelectionPageCubit(
    this._getUserAddressesUseCase,
  ) : super(AddressSelectionPageState.loading());

  Future<void> init(Address? address) async {
    _selectedAddress = address;

    await _loadUserAddresses();
  }

  void selectAddress(Address address) {
    _selectedAddress = address;
    _emitIdleState();
  }

  Future<void> _loadUserAddresses() async {
    try {
      _addresses = await _getUserAddressesUseCase();
      _selectedAddress ??= _addresses?.first;

      _emitIdleState();
    } on GeneralConnectionError catch (e) {
      emit(AddressSelectionPageState.connectionError(e));
      emit(AddressSelectionPageState.empty());
    } catch (e, s) {
      Fimber.e('Fetching list failed', ex: e, stacktrace: s);
      emit(AddressSelectionPageState.empty());
    }
  }

  void _emitIdleState() {
    if (_addresses != null && _selectedAddress != null) {
      emit(AddressSelectionPageState.idle(_addresses!, _selectedAddress!));
    }
  }
}
