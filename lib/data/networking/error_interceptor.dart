import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/networking/error/general_dio_error_wrapper.dart';
import 'package:logpass_me/data/networking/error/logpass_dio_error_wrapper.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
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

    if (err.error is SocketException) {
      return handler.next(
        GeneralDioErrorWrapper(
          connectionError: GeneralConnectionError.noConnection(),
          original: err,
        ),
      );
    }

    if (_isTimeout(err.type)) {
      return handler.next(
        GeneralDioErrorWrapper(
          connectionError: GeneralConnectionError.timeout(),
          original: err,
        ),
      );
    }

    handler.next(err);
  }

  bool _isTimeout(DioErrorType type) {
    return type == DioErrorType.receiveTimeout ||
        type == DioErrorType.connectTimeout ||
        type == DioErrorType.sendTimeout;
  }
}
