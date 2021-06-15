import 'package:freezed_annotation/freezed_annotation.dart';

part 'approve_attempt_dto.g.dart';

@JsonSerializable()
class ApproveAttemptDTO {
  final ApproveAttemptUserInfoDTO userInfo;

  ApproveAttemptDTO(this.userInfo);

  // TODO: extend model with objects:
  // Address address
  // Invoice invoice
  // List<String> extraScoped

  Map<String, dynamic> toJson() => _$ApproveAttemptDTOToJson(this);
}

@JsonSerializable()
class ApproveAttemptUserInfoDTO {
  final String sub;
  final String email;
  final bool emailVerified;
  final String name;

  ApproveAttemptUserInfoDTO(
    this.sub,
    this.email,
    this.emailVerified,
    this.name,
  );

  Map<String, dynamic> toJson() => _$ApproveAttemptUserInfoDTOToJson(this);

  factory ApproveAttemptUserInfoDTO.fromJson(Map<String, dynamic> json) => _$ApproveAttemptUserInfoDTOFromJson(json);
}
