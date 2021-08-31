import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/email.dart';

@injectable
class GetDefaultUserEmailUseCase {
  // TODO: replace after implementation of UserDataRepository
  Future<Email?> call() => Future.delayed(
        const Duration(milliseconds: 200),
        () => Email('test2@iteo.com', isDefault: true),
      );
}
