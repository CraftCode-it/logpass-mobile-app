import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/phone_number_store.dart';

@Injectable()
class SaveUserPhoneNumberUseCase {
  final PhoneNumberStore _store;

  const SaveUserPhoneNumberUseCase(this._store);

  Future<void> call(String phoneNumber) => _store.saveNumber(phoneNumber);
}
