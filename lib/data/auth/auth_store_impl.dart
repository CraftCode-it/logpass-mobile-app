import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/auth/storage/auth_secure_database.dart';
import 'package:logpass_me/data/auth/storage/user_tokens_entity.dart';
import 'package:logpass_me/domain/auth/auth_store.dart';
import 'package:logpass_me/domain/auth/token/user_tokens.dart';

@Singleton(as: AuthStore)
class AuthStoreImpl implements AuthStore {
  final AuthSecureDatabase _authSecureDatabase;
  final UserTokensEntityMapper _userTokensEntityMapper;

  AuthStoreImpl(this._authSecureDatabase, this._userTokensEntityMapper);

  @override
  Future<UserTokens?> loadUserTokens() async {
    await _authSecureDatabase.clear();
    final entity = await _authSecureDatabase.loadTokens();

    if (entity == null) return null;

    return _userTokensEntityMapper.to(entity);
  }

  @override
  Future<void> saveUserTokens(UserTokens tokens) async {
    final entity = _userTokensEntityMapper.from(tokens);
    await _authSecureDatabase.saveTokens(entity);
  }
}
