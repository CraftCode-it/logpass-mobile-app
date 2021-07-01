import 'package:logpass_me/domain/user_data/default_data.dart';

class Address implements DefaultData {
  final String name;
  final String street;
  final String buildingNumber;
  final String? apartmentNumber;
  final String postCode;
  final String city;
  final String country;

  @override
  final bool isDefault;

  Address({
    required this.name,
    required this.street,
    required this.buildingNumber,
    required this.postCode,
    required this.city,
    required this.country,
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
          other.isDefault == isDefault;

  @override
  int get hashCode {
    return name.hashCode ^
        street.hashCode ^
        buildingNumber.hashCode ^
        apartmentNumber.hashCode ^
        postCode.hashCode ^
        city.hashCode ^
        country.hashCode ^
        isDefault.hashCode;
  }
}
