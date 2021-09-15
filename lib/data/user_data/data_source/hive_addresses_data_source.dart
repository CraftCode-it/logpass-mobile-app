import 'package:collection/collection.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/user_data/dto/address_dto.dart';

@LazySingleton()
class HiveAddressesDataSource {
  final Box<AddressDto> _hiveBox;

  HiveAddressesDataSource(this._hiveBox);

  Future create(AddressDto addressDto) async {
    return _hiveBox.put(addressDto.uuid, addressDto);
  }

  Future delete(String id) async {
    return _hiveBox.delete(id);
  }

  Future<List<AddressDto>> all() async {
    return _hiveBox.values.toList();
  }

  Future update(AddressDto addressDto) async {
    return _hiveBox.put(addressDto.uuid, addressDto);
  }

  Future<AddressDto?> getDefault() async {
    final dto = _hiveBox.values.firstWhereOrNull((element) => element.isDefault);
    return dto;
  }

  Future setDefault(AddressDto dto) async {
    final currentDefault = _hiveBox.values.firstWhereOrNull((element) => element.isDefault);
    if (currentDefault != null) {
      await _hiveBox.put(currentDefault.uuid, currentDefault.copyWith(isDefault: false));
    }
    return _hiveBox.put(dto.uuid, dto);
  }
}
