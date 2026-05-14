import 'package:dio/dio.dart';
import 'package:logpass_me/domain/networking/error/logpass_api_error.dart';

class LogpassDioErrorWrapper extends DioException {
  final LogpassApiError logpassApiError;

  LogpassDioErrorWrapper({
    required this.logpassApiError,
    required DioException original,
  }) : super(
          requestOptions: original.requestOptions,
          response: original.response,
          error: original.error,
          type: original.type,
        );
}
