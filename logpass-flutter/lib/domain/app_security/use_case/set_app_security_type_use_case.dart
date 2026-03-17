import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/app_security/app_security_store.dart';
import 'package:logpass_me/domain/app_security/app_security_type.dart';

@Injectable()
class SetAppSecurityTypeUseCase {
  final AppSecurityStore _appSecurityStore;

  SetAppSecurityTypeUseCase(this._appSecurityStore);

  Future<void> call(AppSecurityType type) => _appSecurityStore.saveSecurityType(type);
}
