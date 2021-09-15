import 'package:hive/hive.dart';
import 'package:logpass_me/data/database/database_configuration.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';

part 'address_dto.g.dart';

@HiveType(typeId: HiveTypesIds.SINGLE_ADDRESS_DTO_TYPE)
class AddressDto extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String street;
  @HiveField(2)
  final String buildingNumber;
  @HiveField(3)
  final String? apartmentNumber;
  @HiveField(4)
  final String postCode;
  @HiveField(5)
  final String city;
  @HiveField(6)
  final String country;
  @HiveField(7)
  final bool isDefault;
  @HiveField(8)
  final String uuid;

  AddressDto({
    required this.name,
    required this.street,
    required this.buildingNumber,
    required this.apartmentNumber,
    required this.postCode,
    required this.city,
    required this.country,
    required this.isDefault,
    required this.uuid,
  });

  factory AddressDto.from(Address address) =>
      AddressDto(
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

  AddressDto copyWith({
    String? name,
    String? street,
    String? buildingNumber,
    String? apartmentNumber,
    String? postCode,
    String? city,
    String? country,
    bool? isDefault,
    String? uuid,
  }) {
    return AddressDto(
      name: name ?? this.name,
      street: street ?? this.street,
      buildingNumber: buildingNumber ?? this.buildingNumber,
      apartmentNumber: apartmentNumber ?? this.apartmentNumber,
      postCode: postCode ?? this.postCode,
      city: city ?? this.city,
      country: country ?? this.country,
      isDefault: isDefault ?? this.isDefault,
      uuid: uuid ?? this.uuid,
    );
  }
}
