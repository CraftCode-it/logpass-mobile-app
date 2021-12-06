import 'package:freezed_annotation/freezed_annotation.dart';

part 'approve_attempt_dto.g.dart';

@JsonSerializable()
class ApproveAttemptDTO {
  final ApproveAttemptUserInfoDTO userInfo;
  final List<String> extraScopes;

  ApproveAttemptDTO(this.userInfo, this.extraScopes);

  Map<String, dynamic> toJson() => _$ApproveAttemptDTOToJson(this);
}

@JsonSerializable()
class ApproveAttemptUserInfoDTO {
  final String sub;
  final String email;
  final bool emailVerified;
  final String? phoneNumber;
  final bool phoneNumberVerified;
  @JsonKey(name: 'given_name')
  final String? name;
  @JsonKey(name: 'family_name')
  final String? surname;
  final String locale;
  final ApproveAttemptAddressInfoDTO? address;
  final ApproveAttemptInvoiceInfoDTO? invoice;

  ApproveAttemptUserInfoDTO(
    this.sub,
    this.email,
    this.emailVerified,
    this.phoneNumber,
    this.phoneNumberVerified,
    this.name,
    this.surname,
    this.locale,
    this.address,
    this.invoice,
  );

  Map<String, dynamic> toJson() => _$ApproveAttemptUserInfoDTOToJson(this);

  factory ApproveAttemptUserInfoDTO.fromJson(Map<String, dynamic> json) => _$ApproveAttemptUserInfoDTOFromJson(json);
}

@JsonSerializable()
class ApproveAttemptAddressInfoDTO {
  final String name;
  final String street;
  final String buildingNumber;
  final String? apartmentNumber;
  @JsonKey(name: 'postcode')
  final String postCode;
  final String city;
  final String country;

  ApproveAttemptAddressInfoDTO(
    this.name,
    this.street,
    this.buildingNumber,
    this.apartmentNumber,
    this.postCode,
    this.city,
    this.country,
  );

  Map<String, dynamic> toJson() => _$ApproveAttemptAddressInfoDTOToJson(this);

  factory ApproveAttemptAddressInfoDTO.fromJson(Map<String, dynamic> json) => _$ApproveAttemptAddressInfoDTOFromJson(json);
}

@JsonSerializable()
class ApproveAttemptInvoiceInfoDTO {
  final String? taxId;
  final String surname;
  final String street;
  final String buildingNumber;
  final String? apartmentNumber;
  @JsonKey(name: 'postcode')
  final String postCode;
  final String city;

  ApproveAttemptInvoiceInfoDTO(
    this.taxId,
    this.surname,
    this.street,
    this.buildingNumber,
    this.apartmentNumber,
    this.postCode,
    this.city,
  );

  Map<String, dynamic> toJson() => _$ApproveAttemptInvoiceInfoDTOToJson(this);

  factory ApproveAttemptInvoiceInfoDTO.fromJson(Map<String, dynamic> json) => _$ApproveAttemptInvoiceInfoDTOFromJson(json);
}