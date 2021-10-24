import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/app_security/app_security_type.dart';
import 'package:logpass_me/domain/app_security/use_case/get_app_security_type_use_case.dart';
import 'package:logpass_me/domain/auth/use_case/listen_for_logout_event_use_case.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/switch_pre_login_action_handler_use_case.dart';
import 'package:logpass_me/presentation/widget/logout/logout_state.dart';

@Injectable()
class LogoutCubit extends Cubit<LogoutState> {
  final ListenForLogoutEventUseCase _listenForLogoutEventUseCase;
  final GetAppSecurityTypeUseCase _getAppSecurityTypeUseCase;
  final SwitchPreLoginActionHandlerUseCase _switchPreLoginActionHandlerUseCase;

  StreamSubscription? _logoutEventSubscription;

  LogoutCubit(
    this._listenForLogoutEventUseCase,
    this._getAppSecurityTypeUseCase,
    this._switchPreLoginActionHandlerUseCase,
  ) : super(LogoutState.idle());

  Future<void> init() async {
    await _resolveAppSecurity();
    _logoutEventSubscription = _listenForLogoutEventUseCase().take(1).listen((event) {
      emit(LogoutState.logout());
    });
  }

  Future<void> appResumed() async {
    return _resolveAppSecurity();
  }

  @override
  Future<void> close() async {
    await _logoutEventSubscription?.cancel();
    await super.close();
  }

  Future<void> _resolveAppSecurity() async {
    final securityType = await _getAppSecurityTypeUseCase();

    if (securityType == AppSecurityType.none) {
      emit(LogoutState.idle());
    } else {
      await _switchPreLoginActionHandlerUseCase(true);
      emit(LogoutState.securedLogin());
      emit(LogoutState.idle());
    }
  }
}
