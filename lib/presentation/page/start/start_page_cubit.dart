import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/country_code/country_code.dart';
import 'package:logpass_me/domain/model/phone_number/phone_number.dart';
import 'package:logpass_me/domain/model/phone_number/phone_number_validator.dart';
import 'package:logpass_me/presentation/page/start/start_page_state.dart';

@Injectable()
class StartPageCubit extends Cubit<StartPageState> {
  final PhoneNumberValidator _phoneNumberValidator;

  CountryCode? _selectedCountryCode;
  PhoneNumber? _phoneNumber;

  StartPageCubit(
    this._phoneNumberValidator,
  ) : super(StartPageState.initial());
  
  Future<void> updatePhoneNumber(String phoneNumber) async {}

  Future<void> updateCountryCode(CountryCode countryCode) async {}

  Future<void> register() async {}
}
