import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

@injectable
class AddAddressUseCase {
  final UserDataRepository<Address> _repository;

  AddAddressUseCase(this._repository);

  Future<void> call(Address address) async {
    final isFirst = (await _repository.readAll()).isEmpty;
    return _repository.create(address.copyWith(isDefault: isFirst));
  }
}
