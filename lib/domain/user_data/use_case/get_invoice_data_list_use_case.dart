import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

@injectable
class GetInvoiceDataListUseCase {
  final UserDataRepository<InvoiceData> _repository;

  GetInvoiceDataListUseCase(this._repository);

  Future<List<InvoiceData>> call() => _repository.readAll();
}
