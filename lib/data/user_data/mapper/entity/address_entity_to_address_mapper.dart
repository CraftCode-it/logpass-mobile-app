import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/user_data/entity/address_entity.dart';
import 'package:logpass_me/data/user_data/mapper/entity/hive_entity_mapper.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';

@injectable
class AddressEntityToAddressEntityMapper implements HiveEntityMapper<AddressEntity, Address> {
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
      apartmentNumber: dto.apartmentNumber,
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
