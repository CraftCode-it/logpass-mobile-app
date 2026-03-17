import 'package:hive/hive.dart';
import 'package:logpass_me/data/wallet/wallet_api_data_source.dart';
import 'package:logpass_me/domain/wallet/credential.dart';
import 'package:logpass_me/domain/wallet/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletApiDataSource _api;
  static const _boxName = 'wallet_credentials';

  WalletRepositoryImpl(this._api);

  @override
  Future<Credential> requestAgeVerification({
    required String userPubkey,
    int minAge = 18,
  }) async {
    final resp = await _api.verifyAge(
      userPubkey: userPubkey,
      minAge: minAge,
    );

    final verificationId = resp['verification_id'] as String;
    final status = await _api.getVerificationStatus(verificationId);

    final credential = Credential(
      id: verificationId,
      type: 'age_${minAge}',
      result: status['result'] as bool?,
      validUntil: status['valid_until'] != null
          ? DateTime.parse(status['valid_until'] as String)
          : null,
      commitmentHash: status['commitment_hash'] as String?,
      onChainTxId: status['on_chain_tx_id'] as String?,
      issuedAt: DateTime.now(),
      status: status['status'] as String? ?? 'unknown',
    );

    await _saveCredential(credential);
    return credential;
  }

  @override
  Future<Map<String, dynamic>> generateProof(String verificationId) async {
    return _api.getProof(verificationId);
  }

  @override
  Future<List<Credential>> getStoredCredentials() async {
    final box = await Hive.openBox(_boxName);
    final List<Credential> credentials = [];
    for (final key in box.keys) {
      final map = box.get(key);
      if (map != null) {
        credentials.add(Credential.fromMap(Map<String, dynamic>.from(map as Map)));
      }
    }
    return credentials;
  }

  @override
  Future<Credential?> getCredential(String id) async {
    final box = await Hive.openBox(_boxName);
    final map = box.get(id);
    if (map == null) return null;
    return Credential.fromMap(Map<String, dynamic>.from(map as Map));
  }

  @override
  Future<bool> checkServiceHealth() async {
    try {
      final resp = await _api.getHealth();
      return resp['status'] == 'ok';
    } catch (_) {
      return false;
    }
  }

  Future<void> _saveCredential(Credential credential) async {
    final box = await Hive.openBox(_boxName);
    await box.put(credential.id, credential.toMap());
  }
}
