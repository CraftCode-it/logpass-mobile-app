import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/personal_data.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

@injectable
class UpdatePersonalDataUseCase {
  final UserDataRepository<PersonalData> _repository;

  UpdatePersonalDataUseCase(this._repository);

  Future<void> call(PersonalData oldPersonalData, PersonalData personalData) async {
    await _repository.delete(oldPersonalData);
    return _repository.create(personalData);
  }
}
