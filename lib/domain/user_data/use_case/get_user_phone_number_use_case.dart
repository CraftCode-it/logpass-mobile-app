import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/phone_number_store.dart';

@Injectable()
class GetUserPhoneNumberUseCase {
  final PhoneNumberStore _store;

  const GetUserPhoneNumberUseCase(this._store);

  Future<String?> call() => _store.loadNumber();
}
