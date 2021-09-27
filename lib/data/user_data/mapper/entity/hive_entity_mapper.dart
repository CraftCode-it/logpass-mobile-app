import 'package:logpass_me/data/common/bidirectional_data_mapper.dart';
import 'package:logpass_me/data/user_data/entity/hive_entity.dart';

abstract class HiveEntityMapper<FROM extends HiveEntity, TO> extends BidirectionalDataMapper<FROM, TO> {}
