import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

@injectable
class GetUserAddressesUseCase {
  final UserDataRepository<Address> _repository;

  GetUserAddressesUseCase(this._repository);

  // TODO: replace after implementation of UserDataRepository
  Future<List<Address>> call() => _repository.readAll();
}
