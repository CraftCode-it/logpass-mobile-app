import 'package:freezed_annotation/freezed_annotation.dart';

part 'approve_attempt_dto.g.dart';

@JsonSerializable()
class ApproveAttemptDTO {
  final ApproveAttemptUserInfoDTO userInfo;

  ApproveAttemptDTO(this.userInfo);

  // TODO: extend model with objects:
  // Address address
  // Invoice invoice

  Map<String, dynamic> toJson() => _$ApproveAttemptDTOToJson(this);
}

@JsonSerializable()
class ApproveAttemptUserInfoDTO {
  final String sub;
  final String email;
  final bool emailVerified;
  final String name;
  final List<String> extraScopes;

  ApproveAttemptUserInfoDTO(
    this.sub,
    this.email,
    this.emailVerified,
    this.name,
    this.extraScopes,
  );

  Map<String, dynamic> toJson() => _$ApproveAttemptUserInfoDTOToJson(this);

  factory ApproveAttemptUserInfoDTO.fromJson(Map<String, dynamic> json) => _$ApproveAttemptUserInfoDTOFromJson(json);
}
