import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

@injectable
class AddInvoiceDataUseCase {
  final UserDataRepository<InvoiceData> _repository;

  AddInvoiceDataUseCase(this._repository);

  Future<void> call(InvoiceData invoiceData) async {
    final isFirst = (await _repository.readAll()).isEmpty;
    return _repository.create(invoiceData.copyWith(isDefault: isFirst));
  }
}
