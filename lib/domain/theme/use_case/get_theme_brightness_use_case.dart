import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/theme/theme_brightness.dart';
import 'package:logpass_me/domain/theme/theme_brightness_service.dart';

@Injectable()
class GetThemeBrightnessUseCase {
  final ThemeBrightnessService _themeBrightnessService;

  GetThemeBrightnessUseCase(this._themeBrightnessService);

  Future<ThemeBrightness> call() => _themeBrightnessService.get();
}