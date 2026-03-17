import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/one_time_code/one_time_code.dart';
import 'package:logpass_me/domain/one_time_code/one_time_code_repository.dart';

@injectable
class SubscribeToOnetimeCodeUseCase {
  final OneTimeCodeRepository _repository;

  SubscribeToOnetimeCodeUseCase(this._repository);

  Stream<OneTimeCode?> call() => _repository.listenForOneTimeCode();
}
