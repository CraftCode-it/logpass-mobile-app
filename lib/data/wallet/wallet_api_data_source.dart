import 'package:dio/dio.dart';

class WalletApiDataSource {
  final Dio _dio;

  WalletApiDataSource(this._dio);

  Future<Map<String, dynamic>> verifyAge({
    required String userPubkey,
    String source = 'mock',
    int minAge = 18,
  }) async {
    final response = await _dio.post(
      '/verify/age',
      data: {
        'user_pubkey': userPubkey,
        'source': source,
        'min_age': minAge,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getVerificationStatus(String verificationId) async {
    final response = await _dio.get('/verify/$verificationId/status');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getProof(String verificationId) async {
    final response = await _dio.get('/verify/$verificationId/proof');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getIssuerPubkey() async {
    final response = await _dio.get('/issuer/pubkey');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getHealth() async {
    final response = await _dio.get('/health');
    return response.data as Map<String, dynamic>;
  }
}
