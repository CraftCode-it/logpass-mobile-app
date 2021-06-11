import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/networking/auth_token_interceptor.dart';
import 'package:logpass_me/data/networking/content_type_interceptor.dart';
import 'package:logpass_me/data/networking/error_interceptor.dart';
import 'package:logpass_me/data/networking/language_interceptor.dart';
import 'package:logpass_me/data/networking/refresh_token_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const mainInterceptors = 'main_interceptors';
const refreshInterceptors = 'refresh_interceptors';

@module
abstract class NetworkModule {
  @prod
  @Injectable()
  @Named(mainInterceptors)
  List<Interceptor> prodMainInterceptors(
    AuthTokenInterceptor authTokenInterceptor,
    RefreshTokenInterceptor refreshTokenInterceptor,
    LanguageInterceptor languageInterceptor,
    ContentTypeInterceptor contentTypeInterceptor,
    ErrorInterceptor errorInterceptor,
  ) =>
      [
        languageInterceptor,
        authTokenInterceptor,
        contentTypeInterceptor,
        refreshTokenInterceptor,
        errorInterceptor,
      ];

  @dev
  @Injectable()
  @Named(mainInterceptors)
  List<Interceptor> devMainInterceptors(
    AuthTokenInterceptor authTokenInterceptor,
    RefreshTokenInterceptor refreshTokenInterceptor,
    LanguageInterceptor languageInterceptor,
    ContentTypeInterceptor contentTypeInterceptor,
    ErrorInterceptor errorInterceptor,
  ) =>
      [
        languageInterceptor,
        authTokenInterceptor,
        _logger,
        contentTypeInterceptor,
        refreshTokenInterceptor,
        errorInterceptor,
      ];

  @prod
  @Injectable()
  @Named(refreshInterceptors)
  List<Interceptor> prodRefreshInterceptors(
    LanguageInterceptor languageInterceptor,
    ContentTypeInterceptor contentTypeInterceptor,
  ) =>
      [
        languageInterceptor,
        contentTypeInterceptor,
      ];

  @dev
  @Injectable()
  @Named(refreshInterceptors)
  List<Interceptor> devRefreshInterceptors(
    LanguageInterceptor languageInterceptor,
    ContentTypeInterceptor contentTypeInterceptor,
  ) =>
      [
        languageInterceptor,
        contentTypeInterceptor,
        _logger,
      ];
}

PrettyDioLogger get _logger => PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      maxWidth: 150,
    );
