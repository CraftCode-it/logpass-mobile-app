import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/personal_data.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

@injectable
class AddPersonalDataUseCase {
  final UserDataRepository<PersonalData> _repository;

  AddPersonalDataUseCase(this._repository);

  Future<void> call(PersonalData personalData) async {
    final isFirst = (await _repository.readAll()).isEmpty;
    return _repository.create(personalData.copyWith(isDefault: isFirst));
  }
}
