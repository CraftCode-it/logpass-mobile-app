import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/data/incoming_actions/mappers/incoming_action_data_fields_body_dto_to_action_id_mapper.dart';

void main() {
  late IncomingActionDataFieldsBodyDTOToActionIdMapper mapper;

  setUp(() {
    mapper = IncomingActionDataFieldsBodyDTOToActionIdMapper();
  });

  test('returns mapped id action', () {
    const body = '{\"id\": \"id\"}';

    final action = mapper(body);

    expect(action, 'id');
  });

  test('returns null as id action', () {
    final action = mapper(null);

    expect(action, null);
  });
}