import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/auth/use_case/sign_up_using_otp_code_use_case.dart';
import 'package:logpass_me/domain/auth/verification_method.dart';
import 'package:logpass_me/domain/country_code/country_code.dart';
import 'package:logpass_me/domain/model/phone_number/phone_number.dart';
import 'package:logpass_me/domain/model/phone_number/phone_number_validator.dart';
import 'package:logpass_me/presentation/page/start/start_page_state.dart';

enum StartPageError { phoneValidation }

@Injectable()
class StartPageCubit extends Cubit<StartPageState> {
  final PhoneNumberValidator _phoneNumberValidator;
  final SignUpUsingOTPCodeUseCase _signUpUsingOTPCodeUseCase;

  PhoneNumber _phoneNumber = PhoneNumber();
  bool _termsAccepted = false;

  StartPageCubit(
    this._phoneNumberValidator,
    this._signUpUsingOTPCodeUseCase,
  ) : super(StartPageState.initial());

  Future<void> updatePhoneNumber(String phoneNumber) async {
    _phoneNumber = _phoneNumber.copyWith(number: phoneNumber);
    await _buildIdleState();
  }

  Future<void> updateCountryCode(CountryCode countryCode) async {
    _phoneNumber = _phoneNumber.copyWith(
      countryCode: countryCode.code,
      country: countryCode.country,
    );

    await _buildIdleState();
  }

  Future<void> updateTerms(bool accepted) async {
    _termsAccepted = accepted;
    await _buildIdleState();
  }

  Future<void> register() async {
    emit(StartPageState.processing());

    try {
      final result = await _signUpUsingOTPCodeUseCase(_phoneNumber.fullPhoneNumber());

      switch (result.verificationMethod) {
        case VerificationMethod.otpCode:
          emit(StartPageState.successOTP(result));
          break;
        case VerificationMethod.signature:
          emit(StartPageState.successSignature());
          break;
      }
    } catch (e, s) {
      Fimber.e('Signing up failed', ex: e, stacktrace: s);
      emit(StartPageState.error());
    }

    await _buildIdleState();
  }

  Future<void> _buildIdleState() async {
    final phoneNumber = _phoneNumber;

    final errors = <StartPageError>[];

    final isPhoneNumberValid = await _phoneNumberValidator.isValid(phoneNumber);
    if (!isPhoneNumberValid && phoneNumber.number.isNotEmpty) {
      errors.add(StartPageError.phoneValidation);
    }

    final isFormValid = _termsAccepted && isPhoneNumberValid;

    emit(StartPageState.idle(isFormValid, errors));
  }
}
