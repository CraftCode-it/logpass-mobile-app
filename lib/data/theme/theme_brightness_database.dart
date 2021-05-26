import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton()
class ThemeBrightnessDatabase {
  static const _key = 'themeBrightness';

  final SharedPreferences _sharedPreferences;

  ThemeBrightnessDatabase(this._sharedPreferences);

  Future<void> save(String? value) async {
    if (value != null) {
      await _sharedPreferences.setString(_key, value);
    }
  }

  Future<String?> load() async => _sharedPreferences.getString(_key);
}
