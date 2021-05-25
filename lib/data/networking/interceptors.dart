import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/networking/auth_token_interceptor.dart';
import 'package:logpass_me/data/networking/language_interceptor.dart';
import 'package:logpass_me/data/networking/refresh_token_interceptor.dart';

abstract class InterceptorListContainer {
  List<Interceptor> get list;
}

@Injectable()
class LogPassInterceptors implements InterceptorListContainer {
  @override
  final List<Interceptor> list;

  LogPassInterceptors._(this.list);

  @prod
  @factoryMethod
  factory LogPassInterceptors.prod(
    AuthTokenInterceptor authTokenInterceptor,
    RefreshTokenInterceptor refreshTokenInterceptor,
    LanguageInterceptor languageInterceptor,
  ) =>
      LogPassInterceptors._(
        [
          languageInterceptor,
          authTokenInterceptor,
          refreshTokenInterceptor,
        ],
      );

  @dev
  @factoryMethod
  factory LogPassInterceptors.dev(
    AuthTokenInterceptor authTokenInterceptor,
    RefreshTokenInterceptor refreshTokenInterceptor,
    LanguageInterceptor languageInterceptor,
  ) =>
      LogPassInterceptors._(
        [
          languageInterceptor,
          authTokenInterceptor,
          LogInterceptor(logPrint: (object) => Fimber.d(object.toString())),
          refreshTokenInterceptor,
        ],
      );
}

@Injectable()
class RefreshTokenInterceptors implements InterceptorListContainer {
  @override
  final List<Interceptor> list;

  RefreshTokenInterceptors._(this.list);

  @prod
  @factoryMethod
  factory RefreshTokenInterceptors.prod() => RefreshTokenInterceptors._([]);

  @dev
  @factoryMethod
  factory RefreshTokenInterceptors.dev() => RefreshTokenInterceptors._(
        [
          LogInterceptor(logPrint: (object) => Fimber.d(object.toString())),
        ],
      );
}
