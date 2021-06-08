import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/core/app_env.dart';
import 'package:logpass_me/core/di/network_module.dart';
import 'package:logpass_me/data/networking/interceptor_with_dio.dart';

@Singleton()
class LogPassDio extends DioMixin implements Dio {
  static const acceptHeaderValue = 'application/vnd.logpass+json';

  LogPassDio(
    AppEnv appEnv,
    List<Interceptor> interceptors,
  ) {
    options = BaseOptions(
      baseUrl: appEnv.apiUrl,
      headers: {
        HttpHeaders.acceptHeader: acceptHeaderValue,
      },
      followRedirects: false,
    );
    httpClientAdapter = DefaultHttpClientAdapter();
    _setupInterceptors(interceptors);
  }

  @factoryMethod
  factory LogPassDio.create(
    AppEnv appEnv,
    @Named(mainInterceptors) List<Interceptor> interceptors,
  ) =>
      LogPassDio(appEnv, interceptors);

  void _setupInterceptors(List<Interceptor> interceptorList) {
    interceptorList.whereType<InterceptorWithDio>().forEach((element) => element.set(this));
    interceptors.addAll(interceptorList);
  }
}

@LazySingleton()
class RefreshTokenDio extends LogPassDio {
  RefreshTokenDio(
    AppEnv appEnv,
    @Named(refreshInterceptors) List<Interceptor> interceptors,
  ) : super(appEnv, interceptors);
}
