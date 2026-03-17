import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/data_mapper.dart';

final _codeRegexp = RegExp(r'[0-9]{6}');

@Injectable()
class SmsCodeMapper implements DataMapper<String?, String?> {
  @override
  String? call(String? sms) {
    if(sms == null) return null;

    return _codeRegexp.stringMatch(sms);
  }
}