import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/data_mapper.dart';
import 'package:logpass_me/data/incoming_actions/dtos/incoming_action_dto.dart';
import 'package:logpass_me/data/incoming_actions/mappers/incoming_action_data_fields_body_dto_to_action_id_mapper.dart';
import 'package:logpass_me/domain/incoming_actions/action_type.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';

@injectable
class WebSocketActionDTOToIncomingActionMapper implements DataMapper<IncomingActionDTO, IncomingAction> {
  final IncomingActionDataFieldsBodyDTOToActionIdMapper _dataFieldsBodyMapper;

  WebSocketActionDTOToIncomingActionMapper(this._dataFieldsBodyMapper);

  @override
  IncomingAction call(IncomingActionDTO incomingActionDTO) {
    final actionType = mapActionType(incomingActionDTO.data.dataFields.action);
    final actionId = _dataFieldsBodyMapper(incomingActionDTO.data.dataFields.body);

    return IncomingAction.create(
      actionType,
      actionId,
      incomingActionDTO.data.dataFields.sendAttemptId,
      null
    );
  }
}