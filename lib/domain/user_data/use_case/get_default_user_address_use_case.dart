import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';

@injectable
class GetDefaultUserAddressUseCase {
  // TODO: replace after implementation of UserDataRepository
  Future<Address?> call() async => Future.value(
        Address(
          name: 'John Doe',
          street: 'Some kind of street',
          buildingNumber: '28',
          apartmentNumber: '92',
          postCode: '04-242',
          city: 'Warsaw',
          country: 'Poland',
          isDefault: true,
        ),
      );
}
