import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/wallet/wallet_api_data_source.dart';
import 'package:logpass_me/domain/wallet/credential.dart';
import 'package:logpass_me/domain/wallet/wallet_repository.dart';

@Injectable(as: WalletRepository)
class WalletRepositoryImpl implements WalletRepository {
  final WalletApiDataSource _api;
  final FlutterSecureStorage _secureStorage;
  static const _boxName = 'wallet_credentials';
  static const _hiveKeyName = 'hive_encryption_key';
  Box? _cachedBox;

  WalletRepositoryImpl(this._api, this._secureStorage);

  Future<Box> _getBox() async {
    if (_cachedBox != null && _cachedBox!.isOpen) return _cachedBox!;

    var keyBase64 = await _secureStorage.read(key: _hiveKeyName);
    if (keyBase64 == null) {
      final key = Hive.generateSecureKey();
      keyBase64 = base64Encode(key);
      await _secureStorage.write(key: _hiveKeyName, value: keyBase64);
    }
    final keyBytes = base64Decode(keyBase64);

    _cachedBox = await Hive.openBox(
      _boxName,
      encryptionCipher: HiveAesCipher(keyBytes),
    );
    return _cachedBox!;
  }

  @override
  Future<Credential> requestAgeVerification({
    required String userPubkey,
    int minAge = 18,
    bool forced = false,
  }) async {
    // Pobranie user_id z backendu — przekazane do verify_age aby uzyl realnego DOB
    String? userId;
    try {
      final self = await getUserSelf();
      userId = self['id'] as String?;
    } catch (_) {}

    final resp = await _api.verifyAge(
      userPubkey: userPubkey,
      minAge: minAge,
      userId: userId,
    );

    final verificationId = resp['verification_id'] as String;
    final status = await _api.getVerificationStatus(verificationId);

    final serverResult = status['result'] as bool?;
    final isUnderAge = serverResult == false;
    final credential = Credential(
      id: verificationId,
      type: 'age_$minAge',
      result: serverResult,
      validUntil: status['valid_until'] != null
          ? DateTime.parse(status['valid_until'] as String)
          : null,
      commitmentHash: status['commitment_hash'] as String?,
      onChainTxId: status['on_chain_tx_id'] as String?,
      issuedAt: DateTime.now(),
      status: status['status'] as String? ?? 'unknown',
      forced: forced || isUnderAge,
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
    final box = await _getBox();
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
    final box = await _getBox();
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

  @override
  Future<Map<String, dynamic>> getUserSelf() async {
    return _api.getUserSelf();
  }

  @override
  Future<Map<String, dynamic>> verifyIdentityMobywatel(String testAccount) async {
    final data = await _api.verifyIdentityMobywatel(testAccount: testAccount);
    final addressRaw = data['address'];
    final address = (addressRaw is Map)
        ? Map<String, dynamic>.from(addressRaw)
        : null;
    final result = {
      'dob_verified': data['dob_verified'] == true,
      'dob': data['dob'] as String? ?? '',
      'first_name': data['first_name'] as String? ?? '',
      'last_name': data['last_name'] as String? ?? '',
      'pesel_masked': data['pesel_masked'] as String? ?? '',
      'address': address,
      'identity_verified': data['dob_verified'] == true,
    };
    return result;
  }

  @override
  Future<Map<String, dynamic>> fulfillRequest({
    required String requestId,
    required String zkProof,
    required List<String> zkPublicInputs,
    String? userId,
    String? profileId,
  }) async {
    return _api.fulfillRequest(
      requestId: requestId,
      zkProof: zkProof,
      zkPublicInputs: zkPublicInputs,
      userId: userId,
      profileId: profileId,
    );
  }

  @override
  Future<Map<String, dynamic>> fulfillIdentityRequest({
    required String requestId,
    String? userId,
    String? profileId,
  }) async {
    return _api.fulfillIdentityRequest(
      requestId: requestId,
      userId: userId,
      profileId: profileId,
    );
  }

  @override
  Future<String> registerPairingCode() async {
    final resp = await _api.registerPairingCode();
    return resp['code'] as String? ?? resp['pairing_code'] as String? ?? '';
  }

  Future<void> _saveCredential(Credential credential) async {
    final box = await _getBox();
    await box.put(credential.type, credential.toMap());
  }
}
