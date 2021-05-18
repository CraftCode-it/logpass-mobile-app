import 'package:injectable/injectable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logpass_me/data/common/data_mapper.dart';
import 'package:logpass_me/domain/auth/token/access_token.dart';
import 'package:logpass_me/domain/auth/token/user_tokens.dart';

part 'tokens_result_dto.g.dart';

@JsonSerializable()
class TokensResultDTO {
  final TokensResultDataDTO data;

  TokensResultDTO(this.data);

  Map<String, dynamic> toJson() => _$TokensResultDTOToJson(this);

  factory TokensResultDTO.fromJson(Map<String, dynamic> json) => _$TokensResultDTOFromJson(json);
}

@JsonSerializable()
class TokensResultDataDTO {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final String sub;

  TokensResultDataDTO(this.accessToken, this.refreshToken, this.tokenType, this.expiresIn, this.sub);

  Map<String, dynamic> toJson() => _$TokensResultDataDTOToJson(this);

  factory TokensResultDataDTO.fromJson(Map<String, dynamic> json) => _$TokensResultDataDTOFromJson(json);
}

@Injectable()
class UserTokensDTOMapper implements DataMapper<TokensResultDTO, UserTokens> {
  @override
  UserTokens call(TokensResultDTO data) {
    return UserTokens(
      accessToken: AccessToken(
        token: data.data.accessToken,
        type: data.data.tokenType,
      ),
      refreshToken: data.data.refreshToken,
    );
  }
}
