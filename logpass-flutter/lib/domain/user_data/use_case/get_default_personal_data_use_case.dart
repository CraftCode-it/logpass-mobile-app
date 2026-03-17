import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';
import 'package:logpass_me/domain/user_data/data/personal_data.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

@injectable
class GetDefaultPersonalDataUseCase {
  final UserDataRepository<PersonalData> _repository;

  GetDefaultPersonalDataUseCase(this._repository);

  Future<PersonalData?> call() async => _repository.readDefault();
}
