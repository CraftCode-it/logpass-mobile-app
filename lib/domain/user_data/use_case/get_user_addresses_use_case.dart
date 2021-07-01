import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';

@injectable
class GetUserAddressesUseCase {
  // TODO: replace after implementation of UserDataRepository
  Future<List<Address>> call() => Future.delayed(
        const Duration(seconds: 2),
        () => [
          Address(
            name: 'John Doe',
            street: 'Some kind of street',
            buildingNumber: '127',
            apartmentNumber: '21',
            postCode: '51-612',
            city: 'Cracow',
            country: 'Poland',
          ),
          Address(
            name: 'John Doe',
            street: 'Some kind of street',
            buildingNumber: '99',
            postCode: '62-242',
            city: 'Katowice',
            country: 'Poland',
          ),
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
        ],
      );
}
