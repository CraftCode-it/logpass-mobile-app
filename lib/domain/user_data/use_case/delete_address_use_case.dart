import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

@injectable
class DeleteAddressUseCase {
  final UserDataRepository<Address> _repository;

  DeleteAddressUseCase(this._repository);

  Future<void> call(Address address) => _repository.delete(address);
}
