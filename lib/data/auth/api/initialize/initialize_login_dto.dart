import 'package:json_annotation/json_annotation.dart';

part 'initialize_login_dto.g.dart';

@JsonSerializable(includeIfNull: false)
class InitializeLoginDTO {
  final String credential;
  final String rawVerifyKey;
  final String rawPublicKey;
  final String? verificationMethod;

  InitializeLoginDTO({
    required this.credential,
    required this.rawVerifyKey,
    required this.rawPublicKey,
    this.verificationMethod,
  });

  Map<String, dynamic> toJson() => _$InitializeLoginDTOToJson(this);
}
