import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/use_case/get_user_phone_number_use_case.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'data_phone_number_page_state.dart';
part 'data_phone_number_page_cubit.freezed.dart';

@Injectable()
class DataPhoneNumberPageCubit extends Cubit<DataPhoneNumberPageState> {
  final GetUserPhoneNumberUseCase _getUserPhoneNumberUseCase;

  DataPhoneNumberPageCubit(this._getUserPhoneNumberUseCase)
      : super(DataPhoneNumberPageState.loading());

  Future<void> initialize() async {
    final phoneNumber = await _getUserPhoneNumberUseCase();

    if(phoneNumber != null && phoneNumber.isNotEmpty) {
      emit(DataPhoneNumberPageState.idle(phoneNumber));
    } else {
      emit(DataPhoneNumberPageState.empty());
    }
  }
}
