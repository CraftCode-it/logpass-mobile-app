import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/app_security/app_security_store.dart';

@Injectable()
class ValidatePinCodeUseCase {
  final AppSecurityStore _appSecurityStore;

  ValidatePinCodeUseCase(this._appSecurityStore);

  Future<bool> call(String code) => _appSecurityStore.compareCode(code);
}
