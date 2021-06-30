import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/data/incoming_actions/dtos/incoming_action_dto.dart';
import 'package:logpass_me/data/incoming_actions/mappers/incoming_action_dto_to_incoming_action_mapper.dart';
import 'package:logpass_me/domain/incoming_actions/action_type.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';

void main() {
  late IncomingActionDTOToIncomingActionMapper mapper;

  setUp(() {
    mapper = IncomingActionDTOToIncomingActionMapper();
  });

  const deepLinkScheme = IncomingActionDTOToIncomingActionMapper.deepLinkScheme;
  const appLinkScheme = IncomingActionDTOToIncomingActionMapper.appLinkScheme;

  group('for deep link uri it', () {
    test('returns mapped authorize action', () {
      const id = 'abcd3';
      const link = '$deepLinkScheme://authorize/$id';
      final dto = IncomingActionDTO(link);

      final action = mapper(dto);

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
      final dto = IncomingActionDTO(link);

      final action = mapper(dto);

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
      final dto = IncomingActionDTO(link);

      final action = mapper(dto);

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
      final dto = IncomingActionDTO(link);

      final action = mapper(dto);

      expect(
        action,
        isA<IncomingAction>().having((a) => a.actionId, 'actionId', id),
      );
    });

    test('throws exception when action is unknown', () {
      const id = 'abcd1';
      const link = '$deepLinkScheme://someAction/$id';
      final dto = IncomingActionDTO(link);

      expect(() => mapper(dto), throwsException);
    });

    test('throws exception when id is missing', () {
      const link = '$deepLinkScheme://someAction';
      final dto = IncomingActionDTO(link);

      expect(() => mapper(dto), throwsException);
    });
  });

  group('for app link uri it', () {
    test('returns mapped authorize action', () {
      const id = 'abcd1';
      const link = '$appLinkScheme://host/authorize/$id';
      final dto = IncomingActionDTO(link);

      final action = mapper(dto);

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
      final dto = IncomingActionDTO(link);

      final action = mapper(dto);

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
      final dto = IncomingActionDTO(link);

      final action = mapper(dto);

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
      final dto = IncomingActionDTO(link);

      final action = mapper(dto);

      expect(
        action,
        isA<IncomingAction>().having((a) => a.actionId, 'actionId', id),
      );
    });

    test('throws exception when action is unknown', () {
      const id = 'abcd1';
      const link = '$appLinkScheme://someAction/$id';
      final dto = IncomingActionDTO(link);

      expect(() => mapper(dto), throwsException);
    });

    test('throws exception when id is missing', () {
      const link = '$appLinkScheme://host/someAction';
      final dto = IncomingActionDTO(link);

      expect(() => mapper(dto), throwsException);
    });
  });

  test('for unknown scheme it throws exception', () {
    const id = 'abcd3';
    const link = 'scheme://updateAccount/$id';
    final dto = IncomingActionDTO(link);

    expect(() => mapper(dto), throwsException);
  });
}
