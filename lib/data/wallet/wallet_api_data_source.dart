import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/core/di/network_module.dart';

@injectable
class WalletApiDataSource {
  final Dio _dio;

  WalletApiDataSource(@Named(walletDio) this._dio);

  Future<Map<String, dynamic>> verifyAge({
    required String userPubkey,
    String source = 'mock',
    int minAge = 18,
  }) async {
    final response = await _dio.post(
      'verify/age',
      data: {
        'user_pubkey': userPubkey,
        'source': source,
        'min_age': minAge,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getVerificationStatus(String verificationId) async {
    final response = await _dio.get('verify/$verificationId/status');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getProof(String verificationId) async {
    final response = await _dio.get('verify/$verificationId/proof');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getIssuerPubkey() async {
    final response = await _dio.get('issuer/pubkey');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getHealth() async {
    final response = await _dio.get('health');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> fulfillRequest({
    required String requestId,
    required String zkProof,
    required List<String> zkPublicInputs,
  }) async {
    final response = await _dio.post(
      'verifier/fulfill/$requestId',
      data: {
        'zk_proof': zkProof,
        'zk_public_inputs': zkPublicInputs,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getVerifierRequestStatus(String requestId) async {
    final response = await _dio.get('verifier/request/$requestId');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> verifyIdentityMobywatel({
    required String testAccount,
  }) async {
    final response = await _dio.post(
      'users/self/verifications/',
      data: {'provider': 'mobywatel_mock', 'test_account': testAccount},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> registerPairingCode() async {
    final response = await _dio.post('auth/pairing/register');
    return response.data as Map<String, dynamic>;
  }
}
