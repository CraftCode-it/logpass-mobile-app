import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/personal_data.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

@injectable
class GetPersonalDataListUseCase {
  final UserDataRepository<PersonalData> _repository;

  GetPersonalDataListUseCase(this._repository);

  Future<List<PersonalData>> call() => _repository.readAll();
}
