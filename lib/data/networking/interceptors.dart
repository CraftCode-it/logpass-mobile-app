import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/networking/auth_token_interceptor.dart';
import 'package:logpass_me/data/networking/content_type_interceptor.dart';
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
    ContentTypeInterceptor contentTypeInterceptor,
  ) =>
      LogPassInterceptors._(
        [
          languageInterceptor,
          authTokenInterceptor,
          contentTypeInterceptor,
          refreshTokenInterceptor,
        ],
      );

  @dev
  @factoryMethod
  factory LogPassInterceptors.dev(
    AuthTokenInterceptor authTokenInterceptor,
    RefreshTokenInterceptor refreshTokenInterceptor,
    LanguageInterceptor languageInterceptor,
    ContentTypeInterceptor contentTypeInterceptor,
  ) =>
      LogPassInterceptors._(
        [
          languageInterceptor,
          authTokenInterceptor,
          LogInterceptor(),
          contentTypeInterceptor,
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
  factory RefreshTokenInterceptors.prod(
    LanguageInterceptor languageInterceptor,
    ContentTypeInterceptor contentTypeInterceptor,
  ) =>
      RefreshTokenInterceptors._(
        [
          languageInterceptor,
          contentTypeInterceptor,
        ],
      );

  @dev
  @factoryMethod
  factory RefreshTokenInterceptors.dev(
    LanguageInterceptor languageInterceptor,
    ContentTypeInterceptor contentTypeInterceptor,
  ) =>
      RefreshTokenInterceptors._(
        [
          languageInterceptor,
          contentTypeInterceptor,
          LogInterceptor(),
        ],
      );
}
