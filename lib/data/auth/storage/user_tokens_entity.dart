import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/bidirectional_data_mapper.dart';
import 'package:logpass_me/domain/auth/token/access_token.dart';
import 'package:logpass_me/domain/auth/token/user_tokens.dart';

part 'user_tokens_entity.g.dart';

@JsonSerializable()
class UserTokensEntity {
  final String accessToken;
  final String refreshToken;
  final String tokenType;

  UserTokensEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });

  Map<String, dynamic> toJson() => _$UserTokensEntityToJson(this);

  factory UserTokensEntity.fromJson(Map<String, dynamic> json) => _$UserTokensEntityFromJson(json);
}

@Injectable()
class UserTokensEntityMapper implements BidirectionalDataMapper<UserTokens, UserTokensEntity> {
  @override
  UserTokensEntity from(UserTokens data) {
    return UserTokensEntity(
      accessToken: data.accessToken.token,
      refreshToken: data.refreshToken,
      tokenType: data.accessToken.type,
    );
  }

  @override
  UserTokens to(UserTokensEntity data) {
    return UserTokens(
      accessToken: AccessToken(
        token: data.accessToken,
        type: data.tokenType,
      ),
      refreshToken: data.refreshToken,
    );
  }
}
