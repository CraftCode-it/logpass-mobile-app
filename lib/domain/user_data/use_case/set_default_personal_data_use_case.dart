import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/personal_data.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

@injectable
class SetDefaultPersonalDataUseCase {
  final UserDataRepository<PersonalData> _repository;

  SetDefaultPersonalDataUseCase(this._repository);

  Future<void> call(PersonalData personalData) => _repository.setDefault(
        personalData.copyWith(
          isDefault: true,
        ),
      );
}
