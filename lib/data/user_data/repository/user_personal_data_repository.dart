import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/user_data/data_source/hive_personal_data_data_sorce.dart';
import 'package:logpass_me/data/user_data/mapper/personal_data_dto_mapper.dart';
import 'package:logpass_me/domain/user_data/data/personal_data.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

class UserPersonalDataRepository implements UserDataRepository<PersonalData> {
  final HivePersonalDataDataSource _hiveDataSource;
  final PersonalDataDtoMapper _dtoMapper;

  UserPersonalDataRepository(this._hiveDataSource, this._dtoMapper);

  @override
  Future create(PersonalData value) async {
    final dto = _dtoMapper.to(value);
    return _hiveDataSource.create(dto);
  }

  @override
  Future delete(PersonalData value) async {
    return _hiveDataSource.delete(value.uuid);
  }

  @override
  Future<List<PersonalData>> readAll() async {
    return (await _hiveDataSource.all()).map(_dtoMapper.from).toList();
  }

  @override
  Future update(PersonalData value) async {
    return _hiveDataSource.update(_dtoMapper.to(value));
  }

  @override
  Future<PersonalData?> readDefault() async {
    final dto = await _hiveDataSource.getDefault();
    return dto != null ? _dtoMapper.from(dto) : null;
  }

  @override
  Future setDefault(PersonalData value) {
    return _hiveDataSource.setDefault(_dtoMapper.to(value));
  }
}
