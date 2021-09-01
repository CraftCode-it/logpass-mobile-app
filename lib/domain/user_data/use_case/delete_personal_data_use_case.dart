import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/personal_data.dart';

@injectable
class DeletePersonalDataUseCase {
  // TODO: replace after implementation of UserDataRepository
  Future<void> call(PersonalData personalData) => Future.delayed(
        const Duration(milliseconds: 200),
        () => null,
      );
}
