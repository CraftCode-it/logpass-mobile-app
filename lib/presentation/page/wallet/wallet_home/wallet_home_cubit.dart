import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/core/crypto/key_provider.dart';
import 'package:logpass_me/domain/wallet/credential.dart';
import 'package:logpass_me/domain/wallet/wallet_repository.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

abstract class WalletHomeState {}

class WalletHomeInitial extends WalletHomeState implements BuildState {}

class WalletHomeLoading extends WalletHomeState implements BuildState {}

class WalletHomeLoaded extends WalletHomeState implements BuildState {
  final List<Credential> credentials;
  final bool serviceOnline;
  WalletHomeLoaded({required this.credentials, required this.serviceOnline});
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

  WalletHomeCubit(this._repository, this._keyProvider) : super(WalletHomeInitial());

  Future<void> loadCredentials() async {
    emit(WalletHomeLoading());
    try {
      final credentials = await _repository.getStoredCredentials();
      final online = await _repository.checkServiceHealth();
      emit(WalletHomeLoaded(credentials: credentials, serviceOnline: online));
    } catch (e) {
      emit(WalletHomeError(e.toString()));
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
