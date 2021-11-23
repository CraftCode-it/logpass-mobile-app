part of 'data_phone_number_page_cubit.dart';

@freezed
class DataPhoneNumberPageState with _$DataPhoneNumberPageState {
  @Implements(BuildState)
  factory DataPhoneNumberPageState.idle(String phoneNumber) = _DataPhoneNumberPageStateIdle;

  @Implements(BuildState)
  factory DataPhoneNumberPageState.loading() = _DataPhoneNumberPageStateLoading;
}
