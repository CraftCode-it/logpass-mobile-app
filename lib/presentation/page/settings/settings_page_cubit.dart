import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/presentation/page/settings/settings_page_state.dart';

@injectable
class SettingsPageCubit extends Cubit<SettingsPageState> {
  SettingsPageCubit() : super(SettingsPageState.idle());

  Future<void> logOut() async {}
}
