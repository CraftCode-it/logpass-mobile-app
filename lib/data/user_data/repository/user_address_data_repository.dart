import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/user_data/data_source/hive_address_data_sorce.dart';
import 'package:logpass_me/data/user_data/mapper/address_dto_to_address_mapper.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

class UserAddressDataRepository implements UserDataRepository<Address> {
  final HiveAddressDataSource _hiveAddressesDataSource;
  final AddressDtoToAddressMapper _dtoMapper;

  UserAddressDataRepository(this._hiveAddressesDataSource, this._dtoMapper);

  @override
  Future create(Address value) async {
    final dto = _dtoMapper.to(value);
    return _hiveAddressesDataSource.create(dto);
  }

  @override
  Future delete(Address value) async {
    return _hiveAddressesDataSource.delete(value.uuid);
  }

  @override
  Future<List<Address>> readAll() async {
    return (await _hiveAddressesDataSource.all()).map(_dtoMapper.from).toList();
  }

  @override
  Future update(Address value) async {
    return _hiveAddressesDataSource.update(_dtoMapper.to(value));
  }

  @override
  Future<Address?> readDefault() async {
    final dto = await _hiveAddressesDataSource.getDefault();
    return dto != null ? _dtoMapper.from(dto) : null;
  }

  @override
  Future setDefault(Address value) {
    return _hiveAddressesDataSource.setDefault(_dtoMapper.to(value));
  }
}
