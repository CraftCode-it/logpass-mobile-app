import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/user_data/data/personal_data.dart';
import 'package:logpass_me/domain/user_data/use_case/delete_personal_data_use_case.dart';
import 'package:logpass_me/domain/user_data/use_case/get_personal_data_list_use_case.dart';
import 'package:logpass_me/domain/user_data/use_case/set_default_personal_data_use_case.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'data_personal_page_state.dart';
part 'data_personal_page_cubit.freezed.dart';

@injectable
class DataPersonalPageCubit extends Cubit<DataPersonalPageState> {
  final GetPersonalDataListUseCase _getPersonalDataListUseCase;
  final SetDefaultPersonalDataUseCase _setDefaultPersonalDataUseCase;
  final DeletePersonalDataUseCase _deletePersonalDataUseCase;

  List<PersonalData>? _personalDataList;

  DataPersonalPageCubit(
    this._getPersonalDataListUseCase,
    this._setDefaultPersonalDataUseCase,
    this._deletePersonalDataUseCase,
  ) : super(DataPersonalPageState.loading());

  Future<void> init() async {
    await _getPersonalDataList();
  }

  Future<void> _getPersonalDataList() async {
    try {
      final result = await _getPersonalDataListUseCase();
      _personalDataList = result;

      _emitIdleOrEmptyState();
    } on GeneralConnectionError catch (e) {
      emit(DataPersonalPageState.connectionError(e));
      emit(DataPersonalPageState.empty());
    } catch (e, s) {
      Fimber.e('Failed to load Personal Data list', ex: e, stacktrace: s);
    }
  }

  Future<void> deletePersonalData(PersonalData data) async {
    emit(DataPersonalPageState.loading());

    try {
      await _deletePersonalDataUseCase(data);
      await _getPersonalDataList();
    } on GeneralConnectionError catch (e) {
      emit(DataPersonalPageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Failed to load Personal Data list', ex: e, stacktrace: s);
    }
  }

  Future<void> setDefaultPersonalData(PersonalData data) async {
    emit(DataPersonalPageState.loading());

    try {
      await _setDefaultPersonalDataUseCase(data);

      emit(DataPersonalPageState.dataRemoved());

      await _getPersonalDataList();
    } on GeneralConnectionError catch (e) {
      emit(DataPersonalPageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Failed to load Personal Data list', ex: e, stacktrace: s);
    }
  }

  void _emitIdleOrEmptyState() {
    final personalDataList = _personalDataList;
    if (personalDataList != null) {
      personalDataList.isNotEmpty
          ? emit(DataPersonalPageState.idle(personalDataList))
          : emit(DataPersonalPageState.empty());
    } else {
      emit(DataPersonalPageState.empty());
    }
  }
}
