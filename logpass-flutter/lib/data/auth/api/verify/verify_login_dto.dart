import 'package:json_annotation/json_annotation.dart';

part 'verify_login_dto.g.dart';

@JsonSerializable()
class VerifyLoginDTO {
  final String secret;

  VerifyLoginDTO({required this.secret});

  Map<String, dynamic> toJson() => _$VerifyLoginDTOToJson(this);
}
