class Address {
  final String name;
  final String street;
  final String buildingNumber;
  final String? apartmentNumber;
  final String postCode;
  final String city;
  final String country;
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
}
