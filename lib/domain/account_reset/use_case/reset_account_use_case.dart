import 'package:injectable/injectable.dart';

@injectable
class ResetAccountUseCase {
  // TODO: replace after actual implementation of repository
  Future<void> call() => Future.delayed(
        const Duration(seconds: 2),
        () => null,
      );
}
