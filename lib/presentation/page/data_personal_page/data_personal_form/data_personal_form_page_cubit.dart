import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/user_data/data/personal_data.dart';
import 'package:logpass_me/domain/user_data/use_case/add_personal_data_use_case.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'data_personal_form_page_state.dart';
part 'data_personal_form_page_cubit.freezed.dart';

@injectable
class DataPersonalFormPageCubit extends Cubit<DataPersonalFormPageState> {
  final AddPersonalDataUseCase _addPersonalDataUseCase;

  String _name = '';
  String _surname = '';

  bool get _canSave => _name.isNotEmpty && _surname.isNotEmpty;
  bool get _areSomeFieldsFilled => _name.isNotEmpty || _surname.isNotEmpty;

  DataPersonalFormPageCubit(
    this._addPersonalDataUseCase,
  ) : super(const DataPersonalFormPageState.idle(false, false));

  void nameChanged(String value) {
    _name = value.trim();
    _emitIdleState();
  }

  void surnameChanged(String value) {
    _surname = value.trim();
    _emitIdleState();
  }

  Future<void> savePersonalData() async {
    emit(const DataPersonalFormPageState.loading());

    try {
      final personalData = _createPersonalData();
      await _addPersonalDataUseCase(personalData);

      emit(DataPersonalFormPageState.savedSuccessful());
    } on GeneralConnectionError catch (e) {
      emit(DataPersonalFormPageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Failed to save Personal Data', ex: e, stacktrace: s);
    }
  }

  PersonalData _createPersonalData() => PersonalData(
        name: _name,
        surname: _surname,
      );

  void _emitIdleState() {
    emit(DataPersonalFormPageState.idle(_canSave, _areSomeFieldsFilled));
  }
}
