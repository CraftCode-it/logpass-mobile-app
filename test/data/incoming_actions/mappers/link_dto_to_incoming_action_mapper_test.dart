import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/data/incoming_actions/mappers/link_dto_to_incoming_action_mapper.dart';
import 'package:logpass_me/domain/incoming_actions/action_type.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';

void main() {
  late LinkDTOToIncomingActionMapper mapper;

  setUp(() {
    mapper = LinkDTOToIncomingActionMapper();
  });

  const deepLinkScheme = LinkDTOToIncomingActionMapper.deepLinkScheme;
  const appLinkScheme = LinkDTOToIncomingActionMapper.appLinkScheme;

  group('for deep link uri it', () {
    test('returns mapped authorize action', () {
      const id = 'abcd3';
      const link = '$deepLinkScheme://authorize/$id';

      final action = mapper(link);

      expect(
        action,
        isA<IncomingAction>()
            .having((a) => a.actionType, 'actionType', ActionType.authorize())
            .having((a) => a.actionId, 'actionId', id),
      );
    });

    test('returns mapped confirm action', () {
      const id = 'abcd2';
      const link = '$deepLinkScheme://confirm/$id';

      final action = mapper(link);

      expect(
        action,
        isA<IncomingAction>()
            .having((a) => a.actionType, 'actionType', ActionType.confirm())
            .having((a) => a.actionId, 'actionId', id),
      );
    });

    test('returns mapped updateAccount action', () {
      const id = 'abcd1';
      const link = '$deepLinkScheme://updateAccount/$id';

      final action = mapper(link);

      expect(
        action,
        isA<IncomingAction>()
            .having((a) => a.actionType, 'actionType', ActionType.updateAccount())
            .having((a) => a.actionId, 'actionId', id),
      );
    });

    test('returns mapped action when uri is closed by slash', () {
      const id = 'abcd1';
      const link = '$deepLinkScheme://updateAccount/$id/';

      final action = mapper(link);

      expect(
        action,
        isA<IncomingAction>().having((a) => a.actionId, 'actionId', id),
      );
    });

    test('throws exception when action is unknown', () {
      const id = 'abcd1';
      const link = '$deepLinkScheme://someAction/$id';

      expect(() => mapper(link), throwsException);
    });

    test('throws exception when id is missing', () {
      const link = '$deepLinkScheme://someAction';

      expect(() => mapper(link), throwsException);
    });
  });

  group('for app link uri it', () {
    test('returns mapped authorize action', () {
      const id = 'abcd1';
      const link = '$appLinkScheme://host/authorize/$id';

      final action = mapper(link);

      expect(
        action,
        isA<IncomingAction>()
            .having((a) => a.actionType, 'actionType', ActionType.authorize())
            .having((a) => a.actionId, 'actionId', id),
      );
    });

    test('returns mapped confirm action', () {
      const id = 'abcd2';
      const link = '$appLinkScheme://host/confirm/$id';

      final action = mapper(link);

      expect(
        action,
        isA<IncomingAction>()
            .having((a) => a.actionType, 'actionType', ActionType.confirm())
            .having((a) => a.actionId, 'actionId', id),
      );
    });

    test('returns mapped updateAccount action', () {
      const id = 'abcd3';
      const link = '$appLinkScheme://host/updateAccount/$id';

      final action = mapper(link);

      expect(
        action,
        isA<IncomingAction>()
            .having((a) => a.actionType, 'actionType', ActionType.updateAccount())
            .having((a) => a.actionId, 'actionId', id),
      );
    });

    test('returns mapped action when uri is closed by slash', () {
      const id = 'abcd3';
      const link = '$appLinkScheme://host/updateAccount/$id/';

      final action = mapper(link);

      expect(
        action,
        isA<IncomingAction>().having((a) => a.actionId, 'actionId', id),
      );
    });

    test('throws exception when action is unknown', () {
      const id = 'abcd1';
      const link = '$appLinkScheme://someAction/$id';

      expect(() => mapper(link), throwsException);
    });

    test('throws exception when id is missing', () {
      const link = '$appLinkScheme://host/someAction';

      expect(() => mapper(link), throwsException);
    });
  });

  test('for unknown scheme it throws exception', () {
    const id = 'abcd3';
    const link = 'scheme://updateAccount/$id';

    expect(() => mapper(link), throwsException);
  });
}
