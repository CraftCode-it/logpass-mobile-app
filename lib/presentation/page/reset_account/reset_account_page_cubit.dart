import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/account_reset/use_case/reset_account_use_case.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'reset_account_page_state.dart';
part 'reset_account_page_cubit.freezed.dart';

@injectable
class ResetAccountPageCubit extends Cubit<ResetAccountPageState> {
  final ResetAccountUseCase _resetAccountUseCase;

  ResetAccountPageCubit(this._resetAccountUseCase) : super(ResetAccountPageState.idle());

  Future<void> resetAccount() async {
    emit(ResetAccountPageState.processing());

    try {
      await _resetAccountUseCase();
      // TODO: uncomment after backend impl of account reset
      // emit(ResetAccountPageState.accountResetSuccessful());
    } on GeneralConnectionError catch (e) {
      emit(ResetAccountPageState.idle());
      await Future.delayed(const Duration(milliseconds: 200));
      emit(ResetAccountPageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Account reset has failed', ex: e, stacktrace: s);
      emit(ResetAccountPageState.idle());
      await Future.delayed(const Duration(milliseconds: 200));
      emit(ResetAccountPageState.error());
    }
  }
}
