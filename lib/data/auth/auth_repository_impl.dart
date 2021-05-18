import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/auth/api/auth_api_data_source.dart';
import 'package:logpass_me/data/auth/api/refresh/refresh_token_dto.dart';
import 'package:logpass_me/data/auth/api/verify/tokens_result_dto.dart';
import 'package:logpass_me/domain/auth/auth_repository.dart';
import 'package:logpass_me/domain/auth/token/user_tokens.dart';

@Singleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthApiDataSource _apiDataSource;
  final UserTokensDTOMapper _userTokensDTOMapper;

  AuthRepositoryImpl(this._apiDataSource, this._userTokensDTOMapper);

  @override
  Future<UserTokens> refreshUserTokens(String refreshToken) async {
    final requestBody = RefreshTokenDTO(refreshToken: refreshToken);
    final refreshedTokens = await _apiDataSource.refreshAccessToken(requestBody);
    return _userTokensDTOMapper(refreshedTokens);
  }
}
