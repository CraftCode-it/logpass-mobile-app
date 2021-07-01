import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/email.dart';

@injectable
class AddEmailUseCase {
  // TODO: replace after implementation of UserDataRepository
  Future<void> call(Email email) => Future.delayed(
        const Duration(seconds: 2),
        () => null,
      );
}
