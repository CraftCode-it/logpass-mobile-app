import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/user_data/data/email.dart';
import 'package:logpass_me/domain/user_data/exception/duplicated_entry_exception.dart';
import 'package:logpass_me/domain/user_data/use_case/add_email_use_case.dart';
import 'package:logpass_me/presentation/utils/form_utils.dart';
import 'package:logpass_me/presentation/utils/uuid.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'data_emails_form_page_cubit.freezed.dart';

part 'data_emails_form_page_state.dart';

@injectable
class DataEmailsFormPageCubit extends Cubit<DataEmailsFormPageState> {
  final AddEmailUseCase _addEmailUseCase;

  String _email = '';

  bool get canSave => _email.isNotEmpty && _email.isEmailValid();

  DataEmailsFormPageCubit(this._addEmailUseCase) : super(const DataEmailsFormPageState.idle(false, false));

  Future<void> saveEmail() async {
    emit(const DataEmailsFormPageState.loading());

    try {
      final email = _createEmail();
      await _addEmailUseCase(email);

      emit(DataEmailsFormPageState.savedSuccessful());
    } on GeneralConnectionError catch (e) {
      emit(DataEmailsFormPageState.connectionError(e));
    } on DuplicatedEntryException catch (_) {
        emit(DataEmailsFormPageState.duplicatedEntry());
        emit(const DataEmailsFormPageState.idle(false, false));
    } catch (e, s) {
      Fimber.e('Failed to save email', ex: e, stacktrace: s);
    }
  }

  void emailChanged(String value) {
    _email = value.trim();
    _emitIdleState();
  }

  Email _createEmail() => Email(
        _email,
        uuid: uuid.v4(),
      );

  void _emitIdleState() {
    emit(DataEmailsFormPageState.idle(canSave, _email.isNotEmpty));
  }
}
