import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/auth/use_case/logout_use_case.dart';
import 'package:logpass_me/presentation/page/settings/settings_page_state.dart';

@injectable
class SettingsPageCubit extends Cubit<SettingsPageState> {
  final LogoutUseCase _logoutUseCase;

  SettingsPageCubit(this._logoutUseCase) : super(SettingsPageState.idle());

  Future<void> logOut() async {
    emit(SettingsPageState.loggingOut());
    await _logoutUseCase();
  }
}
