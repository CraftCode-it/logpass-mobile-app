import 'package:json_annotation/json_annotation.dart';

part 'initialize_login_dto.g.dart';

@JsonSerializable()
class InitializeLoginDTO {
  final String credential;
  final String rawVerifyCode;
  final String rawPublicKey;
  final String? verificationMethod;

  InitializeLoginDTO({
    required this.credential,
    required this.rawVerifyCode,
    required this.rawPublicKey,
    this.verificationMethod,
  });

  Map<String, dynamic> toJson() => _$InitializeLoginDTOToJson(this);
}
