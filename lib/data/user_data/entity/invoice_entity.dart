import 'package:hive_flutter/hive_flutter.dart';
import 'package:logpass_me/data/database/database_configuration.dart';
import 'package:logpass_me/data/user_data/entity/hive_entity.dart';

part 'invoice_entity.g.dart';

@HiveType(typeId: HiveTypesIds.SINGLE_INVOICE_DTO_TYPE)
class InvoiceEntity extends HiveObject implements HiveEntity<InvoiceEntity> {
  @HiveField(0)
  final String? taxId;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String surname;
  @HiveField(3)
  final String street;
  @HiveField(4)
  final String buildingNumber;
  @HiveField(5)
  final String? apartmentNumber;
  @HiveField(6)
  final String postCode;
  @HiveField(7)
  final String city;

  @override
  @HiveField(8)
  final bool isDefault;

  @override
  @HiveField(9)
  final String uuid;

  InvoiceEntity({
    required this.name,
    required this.surname,
    required this.street,
    required this.buildingNumber,
    required this.postCode,
    required this.city,
    required this.isDefault,
    required this.uuid,
    this.apartmentNumber,
    this.taxId,
  });

  @override
  InvoiceEntity copyWith({
    String? taxId,
    String? name,
    String? surname,
    String? street,
    String? buildingNumber,
    String? apartmentNumber,
    String? postCode,
    String? city,
    bool? isDefault,
    String? uuid,
  }) {
    return InvoiceEntity(
      taxId: taxId ?? this.taxId,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      street: street ?? this.street,
      buildingNumber: buildingNumber ?? this.buildingNumber,
      apartmentNumber: apartmentNumber ?? this.apartmentNumber,
      postCode: postCode ?? this.postCode,
      city: city ?? this.city,
      isDefault: isDefault ?? this.isDefault,
      uuid: uuid ?? this.uuid,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceEntity &&
          runtimeType == other.runtimeType &&
          taxId == other.taxId &&
          name == other.name &&
          surname == other.surname &&
          street == other.street &&
          buildingNumber == other.buildingNumber &&
          apartmentNumber == other.apartmentNumber &&
          postCode == other.postCode &&
          city == other.city &&
          isDefault == other.isDefault &&
          uuid == other.uuid;

  @override
  int hashIt() =>
      taxId.hashCode ^
      name.hashCode ^
      surname.hashCode ^
      street.hashCode ^
      buildingNumber.hashCode ^
      apartmentNumber.hashCode ^
      postCode.hashCode ^
      city.hashCode ^
      isDefault.hashCode;
}
