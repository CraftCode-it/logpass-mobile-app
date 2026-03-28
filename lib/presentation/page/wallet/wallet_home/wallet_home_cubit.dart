import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/core/crypto/key_provider.dart';
import 'package:logpass_me/domain/identity/identity_field.dart';
import 'package:logpass_me/domain/identity/identity_profile_type.dart';
import 'package:logpass_me/domain/identity/identity_repository.dart';
import 'package:logpass_me/domain/wallet/credential.dart';
import 'package:logpass_me/domain/wallet/wallet_repository.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

abstract class WalletHomeState {}

class WalletHomeInitial extends WalletHomeState implements BuildState {}

class WalletHomeLoading extends WalletHomeState implements BuildState {}

class WalletHomeLoaded extends WalletHomeState implements BuildState {
  final List<Credential> credentials;
  final bool serviceOnline;
  /// True when the user's DOB (from private profile) indicates age < 18.
  final bool isMinor;
  WalletHomeLoaded({
    required this.credentials,
    required this.serviceOnline,
    this.isMinor = false,
  });
}

class WalletHomeError extends WalletHomeState implements BuildState {
  final String message;
  WalletHomeError(this.message);
}

class WalletHomeVerifying extends WalletHomeState implements BuildState {}

@injectable
class WalletHomeCubit extends Cubit<WalletHomeState> {
  final WalletRepository _repository;
  final KeyProvider _keyProvider;
  final IdentityRepository _identityRepository;

  WalletHomeCubit(this._repository, this._keyProvider, this._identityRepository)
      : super(WalletHomeInitial());

  Future<void> loadCredentials() async {
    emit(WalletHomeLoading());
    try {
      final credentials = await _repository.getStoredCredentials();
      final online = await _repository.checkServiceHealth();
      final isMinor = await _checkIsMinor();
      emit(WalletHomeLoaded(
        credentials: credentials,
        serviceOnline: online,
        isMinor: isMinor,
      ));
    } catch (e) {
      emit(WalletHomeError(e.toString()));
    }
  }

  Future<bool> _checkIsMinor() async {
    try {
      final profiles = await _identityRepository.getProfiles();
      final privateProfile = profiles.where((p) => p.type == IdentityProfileType.private).firstOrNull;
      if (privateProfile == null) return false;
      final dobField = privateProfile.fields
          .where((f) => f.key == IdentityFieldKey.dateOfBirth && f.value.isNotEmpty)
          .firstOrNull;
      if (dobField == null) return false;
      final dob = DateTime.tryParse(dobField.value);
      if (dob == null) return false;
      return _calculateAge(dob) < 18;
    } catch (_) {
      return false;
    }
  }

  int _calculateAge(DateTime dob) {
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  /// Standard verification (age >= 18 flow).
  Future<Credential?> requestVerification() async {
    emit(WalletHomeVerifying());
    try {
      final pubkey = await _keyProvider.getUserPubkeyHex();
      final credential = await _repository.requestAgeVerification(
        userPubkey: pubkey,
      );
      await loadCredentials();
      return credential;
    } catch (e) {
      emit(WalletHomeError(e.toString()));
      return null;
    }
  }

  /// Forced verification for minor (age < 18). Creates credential with forced=true.
  Future<Credential?> requestForcedVerification() async {
    emit(WalletHomeVerifying());
    try {
      final pubkey = await _keyProvider.getUserPubkeyHex();
      final credential = await _repository.requestAgeVerification(
        userPubkey: pubkey,
        forced: true,
      );
      await loadCredentials();
      return credential;
    } catch (e) {
      emit(WalletHomeError(e.toString()));
      return null;
    }
  }
}
