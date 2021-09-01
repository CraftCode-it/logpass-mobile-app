import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/personal_data.dart';

@injectable
class GetPersonalDataListUseCase {
  // TODO: replace after implementation of UserDataRepository
  Future<List<PersonalData>> call() => Future.delayed(
        const Duration(milliseconds: 200),
        () => [
          PersonalData(
            name: 'John',
            surname: 'Doe',
            isDefault: true,
          ),
          PersonalData(
            name: 'Jack',
            surname: 'Black',
          ),
        ],
      );
}
