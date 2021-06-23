import 'package:logpass_me/domain/country_code/country_code.dart';

class Address {
  final String name;
  final String street;
  final String buildingNumber;
  final String? apartmentNumber;
  final String postCode;
  final String city;
  final CountryCode countryCode;
  final bool isDefault;

  Address({
    required this.name,
    required this.street,
    required this.buildingNumber,
    required this.postCode,
    required this.city,
    required this.countryCode,
    this.isDefault = false,
    this.apartmentNumber,
  });
}
