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
    String? userId,
  }) async {
    final response = await _dio.post(
      'verifier/fulfill/$requestId',
      data: {
        'zk_proof': zkProof,
        'zk_public_inputs': zkPublicInputs,
        if (userId != null) 'user_id': userId,
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

  Future<Map<String, dynamic>> getUserSelf() async {
    final response = await _dio.get('users/self/');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> fulfillIdentityRequest({
    required String requestId,
    String? userId,
  }) async {
    final response = await _dio.post(
      'verifier/fulfill/$requestId',
      data: {
        'zk_proof': '',
        'zk_public_inputs': <String>[],
        if (userId != null) 'user_id': userId,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> registerPairingCode() async {
    final response = await _dio.post('auth/pairing/register');
    return response.data as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getUserServices() async {
    final response = await _dio.get('users/self/services');
    final body = response.data as Map<String, dynamic>? ?? {};
    final list = body['data'] as List? ?? [];
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<List<Map<String, dynamic>>> getUserActivity({String? service, int offset = 0, int limit = 20}) async {
    final response = await _dio.get(
      'users/self/activity',
      queryParameters: {
        if (service != null) 'service': service,
        'offset': offset,
        'limit': limit,
      },
    );
    final body = response.data as Map<String, dynamic>? ?? {};
    final list = body['data'] as List? ?? [];
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<void> postUserActivity({
    required String serviceName,
    required String actionType,
    Map<String, dynamic>? details,
  }) async {
    await _dio.post(
      'users/self/activity',
      data: {
        'service_name': serviceName,
        'action_type': actionType,
        if (details != null) 'details': details,
      },
    );
  }

  Future<Map<String, dynamic>> requestGuardian({required String guardianUserId, String? relationshipType}) async {
    final response = await _dio.post(
      'auth/guardians/request',
      data: {
        'guardian_user_id': guardianUserId,
        if (relationshipType != null) 'relationship_type': relationshipType,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> confirmGuardian(String guardianRequestId) async {
    await _dio.post('auth/guardians/$guardianRequestId/confirm');
  }

  Future<void> rejectGuardian(String guardianRequestId) async {
    await _dio.post('auth/guardians/$guardianRequestId/reject');
  }

  Future<Map<String, dynamic>> getUserGuardians() async {
    final response = await _dio.get('users/self/guardians');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> requestAuthorization({
    required String guardianId,
    required String serviceName,
    required String action,
  }) async {
    final response = await _dio.post(
      'auth/authorization/request',
      data: {
        'guardian_id': guardianId,
        'service_name': serviceName,
        'action': action,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> approveAuthorization(String authRequestId) async {
    await _dio.post('auth/authorization/$authRequestId/approve');
  }

  Future<void> rejectAuthorization(String authRequestId) async {
    await _dio.post('auth/authorization/$authRequestId/reject');
  }

  Future<Map<String, dynamic>> pollAuthorization(String authRequestId) async {
    final response = await _dio.get('auth/authorization/$authRequestId');
    return response.data as Map<String, dynamic>;
  }

}
