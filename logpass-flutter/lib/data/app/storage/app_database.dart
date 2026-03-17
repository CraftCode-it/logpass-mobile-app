import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Singleton()
class AppDatabase {
  static const _FIRST_RUN_KEY = 'first_run';

  final SharedPreferences _sharedPreferences;

  AppDatabase(this._sharedPreferences);

  Future<void> markFirstRun() async {
    await _sharedPreferences.setBool(_FIRST_RUN_KEY, false);
  }

  Future<bool?> isFirstRun() async => _sharedPreferences.getBool(_FIRST_RUN_KEY);
}