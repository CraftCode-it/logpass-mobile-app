import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/user_data/data/email.dart';
import 'package:logpass_me/domain/user_data/use_case/add_email_use_case.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/utils/form_utils.dart';

part 'data_emails_form_page_state.dart';
part 'data_emails_form_page_cubit.freezed.dart';

@injectable
class DataEmailsFormPageCubit extends Cubit<DataEmailsFormPageState> {
  final AddEmailUseCase _addEmailUseCase;

  String _email = '';

  bool get canSave => _email.isNotEmpty && _email.isEmailValid();

  DataEmailsFormPageCubit(this._addEmailUseCase) : super(const DataEmailsFormPageState.idle(false, false));

  Email _createEmail() => Email(_email);

  Future<void> saveEmail() async {
    emit(const DataEmailsFormPageState.loading());

    try {
      final email = _createEmail();
      await _addEmailUseCase(email);

      emit(DataEmailsFormPageState.savedSuccessful());
    } on GeneralConnectionError catch (e) {
      emit(DataEmailsFormPageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Failed to save email', ex: e, stacktrace: s);
    }
  }

  void emailChanged(String value) {
    _email = value.trim();
    _emitIdleState();
  }

  void _emitIdleState() {
    emit(DataEmailsFormPageState.idle(canSave, _email.isNotEmpty));
  }
}
