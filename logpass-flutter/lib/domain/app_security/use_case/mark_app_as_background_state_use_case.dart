import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/app_security/app_lifecycle_store.dart';

@Injectable()
class MarkAppAsBackgroundStateUseCase {
  final AppLifeCycleStore _appLifeCycleStore;

  MarkAppAsBackgroundStateUseCase(this._appLifeCycleStore);

  Future<void> call() => _appLifeCycleStore.appSentToBackground();
}
