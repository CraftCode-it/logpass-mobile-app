import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/email.dart';

@injectable
class GetUserEmailsUseCase {
  // TODO: replace after implementation of UserDataRepository
  Future<List<Email>> call() => Future.delayed(
        const Duration(seconds: 2),
        () => [
          Email('test1@iteo.com'),
          Email('test2@iteo.com', isDefault: true),
          Email('test3@iteo.com'),
        ],
      );
}
