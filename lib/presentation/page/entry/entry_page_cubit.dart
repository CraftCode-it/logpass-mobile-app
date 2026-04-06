import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/app/use_case/is_first_run_app_use_case.dart';
import 'package:logpass_me/domain/auth/use_case/is_logged_in_use_case.dart';
import 'package:logpass_me/domain/auth/use_case/logout_without_listenable_callback_use_case.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/setup_initial_action_use_case.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/switch_pre_login_action_handler_use_case.dart';
import 'package:logpass_me/presentation/page/entry/entry_page_state.dart';

@Injectable()
class EntryPageCubit extends Cubit<EntryPageState> {
  final LogoutWithoutListenableCallbackUseCase _logoutUseCase;
  final IsLoggedInUseCase _isLoggedInUseCase;
  final IsFirstRunAppUseCase _isFirstRunAppUseCase;

  final SetupInitialActionUseCase _setupInitialActionUseCase;
  final SwitchPreLoginActionHandlerUseCase _switchPreLoginActionHandlerUseCase;

  EntryPageCubit(
    this._logoutUseCase,
    this._isLoggedInUseCase,
    this._isFirstRunAppUseCase,
    this._setupInitialActionUseCase,
    this._switchPreLoginActionHandlerUseCase,
  ) : super(EntryPageState.idle());

  Future<void> initialize() async {
    try {
      await _setupInitialActionUseCase();

      final isFirstRunApp = await _isFirstRunAppUseCase();

      if (isFirstRunApp) {
        await _logoutUseCase();
        await _onboarding();
      } else {
        await _loadCredential();
      }
    } catch (e) {
      // Corrupt storage or unexpected error -- fall back to onboarding
      await _onboarding();
    }
  }

  Future<void> _loadCredential() async {
    final isLoggedIn = await _isLoggedInUseCase();

    if (isLoggedIn) {
      emit(EntryPageState.home());
    } else {
      await _onboarding();
    }
  }

  Future<void> _onboarding() async {
    await _switchPreLoginActionHandlerUseCase(true);
    emit(EntryPageState.onboarding());
  }
}
