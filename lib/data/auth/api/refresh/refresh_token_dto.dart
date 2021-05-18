import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_dto.g.dart';

@JsonSerializable()
class RefreshTokenDTO {
  final String refreshToken;

  RefreshTokenDTO({required this.refreshToken});

  Map<String, dynamic> toJson() => _$RefreshTokenDTOToJson(this);
}
