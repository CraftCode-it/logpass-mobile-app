import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/data_mapper.dart';
import 'package:logpass_me/data/incoming_actions/dtos/incoming_action_dto.dart';
import 'package:logpass_me/domain/incoming_actions/action_type.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';

@injectable
class IncomingActionDTOToIncomingActionMapper implements DataMapper<IncomingActionDTO, IncomingAction> {
  // TODO: refactor keys after backend's implementation
  ActionType _mapActionType(String key) {
    switch (key) {
      case 'authorize':
        return ActionType.authorize();
      case 'confirm':
        return ActionType.confirm();
      case 'updateAccount':
        return ActionType.updateAccount();
      default:
        throw Exception('Unsupported action type');
    }
  }

  @override
  IncomingAction call(IncomingActionDTO data) {
    final uri = Uri.parse(data.link);
    final actionType = _mapActionType(uri.host);
    final actionId = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : throw Exception('Lack of action id');
    return IncomingAction(actionType, actionId);
  }
}
