import 'package:dio/dio.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';

class GeneralDioErrorWrapper extends DioError {
  final GeneralConnectionError connectionError;

  GeneralDioErrorWrapper({
    required this.connectionError,
    required DioError original,
  }) : super(
          requestOptions: original.requestOptions,
          response: original.response,
          error: original.error,
          type: original.type,
        );
}
