class InvoiceData {
  final String? taxId;
  final String name;
  final String surname;
  final String street;
  final String buildingNumber;
  final String? apartmentNumber;
  final String postCode;
  final String city;
  final bool isDefault;

  InvoiceData({
    required this.name,
    required this.surname,
    required this.street,
    required this.buildingNumber,
    required this.postCode,
    required this.city,
    this.isDefault = false,
    this.apartmentNumber,
    this.taxId,
  });
}
