import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/core/crypto/key_provider.dart';
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
  final bool dobVerified;
  final String? pairingCode;
  WalletHomeLoaded({
    required this.credentials,
    required this.serviceOnline,
    this.dobVerified = false,
    this.pairingCode,
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

  bool _dobVerified = false;
  String? _pairingCode;

  WalletHomeCubit(this._repository, this._keyProvider, this._identityRepository) : super(WalletHomeInitial());

  Future<void> loadCredentials() async {
    emit(WalletHomeLoading());
    try {
      final credentials = await _repository.getStoredCredentials();
      final online = await _repository.checkServiceHealth();
      emit(WalletHomeLoaded(
        credentials: credentials,
        serviceOnline: online,
        dobVerified: _dobVerified,
        pairingCode: _pairingCode,
      ));
    } catch (e) {
      emit(WalletHomeError(e.toString()));
    }
  }

  Future<String?> verifyMobywatel(String testAccount) async {
    try {
      final result = await _repository.verifyIdentityMobywatel(testAccount);
      if (result['dob_verified'] == true) {
        _dobVerified = true;
        final dob = result['dob'] as String? ?? '';
        if (dob.isNotEmpty) {
          await _identityRepository.applyVerifiedDob(dob);
        }
        await loadCredentials();
        return null;
      }
      return 'Weryfikacja nie powiodła się';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> refreshPairingCode() async {
    try {
      final code = await _repository.registerPairingCode();
      _pairingCode = code;
      final currentState = state;
      if (currentState is WalletHomeLoaded) {
        emit(WalletHomeLoaded(
          credentials: currentState.credentials,
          serviceOnline: currentState.serviceOnline,
          dobVerified: _dobVerified,
          pairingCode: _pairingCode,
        ));
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

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
}
