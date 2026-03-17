import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/data_mapper.dart';

@injectable
class IncomingActionDataFieldsBodyDTOToActionIdMapper implements DataMapper<String, String?> {
  @override
  String? call(String? body) {
    if(body == null) return null;

    return jsonDecode(body)['id'] as String;
  }
}