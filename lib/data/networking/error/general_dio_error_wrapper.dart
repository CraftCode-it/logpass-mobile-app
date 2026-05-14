import 'package:dio/dio.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';

class GeneralDioErrorWrapper extends DioException {
  final GeneralConnectionError connectionError;

  GeneralDioErrorWrapper({
    required this.connectionError,
    required DioException original,
  }) : super(
          requestOptions: original.requestOptions,
          response: original.response,
          error: original.error,
          type: original.type,
        );
}
