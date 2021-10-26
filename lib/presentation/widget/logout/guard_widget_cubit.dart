import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/app_security/use_case/mark_app_as_background_state_use_case.dart';
import 'package:logpass_me/domain/app_security/use_case/should_lock_app_use_case.dart';
import 'package:logpass_me/domain/auth/use_case/listen_for_logout_event_use_case.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/switch_pre_login_action_handler_use_case.dart';
import 'package:logpass_me/presentation/widget/logout/guard_widget_state.dart';

@Injectable()
class GuardWidgetCubit extends Cubit<GuardWidgetState> {
  final ListenForLogoutEventUseCase _listenForLogoutEventUseCase;
  final ShouldLockAppUseCase _shouldLockAppUseCase;
  final SwitchPreLoginActionHandlerUseCase _switchPreLoginActionHandlerUseCase;
  final MarkAppAsBackgroundStateUseCase _markAppAsBackgroundStateUseCase;

  StreamSubscription? _logoutEventSubscription;

  GuardWidgetCubit(
    this._listenForLogoutEventUseCase,
    this._shouldLockAppUseCase,
    this._switchPreLoginActionHandlerUseCase,
    this._markAppAsBackgroundStateUseCase,
  ) : super(GuardWidgetState.idle());

  Future<void> init() async {
    await _resolveAppSecurity();
    _logoutEventSubscription = _listenForLogoutEventUseCase().take(1).listen((event) {
      emit(GuardWidgetState.logout());
    });
  }

  Future<void> appResumed() async {
    return _resolveAppSecurity();
  }

  Future<void> appPaused() async {
    return _markAppAsBackgroundStateUseCase();
  }

  @override
  Future<void> close() async {
    await _logoutEventSubscription?.cancel();
    await super.close();
  }

  Future<void> _resolveAppSecurity() async {
    final showLockScreen = await _shouldLockAppUseCase();

    if (showLockScreen) {
      await _switchPreLoginActionHandlerUseCase(true);
      emit(GuardWidgetState.securedLogin());
      emit(GuardWidgetState.idle());
    } else {
      emit(GuardWidgetState.idle());
    }
  }
}
