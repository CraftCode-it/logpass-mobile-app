import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/app_security/app_security_type.dart';
import 'package:logpass_me/domain/app_security/use_case/authorize_with_biometrics_use_case.dart';
import 'package:logpass_me/domain/app_security/use_case/get_app_security_type_use_case.dart';
import 'package:logpass_me/domain/app_security/use_case/set_app_security_type_use_case.dart';
import 'package:logpass_me/presentation/page/security_settings/security_settings_page_state.dart';

@injectable
class SecuritySettingsPageCubit extends Cubit<SecuritySettingsPageState> {
  final GetAppSecurityTypeUseCase _getAppSecurityTypeUseCase;
  final SetAppSecurityTypeUseCase _setAppSecurityTypeUseCase;
  final AuthorizeWithBiometricsUseCase _authorizeWithBiometricsUseCase;

  late AppSecurityType _securityType;

  SecuritySettingsPageCubit(
    this._getAppSecurityTypeUseCase,
    this._setAppSecurityTypeUseCase,
    this._authorizeWithBiometricsUseCase,
  ) : super(SecuritySettingsPageState.loading());

  Future<void> initialize() async {
    _securityType = await _getAppSecurityTypeUseCase();
    emit(SecuritySettingsPageState.idle(_securityType));
  }

  Future<void> invokeBiometricChange() async {
    if (_securityType == AppSecurityType.biometric) {
      await _turnOffBiometrics();
    } else {
      await _turnOnBiometrics();
    }
  }

  Future<void> invokePinCodeChange() async {
    if (_securityType == AppSecurityType.none) {
      await _turnOnPinCode();
    } else {
      await _turnOffPinCode();
    }
  }

  Future<void> applySecurityChange(AppSecurityType type) async {
    emit(SecuritySettingsPageState.loading());

    await _setAppSecurityTypeUseCase(type);
    _securityType = type;

    emit(SecuritySettingsPageState.idle(_securityType));
  }

  Future<void> _turnOnBiometrics() async {
    try {
      final authorized = await _authorizeWithBiometricsUseCase();
      if (!authorized) return;

      if (_securityType == AppSecurityType.code) {
        await _setAppSecurityTypeUseCase(AppSecurityType.biometric);
        _securityType = AppSecurityType.biometric;
      } else if (_securityType == AppSecurityType.none) {
        emit(SecuritySettingsPageState.setCode(AppSecurityType.biometric));
      }
    } catch (e, s) {
      Fimber.e('Authorizing with biometrics on initialization failed', ex: e, stacktrace: s);
    }

    emit(SecuritySettingsPageState.idle(_securityType));
  }

  Future<void> _turnOffBiometrics() async {
    emit(SecuritySettingsPageState.confirmWithCode(AppSecurityType.code));
  }

  Future<void> _turnOnPinCode() async {
    emit(SecuritySettingsPageState.setCode(AppSecurityType.code));
  }

  Future<void> _turnOffPinCode() async {
    emit(SecuritySettingsPageState.confirmWithCode(AppSecurityType.none));
  }
}
