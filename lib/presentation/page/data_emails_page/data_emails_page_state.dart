part of 'data_emails_page_cubit.dart';

@freezed
class DataEmailsPageState with _$DataEmailsPageState {
  @Implements<BuildState>()
  factory DataEmailsPageState.idle(List<Email> emailList) = _DataEmailsPageStateIdle;

  @Implements<BuildState>()
  factory DataEmailsPageState.loading() = _DataEmailsPageStateLoading;

  @Implements<BuildState>()
  factory DataEmailsPageState.empty() = _DataEmailsPageStateEmpty;

  factory DataEmailsPageState.connectionError(GeneralConnectionError error) = _DataEmailsPageStateConnectionError;

  factory DataEmailsPageState.removalConfirmationNeeded(Email email) = _DataEmailsPageStateRemovalConfirmationNeeded;

  factory DataEmailsPageState.emailRemoved() = _DataEmailsPageStateEmailRemoved;
}
