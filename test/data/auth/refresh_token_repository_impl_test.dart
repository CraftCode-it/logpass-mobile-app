import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/data/auth/api/refresh/refresh_token_dto.dart';
import 'package:logpass_me/data/auth/api/refresh_token_api_data_source.dart';
import 'package:logpass_me/data/auth/api/verify/tokens_result_dto.dart';
import 'package:logpass_me/data/auth/refresh_token_repository_impl.dart';
import 'package:logpass_me/domain/auth/auth_exception.dart';
import 'package:logpass_me/domain/auth/token/user_tokens.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'refresh_token_repository_impl_test.mocks.dart';

class FakeTokensResultDTO extends Fake implements TokensResultDTO {}

class FakeUserTokens extends Fake implements UserTokens {}

@GenerateMocks(
  [
    RefreshTokenApiDataSource,
    UserTokensDTOMapper,
  ],
)
void main() {
  late MockRefreshTokenApiDataSource refreshTokenApiDataSource;
  late MockUserTokensDTOMapper userTokensDTOMapper;
  late RefreshTokenRepositoryImpl refreshTokenRepositoryImpl;

  setUp(() {
    refreshTokenApiDataSource = MockRefreshTokenApiDataSource();
    userTokensDTOMapper = MockUserTokensDTOMapper();
    refreshTokenRepositoryImpl = RefreshTokenRepositoryImpl(refreshTokenApiDataSource, userTokensDTOMapper);
  });

  group('refreshUserTokens', () {
    test('returns refreshed tokens on success', () async {
      const refreshToken = 'abcd0123';

      final request = RefreshTokenDTO(refreshToken: refreshToken);
      final result = FakeTokensResultDTO();
      final expected = FakeUserTokens();

      when(refreshTokenApiDataSource.refreshAccessToken(request)).thenAnswer((realInvocation) async => result);
      when(userTokensDTOMapper(result)).thenAnswer((realInvocation) => expected);

      final actual = await refreshTokenRepositoryImpl.refreshUserTokens(refreshToken);

      expect(actual, expected);
    });

    test('throws expired error when API call finishes with code 400', () async {
      const refreshToken = 'abcd0123';

      final request = RefreshTokenDTO(refreshToken: refreshToken);
      final apiError = DioError(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
        ),
      );

      when(refreshTokenApiDataSource.refreshAccessToken(request)).thenAnswer((realInvocation) => throw apiError);

      expect(
        refreshTokenRepositoryImpl.refreshUserTokens(refreshToken),
        throwsA(isA<AuthExceptionRefreshTokenExpired>()),
      );
    });

    test('throws error when API call fails', () async {
      const refreshToken = 'abcd0123';

      final request = RefreshTokenDTO(refreshToken: refreshToken);
      final apiError = DioError(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 401,
        ),
      );

      when(refreshTokenApiDataSource.refreshAccessToken(request)).thenAnswer((realInvocation) => throw apiError);

      expect(
        refreshTokenRepositoryImpl.refreshUserTokens(refreshToken),
        throwsA(apiError),
      );
    });
  });
}
