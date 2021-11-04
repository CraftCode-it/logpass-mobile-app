import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/user_data/data/personal_data.dart';
import 'package:logpass_me/domain/user_data/exception/duplicated_entry_exception.dart';
import 'package:logpass_me/domain/user_data/use_case/add_personal_data_use_case.dart';
import 'package:logpass_me/domain/user_data/use_case/update_personal_data_use_case.dart';
import 'package:logpass_me/presentation/utils/uuid.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'data_personal_form_page_cubit.freezed.dart';

part 'data_personal_form_page_state.dart';

@injectable
class DataPersonalFormPageCubit extends Cubit<DataPersonalFormPageState> {
  final AddPersonalDataUseCase _addPersonalDataUseCase;
  final UpdatePersonalDataUseCase _updatePersonalDataUseCase;

  String _name = '';
  String _surname = '';
  PersonalData? _oldPersonalData;

  bool get _editMode => _oldPersonalData != null;

  bool get _canSave => _name.isNotEmpty && _surname.isNotEmpty;

  bool get _areSomeFieldsFilled => _name.isNotEmpty || _surname.isNotEmpty;

  DataPersonalFormPageCubit(
    this._addPersonalDataUseCase,
    this._updatePersonalDataUseCase,
  ) : super(const DataPersonalFormPageState.idle(false, false));

  void init(PersonalData? personalData) {
    if (personalData == null) return;
    _oldPersonalData = personalData;
    _name = personalData.name;
    _surname = personalData.surname;
  }

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
      if (_editMode) {
        await _updatePersonalDataUseCase(_oldPersonalData!, personalData);
      } else {
        await _addPersonalDataUseCase(personalData);
      }

      emit(DataPersonalFormPageState.savedSuccessful());
    } on GeneralConnectionError catch (e) {
      emit(DataPersonalFormPageState.connectionError(e));
    } on DuplicatedEntryException catch (_) {
      emit(DataPersonalFormPageState.duplicatedEntry());
      emit(const DataPersonalFormPageState.idle(false, false));
    } catch (e, s) {
      Fimber.e('Failed to save Personal Data', ex: e, stacktrace: s);
    }
  }

  PersonalData _createPersonalData() => PersonalData(
        name: _name,
        surname: _surname,
        uuid: uuid.v4(),
        isDefault: _oldPersonalData?.isDefault ?? false,
      );

  void _emitIdleState() {
    emit(DataPersonalFormPageState.idle(_canSave, _areSomeFieldsFilled));
  }
}
