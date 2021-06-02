import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/auth/sign_up/sign_up_verification.dart';
import 'package:logpass_me/domain/auth/use_case/verify_otp_sign_up_use_case.dart';
import 'package:logpass_me/presentation/page/otp_code/otp_code_page_state.dart';

@Injectable()
class OTPCodePageCubit extends Cubit<OTPCodePageState> {
  static const otpCodeLength = 6;
  static const _resendDelayDuration = Duration(seconds: 30);

  final VerifyOTPSignUpUseCase _verifyOTPSignUpUseCase;

  late SignUpVerification _signUpVerification;
  late DateTime _resendTimestamp;

  String _code = '';

  OTPCodePageCubit(this._verifyOTPSignUpUseCase) : super(OTPCodePageState.loading());

  void initialize(SignUpVerification verification) {
    _signUpVerification = verification;
    _resendTimestamp = DateTime.now().add(_resendDelayDuration);

    emit(OTPCodePageState.idle(_code, false, _resendTimestamp));
  }

  void updateCode(String? code) {
    _code = code ?? '';
    _emitIdleState();
  }

  Future<void> verify() async {
    emit(OTPCodePageState.processing(_code));

    try {
      await _verifyOTPSignUpUseCase(_signUpVerification.verificationUrl, _code);
      emit(OTPCodePageState.success());
    } catch (e, s) {
      Fimber.e('OTP code verification failed', ex: e, stacktrace: s);
      emit(OTPCodePageState.error());
    }

    _emitIdleState();
  }

  Future<void> resendCode() async {
    _resendTimestamp = DateTime.now().add(_resendDelayDuration);
    _emitIdleState();
  }

  void _emitIdleState() {
    final isValid = _code.length == otpCodeLength;
    emit(OTPCodePageState.idle(_code, isValid, _resendTimestamp));
  }
}
