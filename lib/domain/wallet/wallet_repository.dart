import 'package:logpass_me/domain/wallet/credential.dart';

abstract class WalletRepository {
  Future<Credential> requestAgeVerification({
    required String userPubkey,
    int minAge = 18,
    bool forced = false,
  });

  Future<Map<String, dynamic>> generateProof(String verificationId);

  Future<List<Credential>> getStoredCredentials();

  Future<Credential?> getCredential(String id);

  Future<bool> checkServiceHealth();

  Future<Map<String, dynamic>> verifyIdentityMobywatel(String testAccount);

  /// Returns /users/self/ data including identity_verified, dob, first_name, etc.
  Future<Map<String, dynamic>> getUserSelf();
}
