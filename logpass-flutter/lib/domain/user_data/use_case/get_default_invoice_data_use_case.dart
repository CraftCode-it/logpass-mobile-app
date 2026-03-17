import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

@injectable
class GetDefaultInvoiceDataUseCase {
  final UserDataRepository<InvoiceData> _repository;

  GetDefaultInvoiceDataUseCase(this._repository);

  Future<InvoiceData?> call() async => _repository.readDefault();
}
