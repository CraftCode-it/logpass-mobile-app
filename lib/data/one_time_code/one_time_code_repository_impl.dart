import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/one_time_code/api/one_time_code_api_data_source.dart';
import 'package:logpass_me/data/one_time_code/dtos/one_time_code_parameter_dto.dart';
import 'package:logpass_me/data/one_time_code/mappers/one_time_code_dto_to_one_time_code_mapper.dart';
import 'package:logpass_me/domain/one_time_code/one_time_code.dart';
import 'package:logpass_me/domain/one_time_code/one_time_code_repository.dart';
import 'package:rxdart/subjects.dart';

@Singleton(as: OneTimeCodeRepository)
class OneTimeCodeRepositoryImpl implements OneTimeCodeRepository {
  final OneTimeCodeApiDataSource _apiDataSource;
  final OneTimeCodeDTOToOneTimeCodeMapper _mapper;
  final BehaviorSubject<OneTimeCode?> _oneTimeCodeSubject = BehaviorSubject<OneTimeCode>();

  OneTimeCodeRepositoryImpl(this._apiDataSource, this._mapper);

  @override
  Future<void> loadOneTimeCode(bool forceRefresh) async {
    final parameterDto = OneTimeCodeParameterDTO(forceRefresh);
    final dto = await _apiDataSource.getOneTimeCode(parameterDto);
    final oneTimeCode = _mapper.call(dto);

    _setOneTimeCode(oneTimeCode);
  }

  void _setOneTimeCode(OneTimeCode oneTimeCode) {
    _oneTimeCodeSubject.add(oneTimeCode);
  }

  @override
  Stream<OneTimeCode?> listenForOneTimeCode() => _oneTimeCodeSubject.stream.distinct();
}
