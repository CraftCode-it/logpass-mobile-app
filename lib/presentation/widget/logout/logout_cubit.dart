import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/auth/use_case/listen_for_logout_event_use_case.dart';
import 'package:logpass_me/presentation/widget/logout/logout_state.dart';

@Injectable()
class LogoutCubit extends Cubit<LogoutState> {
  final ListenForLogoutEventUseCase _listenForLogoutEventUseCase;

  StreamSubscription? _logoutEventSubscription;

  LogoutCubit(this._listenForLogoutEventUseCase) : super(LogoutState.idle());

  Future<void> init() async {
    _logoutEventSubscription = _listenForLogoutEventUseCase().take(1).listen((event) {
      emit(LogoutState.logout());
    });
  }

  @override
  Future<void> close() async {
    await _logoutEventSubscription?.cancel();
    await super.close();
  }
}
