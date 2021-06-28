import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';

@injectable
class GetDefaultInvoiceDataUseCase {
  // TODO: replace after implementation of UserDataRepository
  Future<InvoiceData?> call() async => Future.value(
        InvoiceData(
          name: 'John',
          surname: 'Doe',
          street: 'Some kind of street',
          buildingNumber: '28',
          apartmentNumber: '92',
          postCode: '04-242',
          city: 'Warsaw',
          isDefault: true,
        ),
      );
}
