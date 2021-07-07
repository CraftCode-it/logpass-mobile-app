import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'reset_account_page_state.dart';
part 'reset_account_page_cubit.freezed.dart';

@injectable
class ResetAccountPageCubit extends Cubit<ResetAccountPageState> {
  ResetAccountPageCubit() : super(ResetAccountPageState.idle());
}
