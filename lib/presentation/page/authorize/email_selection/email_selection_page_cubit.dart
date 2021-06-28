import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/user_data/data/email.dart';
import 'package:logpass_me/domain/user_data/use_case/get_user_emails_use_case.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'email_selection_page_state.dart';
part 'email_selection_page_cubit.freezed.dart';

@injectable
class EmailSelectionPageCubit extends Cubit<EmailSelectionPageState> {
  final GetUserEmailsUseCase _getUserEmailsUseCase;

  List<Email>? _emails;
  Email? _selectedEmail;

  EmailSelectionPageCubit(
    this._getUserEmailsUseCase,
  ) : super(EmailSelectionPageState.loading());

  Future<void> init(Email? email) async {
    _selectedEmail = email;

    await _loadUserEmails();
  }

  void selectEmail(Email email) {
    _selectedEmail = email;
    _emitIdleState();
  }

  Future<void> _loadUserEmails() async {
    try {
      _emails = await _getUserEmailsUseCase();
      _selectedEmail ??= _emails?.first;

      _emitIdleState();
    } on GeneralConnectionError catch (e) {
      emit(EmailSelectionPageState.connectionError(e));
      emit(EmailSelectionPageState.empty());
    } catch (e, s) {
      Fimber.e('Fetching list failed', ex: e, stacktrace: s);
      emit(EmailSelectionPageState.empty());
    }
  }

  void _emitIdleState() {
    if (_emails != null && _selectedEmail != null) {
      emit(EmailSelectionPageState.idle(_emails!, _selectedEmail!));
    }
  }
}
