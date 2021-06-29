import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/data_mapper.dart';
import 'package:logpass_me/data/incoming_actions/dtos/incoming_action_dto.dart';
import 'package:logpass_me/domain/incoming_actions/action_type.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';

@injectable
class IncomingActionDTOToIncomingActionMapper implements DataMapper<IncomingActionDTO, IncomingAction> {
  static const deepLinkScheme = 'logpass';
  static const appLinkScheme = 'https';

  // TODO: refactor keys after backend's implementation
  ActionType _mapActionType(String key) {
    switch (key.toLowerCase()) {
      case 'authorize':
        return ActionType.authorize();
      case 'confirm':
        return ActionType.confirm();
      case 'updateaccount':
        return ActionType.updateAccount();
      default:
        throw Exception('Unsupported action type');
    }
  }

  @override
  IncomingAction call(IncomingActionDTO data) {
    final uri = Uri.parse(data.link);

    if (uri.isScheme(deepLinkScheme)) {
      return _parseDeepLinkAction(uri);
    } else if (uri.isScheme(appLinkScheme)) {
      return _parseAppLinkAction(uri);
    } else {
      throw Exception('Unhandled scheme for action: ${uri.toString()}');
    }
  }

  IncomingAction _parseDeepLinkAction(Uri uri) {
    final actionType = _mapActionType(uri.host);
    final actionId = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : throw Exception('Lack of action id');

    return IncomingAction(actionType, actionId);
  }

  IncomingAction _parseAppLinkAction(Uri uri) {
    if (uri.pathSegments.length >= 2) {
      final actionPathSegmentIndex = uri.pathSegments.length - 2;
      final actionIdPathSegmentIndex = uri.pathSegments.length - 1;

      final actionType = _mapActionType(uri.pathSegments[actionPathSegmentIndex]);
      final actionId = uri.pathSegments[actionIdPathSegmentIndex];

      return IncomingAction(actionType, actionId);
    }

    throw Exception('Invalid path for app link action: ${uri.toString()}');
  }
}
