part of 'personal_data_selection_page_cubit.dart';

@freezed
class PersonalDataSelectionPageState with _$PersonalDataSelectionPageState {
  @Implements<BuildState>()
  const factory PersonalDataSelectionPageState.idle(
      List<PersonalData> personalDataList,
      PersonalData selectedPersonalData,
      ) = _PersonalDataSelectionPageStateIdle;

  @Implements<BuildState>()
  factory PersonalDataSelectionPageState.loading() = _PersonalDataSelectionPageStateLoading;

  @Implements<BuildState>()
  factory PersonalDataSelectionPageState.empty() = _PersonalDataSelectionPageStateEmpty;

  factory PersonalDataSelectionPageState.connectionError(GeneralConnectionError error) =
      _PersonalDataSelectionPageStateError;
}
