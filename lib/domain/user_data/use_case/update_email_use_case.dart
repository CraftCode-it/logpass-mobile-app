
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/email.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

@injectable
class UpdateEmailUseCase {
  final UserDataRepository<Email> _repository;

  UpdateEmailUseCase(this._repository);

  Future<void> call(Email oldEmail, Email newEmail) async {
    await _repository.delete(oldEmail);
    return _repository.create(newEmail);
  }
}
