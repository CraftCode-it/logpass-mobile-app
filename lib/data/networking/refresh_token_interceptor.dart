import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class RefreshTokenInterceptor extends Interceptor {


  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response == null) handler.next(err);

    if (err.response?.statusCode == HttpStatus.unauthorized) {

    }

    super.onError(err, handler);
  }
}
