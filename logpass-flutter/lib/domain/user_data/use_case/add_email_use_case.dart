import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/email.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

@injectable
class AddEmailUseCase {
  final UserDataRepository<Email> _repository;

  AddEmailUseCase(this._repository);

  Future<void> call(Email email) async {
    final isFirst = (await _repository.readAll()).isEmpty;
    return _repository.create(email.copyWith(isDefault: isFirst));
  }
}
