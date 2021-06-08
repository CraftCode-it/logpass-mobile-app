import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/app_security/app_security_store.dart';
import 'package:logpass_me/domain/app_security/app_security_type.dart';

@Injectable()
class GetAppSecurityTypeUseCase {
  final AppSecurityStore _appSecurityStore;

  GetAppSecurityTypeUseCase(this._appSecurityStore);

  Future<AppSecurityType> call() => _appSecurityStore.loadSecurityType();
}
