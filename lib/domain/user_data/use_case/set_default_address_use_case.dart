import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

@injectable
class SetDefaultAddressUseCase {
  final UserDataRepository<Address> _repository;

  SetDefaultAddressUseCase(this._repository);
  // TODO: replace after implementation of UserDataRepository
  Future<void> call(Address address) => _repository.setDefault(address.copyWith(isDefault: true));
}
