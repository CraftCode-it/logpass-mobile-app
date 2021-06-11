import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/bidirectional_data_mapper.dart';

@Injectable()
class DateTimeDTOMapper implements BidirectionalDataMapper<DateTime, String> {
  @override
  String from(DateTime data) {
    return data.toUtc().toString();
  }

  @override
  DateTime to(String data) {
    return DateTime.parse(data).toLocal();
  }
}
