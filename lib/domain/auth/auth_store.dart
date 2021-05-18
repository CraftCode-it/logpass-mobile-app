import 'package:logpass_me/domain/auth/token/user_tokens.dart';

abstract class AuthStore {
  Future<void> saveUserTokens(UserTokens tokens);

  Future<UserTokens?> loadUserTokens();
}
