import 'package:dio/dio.dart';
import 'package:logpass_me/domain/networking/error/logpass_api_error.dart';

class LogpassDioErrorWrapper extends DioError {
  final LogpassApiError logpassApiError;

  LogpassDioErrorWrapper({
    required this.logpassApiError,
    required DioError original,
  }) : super(
          requestOptions: original.requestOptions,
          response: original.response,
          error: original.error,
          type: original.type,
        );
}
