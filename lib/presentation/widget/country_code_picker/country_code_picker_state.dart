import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/domain/country_code/country_code.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'country_code_picker_state.freezed.dart';

@freezed
class CountryCodePickerState with _$CountryCodePickerState {
  @Implements(BuildState)
  factory CountryCodePickerState.loading() = _CountryCodePickerStateLoading;

  @Implements(BuildState)
  factory CountryCodePickerState.selected(
    List<CountryCode> countryCodeList,
    CountryCode countryCode,
  ) = _CountryCodePickerStateSelected;

  factory CountryCodePickerState.selectedEvent(CountryCode countryCode) = _CountryCodePickerStateSelectedEvent;
}
