import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/one_time_code/one_time_code_repository.dart';

@injectable
class LoadOneTimeCodeUseCase {
  final OneTimeCodeRepository _repository;

  LoadOneTimeCodeUseCase(this._repository);

  Future<void> call({bool forceRefresh = true}) async => _repository.loadOneTimeCode(forceRefresh);
}
