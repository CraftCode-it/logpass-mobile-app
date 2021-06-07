import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/data/auth/auth_store_impl.dart';
import 'package:logpass_me/data/auth/storage/auth_secure_database.dart';
import 'package:logpass_me/data/auth/storage/user_tokens_entity.dart';
import 'package:logpass_me/domain/auth/token/user_tokens.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_store_impl_test.mocks.dart';

class FakeUserTokensEntity extends Fake implements UserTokensEntity {}

class FakeUserTokens extends Fake implements UserTokens {}

@GenerateMocks(
  [
    AuthSecureDatabase,
    UserTokensEntityMapper,
  ],
)
void main() {
  late AuthSecureDatabase authSecureDatabase;
  late UserTokensEntityMapper userTokensEntityMapper;
  late AuthStoreImpl authStoreImpl;

  setUp(() {
    authSecureDatabase = MockAuthSecureDatabase();
    userTokensEntityMapper = MockUserTokensEntityMapper();
    authStoreImpl = AuthStoreImpl(authSecureDatabase, userTokensEntityMapper);
  });

  group('loadUserTokens', () {
    test('returns null when database is empty', () async {
      when(authSecureDatabase.loadTokens()).thenAnswer((realInvocation) async => null);

      final actual = await authStoreImpl.loadUserTokens();

      expect(actual, null);
    });

    test('returns tokens when database is not empty', () async {
      final entity = FakeUserTokensEntity();
      final expected = FakeUserTokens();

      when(authSecureDatabase.loadTokens()).thenAnswer((realInvocation) async => entity);
      when(userTokensEntityMapper.to(entity)).thenAnswer((realInvocation) => expected);

      final actual = await authStoreImpl.loadUserTokens();

      expect(actual, expected);
    });
  });

  group('saveUserTokens', () {
    test('saves mapped tokens to database', () async {
      final tokens = FakeUserTokens();
      final entity = FakeUserTokensEntity();

      when(userTokensEntityMapper.from(tokens)).thenAnswer((realInvocation) => entity);
      when(authSecureDatabase.saveTokens(entity)).thenAnswer((realInvocation) async {});

      await authStoreImpl.saveUserTokens(tokens);

      verify(authSecureDatabase.saveTokens(entity));
    });
  });
}
