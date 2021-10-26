import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/app_security/app_lifecycle_store.dart';
import 'package:logpass_me/domain/app_security/app_security_store.dart';
import 'package:logpass_me/domain/app_security/app_security_type.dart';

const _backgroundMaxTimeMilis = 30 * 1000;

@Injectable()
class ShouldLockAppUseCase {
  final AppSecurityStore _appSecurityStore;
  final AppLifeCycleStore _appLifeCycleStore;

  ShouldLockAppUseCase(this._appSecurityStore, this._appLifeCycleStore);

  Future<bool> call() async {
    final securityType = await _appSecurityStore.loadSecurityType();
    if (securityType == AppSecurityType.none) {
      return false;
    }

    final backgroundTime = await _appLifeCycleStore.getAppBackgroundTime();
    if (backgroundTime == null) {
      return true;
    }

    return DateTime.now().millisecondsSinceEpoch - backgroundTime >= _backgroundMaxTimeMilis;
  }
}
