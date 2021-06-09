import 'package:logpass_me/data/common/data_mapper.dart';
import 'package:logpass_me/data/networking/error/general_dio_error_wrapper.dart';
import 'package:logpass_me/data/networking/error/logpass_dio_error_wrapper.dart';
import 'package:logpass_me/domain/networking/error/logpass_api_error.dart';

Future<R> callWithDioErrorResolver<R, E extends Object>(
  Future<R> Function() request, {
  DataMapper<LogpassApiError, E>? logpassApiErrorMapper,
}) async {
  try {
    return await request();
  } on LogpassDioErrorWrapper catch (e) {
    throw logpassApiErrorMapper?.call(e.logpassApiError) ?? e.logpassApiError;
  } on GeneralDioErrorWrapper catch (e) {
    throw e.connectionError;
  }
}
