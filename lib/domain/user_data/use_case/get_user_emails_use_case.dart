import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/email.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

@injectable
class GetUserEmailsUseCase {
  final UserDataRepository<Email> _repository;

  GetUserEmailsUseCase(this._repository);

  // TODO: replace after implementation of UserDataRepository
  Future<List<Email>> call() => _repository.readAll();
}
