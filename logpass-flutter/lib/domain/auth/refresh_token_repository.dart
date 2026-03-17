import 'package:logpass_me/domain/auth/token/user_tokens.dart';

abstract class RefreshTokenRepository {
  Future<UserTokens> refreshUserTokens(String refreshToken);
}
