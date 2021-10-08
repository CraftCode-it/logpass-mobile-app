import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/crypto/data_source/seed_data_ource.dart';

const _boxName = "logpass_seed_box";
const _seedFieldName = "logpass_seed_field";

@Singleton()
class HiveSeedDataSource implements SeedDataSource {
  @override
  Future<Uint8List?> getSeed() async {
    final box = await Hive.openBox<Uint8List>(_boxName);
    return box.get(_seedFieldName);
  }

  Future<void> saveSeed(Uint8List seed) async {
    final box = await Hive.openBox<Uint8List>(_boxName);
    await box.delete(_seedFieldName);
    await box.put(_seedFieldName, seed);
  }
}
