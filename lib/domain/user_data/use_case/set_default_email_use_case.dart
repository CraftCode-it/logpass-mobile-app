import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/email.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

@injectable
class SetDefaultEmailUseCase {
  final UserDataRepository<Email> _repository;

  SetDefaultEmailUseCase(this._repository);

  Future<void> call(Email email) => _repository.setDefault(
        email.copyWith(
          isDefault: true,
        ),
      );
}
