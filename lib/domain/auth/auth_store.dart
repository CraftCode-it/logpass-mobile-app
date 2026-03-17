import 'package:logpass_me/domain/auth/token/user_tokens.dart';
import 'package:logpass_me/domain/common/clearable.dart';

abstract class AuthStore implements Clearable {
  Future<void> saveUserTokens(UserTokens tokens);

  Future<UserTokens?> loadUserTokens();
}
