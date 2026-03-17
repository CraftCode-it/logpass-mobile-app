import 'package:bloc/bloc.dart';
import 'package:logpass_me/domain/wallet/credential.dart';
import 'package:logpass_me/domain/wallet/wallet_repository.dart';

abstract class WalletHomeState {}

class WalletHomeInitial extends WalletHomeState {}

class WalletHomeLoading extends WalletHomeState {}

class WalletHomeLoaded extends WalletHomeState {
  final List<Credential> credentials;
  final bool serviceOnline;
  WalletHomeLoaded({required this.credentials, required this.serviceOnline});
}

class WalletHomeError extends WalletHomeState {
  final String message;
  WalletHomeError(this.message);
}

class WalletHomeVerifying extends WalletHomeState {}

class WalletHomeCubit extends Cubit<WalletHomeState> {
  final WalletRepository _repository;

  WalletHomeCubit(this._repository) : super(WalletHomeInitial());

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

  Future<Credential?> requestVerification(String userPubkey) async {
    emit(WalletHomeVerifying());
    try {
      final credential = await _repository.requestAgeVerification(
        userPubkey: userPubkey,
      );
      await loadCredentials();
      return credential;
    } catch (e) {
      emit(WalletHomeError(e.toString()));
      return null;
    }
  }
}
