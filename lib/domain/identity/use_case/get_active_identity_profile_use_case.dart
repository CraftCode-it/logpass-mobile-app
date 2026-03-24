import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/identity/identity_profile.dart';
import 'package:logpass_me/domain/identity/identity_repository.dart';

@injectable
class GetActiveIdentityProfileUseCase {
  final IdentityRepository _repository;

  GetActiveIdentityProfileUseCase(this._repository);

  Future<IdentityProfile?> call() async {
    final profiles = await _repository.getProfiles();
    final activeId = await _repository.getActiveProfileId();
    return profiles.firstWhere(
      (p) => p.id == activeId,
      orElse: () => profiles.isNotEmpty ? profiles.first : IdentityProfile.defaultPrivate(),
    );
  }
}
