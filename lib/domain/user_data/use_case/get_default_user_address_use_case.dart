import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

@injectable
class GetDefaultUserAddressUseCase {
  final UserDataRepository<Address> _repository;

  GetDefaultUserAddressUseCase(this._repository);

  // TODO: replace after implementation of UserDataRepository
  Future<Address?> call() async => _repository.readDefault();
}
