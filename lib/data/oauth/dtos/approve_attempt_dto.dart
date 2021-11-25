import 'package:freezed_annotation/freezed_annotation.dart';

part 'approve_attempt_dto.g.dart';

@JsonSerializable()
class ApproveAttemptDTO {
  @JsonKey(name: 'user_info')
  final ApproveAttemptUserInfoDTO userInfo;
  @JsonKey(name: 'extra_scopes')
  final List<String> extraScopes;

  ApproveAttemptDTO(this.userInfo, this.extraScopes);

  Map<String, dynamic> toJson() => _$ApproveAttemptDTOToJson(this);
}

@JsonSerializable()
class ApproveAttemptUserInfoDTO {
  final String sub;
  final String email;
  @JsonKey(name: 'email_verified')
  final bool emailVerified;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @JsonKey(name: 'phone_number_verified')
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
  @JsonKey(name: 'building_number')
  final String buildingNumber;
  @JsonKey(name: 'apartment_number')
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
  @JsonKey(name: 'tax_id')
  final String? taxId;
  final String surname;
  final String street;
  @JsonKey(name: 'building_number')
  final String buildingNumber;
  @JsonKey(name: 'apartment_number')
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