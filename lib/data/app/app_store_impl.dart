import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/app/storage/app_database.dart';
import 'package:logpass_me/domain/app/app_store.dart';

@Singleton(as: AppStore)
class AppStoreImpl implements AppStore {
  final AppDatabase _appDatabase;

  AppStoreImpl(this._appDatabase);

  @override
  Future<bool> isFirstRun() async {
    return await _appDatabase.isFirstRun() ?? true;
  }

  @override
  Future<void> markFirstRun() => _appDatabase.markFirstRun();
}