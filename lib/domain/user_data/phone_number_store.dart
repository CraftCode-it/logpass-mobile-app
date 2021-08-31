import 'package:logpass_me/domain/common/clearable.dart';

abstract class PhoneNumberStore implements Clearable {
  Future<void> saveNumber(String phoneNumber);

  Future<String?> loadNumber();
}
