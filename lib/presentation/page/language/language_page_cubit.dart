import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/language/use_case/get_language_code_use_case.dart';
import 'package:logpass_me/domain/language/use_case/set_language_code_use_case.dart';
import 'package:logpass_me/presentation/page/language/language_page_state.dart';

@injectable
class LanguagePageCubit extends Cubit<LanguagePageState> {
  final SetLanguageCodeUseCase _setLanguageCodeUseCase;
  final GetLanguageCodeUseCase _getLanguageCodeUseCase;

  LanguagePageCubit(
    this._setLanguageCodeUseCase,
    this._getLanguageCodeUseCase,
  ) : super(LanguagePageState.loading());

  Future<void> initialize() async {
    final code = await _getLanguageCodeUseCase();
    emit(LanguagePageState.idle(code));
  }

  Future<void> changeLanguage(String code) async {
    await _setLanguageCodeUseCase(code);
    emit(LanguagePageState.idle(code));
  }
}
