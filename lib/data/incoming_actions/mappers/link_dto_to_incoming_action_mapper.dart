import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/data_mapper.dart';
import 'package:logpass_me/domain/incoming_actions/action_type.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';

@injectable
class LinkDTOToIncomingActionMapper implements DataMapper<String, IncomingAction> {
  static const deepLinkScheme = 'logpass';
  static const appLinkScheme = 'https';

  @override
  IncomingAction call(String url) {
    final uri = Uri.parse(url);
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
    final actionType = mapActionType(uri.host);

    if (isShortUri) {
      final actionId = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : throw Exception('Lack of action id');
      return IncomingAction.create(actionType, actionId, null, null);
    } else {
      final queryParameters = uri.queryParameters;
      return IncomingAction.create(actionType, null, null, queryParameters);
    }
  }

  IncomingAction _parseAppLinkAction(Uri uri, bool isShortUri) {
    if (uri.pathSegments.length >= 2) {
      final nonEmptyPathSegments = uri.pathSegments.where((e) => e.isNotEmpty).toList();

      if (isShortUri) {
        final actionPathSegmentIndex = nonEmptyPathSegments.length - 2;
        final actionIdPathSegmentIndex = nonEmptyPathSegments.length - 1;

        final actionType = mapActionType(nonEmptyPathSegments[actionPathSegmentIndex]);
        final actionId = nonEmptyPathSegments[actionIdPathSegmentIndex];

        return IncomingAction.create(actionType, actionId, null, null);
      } else {
        final actionPathSegmentIndex = nonEmptyPathSegments.length - 1;
        final actionType = mapActionType(nonEmptyPathSegments[actionPathSegmentIndex]);
        final queryParameters = uri.queryParameters;

        return IncomingAction.create(actionType, null, null, queryParameters);
      }
    }

    throw Exception('Invalid path for app link action: ${uri.toString()}');
  }
}
