import 'package:logpass_me/data/user_data/cipher/user_data_cipher.dart';
import 'package:logpass_me/data/user_data/data_source/hive/hive_address_data_sorce.dart';
import 'package:logpass_me/data/user_data/mapper/entity/address_entity_to_address_mapper.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

const _addressDtoKey = "user_address_data";

class UserAddressDataRepository implements UserDataRepository<Address> {
  final HiveAddressDataSource _hiveAddressesDataSource;
  final AddressEntityToAddressEntityMapper _entityMapper;
  final UserDataCipher _cipher;

  UserAddressDataRepository(
    this._hiveAddressesDataSource,
    this._entityMapper,
    this._cipher,
  );

  @override
  Future create(Address value) async {
    final entity = _entityMapper.to(value);
    await _hiveAddressesDataSource.create(entity);
  }

  @override
  Future delete(Address value) async {
    final entity = _entityMapper.to(value);
    return _hiveAddressesDataSource.delete(entity);
  }

  @override
  Future<List<Address>> readAll() async {
    return (await _hiveAddressesDataSource.all()).map(_entityMapper.from).toList();
  }

  @override
  Future update(Address value) async {
    return _hiveAddressesDataSource.update(_entityMapper.to(value));
  }

  @override
  Future<Address?> readDefault() async {
    final dto = await _hiveAddressesDataSource.getDefault();
    return dto != null ? _entityMapper.from(dto) : null;
  }

  @override
  Future setDefault(Address value) {
    return _hiveAddressesDataSource.setDefault(_entityMapper.to(value));
  }
}
