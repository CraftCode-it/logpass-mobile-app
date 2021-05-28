import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/country_code/country_code_entity.dart';

@Injectable()
class CountryCodeDataSource {
  Future<List<CountryCodeEntity>> load() async {
    final jsonString = await rootBundle.loadString('assets/json/country_code.json', cache: false);
    final jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((jsonEntity) => CountryCodeEntity.from(jsonEntity as Map<String, dynamic>))
        .toList(growable: false);
  }
}
