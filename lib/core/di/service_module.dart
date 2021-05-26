import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/theme/theme_brightness_service.dart';
import 'package:logpass_me/domain/theme/theme_brigthness_store.dart';

@module
abstract class ServiceModule {
  @preResolve
  Future<ThemeBrightnessService> getThemeBrightnessService(ThemeBrightnessStore store) =>
      ThemeBrightnessService.create(store);
}
