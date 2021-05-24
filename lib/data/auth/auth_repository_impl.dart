import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/auth/api/refresh/refresh_token_dto.dart';
import 'package:logpass_me/data/auth/api/refresh_token_api_data_source.dart';
import 'package:logpass_me/data/auth/api/verify/tokens_result_dto.dart';
import 'package:logpass_me/domain/auth/auth_exception.dart';
import 'package:logpass_me/domain/auth/auth_repository.dart';
import 'package:logpass_me/domain/auth/token/user_tokens.dart';

@Singleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final RefreshTokenApiDataSource _refreshTokenApiDataSource;
  final UserTokensDTOMapper _userTokensDTOMapper;

  AuthRepositoryImpl(this._refreshTokenApiDataSource, this._userTokensDTOMapper);

  @override
  Future<UserTokens> refreshUserTokens(String refreshToken) async {
    final requestBody = RefreshTokenDTO(refreshToken: refreshToken);

    try {
      final refreshedTokens = await _refreshTokenApiDataSource.refreshAccessToken(requestBody);
      return _userTokensDTOMapper(refreshedTokens);
    } on DioError catch (e) {
      if (e.response?.statusCode == HttpStatus.badRequest) {
        throw AuthException.refreshTokenExpired();
      }
      rethrow;
    }
  }
}
