import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/theme/theme_brightness.dart';
import 'package:logpass_me/domain/theme/theme_brightness_service.dart';

@Injectable()
class SetThemeBrightnessUseCase {
  final ThemeBrightnessService _themeBrightnessService;

  SetThemeBrightnessUseCase(this._themeBrightnessService);

  Future<void> call(ThemeBrightness brightness) => _themeBrightnessService.setThemeBrightness(brightness);
}
