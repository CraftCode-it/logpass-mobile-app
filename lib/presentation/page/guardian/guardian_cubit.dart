import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/guardian/guardian.dart';
import 'package:logpass_me/domain/guardian/guardian_repository.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

abstract class GuardianState implements BuildState {}

class GuardianLoading extends GuardianState {}

class GuardianLoaded extends GuardianState {
  final List<Guardian> myGuardians;
  final List<Guardian> myMinors;
  GuardianLoaded({required this.myGuardians, required this.myMinors});
}

class GuardianError extends GuardianState {
  final String message;
  GuardianError(this.message);
}

class GuardianOperating extends GuardianState {}

@injectable
class GuardianCubit extends Cubit<GuardianState> {
  final GuardianRepository _repository;

  GuardianCubit(this._repository) : super(GuardianLoading());

  Future<void> load() async {
    emit(GuardianLoading());
    try {
      final guardians = await _repository.getMyGuardians();
      final minors = await _repository.getMyMinors();
      emit(GuardianLoaded(myGuardians: guardians, myMinors: minors));
    } catch (e) {
      emit(GuardianError(e.toString()));
    }
  }

  Future<void> addGuardian(String guardianUserId) async {
    emit(GuardianOperating());
    try {
      await _repository.requestGuardian(guardianUserId);
      await load();
    } catch (e) {
      emit(GuardianError(e.toString()));
    }
  }

  Future<void> confirmGuardian(String guardianRequestId) async {
    emit(GuardianOperating());
    try {
      await _repository.confirmGuardian(guardianRequestId);
      await load();
    } catch (e) {
      emit(GuardianError(e.toString()));
    }
  }

  Future<void> rejectGuardian(String guardianRequestId) async {
    emit(GuardianOperating());
    try {
      await _repository.rejectGuardian(guardianRequestId);
      await load();
    } catch (e) {
      emit(GuardianError(e.toString()));
    }
  }
}
