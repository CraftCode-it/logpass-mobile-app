import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/networking/error/dio_error_wrapper.dart';
import 'package:logpass_me/domain/networking/error/logpass_api_error.dart';

@Injectable()
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    final response = err.response;

    if (err.type == DioErrorType.response && response != null) {
      try {
        final rawData = response.data as String;
        final jsonData = jsonDecode(rawData) as Map<String, dynamic>;
        final logpassApiError = LogpassApiError.fromJson(jsonData);

        return handler.next(
          LogpassDioErrorWrapper(
            logpassApiError: logpassApiError,
            original: err,
          ),
        );
      } catch (e, s) {
        Fimber.e('Parsing response error from API failed.', ex: e, stacktrace: s);
      }
    }

    handler.next(err);
  }
}
