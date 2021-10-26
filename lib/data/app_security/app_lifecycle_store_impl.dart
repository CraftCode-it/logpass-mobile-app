import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/app_security/app_lifecycle_store.dart';

@LazySingleton(as: AppLifeCycleStore)
class AppLifeCycleStoreImpl implements AppLifeCycleStore {
  int? backgroundTime;

  @override
  Future<void> appSentToBackground() async {
    backgroundTime = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  Future<int?> getAppBackgroundTime() => Future.value(backgroundTime);
}
