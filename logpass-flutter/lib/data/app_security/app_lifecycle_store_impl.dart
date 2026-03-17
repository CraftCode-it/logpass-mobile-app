import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/app_security/app_lifecycle_store.dart';

@LazySingleton(as: AppLifeCycleStore)
class AppLifeCycleStoreImpl implements AppLifeCycleStore {
  int? backgroundTime;
  bool? inBackground;

  @override
  Future<void> appSentToBackground() async {
    backgroundTime = DateTime.now().millisecondsSinceEpoch;
    inBackground = true;
  }

  @override
  Future<int?> getAppBackgroundTime() {
    inBackground = false;
    return Future.value(backgroundTime);
  }

  @override
  Future<bool?> wasInBackground() => Future.value(inBackground);
}
