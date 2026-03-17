import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/bidirectional_data_mapper.dart';
import 'package:logpass_me/domain/theme/theme_brightness.dart';

@Injectable()
class ThemeBrightnessEntityMapper extends BidirectionalDataMapper<ThemeBrightness?, String?> {
  static const _system = 'themeSystem';
  static const _light = 'themeLight';
  static const _dark = 'themeDark';

  final _themeBrightnessEntityMap = {
    ThemeBrightness.system: _system,
    ThemeBrightness.light: _light,
    ThemeBrightness.dark: _dark,
  };

  @override
  String? from(ThemeBrightness? data) => _themeBrightnessEntityMap[data];

  @override
  ThemeBrightness? to(String? data) {
    try {
      final entry = _themeBrightnessEntityMap.entries.firstWhere((element) => element.value == data);
      return entry.key;
    } on StateError {
      return null;
    }
  }
}
