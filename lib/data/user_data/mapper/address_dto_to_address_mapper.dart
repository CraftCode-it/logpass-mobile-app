import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/data_mapper.dart';
import 'package:logpass_me/data/user_data/dto/address_dto.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';

@injectable
class AddressDtoToAddressMapper  implements DataMapper<AddressDto, Address>{
  @override
  Address call(AddressDto dto) {
    return Address(
      name: dto.name,
      street: dto.street,
      buildingNumber: dto.buildingNumber,
      postCode: dto.postCode,
      city: dto.city,
      country: dto.country,
      uuid: dto.uuid,
      isDefault: dto.isDefault,
    );
  }
}
