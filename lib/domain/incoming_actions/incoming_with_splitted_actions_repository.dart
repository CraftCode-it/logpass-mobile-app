import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_actions_repository.dart';

abstract class IncomingWithSplittedActionsRepository implements IncomingActionsRepository {
  Stream<IncomingAction> listenForIncomingRefreshCodeActions();
}