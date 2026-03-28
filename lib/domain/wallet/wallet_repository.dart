import 'package:logpass_me/domain/wallet/credential.dart';

abstract class WalletRepository {
  Future<Credential> requestAgeVerification({
    required String userPubkey,
    int minAge = 18,
  });

  Future<Map<String, dynamic>> generateProof(String verificationId);

  Future<List<Credential>> getStoredCredentials();

  Future<Credential?> getCredential(String id);

  Future<bool> checkServiceHealth();

  Future<Map<String, dynamic>> verifyIdentityMobywatel(String testAccount);

  Future<String> registerPairingCode();
}
