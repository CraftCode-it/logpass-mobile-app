import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/theme/theme_brightness.dart';
import 'package:logpass_me/domain/theme/theme_brigthness_store.dart';
import 'package:rxdart/rxdart.dart';

@Singleton()
class ThemeBrightnessService {
  final ThemeBrightnessStore _themeBrightnessStore;

  late BehaviorSubject<ThemeBrightness> _themeSubject;
  late ThemeBrightness _systemBrightness;

  ThemeBrightnessService(this._themeBrightnessStore);

  Future<void> initialize(ThemeBrightness systemBrightness) async {
    _systemBrightness = systemBrightness;
    _themeSubject = BehaviorSubject.seeded(_systemBrightness);

    final storedThemeBrightness = await _themeBrightnessStore.load();
    _themeSubject.sink.add(storedThemeBrightness ?? systemBrightness);
  }

  Future<void> setThemeBrightness(ThemeBrightness themeBrightness) async {
    await _themeBrightnessStore.save(themeBrightness);
    _themeSubject.sink.add(themeBrightness);
  }

  Future<ThemeBrightness> get() async => _themeSubject.value;

  Stream<ThemeBrightness> listen() => _themeSubject.stream.distinct();
}
