import 'package:collection/collection.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logpass_me/data/user_data/dto/hive_dto.dart';

class HiveUserDataDataSource<T extends HiveDto<T>> {
  final Box<T> _hiveBox;

  HiveUserDataDataSource(this._hiveBox);

  Future create(T input) async {
    return _hiveBox.put(input.uuid, input);
  }

  Future delete(String id) async {
    return _hiveBox.delete(id);
  }

  Future<List<T>> all() async {
    return _hiveBox.values.toList();
  }

  Future update(T input) async {
    return _hiveBox.put(input.uuid, input);
  }

  Future<T?> getDefault() async {
    return _hiveBox.values.firstWhereOrNull((element) => element.isDefault);
  }

  Future setDefault(T dto) async {
    final currentDefault = _hiveBox.values.firstWhereOrNull((element) => element.isDefault);
    if (currentDefault != null) {
      await _hiveBox.put(currentDefault.uuid, currentDefault.copyWith(isDefault: false));
    }
    return _hiveBox.put(dto.uuid, dto);
  }
}
