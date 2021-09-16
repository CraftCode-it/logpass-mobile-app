import 'package:logpass_me/data/common/bidirectional_data_mapper.dart';
import 'package:logpass_me/data/user_data/dto/hive_dto.dart';

abstract class HiveDtoMapper<FROM extends HiveDto, TO> extends BidirectionalDataMapper<FROM, TO> {}
