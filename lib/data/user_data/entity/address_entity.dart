import 'package:hive/hive.dart';
import 'package:logpass_me/data/database/database_configuration.dart';
import 'package:logpass_me/data/user_data/entity/hive_entity.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';

part 'address_entity.g.dart';

@HiveType(typeId: HiveTypesIds.SINGLE_ADDRESS_DTO_TYPE)
class AddressEntity extends HiveObject implements HiveEntity<AddressEntity> {
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

  @override
  @HiveField(7)
  final bool isDefault;

  @override
  @HiveField(8)
  final String uuid;

  AddressEntity({
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

  @override
  AddressEntity copyWith({
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
    return AddressEntity(
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
