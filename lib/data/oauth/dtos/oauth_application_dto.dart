import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/data/service/api/data/service_dto.dart';

part 'oauth_application_dto.g.dart';

const _linksKey = '_links';

@JsonSerializable()
class OAuthApplicationDTO {
  final OAuthApplicationDataDTO data;
  @JsonKey(name: _linksKey)
  final OAuthApplicationLinksDTO links;

  OAuthApplicationDTO(this.data, this.links);

  Map<String, dynamic> toJson() => _$OAuthApplicationDTOToJson(this);

  factory OAuthApplicationDTO.fromJson(Map<String, dynamic> json) => _$OAuthApplicationDTOFromJson(json);
}

@JsonSerializable()
class OAuthApplicationDataDTO {
  final String id;
  final String user;
  final String deviceType;
  final String deviceName;
  final String operatingSystem;
  final String browser;
  final String ipAddress;
  final String city;
  final String country;
  final bool isRemote;
  final List<String> scopesRequested;
  @JsonKey(name: _linksKey)
  final OAuthApplicationDataLinksDTO links;
  final ServiceDTO client;

  OAuthApplicationDataDTO(
    this.id,
    this.user,
    this.deviceType,
    this.deviceName,
    this.operatingSystem,
    this.browser,
    this.ipAddress,
    this.city,
    this.country,
    this.isRemote,
    this.scopesRequested,
    this.links,
    this.client,
  );

  Map<String, dynamic> toJson() => _$OAuthApplicationDataDTOToJson(this);

  factory OAuthApplicationDataDTO.fromJson(Map<String, dynamic> json) => _$OAuthApplicationDataDTOFromJson(json);
}

@JsonSerializable()
class OAuthApplicationDataLinksDTO {
  final String self;
  final String user;
  final String approvals;

  OAuthApplicationDataLinksDTO(
    this.self,
    this.user,
    this.approvals,
  );

  Map<String, dynamic> toJson() => _$OAuthApplicationDataLinksDTOToJson(this);

  factory OAuthApplicationDataLinksDTO.fromJson(Map<String, dynamic> json) =>
      _$OAuthApplicationDataLinksDTOFromJson(json);
}

@JsonSerializable()
class OAuthApplicationLinksDTO {
  final String review;
  final String websocket;

  OAuthApplicationLinksDTO(
    this.review,
    this.websocket,
  );

  Map<String, dynamic> toJson() => _$OAuthApplicationLinksDTOToJson(this);

  factory OAuthApplicationLinksDTO.fromJson(Map<String, dynamic> json) => _$OAuthApplicationLinksDTOFromJson(json);
}
