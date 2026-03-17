import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/data/incoming_actions/dtos/incoming_action_dto.dart';
import 'package:logpass_me/data/incoming_actions/mappers/incoming_action_data_fields_body_dto_to_action_id_mapper.dart';
import 'package:logpass_me/data/incoming_actions/mappers/web_socket_action_dto_to_incoming_action_mapper.dart';
import 'package:logpass_me/domain/incoming_actions/action_type.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'web_socket_action_dto_to_incoming_action_mapper_test.mocks.dart';

@GenerateMocks(
  [
    IncomingActionDataFieldsBodyDTOToActionIdMapper,
  ],
)
void main() {
  late IncomingActionDataFieldsBodyDTOToActionIdMapper dataFieldsBodyMapper;
  late WebSocketActionDTOToIncomingActionMapper mapper;

  setUp(() {
    dataFieldsBodyMapper = MockIncomingActionDataFieldsBodyDTOToActionIdMapper();
    mapper = WebSocketActionDTOToIncomingActionMapper(dataFieldsBodyMapper);
  });

  IncomingActionDTO _generateDTOModel(String action, String? dataFieldsBody) {
    final incomingActionDataFieldsDTO = IncomingActionDataFieldsDTO(action, 'https://url', 'asd1-df', dataFieldsBody);
    final incomingActionDataDTO = IncomingActionDataDTO('', '', incomingActionDataFieldsDTO, '', 0, '', '');
    final incomingActionDTO = IncomingActionDTO('', incomingActionDataDTO);

    return incomingActionDTO;
  }

  group('mapped incoming action data with fields body dto', () {
    test('returns mapped authorize action', () {
      const actionId = 'id';
      final incomingActionDTO = _generateDTOModel('oauth2_authorize', 'body');

      when(dataFieldsBodyMapper(incomingActionDTO.data.dataFields.body)).thenReturn(actionId);
      final action = mapper(incomingActionDTO);

      expect(
        action,
        isA<IncomingAction>()
            .having((a) => a.actionType, 'actionType', ActionType.authorize())
            .having((a) => a.actionId, 'actionId', actionId),
      );
    });

    test('returns mapped confirm action', () {
      const actionId = 'id';
      final incomingActionDTO = _generateDTOModel('confirm', 'body');

      when(dataFieldsBodyMapper(incomingActionDTO.data.dataFields.body)).thenReturn(actionId);
      final action = mapper(incomingActionDTO);

      expect(
        action,
        isA<IncomingAction>()
            .having((a) => a.actionType, 'actionType', ActionType.confirm())
            .having((a) => a.actionId, 'actionId', actionId),
      );
    });

    test('returns mapped updateAccount action', () {
      const actionId = 'id';
      final incomingActionDTO = _generateDTOModel('updateaccount', 'body');

      when(dataFieldsBodyMapper(incomingActionDTO.data.dataFields.body)).thenReturn(actionId);
      final action = mapper(incomingActionDTO);

      expect(
        action,
        isA<IncomingAction>()
            .having((a) => a.actionType, 'actionType', ActionType.updateAccount())
            .having((a) => a.actionId, 'actionId', actionId),
      );
    });

    test('returns mapped refresh user code action', () {
      const actionId = 'id';
      final incomingActionDTO = _generateDTOModel('refresh_usercode', 'body');

      when(dataFieldsBodyMapper(incomingActionDTO.data.dataFields.body)).thenReturn(actionId);
      final action = mapper(incomingActionDTO);

      expect(
        action,
        isA<IncomingAction>()
            .having((a) => a.actionType, 'actionType', ActionType.refreshUserCode())
            .having((a) => a.actionId, 'actionId', actionId),
      );
    });

    test('throws exception when action is unknown', () {
      final incomingActionDTO = _generateDTOModel('unknown', 'body');

      expect(() => mapper(incomingActionDTO), throwsException);
    });
  });

  group('mapped incoming action without fields body dto', () {
    test('returns mapped authorize action', () {
      final incomingActionDTO = _generateDTOModel('oauth2_authorize', null);

      when(dataFieldsBodyMapper(incomingActionDTO.data.dataFields.body)).thenReturn(null);
      final action = mapper(incomingActionDTO);

      expect(
        action,
        isA<IncomingAction>()
            .having((a) => a.actionType, 'actionType', ActionType.authorize())
            .having((a) => a.actionId, 'actionId', null),
      );
    });

    test('returns mapped confirm action', () {
      final incomingActionDTO = _generateDTOModel('confirm', null);

      when(dataFieldsBodyMapper(incomingActionDTO.data.dataFields.body)).thenReturn(null);
      final action = mapper(incomingActionDTO);

      expect(
        action,
        isA<IncomingAction>()
            .having((a) => a.actionType, 'actionType', ActionType.confirm())
            .having((a) => a.actionId, 'actionId', null),
      );
    });

    test('returns mapped updateAccount action', () {
      final incomingActionDTO = _generateDTOModel('updateaccount', null);

      when(dataFieldsBodyMapper(incomingActionDTO.data.dataFields.body)).thenReturn(null);
      final action = mapper(incomingActionDTO);

      expect(
        action,
        isA<IncomingAction>()
            .having((a) => a.actionType, 'actionType', ActionType.updateAccount())
            .having((a) => a.actionId, 'actionId', null),
      );
    });

    test('returns mapped refresh user code action', () {
      final incomingActionDTO = _generateDTOModel('refresh_usercode', null);

      when(dataFieldsBodyMapper(incomingActionDTO.data.dataFields.body)).thenReturn(null);
      final action = mapper(incomingActionDTO);

      expect(
        action,
        isA<IncomingAction>()
            .having((a) => a.actionType, 'actionType', ActionType.refreshUserCode())
            .having((a) => a.actionId, 'actionId', null),
      );
    });

    test('throws exception when action is unknown', () {
      final incomingActionDTO = _generateDTOModel('unknown', null);

      expect(() => mapper(incomingActionDTO), throwsException);
    });
  });
}
