import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

@injectable
class UpdateInvoiceDataUseCase {
  final UserDataRepository<InvoiceData> _repository;

  UpdateInvoiceDataUseCase(this._repository);

  Future<void> call(InvoiceData oldInvoiceData, InvoiceData invoiceData) async {
    await _repository.delete(oldInvoiceData);
    return _repository.create(invoiceData);
  }
}
