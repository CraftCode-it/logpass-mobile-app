import 'package:logpass_me/domain/user_data/default_data.dart';

class Address implements DefaultData {
  final String name;
  final String street;
  final String buildingNumber;
  final String? apartmentNumber;
  final String postCode;
  final String city;
  final String country;
  final String uuid;

  @override
  final bool isDefault;

  Address({
    required this.name,
    required this.street,
    required this.buildingNumber,
    required this.postCode,
    required this.city,
    required this.country,
    required this.uuid,
    this.isDefault = false,
    this.apartmentNumber,
  });

  @override
  String toString() {
    if (apartmentNumber != null) {
      return '$name\n$street $buildingNumber/$apartmentNumber\n$postCode $city';
    }
    return '$name\n$street $buildingNumber\n$postCode $city';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Address &&
          other.name == name &&
          other.street == street &&
          other.buildingNumber == buildingNumber &&
          other.apartmentNumber == apartmentNumber &&
          other.postCode == postCode &&
          other.city == city &&
          other.country == country &&
          other.isDefault == isDefault &&
          other.uuid == uuid;

  @override
  int get hashCode {
    return name.hashCode ^
        street.hashCode ^
        buildingNumber.hashCode ^
        apartmentNumber.hashCode ^
        postCode.hashCode ^
        city.hashCode ^
        country.hashCode ^
        uuid.hashCode ^
        isDefault.hashCode;
  }

  Address copyWith({
    String? name,
    String? street,
    String? buildingNumber,
    String? apartmentNumber,
    String? postCode,
    String? city,
    String? country,
    String? uuid,
    bool? isDefault,
  }) {
    return Address(
      name: name ?? this.name,
      street: street ?? this.street,
      buildingNumber: buildingNumber ?? this.buildingNumber,
      apartmentNumber: apartmentNumber ?? this.apartmentNumber,
      postCode: postCode ?? this.postCode,
      city: city ?? this.city,
      country: country ?? this.country,
      uuid: uuid ?? this.uuid,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

extension FormatContent on Address {
  String buildContent() {
    if (apartmentNumber != null) {
      return '$street $buildingNumber/$apartmentNumber\n$postCode $city';
    }
    return '$street $buildingNumber\n$postCode $city';
  }
}
