import 'package:logpass_me/domain/user_data/default_data.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class InvoiceData implements DefaultData {
  final String? taxId;
  final String name;
  final String surname;
  final String street;
  final String buildingNumber;
  final String? apartmentNumber;
  final String postCode;
  final String city;

  @override
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

  @override
  String toString() {
    final taxInfo = (taxId != null) ? '\n${LocaleKeys.yourData_invoiceDataForm_taxId.tr(args: [taxId!])}' : '';

    if (apartmentNumber != null) {
      return '$name $surname\n$street $buildingNumber/$apartmentNumber\n$postCode $city $taxInfo';
    }
    return '$name $surname\n$street $buildingNumber\n$postCode $city $taxInfo';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InvoiceData &&
        other.taxId == taxId &&
        other.name == name &&
        other.surname == surname &&
        other.street == street &&
        other.buildingNumber == buildingNumber &&
        other.apartmentNumber == apartmentNumber &&
        other.postCode == postCode &&
        other.city == city &&
        other.isDefault == isDefault;
  }

  @override
  int get hashCode {
    return taxId.hashCode ^
        name.hashCode ^
        surname.hashCode ^
        street.hashCode ^
        buildingNumber.hashCode ^
        apartmentNumber.hashCode ^
        postCode.hashCode ^
        city.hashCode ^
        isDefault.hashCode;
  }
}

extension FormatContent on InvoiceData {
  String buildContent() {
    final taxInfo = (taxId != null) ? '\n${LocaleKeys.yourData_invoiceDataForm_taxId.tr(args: [taxId!])}' : '';

    if (apartmentNumber != null) {
      return '$street $buildingNumber/$apartmentNumber\n$postCode $city $taxInfo';
    }
    return '$street $buildingNumber\n$postCode $city $taxInfo';
  }
}
