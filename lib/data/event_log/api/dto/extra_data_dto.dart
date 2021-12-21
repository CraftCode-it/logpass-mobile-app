import 'package:json_annotation/json_annotation.dart';
import 'package:logpass_me/data/event_log/api/dto/application_dto.dart';

part 'extra_data_dto.g.dart';

@JsonSerializable()
class ExtraDataDTO {
  final String? id;
  final String? city;
  final String? status;
  final String? type;
  final String? name;
  final String? scope;
  final String? url;
  final String? isRequired;
  final String? acceptedAt;
  final String? browser;
  final String? country;
  final String? createdAt;
  final String? ipAddress;
  final String? updatedAt;
  final String? deviceName;
  final String? deviceType;
  final String? rawUserAgent;
  final String? credentialType;
  final String? operatingSystem;
  final String? verificationMethod;
  final String? key;
  final String? rawData;
  final String? owner;
  final String? checksum;
  final bool? isRemote;
  final int? trustLevel;
  final ApplicationDTO? application;
  final List<String>? scopesRequested;

  ExtraDataDTO(this.id, this.city, this.status, this.browser, this.country,
      this.createdAt, this.ipAddress, this.updatedAt, this.deviceName,
      this.deviceType, this.rawUserAgent, this.credentialType, this.operatingSystem,
      this.verificationMethod, this.key, this.rawData, this.owner, this.checksum,
      this.isRemote, this.trustLevel, this.application, this.scopesRequested,
      this.type, this.name, this.scope, this.url, this.isRequired, this.acceptedAt);

  factory ExtraDataDTO.fromJson(Map<String, dynamic> json) =>
      _$ExtraDataDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ExtraDataDTOToJson(this);
}