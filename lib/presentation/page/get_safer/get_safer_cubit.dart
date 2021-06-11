import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/app_security/app_security_type.dart';
import 'package:logpass_me/domain/app_security/use_case/authorize_with_biometrics_use_case.dart';
import 'package:logpass_me/domain/app_security/use_case/is_biometric_available_use_case.dart';
import 'package:logpass_me/domain/app_security/use_case/set_app_security_type_use_case.dart';
import 'package:logpass_me/presentation/page/get_safer/get_safer_page_state.dart';

@Injectable()
class GetSaferCubit extends Cubit<GetSaferPageState> {
  final IsBiometricAvailableUseCase _isBiometricAvailableUseCase;
  final SetAppSecurityTypeUseCase _setAppSecurityTypeUseCase;
  final AuthorizeWithBiometricsUseCase _authorizeWithBiometricsUseCase;

  late bool _supportsBiometric;

  GetSaferCubit(
    this._isBiometricAvailableUseCase,
    this._setAppSecurityTypeUseCase,
    this._authorizeWithBiometricsUseCase,
  ) : super(GetSaferPageState.loading());

  Future<void> initialize() async {
    _supportsBiometric = await _isBiometricAvailableUseCase();
    emit(GetSaferPageState.idle(_supportsBiometric));
  }

  Future<void> invokeBiometricsSetup() async {
    emit(GetSaferPageState.loading());

    try {
      final biometricAuthorized = await _authorizeWithBiometricsUseCase();
      if (biometricAuthorized) {
        emit(GetSaferPageState.setCodeForBiometrics());
      }
    } catch (e, s) {
      Fimber.e('Authorizing with biometrics on initialization failed', ex: e, stacktrace: s);
    }

    emit(GetSaferPageState.idle(_supportsBiometric));
  }

  Future<void> setPinSecurity() async {
    emit(GetSaferPageState.loading());
    await _setAppSecurityTypeUseCase(AppSecurityType.code);
    emit(GetSaferPageState.success());
  }

  Future<void> setBiometricsSecurity() async {
    emit(GetSaferPageState.loading());
    await _setAppSecurityTypeUseCase(AppSecurityType.biometric);
    emit(GetSaferPageState.success());
  }
}
