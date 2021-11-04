import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

@injectable
class UpdateAddressUseCase {
  final UserDataRepository<Address> _repository;

  UpdateAddressUseCase(this._repository);

  Future<void> call(Address oldAddress, Address address) async {
    await _repository.delete(oldAddress);
    return _repository.create(address);
  }
}
