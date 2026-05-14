import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/auth/use_case/get_user_tokens_use_case.dart';

@Injectable()
class AuthTokenInterceptor extends Interceptor {
  final GetUserTokensUseCase _getUserTokensUseCase;

  AuthTokenInterceptor(this._getUserTokensUseCase);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (_isForbidden(options)) {
      return super.onRequest(options, handler);
    }

    try {
      final tokens = await _getUserTokensUseCase();
      options.headers[HttpHeaders.authorizationHeader] = tokens.accessToken.toAuthorizationHeader();
    } catch (e, s) {
      Fimber.w('Failed adding authorization header to API call.', ex: e, stacktrace: s);
    }

    super.onRequest(options, handler);
  }

  bool _isForbidden(RequestOptions options) {
    for (final forbiddenPath in _forbiddenRequestList) {
      if (options.uri.path.contains(forbiddenPath)) {
        return true;
      }
    }

    return false;
  }
}

const _forbiddenRequestList = [
  '/auth/users/login-attempts/',
];
