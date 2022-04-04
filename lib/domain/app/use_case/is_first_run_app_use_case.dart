import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/app/app_store.dart';

@Injectable()
class IsFirstRunAppUseCase {
  final AppStore _appStore;

  IsFirstRunAppUseCase(this._appStore);

  Future<bool> call() async {
    final isFirstRun = await _appStore.isFirstRun();

    if(isFirstRun) {
      await _appStore.markFirstRun();
    }

    return isFirstRun;
  }
}