import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/email.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

@injectable
class GetDefaultUserEmailUseCase {
  final UserDataRepository<Email> _repository;

  GetDefaultUserEmailUseCase(this._repository);

  Future<Email?> call() => _repository.readDefault();
}
