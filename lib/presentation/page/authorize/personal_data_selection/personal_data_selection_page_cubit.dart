import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/user_data/data/personal_data.dart';
import 'package:logpass_me/domain/user_data/use_case/get_personal_data_list_use_case.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';
import 'package:meta/meta.dart';

part 'personal_data_selection_page_state.dart';
part 'personal_data_selection_page_cubit.freezed.dart';

@injectable
class PersonalDataSelectionPageCubit extends Cubit<PersonalDataSelectionPageState> {
  final GetPersonalDataListUseCase _getPersonalDataListUseCase;

  List<PersonalData>? _personalDataList;
  PersonalData? _selectedPersonalData;

  PersonalDataSelectionPageCubit(
    this._getPersonalDataListUseCase
  ) : super(PersonalDataSelectionPageState.loading());

  Future<void> init(PersonalData? personalData) async {
    _selectedPersonalData = personalData;

    await _loadUserPersonalDataList();
  }

  void selectPersonalData(PersonalData personalData) {
    _selectedPersonalData = personalData;
    _emitIdleState();
  }

  Future<void> _loadUserPersonalDataList() async {
    try {
      _personalDataList = await _getPersonalDataListUseCase();
      _selectedPersonalData ??= _personalDataList?.first;

      _emitIdleState();
    } on GeneralConnectionError catch (e) {
      emit(PersonalDataSelectionPageState.connectionError(e));
      emit(PersonalDataSelectionPageState.empty());
    } catch (e, s) {
      Fimber.e('Fetching list failed', ex: e, stacktrace: s);
      emit(PersonalDataSelectionPageState.empty());
    }
  }

  void _emitIdleState() {
    if (_personalDataList != null && _selectedPersonalData != null) {
      emit(PersonalDataSelectionPageState.idle(_personalDataList!, _selectedPersonalData!));
    }
  }

  void getPersonalDataList() {
    _loadUserPersonalDataList();
  }
}
