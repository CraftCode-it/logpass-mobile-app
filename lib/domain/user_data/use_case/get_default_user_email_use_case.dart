import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/email.dart';

@injectable
class GetDefaultUserEmailUseCase {
  // TODO: replace after implementation of UserDataRepository
  Future<Email?> call() async => Future.value(
        Email('test2@iteo.com', isDefault: true),
      );
}
