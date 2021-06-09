import 'package:bloc/bloc.dart';
import 'package:clock/clock.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/auth/error/login_verification_error.dart';
import 'package:logpass_me/domain/auth/sign_up/sign_up_verification.dart';
import 'package:logpass_me/domain/auth/use_case/sign_up_using_otp_code_use_case.dart';
import 'package:logpass_me/domain/auth/use_case/verify_otp_sign_up_use_case.dart';
import 'package:logpass_me/presentation/page/otp_code/otp_code_page_state.dart';

@Injectable()
class OTPCodePageCubit extends Cubit<OTPCodePageState> {
  static const otpCodeLength = 6;
  static const resendDelayDuration = Duration(minutes: 1);

  final VerifyOTPSignUpUseCase _verifyOTPSignUpUseCase;
  final SignUpUsingOTPCodeUseCase _signUpUsingOTPCodeUseCase;

  late SignUpVerification _signUpVerification;
  late DateTime _resendTimestamp;

  String _code = '';

  OTPCodePageCubit(
    this._verifyOTPSignUpUseCase,
    this._signUpUsingOTPCodeUseCase,
  ) : super(OTPCodePageState.loading());

  void initialize(SignUpVerification verification) {
    _signUpVerification = verification;
    _resendTimestamp = clock.now().add(resendDelayDuration);

    emit(OTPCodePageState.idle(_code, false, _resendTimestamp));
  }

  void updateCode(String? code) {
    _code = code ?? '';
    _emitIdleState();
  }

  Future<void> verify() async {
    emit(OTPCodePageState.verifying(_code));

    try {
      await _verifyOTPSignUpUseCase(_signUpVerification.verificationUrl, _code);
      emit(OTPCodePageState.success());
    } on LoginVerificationError catch (error) {
      _handleLoginVerificationError(error);
    } catch (e, s) {
      Fimber.e('OTP code verification failed', ex: e, stacktrace: s);
      emit(OTPCodePageState.error());
      _emitIdleState();
    }
  }

  Future<void> resendCode() async {
    emit(OTPCodePageState.resending(_code));

    try {
      _signUpVerification = await _signUpUsingOTPCodeUseCase(_signUpVerification.phoneNumber);
    } catch (e, s) {
      Fimber.e('Resending OTP code failed', ex: e, stacktrace: s);
      emit(OTPCodePageState.error());
    } finally {
      _resendTimestamp = clock.now().add(resendDelayDuration);
      _emitIdleState();
    }
  }

  void _handleLoginVerificationError(LoginVerificationError error) {
    error.map(
      invalidCode: (invalidCode) => _emitIdleState(error: invalidCode.message),
      accountAlreadyCreated: (accountAlreadyCreated) => emit(OTPCodePageState.accountAlreadyExists()),
    );
  }

  void _emitIdleState({String? error}) {
    final isValid = _code.length == otpCodeLength;
    emit(OTPCodePageState.idle(_code, isValid, _resendTimestamp, codeError: error));
  }
}
