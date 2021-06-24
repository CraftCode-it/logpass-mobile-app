import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';

@injectable
class GetInvoiceDatasUseCase {
// TODO: replace after implementation of UserDataRepository
  Future<List<InvoiceData>> call() async => Future.value(
        [
          InvoiceData(
            name: 'John',
            surname: 'Doe',
            street: 'Some kind of street',
            buildingNumber: '127',
            apartmentNumber: '21',
            postCode: '51-612',
            city: 'Cracow',
          ),
          InvoiceData(
            name: 'John',
            surname: 'Doe',
            street: 'Some kind of street',
            buildingNumber: '99',
            postCode: '62-242',
            city: 'Katowice',
          ),
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
        ],
      );
}
