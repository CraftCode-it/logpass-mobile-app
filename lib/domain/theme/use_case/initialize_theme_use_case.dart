import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/theme/theme_brightness.dart';
import 'package:logpass_me/domain/theme/theme_brightness_service.dart';

@Injectable()
class InitializeThemeUseCase {
  final ThemeBrightnessService _themeBrightnessService;

  InitializeThemeUseCase(this._themeBrightnessService);

  Future<void> call(ThemeBrightness systemThemeBrightness) => _themeBrightnessService.initialize(systemThemeBrightness);
}
