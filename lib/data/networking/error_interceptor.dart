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
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;

    if (err.type == DioExceptionType.badResponse && response != null) {
      try {
        final dynamic rawData = response.data;
        final Map<String, dynamic> jsonData;
        if (rawData is String) {
          jsonData = jsonDecode(rawData) as Map<String, dynamic>;
        } else if (rawData is Map<String, dynamic>) {
          jsonData = rawData;
        } else {
          return handler.next(err);
        }
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

  bool _isTimeout(DioExceptionType type) {
    return type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.sendTimeout;
  }
}
