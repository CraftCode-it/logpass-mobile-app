import 'package:logpass_me/domain/identity/identity_profile.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

abstract class VerificationRequestState implements BuildState {
  const VerificationRequestState();
}

class VerificationRequestIdle extends VerificationRequestState {
  final List<IdentityProfile> profiles;
  final String? selectedProfileId;
  final bool isMinor;

  const VerificationRequestIdle({
    this.profiles = const [],
    this.selectedProfileId = 'private',
    this.isMinor = false,
  });

  VerificationRequestIdle copyWith({
    List<IdentityProfile>? profiles,
    String? selectedProfileId,
    bool? isMinor,
  }) {
    return VerificationRequestIdle(
      profiles: profiles ?? this.profiles,
      selectedProfileId: selectedProfileId ?? this.selectedProfileId,
      isMinor: isMinor ?? this.isMinor,
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
