import 'package:logpass_me/domain/identity/identity_profile.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

abstract class VerificationRequestState implements BuildState {
  const VerificationRequestState();
}

class VerificationRequestIdle extends VerificationRequestState {
  final List<IdentityProfile> profiles;
  final String? selectedProfileId;

  const VerificationRequestIdle({
    this.profiles = const [],
    this.selectedProfileId = 'private',
  });

  VerificationRequestIdle copyWith({
    List<IdentityProfile>? profiles,
    String? selectedProfileId,
  }) {
    return VerificationRequestIdle(
      profiles: profiles ?? this.profiles,
      selectedProfileId: selectedProfileId ?? this.selectedProfileId,
    );
  }
}

class VerificationRequestProcessing extends VerificationRequestState {
  const VerificationRequestProcessing();
}

class VerificationRequestSuccess extends VerificationRequestState {
  final String message;
  const VerificationRequestSuccess({required this.message});
}

class VerificationRequestFailure extends VerificationRequestState {
  final String message;
  const VerificationRequestFailure({required this.message});
}
