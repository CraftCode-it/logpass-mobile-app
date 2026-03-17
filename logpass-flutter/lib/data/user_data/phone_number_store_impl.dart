import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/user_data/phone_number_database.dart';
import 'package:logpass_me/domain/user_data/phone_number_store.dart';

@Singleton(as: PhoneNumberStore)
class PhoneNumberStoreImpl implements PhoneNumberStore {
  final PhoneNumberDatabase _phoneNumberDatabase;

  PhoneNumberStoreImpl(this._phoneNumberDatabase);

  @override
  Future<void> clear() async {
    await _phoneNumberDatabase.clear();
  }

  @override
  Future<String?> loadNumber() {
    return _phoneNumberDatabase.loadPhoneNumber();
  }

  @override
  Future<void> saveNumber(String phoneNumber) async {
    await _phoneNumberDatabase.savePhoneNumber(phoneNumber);
  }
}
