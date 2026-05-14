import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/crypto/data_source/seed_data_ource.dart';

const _boxName = 'logpass_seed_box';
const _seedFieldName = 'logpass_seed_field';
const _secureStorageSeedKey = 'logpass_ed25519_seed';
const _secureStorageMigratedKey = 'logpass_seed_migrated';

@Singleton()
class HiveSeedDataSource implements SeedDataSource {
  final FlutterSecureStorage _secureStorage;

  HiveSeedDataSource(this._secureStorage);

  @override
  Future<Uint8List?> getSeed() async {
    await _migrateIfNeeded();
    final b64 = await _secureStorage.read(key: _secureStorageSeedKey);
    return b64 != null ? base64Decode(b64) : null;
  }

  Future<void> saveSeed(Uint8List seed) async {
    await _secureStorage.write(
      key: _secureStorageSeedKey,
      value: base64Encode(seed),
    );
  }

  Future<void> _migrateIfNeeded() async {
    final migrated = await _secureStorage.read(key: _secureStorageMigratedKey);
    if (migrated == 'true') return;

    try {
      final box = await Hive.openBox<Uint8List>(_boxName);
      final oldSeed = box.get(_seedFieldName);
      if (oldSeed != null) {
        await _secureStorage.write(
          key: _secureStorageSeedKey,
          value: base64Encode(oldSeed),
        );
        await box.delete(_seedFieldName);
      }
      await box.close();
    } catch (_) {}

    await _secureStorage.write(key: _secureStorageMigratedKey, value: 'true');
  }
}
