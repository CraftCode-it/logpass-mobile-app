import 'package:logpass_me/data/user_data/data_source/hive_user_data_data_source.dart';
import 'package:logpass_me/data/user_data/dto/email_dto.dart';
import 'package:logpass_me/data/user_data/dto/personal_data_dto.dart';
import 'package:logpass_me/data/user_data/mapper/email_dto_mapper.dart';
import 'package:logpass_me/data/user_data/mapper/personal_data_dto_mapper.dart';
import 'package:logpass_me/domain/user_data/data/email.dart';
import 'package:logpass_me/domain/user_data/data/personal_data.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

class UserEmailDataRepository implements UserDataRepository<Email> {
  final HiveUserDataDataSource<EmailDto> _hiveDataSource;
  final EmailDtoMapper _dtoMapper;

  UserEmailDataRepository(this._hiveDataSource, this._dtoMapper);

  @override
  Future create(Email value) async {
    final dto = _dtoMapper.to(value);
    return _hiveDataSource.create(dto);
  }

  @override
  Future delete(Email value) async {
    return _hiveDataSource.delete(value.uuid);
  }

  @override
  Future<List<Email>> readAll() async {
    return (await _hiveDataSource.all()).map(_dtoMapper.from).toList();
  }

  @override
  Future update(Email value) async {
    return _hiveDataSource.update(_dtoMapper.to(value));
  }

  @override
  Future<Email?> readDefault() async {
    final dto = await _hiveDataSource.getDefault();
    return dto != null ? _dtoMapper.from(dto) : null;
  }

  @override
  Future setDefault(Email value) {
    return _hiveDataSource.setDefault(_dtoMapper.to(value));
  }
}
