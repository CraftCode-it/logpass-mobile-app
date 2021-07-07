import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/auth/use_case/logout_use_case.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/presentation/page/settings/settings_page_state.dart';

@injectable
class SettingsPageCubit extends Cubit<SettingsPageState> {
  final LogoutUseCase _logoutUseCase;

  SettingsPageCubit(this._logoutUseCase) : super(SettingsPageState.idle());

  Future<void> logOut() async {
    emit(SettingsPageState.loggingOut());

    try {
      await _logoutUseCase();
    } on GeneralConnectionError catch (e) {
      emit(SettingsPageState.connectionError(e));
      emit(SettingsPageState.idle());
    } catch (e, s) {
      Fimber.e('Logging out failed', ex: e, stacktrace: s);
      emit(SettingsPageState.error());
      emit(SettingsPageState.idle());
    }
  }
}
