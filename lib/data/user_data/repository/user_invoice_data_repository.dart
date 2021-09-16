import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/user_data/data_source/hive_invoice_data_sorce.dart';
import 'package:logpass_me/data/user_data/mapper/invoice_dto_to_invoice_mapper.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

class UserInvoiceDataRepository implements UserDataRepository<InvoiceData> {
  final HiveInvoiceDataSource _hiveDataSource;
  final InvoiceDtoToInvoiceMapper _dtoMapper;

  UserInvoiceDataRepository(this._hiveDataSource, this._dtoMapper);

  @override
  Future create(InvoiceData value) async {
    final dto = _dtoMapper.to(value);
    return _hiveDataSource.create(dto);
  }

  @override
  Future delete(InvoiceData value) async {
    return _hiveDataSource.delete(value.uuid);
  }

  @override
  Future<List<InvoiceData>> readAll() async {
    return (await _hiveDataSource.all()).map(_dtoMapper.from).toList();
  }

  @override
  Future update(InvoiceData value) async {
    return _hiveDataSource.update(_dtoMapper.to(value));
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
