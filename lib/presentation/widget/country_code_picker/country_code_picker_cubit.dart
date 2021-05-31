import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/country_code/country_code.dart';
import 'package:logpass_me/domain/country_code/get_country_codes_use_case.dart';
import 'package:logpass_me/presentation/widget/country_code_picker/country_code_picker_state.dart';

@Injectable()
class CountryCodePickerCubit extends Cubit<CountryCodePickerState> {
  final GetCountryCodesUseCase _getCountryCodesUseCase;

  late List<CountryCode> _countryCodeList;

  CountryCodePickerCubit(this._getCountryCodesUseCase) : super(CountryCodePickerState.loading());

  Future<void> initialize(String country) async {
    final countryCodeList = await _getCountryCodesUseCase();
    final selectedCountryCode = _findDefaultCountryCode(countryCodeList, country);

    _countryCodeList = countryCodeList;

    emit(CountryCodePickerState.selectedEvent(selectedCountryCode));
    emit(CountryCodePickerState.selected(countryCodeList, selectedCountryCode));
  }

  void select(CountryCode countryCode) {
    emit(CountryCodePickerState.selectedEvent(countryCode));
    emit(CountryCodePickerState.selected(_countryCodeList, countryCode));
  }

  CountryCode _findDefaultCountryCode(
    List<CountryCode> countryCodeList,
    String country,
  ) {
    return countryCodeList.firstWhere(
      (element) => element.country.toLowerCase() == country.toLowerCase(),
      orElse: () {
        Fimber.w('Country code for system region not found: $country. Using first from the list.');
        return countryCodeList.first;
      },
    );
  }
}
