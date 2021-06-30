import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/package_info/package_info_repository.dart';

@injectable
class GetApplicationVersionUseCase {
  final PackageInfoRepository _repository;

  GetApplicationVersionUseCase(this._repository);

  String call() => _repository.getApplicationVersion();
}
