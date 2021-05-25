import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/language/language_store.dart';

@Injectable()
class LanguageInterceptor extends Interceptor {
  final LanguageStore _languageStore;

  LanguageInterceptor(this._languageStore);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final languageCode = await _languageStore.getLanguageCode();
    options.headers[HttpHeaders.acceptLanguageHeader] = languageCode;
  }
}
