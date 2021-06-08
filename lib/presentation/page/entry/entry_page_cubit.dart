import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/app_security/app_security_type.dart';
import 'package:logpass_me/domain/app_security/use_case/get_app_security_type_use_case.dart';
import 'package:logpass_me/domain/auth/use_case/is_logged_in_use_case.dart';
import 'package:logpass_me/presentation/page/entry/entry_page_state.dart';

@Injectable()
class EntryPageCubit extends Cubit<EntryPageState> {
  final IsLoggedInUseCase _isLoggedInUseCase;
  final GetAppSecurityTypeUseCase _getAppSecurityTypeUseCase;

  EntryPageCubit(
    this._isLoggedInUseCase,
    this._getAppSecurityTypeUseCase,
  ) : super(EntryPageState.idle());

  Future<void> initialize() async {
    final isLoggedIn = await _isLoggedInUseCase();

    if (isLoggedIn) {
      await _resolveAppSecurity();
    } else {
      emit(EntryPageState.onboarding());
    }
  }

  Future<void> _resolveAppSecurity() async {
    final securityType = await _getAppSecurityTypeUseCase();

    if (securityType == AppSecurityType.none) {
      emit(EntryPageState.home());
    } else {
      emit(EntryPageState.securedLogin());
    }
  }
}
