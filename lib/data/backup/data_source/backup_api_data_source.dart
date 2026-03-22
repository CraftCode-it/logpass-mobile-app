import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/backup/dtos/backup_entry_dto.dart';
import 'package:logpass_me/data/networking/log_pass_dio.dart';
import 'package:retrofit/retrofit.dart';

part 'backup_api_data_source.g.dart';

@LazySingleton()
@RestApi()
abstract class BackupApiDataSource {
  @factoryMethod
  factory BackupApiDataSource(LogPassDio dio) = _BackupApiDataSource;

  @POST('/backups/')
  Future<void> createEntry(@Body() BackupEntryDto body);

  @GET('/backups/')
  Future<void> getAll(@Path('agreementId') String agreementId);

  @GET('/backups/{backupKey}')
  Future<void> getSingle(@Path('backupKey') String backupKey);

  @DELETE('/backups/{backupKey}')
  Future<void> removeEntry(@Path('backupKey') String backupKey);
}
