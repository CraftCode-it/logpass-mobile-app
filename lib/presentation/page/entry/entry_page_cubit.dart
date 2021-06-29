import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/app_security/app_security_type.dart';
import 'package:logpass_me/domain/app_security/use_case/get_app_security_type_use_case.dart';
import 'package:logpass_me/domain/auth/use_case/is_logged_in_use_case.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/setup_initial_action_use_case.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/switch_pre_login_action_handler_use_case.dart';
import 'package:logpass_me/presentation/page/entry/entry_page_state.dart';

@Injectable()
class EntryPageCubit extends Cubit<EntryPageState> {
  final IsLoggedInUseCase _isLoggedInUseCase;
  final GetAppSecurityTypeUseCase _getAppSecurityTypeUseCase;
  final SetupInitialActionUseCase _setupInitialActionUseCase;
  final SwitchPreLoginActionHandlerUseCase _switchPreLoginActionHandlerUseCase;

  EntryPageCubit(
    this._isLoggedInUseCase,
    this._getAppSecurityTypeUseCase,
    this._setupInitialActionUseCase,
    this._switchPreLoginActionHandlerUseCase,
  ) : super(EntryPageState.idle());

  Future<void> initialize() async {
    await _setupInitialActionUseCase();

    final isLoggedIn = await _isLoggedInUseCase();

    if (isLoggedIn) {
      await _resolveAppSecurity();
    } else {
      await _switchPreLoginActionHandlerUseCase(true);
      emit(EntryPageState.onboarding());
    }
  }

  Future<void> _resolveAppSecurity() async {
    final securityType = await _getAppSecurityTypeUseCase();

    if (securityType == AppSecurityType.none) {
      emit(EntryPageState.home());
    } else {
      await _switchPreLoginActionHandlerUseCase(true);
      emit(EntryPageState.securedLogin());
    }
  }
}
