import 'package:hive_flutter/hive_flutter.dart';
import 'package:logpass_me/data/database/database_configuration.dart';
import 'package:logpass_me/data/user_data/dto/hive_dto.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';

part 'invoice_dto.g.dart';

@HiveType(typeId: HiveTypesIds.SINGLE_INVOICE_DTO_TYPE)
class InvoiceDto extends HiveObject implements HiveDto<InvoiceDto> {
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

  InvoiceDto({
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
  InvoiceDto copyWith({
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
    return InvoiceDto(
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

}
