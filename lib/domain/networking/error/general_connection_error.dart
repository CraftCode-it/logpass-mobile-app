import 'package:freezed_annotation/freezed_annotation.dart';

part 'general_connection_error.freezed.dart';

@freezed
class GeneralConnectionError with _$GeneralConnectionError {
  factory GeneralConnectionError.noConnection() = _GeneralConnectionErrorNoConnection;

  factory GeneralConnectionError.timeout() = _GeneralConnectionErrorTimeout;

  factory GeneralConnectionError.somethingWentWrong() = _GeneralConnectionErrorSomethingWentWrong;
}
