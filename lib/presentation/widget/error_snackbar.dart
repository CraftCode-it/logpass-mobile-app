import 'package:easy_localization/easy_localization.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/generated/local_keys.g.dart';

String getConnectionErrorString(GeneralConnectionError error) {
  return error.when(
    noConnection: () => tr(LocaleKeys.error_noConnection),
    timeout: () => tr(LocaleKeys.error_timeout),
    somethingWentWrong: () => tr(LocaleKeys.error_somethingWentWrong),
  );
}
