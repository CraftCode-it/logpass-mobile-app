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
    final isShortUri = uri.queryParameters.isEmpty;

    if (uri.isScheme(deepLinkScheme)) {
      return _parseDeepLinkAction(uri, isShortUri);
    } else if (uri.isScheme(appLinkScheme)) {
      return _parseAppLinkAction(uri, isShortUri);
    } else {
      throw Exception('Unhandled scheme for action: ${uri.toString()}');
    }
  }

  IncomingAction _parseDeepLinkAction(Uri uri, bool isShortUri) {
    final actionType = _mapActionType(uri.host);

    if (isShortUri) {
      final actionId = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : throw Exception('Lack of action id');
      return IncomingAction.createFromWebSocket(actionType, actionId, null);
    } else {
      final queryParameters = uri.queryParameters;
      return IncomingAction.createFromWebSocket(actionType, null, queryParameters);
    }
  }

  IncomingAction _parseAppLinkAction(Uri uri, bool isShortUri) {
    if (uri.pathSegments.length >= 2) {
      final nonEmptyPathSegments = uri.pathSegments.where((e) => e.isNotEmpty).toList();

      if (isShortUri) {
        final actionPathSegmentIndex = nonEmptyPathSegments.length - 2;
        final actionIdPathSegmentIndex = nonEmptyPathSegments.length - 1;

        final actionType = _mapActionType(nonEmptyPathSegments[actionPathSegmentIndex]);
        final actionId = nonEmptyPathSegments[actionIdPathSegmentIndex];

        return IncomingAction.createFromWebSocket(actionType, actionId, null);
      } else {
        final actionPathSegmentIndex = nonEmptyPathSegments.length - 1;
        final actionType = _mapActionType(nonEmptyPathSegments[actionPathSegmentIndex]);
        final queryParameters = uri.queryParameters;

        return IncomingAction.createFromWebSocket(actionType, null, queryParameters);
      }
    }

    throw Exception('Invalid path for app link action: ${uri.toString()}');
  }
}
