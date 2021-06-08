import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/app_security/app_security_type.dart';
import 'package:logpass_me/domain/app_security/use_case/authorize_with_biometrics_use_case.dart';
import 'package:logpass_me/domain/app_security/use_case/get_app_security_type_use_case.dart';
import 'package:logpass_me/domain/app_security/use_case/validate_pin_code_use_case.dart';
import 'package:logpass_me/presentation/page/pin_setup/app_pin_config.dart';
import 'package:logpass_me/presentation/page/secured_login/secured_login_page_state.dart';

@Injectable()
class SecuredLoginPageCubit extends Cubit<SecuredLoginPageState> {
  final GetAppSecurityTypeUseCase _getAppSecurityTypeUseCase;
  final ValidatePinCodeUseCase _validatePinCodeUseCase;
  final AuthorizeWithBiometricsUseCase _authorizeWithBiometricsUseCase;

  late AppSecurityType _securityType;

  SecuredLoginPageCubit(
    this._getAppSecurityTypeUseCase,
    this._validatePinCodeUseCase,
    this._authorizeWithBiometricsUseCase,
  ) : super(SecuredLoginPageState.processing());

  Future<void> initialize() async {
    _securityType = await _getAppSecurityTypeUseCase();
    emit(SecuredLoginPageState.idle(_securityType, false));

    if (_securityType == AppSecurityType.biometric) {
      await useBiometrics();
    }
  }

  Future<void> useBiometrics() async {
    try {
      final success = await _authorizeWithBiometricsUseCase();
      if (success) {
        emit(SecuredLoginPageState.validated());
      }
    } catch (e, s) {
      Fimber.e('Authorizing with biometrics failed', ex: e, stacktrace: s);
    }
  }

  Future<void> updatePinCode(String code) async {
    if (code.length == appPinLength) {
      emit(SecuredLoginPageState.processing());
      final isCodeValid = await _validatePinCodeUseCase(code);

      if (isCodeValid) {
        emit(SecuredLoginPageState.validated());
      } else {
        await Future.delayed(const Duration(seconds: 1));
        emit(SecuredLoginPageState.wrongPin());
        emit(SecuredLoginPageState.idle(_securityType, true));
      }
    } else {
      emit(SecuredLoginPageState.idle(_securityType, false));
    }
  }
}
