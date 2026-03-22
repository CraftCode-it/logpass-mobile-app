import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/networking/interceptor_with_dio.dart';
import 'package:logpass_me/domain/auth/auth_exception.dart';
import 'package:logpass_me/domain/auth/logout_service.dart';
import 'package:logpass_me/domain/auth/use_case/get_user_tokens_use_case.dart';
import 'package:logpass_me/domain/auth/use_case/refresh_access_token_use_case.dart';

@Injectable()
class RefreshTokenInterceptor extends InterceptorWithDio {
  final GetUserTokensUseCase _getUserTokensUseCase;
  final RefreshAccessTokenUseCase _refreshAccessTokenUseCase;
  final LogoutService _logoutService;

  RefreshTokenInterceptor(
    this._getUserTokensUseCase,
    this._refreshAccessTokenUseCase,
    this._logoutService,
  );

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response == null) return handler.next(err);

    if (err.response?.statusCode == HttpStatus.unauthorized) {
      try {
        final userToken = await _getUserTokensUseCase();
        final requestAuthHeader = err.requestOptions.headers[HttpHeaders.authorizationHeader];
        final currentAuthHeader = userToken.accessToken.toString();

        if (requestAuthHeader != currentAuthHeader) {
          await _retryRequest(err.requestOptions, handler, currentAuthHeader);
        } else {
          await _refreshAccessTokenAndRetryRequest(err, handler);
        }
      } on AuthExceptionUserNotSignedIn catch (e) {
        Fimber.e('Making requests when user is not signed in.', ex: e);
        await _logoutService.logout();
        return handler.next(DioException(requestOptions: err.requestOptions, error: e, response: err.response));
      } catch (e, s) {
        Fimber.e('Failed to retry unauthorized request.', ex: e, stacktrace: s);
        return handler.next(DioException(requestOptions: err.requestOptions, error: e, response: err.response));
      }
    }

    return handler.next(err);
  }

  Future<void> _refreshAccessTokenAndRetryRequest(DioException err, ErrorInterceptorHandler handler) async {
    try {
      try {
        await _refreshAccessTokenUseCase();
      } on AuthException {
        Fimber.d('Refresh token has expired, logging out.');
        await _logoutService.logout();
        handler.reject(err);
        return;
      }

      final newTokens = await _getUserTokensUseCase();
      final newAuthHeader = newTokens.accessToken.toString();

      await _retryRequest(err.requestOptions, handler, newAuthHeader);
    } catch (e, s) {
      Fimber.w('Refreshing token somehow failed', ex: e, stacktrace: s);
      handler.next(DioException(requestOptions: err.requestOptions, error: e, response: err.response));
    }
  }

  Future<void> _retryRequest(RequestOptions requestOptions, ErrorInterceptorHandler handler, String authHeader) async {
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
