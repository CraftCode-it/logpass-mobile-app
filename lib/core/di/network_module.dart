import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/networking/auth_token_interceptor.dart';
import 'package:logpass_me/data/networking/refresh_token_interceptor.dart';

@module
abstract class NetworkModule {
  @dev
  List<Interceptor> getDevInterceptors(
    AuthTokenInterceptor authTokenInterceptor,
    RefreshTokenInterceptor refreshTokenInterceptor,
  ) =>
      [
        authTokenInterceptor,
        refreshTokenInterceptor,
        LogInterceptor(logPrint: (object) => Fimber.d(object.toString())),
      ];

  @prod
  List<Interceptor> getProdInterceptors(
    AuthTokenInterceptor authTokenInterceptor,
    RefreshTokenInterceptor refreshTokenInterceptor,
  ) =>
      [
        authTokenInterceptor,
        refreshTokenInterceptor,
      ];
}
