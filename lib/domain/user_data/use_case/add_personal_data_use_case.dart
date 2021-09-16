import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/personal_data.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

@injectable
class AddPersonalDataUseCase {
  final UserDataRepository<PersonalData> _repository;

  AddPersonalDataUseCase(this._repository);

  Future<void> call(PersonalData personalData) => _repository.create(personalData);
}
