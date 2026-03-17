import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/app_security/app_security_store.dart';

@Injectable()
class SavePinCodeUseCase {
  final AppSecurityStore _appSecurityStore;

  SavePinCodeUseCase(this._appSecurityStore);

  Future<void> call(String code) => _appSecurityStore.saveCode(code);
}