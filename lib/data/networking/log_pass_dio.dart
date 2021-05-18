import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/core/app_env.dart';

@Singleton()
class LogPassDio extends DioMixin implements Dio {
  static const acceptHeaderValue = 'application/vnd.logpass+json';

  LogPassDio(AppEnv appEnv, List<Interceptor> interceptorList) {
    options = BaseOptions(
      baseUrl: appEnv.apiUrl,
      headers: {
        HttpHeaders.acceptHeader: acceptHeaderValue,
      },
    );
    interceptors.addAll(interceptorList);
  }
}
