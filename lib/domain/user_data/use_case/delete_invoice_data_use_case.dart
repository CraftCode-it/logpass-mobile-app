import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';

@injectable
class DeleteInvoiceDataUseCase {
  // TODO: replace after implementation of UserDataRepository
  Future<void> call(InvoiceData invoiceData) => Future.delayed(
        const Duration(milliseconds: 200),
        () => null,
      );
}
