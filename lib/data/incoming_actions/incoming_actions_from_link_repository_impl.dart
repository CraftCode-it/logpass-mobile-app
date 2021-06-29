import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/incoming_actions/incoming_actions_validator.dart';
import 'package:logpass_me/data/incoming_actions/linking/linking_data_source.dart';
import 'package:logpass_me/data/incoming_actions/mappers/incoming_action_dto_to_incoming_action_mapper.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_actions_from_link_repository.dart';

@LazySingleton(as: IncomingActionsFromLinkRepository)
class IncomingActionsFromLinkRepositoryImpl implements IncomingActionsFromLinkRepository {
  final LinkingDataSource _linkingDataSource;
  final IncomingActionsValidator _incomingActionsValidator;
  final IncomingActionDTOToIncomingActionMapper _actionMapper;

  IncomingActionsFromLinkRepositoryImpl(this._linkingDataSource, this._incomingActionsValidator, this._actionMapper);

  @override
  Stream<IncomingAction> listenForIncomingActions() {
    return _linkingDataSource
        .listenForIncomingActions()
        .map<IncomingAction>(_actionMapper)
        .where((event) => _incomingActionsValidator.canInvoke(event));
  }

  @override
  Future<IncomingAction?> getInitialAction() async {
    final dto = await _linkingDataSource.getInitialAction();
    if (dto == null) return null;

    final action = _actionMapper(dto);

    if (_incomingActionsValidator.canInvoke(action)) {
      return action;
    } else {
      return null;
    }
  }

  @override
  Future<void> clear() async {
    await _linkingDataSource.clear();
  }
}
