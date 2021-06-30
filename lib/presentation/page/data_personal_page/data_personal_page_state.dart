part of 'data_personal_page_cubit.dart';

@freezed
class DataPersonalPageState with _$DataPersonalPageState {
  @Implements(BuildState)
  const factory DataPersonalPageState.idle(List<PersonalData> personalDataList) = _DataPersonalPageStateIdle;

  @Implements(BuildState)
  factory DataPersonalPageState.loading() = _DataPersonalPageStateLoading;

  @Implements(BuildState)
  factory DataPersonalPageState.empty() = _DataPersonalPageStateEmpty;

  factory DataPersonalPageState.connectionError(GeneralConnectionError error) = _DataPersonalPageStateConnectionError;

  factory DataPersonalPageState.dataRemovalConfirmation() = _DataPersonalPageStateDataRemovalConfirmation;

  factory DataPersonalPageState.dataRemoved() = _DataPersonalPageStateDataRemoved;
}
