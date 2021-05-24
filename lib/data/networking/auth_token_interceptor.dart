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
    try {
      final tokens = await _getUserTokensUseCase();
      options.headers[HttpHeaders.authorizationHeader] = tokens.accessToken.toString();
    } catch (e, s) {
      Fimber.w('Failed adding authorization header to API call.', ex: e, stacktrace: s);
    }

    super.onRequest(options, handler);
  }
}
