import 'package:logpass_me/domain/one_time_code/one_time_code.dart';

abstract class OneTimeCodeRepository {
  Future<void> loadOneTimeCode(bool forceRefresh);

  Stream<OneTimeCode?> listenForOneTimeCode();
}
