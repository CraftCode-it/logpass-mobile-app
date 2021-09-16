import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/user_data/dto/address_entity.dart';
import 'package:logpass_me/data/user_data/mapper/hive_dto_mapper.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';

@injectable
class AddressDtoToAddressMapper implements HiveDtoMapper<AddressEntity, Address> {
  @override
  Address from(AddressEntity dto) {
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

  @override
  AddressEntity to(Address address) {
    return AddressEntity(
      name: address.name,
      street: address.street,
      buildingNumber: address.buildingNumber,
      apartmentNumber: address.apartmentNumber,
      postCode: address.postCode,
      city: address.city,
      country: address.country,
      isDefault: address.isDefault,
      uuid: address.uuid,
    );
  }
}
