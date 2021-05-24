import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/networking/interceptor_with_dio.dart';
import 'package:logpass_me/domain/auth/auth_exception.dart';
import 'package:logpass_me/domain/auth/forced_logout_service.dart';
import 'package:logpass_me/domain/auth/use_case/get_user_tokens_use_case.dart';
import 'package:logpass_me/domain/auth/use_case/refresh_access_token_use_case.dart';

@Injectable()
class RefreshTokenInterceptor extends InterceptorWithDio {
  final GetUserTokensUseCase _getUserTokensUseCase;
  final RefreshAccessTokenUseCase _refreshAccessTokenUseCase;
  final ForcedLogoutService _forcedLogoutService;

  RefreshTokenInterceptor(
    this._getUserTokensUseCase,
    this._refreshAccessTokenUseCase,
    this._forcedLogoutService,
  );

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response == null) handler.next(err);

    if (err.response?.statusCode == HttpStatus.unauthorized) {
      try {
        dio.lockAll();

        final userToken = await _getUserTokensUseCase();
        final requestAuthHeader = err.requestOptions.headers[HttpHeaders.authorizationHeader];
        final currentAuthHeader = userToken.accessToken.toString();

        if (requestAuthHeader != currentAuthHeader) {
          await _retryRequest(err.requestOptions, handler, currentAuthHeader);
        } else {
          await _refreshAccessTokenAndRetryRequest(err, handler);
        }

        dio.unlockAll();
      } on AuthExceptionUserNotSignedIn catch (e) {
        dio.unlockAll();

        Fimber.e('Making requests when user is not signed in.', ex: e);
        await _forcedLogoutService.logout();
        handler.next(DioError(requestOptions: err.requestOptions, error: e, response: err.response));
      } catch (e, s) {
        dio.unlockAll();

        Fimber.e('Failed to retry unauthorized request.', ex: e, stacktrace: s);
        handler.next(DioError(requestOptions: err.requestOptions, error: e, response: err.response));
      }
    }
  }

  Future<void> _refreshAccessTokenAndRetryRequest(DioError err, ErrorInterceptorHandler handler) async {
    try {
      try {
        await _refreshAccessTokenUseCase();
      } on AuthException {
        Fimber.d('Refresh token has expired, logging out.');
        await _forcedLogoutService.logout();
        handler.reject(err);
      }

      final newTokens = await _getUserTokensUseCase();
      final newAuthHeader = newTokens.accessToken.toString();

      dio.unlockAll();

      await _retryRequest(err.requestOptions, handler, newAuthHeader);
    } catch (e, s) {
      Fimber.w('Refreshing token somehow failed', ex: e, stacktrace: s);
      handler.next(DioError(requestOptions: err.requestOptions, error: e, response: err.response));
    }
  }

  Future<void> _retryRequest(RequestOptions requestOptions, ErrorInterceptorHandler handler, String authHeader) async {
    dio.unlockAll();

    final response = await dio.request(
      requestOptions.path,
      cancelToken: requestOptions.cancelToken,
      data: requestOptions.data,
      onReceiveProgress: requestOptions.onReceiveProgress,
      onSendProgress: requestOptions.onSendProgress,
      queryParameters: requestOptions.queryParameters,
    );

    handler.resolve(response);
  }
}

extension on Dio {
  void lockAll() {
    interceptors.requestLock.lock();
    interceptors.responseLock.lock();
    interceptors.errorLock.lock();
  }

  void unlockAll() {
    interceptors.requestLock.unlock();
    interceptors.responseLock.unlock();
    interceptors.errorLock.unlock();
  }
}
