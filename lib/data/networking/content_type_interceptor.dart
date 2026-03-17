import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/networking/log_pass_dio.dart';

@Injectable()
class ContentTypeInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final contentType = response.headers.map[Headers.contentTypeHeader];
    if (contentType?.join('') == LogPassDio.acceptHeaderValue) {
      final rawResponse = response.data;

      if (rawResponse is String) {
        response.data = jsonDecode(rawResponse);
      }
    }

    super.onResponse(response, handler);
  }
}
