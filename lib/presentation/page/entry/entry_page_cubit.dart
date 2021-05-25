import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/auth/use_case/is_logged_in_use_case.dart';
import 'package:logpass_me/presentation/page/entry/entry_page_state.dart';

@Injectable()
class EntryPageCubit extends Cubit<EntryPageState> {
  final IsLoggedInUseCase _isLoggedInUseCase;

  EntryPageCubit(this._isLoggedInUseCase) : super(EntryPageState.idle());

  Future<void> initialize() async {
    final isLoggedIn = await _isLoggedInUseCase();
    emit(isLoggedIn ? EntryPageState.home() : EntryPageState.onboarding());
  }
}
