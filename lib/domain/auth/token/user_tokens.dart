import 'package:logpass_me/domain/auth/token/access_token.dart';

class UserTokens {
  final AccessToken accessToken;
  final String refreshToken;

  UserTokens({
    required this.accessToken,
    required this.refreshToken,
  });
}