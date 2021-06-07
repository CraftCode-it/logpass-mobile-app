import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/app_security/use_case/is_biometric_available_use_case.dart';
import 'package:logpass_me/presentation/page/get_safer/get_safer_page_state.dart';

@Injectable()
class GetSaferCubit extends Cubit<GetSaferPageState> {
  final IsBiometricAvailableUseCase _isBiometricAvailableUseCase;

  GetSaferCubit(
    this._isBiometricAvailableUseCase,
  ) : super(GetSaferPageState.loading());

  Future<void> initialize() async {
    final supportsBiometric = await _isBiometricAvailableUseCase();
    emit(GetSaferPageState.idle(supportsBiometric));
  }
}
