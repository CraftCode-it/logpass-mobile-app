import 'package:logpass_me/data/user_data/data_source/hive/hive_invoice_data_sorce.dart';
import 'package:logpass_me/data/user_data/mapper/entity/invoice_entity_to_invoice_mapper.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

class UserInvoiceDataRepository implements UserDataRepository<InvoiceData> {
  final HiveInvoiceDataSource _hiveDataSource;
  final InvoiceEntityToInvoiceMapper _dtoMapper;

  UserInvoiceDataRepository(this._hiveDataSource, this._dtoMapper);

  @override
  Future create(InvoiceData value) async {
    final dto = _dtoMapper.to(value);
    return _hiveDataSource.create(dto);
  }

  @override
  Future delete(InvoiceData value) async {
    final entity = _dtoMapper.to(value);
    return _hiveDataSource.delete(entity);
  }

  @override
  Future<List<InvoiceData>> readAll() async {
    return (await _hiveDataSource.all()).map(_dtoMapper.from).toList();
  }

  @override
  Future<InvoiceData?> readDefault() async {
    final dto = await _hiveDataSource.getDefault();
    return dto != null ? _dtoMapper.from(dto) : null;
  }

  @override
  Future setDefault(InvoiceData value) {
    return _hiveDataSource.setDefault(_dtoMapper.to(value));
  }
}
