import 'package:collection/collection.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logpass_me/data/user_data/entity/hive_entity.dart';
import 'package:logpass_me/domain/crypto/crypto_key_provider.dart';
import 'package:logpass_me/domain/user_data/exception/duplicated_entry_exception.dart';

abstract class HiveUserDataDataSource<T extends HiveEntity<T>> {
  final CryptoKeyProvider keyProvider;

  HiveUserDataDataSource(this.keyProvider);

  String get boxName;

  Future<Box<T>> get _hiveBox => getBox();

  Future create(T input) async {
    final entityHash = input.hashIt();
    final box = await _hiveBox;
    if (box.containsKey(entityHash)) {
      throw DuplicatedEntryException();
    }
    return box.put(entityHash, input);
  }

  Future delete(T value) async {
    final hash = value.hashIt();
    return (await _hiveBox).delete(hash);
  }

  Future<List<T>> all() async {
    return (await _hiveBox).values.toList();
  }

  Future<T?> getDefault() async {
    return (await _hiveBox).values.firstWhereOrNull((element) => element.isDefault);
  }

  Future setDefault(T dto) async {
    final box = await _hiveBox;
    final currentDefault = box.values.firstWhereOrNull((element) => element.isDefault);
    if (currentDefault != null) {
      await box.put(currentDefault.hashIt(), currentDefault.copyWith(isDefault: false));
    }
    return box.put(dto.hashIt(), dto);
  }

  Future<Box<T>> getBox() async {
    final key = await keyProvider.getKey();
    return Hive.openBox<T>(boxName, encryptionCipher: HiveAesCipher(key));
  }
}
