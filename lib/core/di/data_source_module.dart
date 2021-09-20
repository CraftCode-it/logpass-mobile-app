import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/incoming_actions/linking/linking_data_source.dart';

@module
abstract class DataSourceModule {
  @preResolve
  Future<LinkingDataSource> getLinkingDataSource() => LinkingDataSource.create();
}
