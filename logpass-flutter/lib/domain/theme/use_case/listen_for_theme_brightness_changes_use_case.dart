import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/theme/theme_brightness.dart';
import 'package:logpass_me/domain/theme/theme_brightness_service.dart';

@Injectable()
class ListenForThemeBrightnessChangesUseCase {
  final ThemeBrightnessService _themeBrightnessService;

  ListenForThemeBrightnessChangesUseCase(this._themeBrightnessService);

  Stream<ThemeBrightness> call() => _themeBrightnessService.listen();
}
