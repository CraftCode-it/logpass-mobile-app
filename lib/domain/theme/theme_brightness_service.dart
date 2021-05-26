import 'package:logpass_me/domain/theme/theme_brightness.dart';
import 'package:logpass_me/domain/theme/theme_brigthness_store.dart';
import 'package:rxdart/rxdart.dart';

class ThemeBrightnessService {
  final ThemeBrightnessStore _themeBrightnessStore;

  late BehaviorSubject<ThemeBrightness> _themeSubject;

  ThemeBrightnessService._(this._themeBrightnessStore);

  static Future<ThemeBrightnessService> create(ThemeBrightnessStore store) async {
    final service = ThemeBrightnessService._(store);
    await service._initialize();
    return service;
  }

  Future<void> _initialize() async {
    final storedThemeBrightness = await _themeBrightnessStore.load() ?? ThemeBrightness.system;
    _themeSubject = BehaviorSubject.seeded(storedThemeBrightness);
  }

  Future<void> setThemeBrightness(ThemeBrightness themeBrightness) async {
    await _themeBrightnessStore.save(themeBrightness);
    _themeSubject.sink.add(themeBrightness);
  }

  Future<ThemeBrightness> get() async => _themeSubject.value;

  Stream<ThemeBrightness> listen() => _themeSubject.stream.distinct();
}
