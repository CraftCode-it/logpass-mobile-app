import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';

@injectable
class DeleteAddressUseCase {
  // TODO: replace after implementation of UserDataRepository
  Future<void> call(Address address) => Future.delayed(
        const Duration(seconds: 2),
        () => null,
      );
}
