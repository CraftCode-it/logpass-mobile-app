import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/package_info/use_case/get_application_version_use_case.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'version_info_state.dart';
part 'version_info_cubit.freezed.dart';

@injectable
class VersionInfoCubit extends Cubit<VersionInfoState> {
  VersionInfoCubit(
    GetApplicationVersionUseCase getApplicationVersionUseCase,
  ) : super(VersionInfoState.idle(getApplicationVersionUseCase()));
}
