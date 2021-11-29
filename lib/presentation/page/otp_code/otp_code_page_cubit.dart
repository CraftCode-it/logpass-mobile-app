import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clock/clock.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/auth/error/login_verification_error.dart';
import 'package:logpass_me/domain/auth/sign_up/sign_up_verification.dart';
import 'package:logpass_me/domain/auth/use_case/verify_otp_sign_up_use_case.dart';
import 'package:logpass_me/domain/auth/use_case/retry_sign_up_sms_code_use_case.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/user_data/use_case/save_user_phone_number_use_case.dart';
import 'package:logpass_me/presentation/page/otp_code/otp_code_page_state.dart';
import 'package:sms_autofill/sms_autofill.dart';

@Injectable()
class OTPCodePageCubit extends Cubit<OTPCodePageState> {
  static const otpCodeLength = 6;
  static const resendDelayDuration = Duration(minutes: 1);

  final VerifyOTPSignUpUseCase _verifyOTPSignUpUseCase;
  final RetrySignUpSmsCodeUseCase _retrySignUpSmsCodeUseCase;
  final SaveUserPhoneNumberUseCase _saveUserPhoneNumberUseCase;
  final SmsAutoFill _smsAutoFill;

  late String _phoneNumber;
  late SignUpVerification _signUpVerification;
  late DateTime _resendTimestamp;

  StreamSubscription? _codeSubscription;
  String _code = '';

  OTPCodePageCubit(
    this._verifyOTPSignUpUseCase,
    this._retrySignUpSmsCodeUseCase,
    this._saveUserPhoneNumberUseCase,
    this._smsAutoFill,
  ) : super(OTPCodePageState.loading());

  @override
  Future<void> close() async {
    await _codeSubscription?.cancel();
    await _smsAutoFill.unregisterListener();
    return super.close();
  }

  Future<void> initialize(String phoneNumber, SignUpVerification verification) async {
    _signUpVerification = verification;
    _phoneNumber = phoneNumber;
    _resendTimestamp = clock.now().add(resendDelayDuration);

    await _smsAutoFill.listenForCode;
    _codeSubscription = _smsAutoFill.code.listen((event) {
      emit(OTPCodePageState.otpAutofill(event));
      updateCode(event);
    });

    emit(OTPCodePageState.idle(_code, false, _resendTimestamp));
  }

  void updateCode(String? code) {
    _code = code?.replaceAll(RegExp('-'), '') ?? '';
    _emitIdleState();
  }

  Future<void> verify() async {
    emit(OTPCodePageState.verifying(_code));

    try {
      await _verifyOTPSignUpUseCase(_signUpVerification.verificationUrl, _code);
      await _saveUserPhoneNumberUseCase(_phoneNumber);
      emit(OTPCodePageState.success());
    } on LoginVerificationError catch (error) {
      _handleLoginVerificationError(error);
    } on GeneralConnectionError catch (e) {
      emit(OTPCodePageState.connectionError(e));
      _emitIdleState();
    } catch (e, s) {
      Fimber.e('OTP code verification failed', ex: e, stacktrace: s);
      emit(OTPCodePageState.connectionError(GeneralConnectionError.somethingWentWrong()));
      _emitIdleState();
    }
  }

  Future<void> resendCode() async {
    emit(OTPCodePageState.resending(_code));

    try {
      _signUpVerification = await _retrySignUpSmsCodeUseCase(_signUpVerification.id);
      _resendTimestamp = clock.now().add(resendDelayDuration);
      emit(OTPCodePageState.resendSuccess());
    } on GeneralConnectionError catch (e) {
      emit(OTPCodePageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Resending OTP code failed', ex: e, stacktrace: s);
      emit(OTPCodePageState.connectionError(GeneralConnectionError.somethingWentWrong()));
    } finally {
      _emitIdleState();
    }
  }

  void _handleLoginVerificationError(LoginVerificationError error) {
    error.map(
      invalidCode: (state) => _emitIdleState(error: state.message),
      tooManyAttempts: (state) {
        emit(OTPCodePageState.tooManyAttempts(state.message));
        _emitIdleState();
      },
      accountAlreadyCreated: (state) => emit(OTPCodePageState.accountAlreadyExists()),
    );
  }

  void _emitIdleState({String? error}) {
    final isValid = _code.length == otpCodeLength;
    emit(OTPCodePageState.idle(_code, isValid, _resendTimestamp, codeError: error));
  }
}
