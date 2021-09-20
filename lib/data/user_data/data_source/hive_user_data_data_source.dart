import 'package:collection/collection.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logpass_me/data/user_data/dto/hive_entity.dart';
import 'package:logpass_me/domain/crypto/crypto_keyh_provider.dart';
import 'package:logpass_me/domain/crypto/crypto_repository.dart';

abstract class HiveUserDataDataSource<T extends HiveEntity<T>> {
  final CryptoKeyProvider keyProvider;

  HiveUserDataDataSource(this.keyProvider);

  String get boxName;

  Future<Box<T>> get _hiveBox => getBox();

  Future create(T input) async {
    return (await _hiveBox).put(input.uuid, input);
  }

  Future delete(String id) async {
    return (await _hiveBox).delete(id);
  }

  Future<List<T>> all() async {
    return (await _hiveBox).values.toList();
  }

  Future update(T input) async {
    return (await _hiveBox).put(input.uuid, input);
  }

  Future<T?> getDefault() async {
    return (await _hiveBox).values.firstWhereOrNull((element) => element.isDefault);
  }

  Future setDefault(T dto) async {
    final box = await _hiveBox;
    final currentDefault = box.values.firstWhereOrNull((element) => element.isDefault);
    if (currentDefault != null) {
      await box.put(currentDefault.uuid, currentDefault.copyWith(isDefault: false));
    }
    return box.put(dto.uuid, dto);
  }

  Future<Box<T>> getBox() async {
    final key = await keyProvider.getKey();
    return Hive.openBox<T>(boxName, encryptionCipher: HiveAesCipher(key));
  }
}
