import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

@injectable
class SetDefaultInvoiceDataUseCase {
  final UserDataRepository<InvoiceData> _repository;

  SetDefaultInvoiceDataUseCase(this._repository);

  Future<void> call(InvoiceData invoiceData) => _repository.setDefault(invoiceData.copyWith(isDefault: true));
}
