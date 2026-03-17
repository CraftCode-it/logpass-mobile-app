import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/user_data/data/email.dart';
import 'package:logpass_me/domain/user_data/use_case/delete_email_use_case.dart';
import 'package:logpass_me/domain/user_data/use_case/get_user_emails_use_case.dart';
import 'package:logpass_me/domain/user_data/use_case/set_default_email_use_case.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'data_emails_page_state.dart';
part 'data_emails_page_cubit.freezed.dart';

@injectable
class DataEmailsPageCubit extends Cubit<DataEmailsPageState> {
  final GetUserEmailsUseCase _getUserEmailsUseCase;
  final SetDefaultEmailUseCase _setDefaultEmailUseCase;
  final DeleteEmailUseCase _deleteEmailUseCase;

  List<Email> _emailList = [];

  DataEmailsPageCubit(
    this._getUserEmailsUseCase,
    this._deleteEmailUseCase,
    this._setDefaultEmailUseCase,
  ) : super(DataEmailsPageState.loading());

  Future<void> init() async {
    await getEmailList();
  }

  Future<void> getEmailList() async {
    emit(DataEmailsPageState.loading());

    try {
      final result = await _getUserEmailsUseCase();
      _emailList = result;

      _emitIdleOrEmptyState();
    } on GeneralConnectionError catch (e) {
      emit(DataEmailsPageState.connectionError(e));
      emit(DataEmailsPageState.empty());
    } catch (e, s) {
      Fimber.e('Failed to load email list', ex: e, stacktrace: s);
    }
  }

  void ensureRemoval(Email email) {
    emit(DataEmailsPageState.removalConfirmationNeeded(email));
    _emitIdleOrEmptyState();
  }

  Future<void> deleteEmail(Email email) async {
    emit(DataEmailsPageState.loading());

    try {
      await _deleteEmailUseCase(email);

      await getEmailList();
      emit(DataEmailsPageState.emailRemoved());
    } on GeneralConnectionError catch (e) {
      emit(DataEmailsPageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Failed to delete email', ex: e, stacktrace: s);
    }
  }

  Future<void> setEmailAsDefault(Email email) async {
    emit(DataEmailsPageState.loading());

    try {
      await _setDefaultEmailUseCase(email);
      await getEmailList();
    } on GeneralConnectionError catch (e) {
      emit(DataEmailsPageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Failed to set email as default', ex: e, stacktrace: s);
    }
  }

  void _emitIdleOrEmptyState() {
    _emailList.isNotEmpty ? emit(DataEmailsPageState.idle(_emailList)) : emit(DataEmailsPageState.empty());
  }
}
