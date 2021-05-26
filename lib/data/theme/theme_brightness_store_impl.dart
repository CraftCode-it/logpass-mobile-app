import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/theme/theme_brightness_database.dart';
import 'package:logpass_me/data/theme/theme_brightness_entity_mapper.dart';
import 'package:logpass_me/domain/theme/theme_brightness.dart';
import 'package:logpass_me/domain/theme/theme_brigthness_store.dart';

@LazySingleton(as: ThemeBrightnessStore)
class ThemeBrightnessStoreImpl implements ThemeBrightnessStore {
  final ThemeBrightnessDatabase _database;
  final ThemeBrightnessEntityMapper _mapper;

  ThemeBrightnessStoreImpl(this._database, this._mapper);

  @override
  Future<ThemeBrightness?> load() async {
    final entity = await _database.load();
    return _mapper.to(entity);
  }

  @override
  Future<void> save(ThemeBrightness themeBrightness) async {
    final entity = _mapper.from(themeBrightness);
    await _database.save(entity);
  }
}
