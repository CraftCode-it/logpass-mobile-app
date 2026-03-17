import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/incoming_actions/pre_login_action_handler.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/switch_pre_login_action_handler_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'switch_pre_login_action_handler_use_case_test.mocks.dart';

@GenerateMocks(
  [
    PreLoginActionHandler,
  ],
)
void main() {
  late MockPreLoginActionHandler preLoginActionHandler;
  late SwitchPreLoginActionHandlerUseCase useCase;

  setUp(() {
    preLoginActionHandler = MockPreLoginActionHandler();
    useCase = SwitchPreLoginActionHandlerUseCase(preLoginActionHandler);
  });

  test('it calls enabled method', () async {
    await useCase(true);
    verify(preLoginActionHandler.enable());
  });

  test('it calls disable method', () async {
    await useCase(false);
    verify(preLoginActionHandler.disable());
  });
}
