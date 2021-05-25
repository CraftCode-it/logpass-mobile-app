import 'package:logpass_me/domain/theme/theme_brightness.dart';

abstract class ThemeBrightnessStore {
  Future<void> save(ThemeBrightness themeBrightness);

  Future<ThemeBrightness?> load();
}
