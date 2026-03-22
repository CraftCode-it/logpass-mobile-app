import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@injectable
class WalletApiKeyInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  static const _apiKeyStorageKey = 'logpass_api_key';

  WalletApiKeyInterceptor(this._storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final apiKey = await _storage.read(key: _apiKeyStorageKey);
    if (apiKey != null) {
      options.headers['X-API-Key'] = apiKey;
    }
    handler.next(options);
  }

  Future<void> setApiKey(String apiKey) async {
    await _storage.write(key: _apiKeyStorageKey, value: apiKey);
  }
}
